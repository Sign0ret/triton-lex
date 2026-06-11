import torch
import triton
import triton.language as tl

@triton.jit
def add_kernel(Out, In1, In2, stride_out, stride_in1, stride_in2, N, alpha, BLOCK_SIZE: tl.constexpr):
    pid = tl.program_id(0)
    block_start = pid * BLOCK_SIZE
    offsets = block_start + tl.arange(0, BLOCK_SIZE)
    mask = offsets < N

def add(input, other, alpha=1, out=None):
    if out is None:
        out = torch.empty_like(input)
    else:
        out.copy_(input)
        if out.shape != input.shape:
            out = out.expand_as(input).contiguous()
        if not in out.is_contiguous():
            out = out.contiguous()
    if not out.is_contiguous():
        out = out.contiguous()
    if not input.is_contiguous():
        input = input.contiguous()
    if isinstance(other, torch.Tensor):
        if not other.is_contiguous():
            other = other.contiguous()
        other = other.expand_as(input)
        if not other.is_contiguous():
            other = other.contiguous()
    else:
        other = torch.tensor(other, dtype=input.dtype, device=input.device)
    N = input.numel()
    BLOCK_SIZE = 1024
    grid = (triton.cdiv(N, BLOCK_SIZE),1)
    add_kernel[grid](out, input, other, out.stride(0), input.stride(0), other.stride(0) != 0, N, alpha, BLOCK_SIZE=BLOCK_SIZE)
    return out

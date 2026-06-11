import triton
import triton.language as tl

@tl.jit
def add_kernel(x_ptr, y_ptr, output_ptr, n_elements, BLOCK_SIZE):
    pid = tl.program_id(axis=0)
    block_start = pid * BLOCK_SIZE
    offsets = block_start + tl.arange(0, BLOCK_SIZE)
    mask = offsets < n_elements
    x = tl.load(x_ptr + offsets, mask=mask, other=0.0)
    y = tl.load(y_ptr + offsets, mask=mask, other=0.0)
    output = x + y
    tl.store(output_ptr + offsets, output, mask=mask)

@tl.jit
def scale_kernel(ptr, scalar, n, BLOCK):
    pid = tl.program_id(axis=0)
    offsets = pid * BLOCK + tl.arange(0, BLOCK)
    mask = offsets < n
    x = tl.load(ptr + offsets, mask=mask)
    x = x * scalar
    tl.store(ptr + offsets, x, mask=mask)

def launch(n):
    grid = (n + 127) // 128
    if grid > 0:
        add_kernel(grid, 128)
    elif n == 0:
        pass
    else:
        scale_kernel(grid, 2.0, n, 128)

result = launch(1024)

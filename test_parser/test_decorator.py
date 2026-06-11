@triton.jit
def add(a, b):
    return a + b

@triton.jit(1, 2, x=3)
def scale(ptr, scalar, n: tl.constexpr, BLOCK: tl.constexpr = 128):
    pid = tl.program_id(0)
    return pid * scalar

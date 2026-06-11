import triton
import triton.language as tl

def kernel(x_ptr, y_ptr):
    pid = tl.program_id(0)
    x = tl.load(x_ptr + pid)
    if x > 0:
        y = x + 1
    elif x < 0:
        y = x - 1
    else:
        y = 0
    for i in range(10):
        y = y + i
    return y

def f(x) -> int:
    return x

def g(x, y: int, z = 1):
    return x + y + z

def h(x, y: int = 1, z = 2):
    return x + y + z

result = f(1)
result = g(1, 2, z=3)
result = h(1, y=2, z=3)

"""Numerically check the steps in README.md at random points.

Run with: python3 check_identities.py
Prints the name of any step that fails, with a few failing points.
"""
import cmath
import random
from math import atan, atan2, hypot, sqrt

random.seed(2)


def sgn(v):
    return (v > 0) - (v < 0)


def close(a, b):
    return abs(a - b) < 1e-9


fails = {}


def check(name, ok, point):
    if not ok:
        fails.setdefault(name, []).append(point)


for _ in range(20000):
    # Steps in terms of x and y.
    x, y = random.uniform(-4, 4), random.uniform(-4, 4)
    X, Y = sqrt(1 + x * x), sqrt(1 + y * y)
    T = atan2(x + y, 1 - x * y)
    check('halving each arctangent', close(T, 2 * atan(x / (1 + X)) + 2 * atan(y / (1 + Y))), (x, y))
    h = x + y + x * Y + y * X
    k = 1 - x * y + X + Y + X * Y
    check('2 atan2(h, k)', close(T, 2 * atan2(h, k)), (x, y))
    b, a = x + y, 1 - x * y
    r = hypot(a, b)
    check('sum of square roots', close(X + Y, sqrt(b * b + 2 * a + 2 * r)), (x, y))
    if x > y:  # x takes the + root, as in the notes
        check('difference of square roots', close(X - Y, sgn(b) * sqrt(max(0, b * b + 2 * a - 2 * r))), (x, y))

    # Final formulas on arbitrary (b, a).
    b, a = random.uniform(-4, 4), random.uniform(-4, 4)
    r = hypot(a, b)
    P = sqrt(b * b + 2 * a + 2 * r)
    D = b * b + 4 * a - 4
    E = b * b + 2 * a - 2 * r
    k = a + P + r
    h = (2 * b + b * P - sgn(b) * cmath.sqrt(D) * cmath.sqrt(E)) / 2
    check('result (principal complex roots)', abs(h.imag) < 1e-9 and close(atan2(b, a), 2 * atan2(h.real, k)), (b, a))
    check('result without inner roots', close(atan2(b, a), 2 * atan2(b * (P + r - a + 2) / P, k)), (b, a))
    check('half-angle form', close(atan2(b, a), 2 * atan2(b, a + r)), (b, a))

for name, points in fails.items():
    print(name, len(points), points[:3])
print('done')

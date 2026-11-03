"""Numerically check the identities in README.md at random points.

Run with: python3 check_identities.py
Prints the name of any identity that fails, with a few failing points.
"""
import cmath
import random
from math import atan, atan2, hypot, pi, sqrt

random.seed(4)


def close(a, b):
    return abs(a - b) < 1e-9


fails = {}


def check(name, ok, point):
    if not ok:
        fails.setdefault(name, []).append(point)


def on_cut(x, y):
    return y == 0 and x <= 0


for _ in range(50000):
    x, y = random.uniform(-4, 4), random.uniform(-4, 4)
    r = hypot(x, y)
    theta = atan2(y, x)

    # Product rule, and atan as an angle.
    check('atan x = arg(1 + ix)', close(atan(x), cmath.phase(complex(1, x))), (x,))
    check('sum of arctangents', close(atan(x) + atan(y), atan2(x + y, 1 - x * y)), (x, y))

    # Half-angle forms.
    check('half-angle y/(r + x)', close(theta, 2 * atan(y / (r + x))), (x, y))
    check('half-angle (r - x)/y', close(theta, 2 * atan((r - x) / y)), (x, y))
    check('halving', close(theta / 2, atan2(y, x + r)), (x, y))

    # Doubling, valid for -pi/2 < theta <= pi/2.
    if x > 0:
        check('doubling', close(2 * theta, atan2(2 * x * y, x * x - y * y)), (x, y))

    # Splitting atan2(b, a) for every allowed c.
    b, a = x, y
    if not on_cut(a, b):
        rr = hypot(a, b)
        c0 = 2 * (rr - a) / (b * b)
        theta_ba = atan2(b, a)
        check('double root is the half-angle form', close(theta_ba, 2 * atan(c0 * b / 2)), (b, a))
        for c in (c0, c0 * 1.5, c0 * 10, c0 + 3):
            disc = (c * b) ** 2 - 4 * (1 - c * a)
            if disc < -1e-9 * ((c * b) ** 2 + 4 * abs(c * a) + 4):
                check('c >= c0 gives real roots', False, (b, a, c))
                continue
            disc = max(disc, 0.0)  # zero at c = c0, up to rounding
            t1 = (c * b + sqrt(disc)) / 2
            t2 = (c * b - sqrt(disc)) / 2
            check('split', close(theta_ba, atan(t1) + atan(t2)), (b, a, c))
        if c0 > 1e-6:
            c = c0 * 0.9
            check('c < c0 gives complex roots', (c * b) ** 2 - 4 * (1 - c * a) < 0, (b, a, c))

    # Stable evaluation.
    stable = 2 * atan(y / (r + x)) if x >= 0 else 2 * atan((r - x) / y)
    check('stable atan2', close(theta, stable), (x, y))

# Points on and near the axes.
for x, y, want in [(1, 0, 0), (-1, 0, pi), (0, 1, pi / 2), (0, -1, -pi / 2)]:
    r = hypot(x, y)
    if x >= 0:
        got = 2 * atan(y / (r + x))
    else:
        got = pi if y == 0 else 2 * atan((r - x) / y)
    check('stable atan2 on axes', close(got, want), (x, y))

for name, points in fails.items():
    print(name, len(points), points[:3])
print('done')

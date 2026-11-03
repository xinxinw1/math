"""Check the input-place rules in README.md at random points.

Run with: python3 check_rules.py
Uses 50-digit decimal arithmetic. For each trial it chooses the input places
by a rule, moves each input by the largest allowed error in each direction,
and checks that the output moves by at most the budget. It also checks that
each rule never asks for fewer places than the exact count.
"""
import math
import random
from decimal import Decimal as D, getcontext

getcontext().prec = 50
random.seed(5)
ONE = D(1)
PI = D('3.14159265358979323846264338327950288419716939937510582097494')


def siz(v):
    v = abs(D(v))
    s = v.adjusted() + 1  # floor(log10 v) + 1
    return s


def atan(x):
    """atan to about 45 digits: halve the argument until it is small, then use the series."""
    x = D(x)
    if x == 0:
        return D(0)
    halvings = 0
    while abs(x) > D('0.01'):
        x = x / (ONE + (ONE + x * x).sqrt())
        halvings += 1
    total, term, n, x2 = D(0), x, 1, x * x
    while abs(term) > D('1e-55'):
        total += term / n
        term = -term * x2
        n += 2
    return total * (2 ** halvings)


def atan2(y, x):
    """Stable half-angle form from the atan2 revisited doc."""
    y, x = D(y), D(x)
    r = (x * x + y * y).sqrt()
    if x >= 0:
        return 2 * atan(y / (r + x))
    if y == 0:
        return PI
    return 2 * atan((r - x) / y)


def atan_rule(d, L=None):
    if L is None:
        return d + 1
    s = siz(D('0.99') * L)
    return max(d + 1 - 2 * max(0, s - 1), 3 - siz(L))


def atan2_rule(d, M):
    """M is the larger of the lower bounds used, L_x or L_y."""
    return d + 2 - siz(D('0.99') * M)


def exact_count(c, eps):
    return math.ceil(math.log10(c) - math.log10(eps))


fails = {}


def check(name, ok, point):
    if not ok:
        fails.setdefault(name, []).append(point)


for _ in range(3000):
    d = random.randint(0, 11)
    c = ONE  # an input good to its places can be off by the full 10^-places
    T = D(10) ** -d
    eta = T / 2

    # atan
    x = D(random.choice((-1, 1))) * D(10) ** D(random.uniform(-3, 7))
    L = abs(x) * D(random.uniform(0.1, 1)) if random.random() < 0.8 else None
    dx = atan_rule(d, L)
    eps = c * D(10) ** -dx
    for xt in (x - eps, x + eps):
        check('atan', abs(atan(xt) - atan(x)) <= eta, (float(x), d, L))
    if L is not None:
        Lb = D('0.99') * L
        A = ONE / (ONE + Lb * Lb)
        check('atan rule >= exact count', dx >= exact_count(float(c), float(eta / A)), (float(x), d))

    # atan2, with y's sign known (L_y given) or x known positive
    x = D(random.uniform(-1, 1)) * D(10) ** D(random.uniform(-2, 4))
    y = D(random.uniform(-1, 1)) * D(10) ** D(random.uniform(-2, 4))
    Lx = abs(x) * D(random.uniform(0.1, 1))
    Ly = abs(y) * D(random.uniform(0.1, 1))
    if x > 0 and random.random() < 0.3:
        M, min_x, min_y = Lx, 3 - siz(Lx), None  # no bound on y
    else:
        M = max(Lx, Ly)
        min_x, min_y = 3 - siz(Lx), 3 - siz(Ly)
    dxy = atan2_rule(d, M)
    dx = max(dxy, min_x)
    dy = dxy if min_y is None else max(dxy, min_y)
    ex, ey = c * D(10) ** -dx, c * D(10) ** -dy
    true = atan2(y, x)
    for xt in (x - ex, x + ex):
        for yt in (y - ey, y + ey):
            check('atan2', abs(atan2(yt, xt) - true) <= eta, (float(x), float(y), d))
    Rb = D('0.99') * M
    check('atan2 rule >= exact count', dxy >= exact_count(float(c), float(eta / 2 * Rb)), (float(M), d))

for name, points in fails.items():
    print(name, len(points), points[:3])

# Examples in the README.
x = 10 * PI
xt = round(x, 7)
val = round(atan(xt), 9)
print('atan(10 pi), d = 8: x~ =', xt, ' atan to 9 places =', val, ' rounded =', round(val, 6), ' true =', round(atan(x), 12))
print('  exact count, c = 1/2:', exact_count(0.5, 0.5e-8 * float(1 + (0.99 * 31) ** 2)))
xt = round(PI, 9)
val = round(atan2(1, xt), 9)
print('atan2(1, pi), d = 8: x~ =', xt, ' atan2 to 9 places =', val, ' rounded =', round(val, 6), ' true =', round(atan2(1, PI), 12))
print('  exact count, c = 1/2:', exact_count(0.5, 0.25e-8 * 2.97))
y, x = D('0.001'), -ONE
print('atan2(0.001, -1) =', round(atan2(y, x), 12))
print('done')

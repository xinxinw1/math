"""Check the additions in README.md at random points.

Run with: python3 check_additions.py
Uses 60-digit decimal arithmetic for the reference values. Checks:

- the atan and atan2 evaluation procedures stay within their error budgets,
- the cheap intervals contain the true values,
- the whole node (places rule, then evaluation, then rounding) gives a
  result good to d places,

and prints the numbers used in the README's examples.
"""
import random
from decimal import Decimal as D, getcontext, ROUND_HALF_EVEN, ROUND_FLOOR, ROUND_CEILING

getcontext().prec = 60
random.seed(6)
ONE, ZERO = D(1), D(0)
PI = D('3.14159265358979323846264338327950288419716939937510582097494459')


def rnd(v, p, rounding=ROUND_HALF_EVEN):
    return D(v).quantize(D(1).scaleb(-p), rounding=rounding)


def siz(v):
    return D(v).copy_abs().adjusted() + 1


def sgn(v):
    return (v > 0) - (v < 0)


# Reference values, to about 55 digits.
def atan_ref(x):
    x = D(x)
    if x == 0:
        return ZERO
    h = 0
    while abs(x) > D('0.001'):
        x = x / (ONE + (ONE + x * x).sqrt())
        h += 1
    total, term, n, x2 = ZERO, x, 1, x * x
    while abs(term) > D('1e-62'):
        total += term / n
        term = -term * x2
        n += 2
    return total * (2 ** h)


def atan2_ref(y, x):
    y, x = D(y), D(x)
    r = (x * x + y * y).sqrt()
    if x >= 0:
        return 2 * atan_ref(y / (r + x))
    if y == 0:
        return PI
    return sgn(y) * PI - 2 * atan_ref(y / (r - x))


# The procedures in the README.
def atan_eval(x, d, k, trace=None):
    """atan(x) for a decimal x, within 0.18 * 10^-(d+k), before the final rounding."""
    x = D(x)
    p = d + k + 2
    if abs(x) > 1:
        w = rnd(ONE / x, p)
        outer = rnd(PI / 2, p) * sgn(x)
    else:
        w, outer = x, None
    v = w
    steps = [('w', w)]
    for _ in range(2):
        s = rnd((ONE + v * v).sqrt(), p)
        v = rnd(v / (ONE + s), p)
        steps.append(('v', v))
    v2 = v * v
    P, total, n, terms = v, v, 0, [(0, v, v)]
    while True:
        if siz(terms[-1][2]) <= -(d + k + 1) or terms[-1][2] == 0:
            break
        n += 1
        pn = d + k + 1 + 2 * siz(n)
        P = rnd(P * v2, pn)
        t = rnd((-1) ** n * P / (2 * n + 1), pn)
        total += t
        terms.append((n, P, t))
    result = 4 * total if outer is None else outer - 4 * total
    if trace is not None:
        trace.update(steps=steps, terms=terms, sum=total, outer=outer, result=result)
    return result


def atan2_eval(y, x, d, k):
    """atan2(y, x) for decimals, within 0.1 * 10^-(d+k), before the final rounding."""
    y, x = D(y), D(x)
    if y == 0 and x < 0:
        return PI
    s = 1 - siz(max(abs(x), abs(y)))  # scale so the larger is at least 1; exact
    y, x = y.scaleb(s), x.scaleb(s)
    p = d + k + 2
    r = rnd((x * x + y * y).sqrt(), p)
    if x >= 0:
        q = rnd(y / (r + x), p)
        return 2 * atan_eval(q, d + 1, k)
    q = rnd(y / (r - x), p)
    return sgn(y) * rnd(PI, p) - 2 * atan_eval(q, d + 1, k)


# Places rules, from Input places for atan and atan2.
def atan_places(d, k, L=None):
    if L is None:
        return d + k + 1
    return max(d + k + 1 - 2 * max(0, siz(D('0.99') * L) - 1), 3 - siz(L))


def atan2_places(d, k, M):
    return d + k + 2 - siz(D('0.99') * M)


# Cheap intervals.
W5 = D('0.000006')


def atan_cheap(lo, hi):
    a1, a2 = rnd(atan_eval(lo, 5, 1), 5), rnd(atan_eval(hi, 5, 1), 5)
    return max(a1 - W5, D('-1.5708')), min(a2 + W5, D('1.5708'))


def atan2_cheap(lx, hx, ly, hy):
    if lx > 0 or ly > 0 or hy < 0:
        vals = [rnd(atan2_eval(y, x, 5, 1), 5) for x in (lx, hx) for y in (ly, hy)]
        return min(vals) - W5, max(vals) + W5
    return D('-3.1416'), D('3.1416')


fails = {}


def check(name, ok, point):
    if not ok:
        fails.setdefault(name, []).append(point)


def rand_dec(lo_exp, hi_exp, places):
    v = D(random.choice((-1, 1))) * D(10) ** D(random.uniform(lo_exp, hi_exp))
    return rnd(v, places)


for _ in range(1500):
    d, k = random.randint(0, 10), random.randint(1, 3)
    T = D(10) ** -(d + k)

    # Evaluation procedures, at decimal inputs.
    x = rand_dec(-4, 6, random.randint(d, d + 12))
    check('atan_eval within 0.18T', abs(atan_eval(x, d, k) - atan_ref(x)) <= D('0.18') * T, (x, d, k))
    x = rand_dec(-3, 4, random.randint(d, d + 10))
    y = rand_dec(-3, 4, random.randint(d, d + 10))
    if not (y == 0 and x <= 0):
        check('atan2_eval within 0.1T', abs(atan2_eval(y, x, d, k) - atan2_ref(y, x)) <= D('0.1') * T, (y, x, d, k))

    # Cheap intervals contain the true values on random boxes.
    lo = rand_dec(-3, 3, 6)
    hi = lo + abs(rand_dec(-4, 2, 6))
    a, b = atan_cheap(lo, hi)
    for t in (lo, hi, (lo + hi) / 2):
        check('atan cheap interval', a <= atan_ref(t) <= b, (lo, hi))
    lx = rand_dec(-2, 2, 6)
    hx = lx + abs(rand_dec(-3, 1, 6))
    ly = rand_dec(-2, 2, 6)
    hy = ly + abs(rand_dec(-3, 1, 6))
    if not (lx <= 0 <= hx and ly <= 0 <= hy):
        a, b = atan2_cheap(lx, hx, ly, hy)
        for _ in range(5):
            tx = lx + (hx - lx) * D(random.random())
            ty = ly + (hy - ly) * D(random.random())
            if not (ty == 0 and tx <= 0):
                check('atan2 cheap interval', a <= atan2_ref(ty, tx) <= b, (lx, hx, ly, hy))

    # Whole atan node: true x, input rounded to the rule's places, evaluate, round.
    c = D('0.5') + D(10) ** -k
    xt_true = D(random.choice((-1, 1))) * D(10) ** D(random.uniform(-3, 6))
    L = abs(xt_true) * D(random.uniform(0.2, 1))
    dx = atan_places(d, k, L)
    for e in (-1, 1):
        xin = rnd(xt_true + e * c * D(10) ** -dx, dx)  # off by up to c * 10^-dx
        if abs(xin - xt_true) > c * D(10) ** -dx:
            continue
        out = rnd(atan_eval(xin, d, k), d)
        check('atan node good to d places', abs(out - atan_ref(xt_true)) <= c * D(10) ** -d, (xt_true, d, k))

    # Whole atan2 node, with L_y known.
    xt_true = D(random.uniform(-1, 1)) * D(10) ** D(random.uniform(-2, 3))
    yt_true = D(random.uniform(-1, 1)) * D(10) ** D(random.uniform(-2, 3))
    Lx = abs(xt_true) * D(random.uniform(0.2, 1))
    Ly = abs(yt_true) * D(random.uniform(0.2, 1))
    M = max(Lx, Ly)
    dxy = atan2_places(d, k, M)
    dx, dy = max(dxy, 3 - siz(Lx)), max(dxy, 3 - siz(Ly))
    for ex in (-1, 1):
        for ey in (-1, 1):
            xin = rnd(xt_true + ex * c * D(10) ** -dx, dx)
            yin = rnd(yt_true + ey * c * D(10) ** -dy, dy)
            if abs(xin - xt_true) > c * D(10) ** -dx or abs(yin - yt_true) > c * D(10) ** -dy:
                continue
            out = rnd(atan2_eval(yin, xin, d, k), d)
            check('atan2 node good to d places', abs(out - atan2_ref(yt_true, xt_true)) <= c * D(10) ** -d, (yt_true, xt_true, d, k))

for name, points in fails.items():
    print('FAIL', name, len(points), points[:3])

# Example 1: atan(10 pi) to 6 places, k = 2, with 10 pi to 7 places.
print('--- atan(10 pi), d = 6, k = 2')
tr = {}
xt = rnd(10 * PI, 7)
val = atan_eval(xt, 6, 2, tr)
print('x~ =', xt)
for name, v in tr['steps']:
    print(' ', name, v)
for n, P, t in tr['terms']:
    print('  n', n, 'p', 6 + 2 + 1 + 2 * siz(n) if n else '', 'P', P, 't', t, 'siz', siz(t) if t else None)
print('  sum', tr['sum'], ' pi/2', tr['outer'], ' result', val, ' rounded', rnd(val, 6))
print('  true atan(x~)', rnd(atan_ref(xt), 15), ' true atan(10 pi)', rnd(atan_ref(10 * PI), 15))

# Example 2: atan2(sin(pi - 0.00001), -1) to 8 places, k = 2.
print('--- atan2(sin(pi - 0.00001), -1), d = 8, k = 2')
y5 = rnd(D('0.00001'), 5)  # sin(pi - 0.00001) to 5 places
print('tighten: sin to 5 places', y5, ' interval', y5 - W5, y5 + W5)
print('cheap interval', atan2_cheap(D(-1), D(-1), y5 - W5, y5 + W5))
d, k = 8, 2
dy = max(atan2_places(d, k, D(1)), 3 - siz(y5 - W5))
print('places for y', dy, ' for sin argument', dy + k + 1)
pi_t = rnd(PI, dy + k + 1)
arg = pi_t - D('0.00001')
# sine of the argument, to dy + k + 1 places, via sin(pi - a) = sin a with high precision
a = PI - arg
sin_val = a - a ** 3 / 6 + a ** 5 / 120
yt = rnd(rnd(sin_val, dy + k + 1), dy)
print('pi~', pi_t, ' arg', arg, ' sin(arg) to', dy + k + 1, rnd(sin_val, dy + k + 1), ' y~', yt)
top = atan2_eval(yt, D(-1), d, k)
print('atan2 before rounding', top, ' to d + k + 1 places', rnd(top, d + k + 1), ' rounded', rnd(top, d))
print('true', rnd(atan2_ref(PI - (PI - D('0.00001')), D(-1)), 15))
print('true value', rnd(PI - atan_ref(D('0.00001')), 15))
print('done')

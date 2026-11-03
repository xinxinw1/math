"""Check the acot rules in README.md at random points.

Run with: python3 check_acot.py
Uses 60-digit decimal arithmetic for the reference values. Checks the places
rule, the cheap intervals, the evaluation error bound and whole nodes, and
prints the numbers used in the README's examples.

acot uses the odd convention: acot(x) = atan(1/x) for x != 0, and acot(0) = pi/2.
"""
import random
from decimal import Decimal as D, getcontext, ROUND_HALF_EVEN

getcontext().prec = 60
random.seed(7)
ONE, ZERO = D(1), D(0)
PI = D('3.14159265358979323846264338327950288419716939937510582097494459')
W5 = D('0.00001')


def rnd(v, p):
    return D(v).quantize(D(1).scaleb(-p), rounding=ROUND_HALF_EVEN)


def siz(v):
    return D(v).copy_abs().adjusted() + 1


def sgn(v):
    return (v > 0) - (v < 0)


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


def acot_ref(x):
    x = D(x)
    return PI / 2 if x == 0 else atan_ref(ONE / x)


def atan_series(w, d, trace=None):
    """The halvings and series from atan and atan2 in whole expressions: returns S with atan(w) = 4S."""
    p = d + 2
    v = w
    steps = []
    for _ in range(2):
        s = rnd((ONE + v * v).sqrt(), p)
        v = rnd(v / (ONE + s), p)
        steps.append(v)
    v2 = v * v
    P, total, n, terms = v, v, 0, [(0, v, v)]
    while not (terms[-1][2] == 0 or siz(terms[-1][2]) <= -(d + 1)):
        n += 1
        pn = d + 1 + 2 * siz(n)
        P = rnd(P * v2, pn)
        t = rnd((-1) ** n * P / (2 * n + 1), pn)
        total += t
        terms.append((n, P, t))
    if trace is not None:
        trace.update(steps=steps, terms=terms, sum=total)
    return total


def acot_eval(x, d, trace=None):
    """acot(x) for a nonzero decimal x, within 0.18 * 10^-d."""
    x = D(x)
    p = d + 2
    if abs(x) >= 1:
        w = rnd(ONE / x, p)
        S = atan_series(w, d, trace)
        result = 4 * S
    else:
        w = x
        S = atan_series(w, d, trace)
        result = sgn(x) * rnd(PI / 2, p) - 4 * S
    if trace is not None:
        trace.update(w=w, result=result)
    return result


def acot_places(d, L):
    return max(d + 1 - 2 * max(0, siz(D('0.99') * L) - 1), 3 - siz(L))


def acot_cheap(lo, hi):
    """Cheap interval for acot on [lo, hi]; None means it contains 0 and x must be tightened."""
    if lo <= 0 <= hi:
        return None
    a_hi = rnd(acot_eval(lo, 5), 5) + W5  # acot is decreasing on each side of 0
    a_lo = rnd(acot_eval(hi, 5), 5) - W5
    if lo > 0:
        a_lo = max(a_lo, min(ONE / hi, ONE) / 2)
        a_hi = min(a_hi, D('1.5708'))
    else:
        a_hi = min(a_hi, -min(ONE / abs(lo), ONE) / 2)
        a_lo = max(a_lo, D('-1.5708'))
    return a_lo, a_hi


fails = {}


def check(name, ok, point):
    if not ok:
        fails.setdefault(name, []).append(point)


for _ in range(2000):
    d = random.randint(0, 12)
    T = D(10) ** -d

    # Evaluation error at decimal inputs.
    x = rnd(D(random.choice((-1, 1))) * D(10) ** D(random.uniform(-6, 6)), random.randint(max(d, 0), d + 14))
    if x != 0:
        check('acot_eval within 0.18T', abs(acot_eval(x, d) - acot_ref(x)) <= D('0.18') * T, (x, d))

    # Cheap intervals.
    lo = rnd(D(random.choice((-1, 1))) * D(10) ** D(random.uniform(-6, 3)), 8)
    hi = lo + abs(rnd(D(10) ** D(random.uniform(-6, 2)), 8))
    iv = acot_cheap(lo, hi)
    if iv is not None:
        for t in (lo, hi, (lo + hi) / 2):
            check('cheap interval', iv[0] <= acot_ref(t) <= iv[1], (lo, hi))
        check('cheap interval excludes 0', iv[0] > 0 or iv[1] < 0, (lo, hi))

    # Whole node: true x, input off by the full 10^-dx, evaluate.
    xt = D(random.choice((-1, 1))) * D(10) ** D(random.uniform(-6, 6))
    L = abs(xt) * D(random.uniform(0.2, 1))
    dx = acot_places(d, L)
    for e in (-1, 1):
        xin = xt + e * D(10) ** -dx
        check('input keeps its sign', sgn(xin) == sgn(xt), (xt, d))
        out = acot_eval(xin, d)
        check('node good to d places', abs(out - acot_ref(xt)) <= D(10) ** -d, (xt, d))

for name, points in fails.items():
    print('FAIL', name, len(points), points[:3])


def sin_near_pi(arg):
    """sin(arg) for arg close to pi, via sin(pi + a) = -sin a."""
    a = arg - PI
    return -(a - a ** 3 / 6 + a ** 5 / 120)


# Example 1: acot(10 pi) rounded to 6 places, so d = 8.
print('--- acot(10 pi), d = 8')
L = D(31)
print('places', acot_places(8, L))
xt = rnd(10 * PI, acot_places(8, L))
tr = {}
val = acot_eval(xt, 8, tr)
print('x~', xt, ' w', tr['w'], ' halvings', tr['steps'])
for n, P, t in tr['terms']:
    print('  n', n, 'P', P, 't', t, 'siz', siz(t) if t else None)
print('  sum', tr['sum'], ' result', val, ' rounded', rnd(val, 6), ' true', rnd(acot_ref(10 * PI), 13))

# Example 2: acot(sin(pi + 0.00001)) rounded to 8 places, so d = 10.
print('--- acot(sin(pi + 0.00001)), d = 10')
for p in (5, 10):  # tightening: the sine good to p places, computed to p + 1
    v = rnd(sin_near_pi(rnd(PI, p + 1) + D('0.00001')), p + 1)
    print('tighten: sin to', p, 'places', v, ' interval', v - D(10) ** -p, v + D(10) ** -p)
lo, hi = v - D(10) ** -10, v + D(10) ** -10
L = abs(hi)
print('cheap interval', acot_cheap(lo, hi))
dx = acot_places(10, L)
print('places for the sine', dx, ' for its argument', dx + 1)
pi_t = rnd(PI, dx + 1)
arg = pi_t + D('0.00001')
xt = rnd(sin_near_pi(arg), dx + 1)
print('pi~', pi_t, ' arg', arg, ' x~ = sin(arg) to', dx + 1, 'places', xt)
val = acot_eval(xt, 10)
print('acot before rounding', val, ' rounded', rnd(val, 8))
print('true', rnd(acot_ref(-(D('0.00001') - D('0.00001') ** 3 / 6)), 15))
print('done')

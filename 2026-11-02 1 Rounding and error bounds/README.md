# Rounding and error bounds

What rounding does to the digits of a number, and how to say how accurate an
approximation is. This is the first of four docs on precision. The others
build on it, and work out how many places the inputs to a calculation need.

*Xin-Xin*

This is a reworking of the
2015 notes on precision and accuracy, which start with
[Precision functions](../2015-03-17%201%20Precision%20functions/README.md).

Throughout, $\log$ means $\log_{10}$.

## Rounding

For an integer $p$, round $x$ to $p$ decimal places with

$$\mathrm{rnd}(x, p) = \mathrm{sgn}(x) \cdot 10^{-p} \left\lfloor 10^p |x| + \tfrac{1}{2} \right\rfloor.$$

This rounds to the nearest multiple of $10^{-p}$, with ties going away from
zero. The place $p$ can be negative: $\mathrm{rnd}(1234, -2) = 1200$.

The properties used below are:

1. $\mathrm{rnd}(x, p)$ is a multiple of $10^{-p}$.
2. $|\mathrm{rnd}(x, p) - x| \le \tfrac{1}{2} \cdot 10^{-p}$.
3. If $x$ is a multiple of $10^{-p}$, then $\mathrm{rnd}(x, p) = x$.
4. $|\mathrm{rnd}(x, p)| = \mathrm{rnd}(|x|, p)$, and $\mathrm{rnd}(x, p)$ is
   non-decreasing in $x$.

Round-half-to-even also has all four properties, so everything below holds for
it too.

## Size, precision and significant figures

### Size

For $x \ne 0$, let

$$\mathrm{siz}(x) = \lfloor \log|x| \rfloor + 1.$$

For $\lvert x \rvert \ge 1$, this is the length of the integer part of $x$: the
number of digits before the decimal point. The formula extends it to every
nonzero $x$. Equivalently, $\mathrm{siz}(x)$ is the integer $s$ with

$$10^{s - 1} \le |x| < 10^s.$$

It can be read off the decimal string of $x$, written without leading zeros in
the integer part:

- **At least 1:** if $\lvert x \rvert \ge 1$, count the digits before the
  decimal point.
- **Below 1:** if $\lvert x \rvert < 1$, count the zeros between the decimal
  point and the first nonzero digit, and negate.

For example:

| $x$ | Rule | $\mathrm{siz}(x)$ |
|---|---|---|
| $1234$ | 4 digits before the point | $4$ |
| $1000$ | 4 digits before the point | $4$ |
| $999.9$ | 3 digits before the point | $3$ |
| $10$ | 2 digits before the point | $2$ |
| $7$ | 1 digit before the point | $1$ |
| $0.5$ | no zeros after the point | $0$ |
| $0.05$ | 1 zero after the point | $-1$ |
| $0.00123$ | 2 zeros after the point | $-2$ |
| $-250$ | 3 digits before the point | $3$ |

A few things the table shows:

- **Powers of 10.** $\mathrm{siz}$ steps up exactly at each power of 10:
  $\mathrm{siz}(999.9) = 3$ but $\mathrm{siz}(1000) = 4$.
- **Leading digit.** The leading digit of $x$ is in the
  $10^{\mathrm{siz}(x) - 1}$ place. For $0.05$ that is the $10^{-2}$ place.
- **Sign.** The sign doesn't matter: $\mathrm{siz}(-250) = \mathrm{siz}(250)$.
- **Zero.** $\mathrm{siz}(0)$ is undefined, since $0$ has no nonzero digit.

This keeps the 2015 name $\mathrm{siz}$, short for size, and extends it below 1.
The 2015 $\mathrm{nsiz}(x)$ is $\mathrm{siz}(x) - 1$, the exponent of $x$ in
scientific notation.

### Precision

Call $x$ a *terminating decimal* if $x = n \cdot 10^{-j}$ for some integers
$n$ and $j$. For a nonzero terminating decimal $x$, let

$$\mathrm{prec}(x) = \text{the smallest integer } p \text{ such that } 10^p x \text{ is an integer}.$$

This is the number of decimal places $x$ has: $\mathrm{prec}(2.50) = 1$ and
$\mathrm{prec}(1200) = -2$.

The smallest $p$ exists. $10^p x$ is an integer for every large enough $p$, and
for $p \le -\mathrm{siz}(x)$ it lies strictly between $-1$ and $1$ but isn't 0.

By properties 1 and 3 of rounding, $\mathrm{rnd}(x, p) = x$ exactly when
$p \ge \mathrm{prec}(x)$. So this matches the 2015 definition ("the smallest $p$
such that $\mathrm{rnd}(x, p) = x$") wherever that one makes sense.
$\mathrm{prec}$ is undefined for $0$ (every $p$ works) and for numbers like
$1/3$ (no $p$ works).

### Significant figures

For a nonzero terminating decimal $x$, let

$$\mathrm{fig}(x) = \mathrm{prec}(x) + \mathrm{siz}(x).$$

The leading digit of $x$ is in the $10^{\mathrm{siz}(x) - 1}$ place and the last
nonzero digit is in the $10^{-\mathrm{prec}(x)}$ place. So $\mathrm{fig}(x)$
counts the digits from the first nonzero digit to the last nonzero digit. For
example:

| $x$ | $\mathrm{prec}(x)$ | $\mathrm{siz}(x)$ | $\mathrm{fig}(x)$ |
|---|---|---|---|
| $1.5$ | $1$ | $1$ | $2$ |
| $0.005$ | $3$ | $-2$ | $1$ |
| $1200$ | $-2$ | $4$ | $2$ |

### Values and measurements

$\mathrm{fig}$ is a property of a number, so $1.5$ and $1.50$ both have 2
significant figures. As measurements they are different: $1.50$ claims an
extra place of accuracy. The accuracy of a measurement isn't something the
number itself can carry. So from here on, an approximation is a pair, a value
and an error bound, rather than a value alone.

## What rounding does to digits

**Theorem 1.** Let $x \ne 0$, and let $y = \mathrm{rnd}(x, p) \ne 0$. Then

$$\mathrm{siz}(y) = \mathrm{siz}(x) \quad \text{or} \quad \mathrm{siz}(y) = \mathrm{siz}(x) + 1.$$

The second case happens only when $|y| = 10^{\mathrm{siz}(x)}$. This is a
*carry*, as in $\mathrm{rnd}(99.6, 0) = 100$.

**Proof.** By property 4 we can assume $x > 0$, so $y > 0$. Let
$s = \mathrm{siz}(x)$ and $u = 10^{-p}$, so $10^{s-1} \le x < 10^s$.

**Upper bound.** If $10^s$ is a multiple of $u$, then by properties 3 and 4,
$y \le \mathrm{rnd}(10^s, p) = 10^s$. So $\mathrm{siz}(y) \le s + 1$, with
equality only if $y = 10^s$. If $10^s$ is not a multiple of $u$, then
$u \ge 10^{s+1}$. That makes $x < 10^s \le u/10 < u/2$, so $y = 0$, which was
excluded.

**Lower bound.** If $10^{s-1}$ is a multiple of $u$, then
$y \ge \mathrm{rnd}(10^{s-1}, p) = 10^{s-1}$ by properties 3 and 4. If not, then
$u > 10^{s-1}$, and $y$ is a positive multiple of $u$, so $y \ge u > 10^{s-1}$.
Either way, $\mathrm{siz}(y) \ge s$. ∎

**Theorem 2.** Let $x$ be a nonzero terminating decimal, and let
$y = \mathrm{rnd}(x, p) \ne 0$. Then:

1. $\mathrm{prec}(y) \le p$.
2. If $p \ge \mathrm{prec}(x)$, then $y = x$.
3. $\mathrm{fig}(y) \le \mathrm{fig}(x)$.
4. $\mathrm{fig}(y) \le p + \mathrm{siz}(y)$.

**Proof.** Part 1 is property 1 of rounding, and part 2 is property 3. Part 4
follows from part 1 and the definition of $\mathrm{fig}$.

For part 3, if $p \ge \mathrm{prec}(x)$ then $y = x$. Otherwise
$p \le \mathrm{prec}(x) - 1$. If rounding carried, $y = \pm 10^{\mathrm{siz}(x)}$
and $\mathrm{fig}(y) = 1$. If not, $\mathrm{siz}(y) = \mathrm{siz}(x)$ by
Theorem 1, so

$$\mathrm{fig}(y) \le p + \mathrm{siz}(x) \le \mathrm{prec}(x) - 1 + \mathrm{siz}(x) = \mathrm{fig}(x) - 1.$$

∎

So rounding never adds significant figures, and if it changes $x$ without a
carry it removes at least one.

The 2015 notes claimed
$\mathrm{fig}(\mathrm{rnd}(x, p)) = \min(p + \mathrm{siz}(x), \mathrm{fig}(x))$.
That fails in two ways:

- **A carry:** $\mathrm{rnd}(99.6, 0) = 100$ has 1 significant figure, but the
  formula gives $\min(0 + 2, 3) = 2$.
- **Trailing zeros dropped:** $\mathrm{rnd}(1.04, 1) = 1.0 = 1$ has 1
  significant figure, but the formula gives $\min(1 + 1, 3) = 2$.

## Approximations

### Error bounds

An *approximation* to a real number $x$ is a pair $(\tilde{x}, \varepsilon_x)$
with

$$|\tilde{x} - x| \le \varepsilon_x.$$

Write this as $x = \tilde{x} \pm \varepsilon_x$. The tilde always marks the
value you have, and the plain letter the true value.

The interval $I_x = [\tilde{x} - \varepsilon_x, \tilde{x} + \varepsilon_x]$
contains both $x$ and $\tilde{x}$.

### Good to d places

Say $\tilde{x}$ is *good to d places* if

$$|\tilde{x} - x| \le 10^{-d}.$$

This says how accurate $\tilde{x}$ is, not how it is written: $\tilde{x}$ can
have any number of decimal places. If the error is at most $c \cdot 10^{-d}$,
call $c$ the *error constant*. Every value good to $d$ places has $c \le 1$,
and an exactly rounded value, $\tilde{x} = \mathrm{rnd}(x, d)$, has
$c = \frac{1}{2}$. The formulas in the later docs keep track of $c$, because
$c = \frac{1}{2}$ sometimes saves a place.

The 2015 notes used a stricter standard. There, a value good to $d$ places
had at most $d$ places, and an error of at most $0.51 \cdot 10^{-d}$: up to
$\frac{1}{2} \cdot 10^{-d}$ from rounding to $d$ places, and up to
$0.01 \cdot 10^{-d}$ from computing it before rounding, with 2 *guard digits*.
Holding every intermediate value to that standard costs about 2 places at
every step of a calculation, because each step has to compute its result 2
places further than it was asked for, just so it can round. Here rounding is
optional, and only the final result needs guard digits.

### The invariant

**Lemma 1.** If $|\tilde{f} - f| \le \varepsilon$, then

$$|\mathrm{rnd}(\tilde{f}, q) - f| \le \varepsilon + \tfrac{1}{2} \cdot 10^{-q}.$$

**Proof.** By property 2 of rounding,

$$|\mathrm{rnd}(\tilde{f}, q) - f| \le |\mathrm{rnd}(\tilde{f}, q) - \tilde{f}| + |\tilde{f} - f| \le \tfrac{1}{2} \cdot 10^{-q} + \varepsilon.$$

∎

So rounding is just another source of error, and it is used in two ways:

- **Along the way.** A value good to $d + 1$ places, rounded to $d$ places, is
  still good to $d$ places, with error at most
  $(0.1 + 0.5) \cdot 10^{-d} = 0.6 \cdot 10^{-d}$. To keep the numbers in a
  calculation short, compute a value one place further than needed and round
  it.
- **At the end.** To report a result rounded to $r$ places, compute it good to
  $d > r$ places, then round it to $r$ places. Its error is then at most
  $(\frac{1}{2} + 10^{-(d - r)}) \cdot 10^{-r}$. The $d - r$ extra places are
  the guard digits. One is enough to make the rounded result good to $r$
  places. More make it more likely that the rounded result is the true value
  correctly rounded, as
  [Correct rounding](../2026-11-03%20Correct%20rounding/README.md) explains.
  The examples use 2, as the 2015 notes did, so $d = r + 2$.

This is the idea that makes the method work. Inputs, intermediate results and
outputs all meet the same standard, so the output of one calculation can be
the input to the next, without rounding it first. Each step has one job: given
the places $d$ its result needs, compute it within $T = 10^{-d}$ of the true
value.

### From an error bound to decimal places

**Lemma 2.** $c \cdot 10^{-d} \le \varepsilon$ exactly when
$d \ge \log c - \log \varepsilon$. So the fewest places that give error at most
$\varepsilon$ is

$$d = \lceil \log c - \log \varepsilon \rceil.$$

The ceiling matters: $d$ has to be a whole number.

Next: [Input places for arithmetic](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md).

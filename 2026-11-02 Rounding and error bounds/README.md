# Rounding and error bounds

How many decimal places the inputs to a calculation need so that the output,
rounded to $d$ places, is accurate. Also covers what rounding does to the
number of digits.

*Xin-Xin*

This is a reworking of the
[2015 notes on precision and accuracy](../2015-03-17%20Precision%20and%20accuracy/README.md).
The last section lists what changed.

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

Fix a whole number $k \ge 1$ of *guard digits*, and let

$$c_k = \tfrac{1}{2} + 10^{-k}.$$

Say $\tilde{x}$ is good to $d$ places if $\tilde{x}$ has at most $d$ decimal
places and

$$|\tilde{x} - x| \le c_k \cdot 10^{-d}.$$

The $\frac{1}{2} \cdot 10^{-d}$ part is the error from rounding to $d$ places.
The $10^{-k} \cdot 10^{-d}$ part is the error left over from computing $x$
before rounding. The 2015 notes used $k = 2$, so $c_2 = 0.51$.

An exactly rounded value, $\tilde{x} = \mathrm{rnd}(x, d)$, is good to $d$
places with error $\frac{1}{2} \cdot 10^{-d}$. In the formulas below, an
exactly rounded input can use $c = \frac{1}{2}$ in place of $c_k$.

### The invariant

**Lemma 1.** If $|\tilde{f} - f| \le 10^{-(d+k)}$, then $\mathrm{rnd}(\tilde{f}, d)$
is good to $d$ places as an approximation to $f$.

**Proof.** By property 2 of rounding,

$$|\mathrm{rnd}(\tilde{f}, d) - f| \le |\mathrm{rnd}(\tilde{f}, d) - \tilde{f}| + |\tilde{f} - f| \le \tfrac{1}{2} \cdot 10^{-d} + 10^{-(d+k)} = c_k \cdot 10^{-d}.$$

∎

This is the idea that makes the method work. Inputs and outputs meet the same
standard, so the output of one calculation can be the input to the next. Each
step has one job: compute $\tilde{f}$ within $T = 10^{-(d+k)}$ of the true
value, then round to $d$ places.

### From an error bound to decimal places

**Lemma 2.** $c \cdot 10^{-d} \le \varepsilon$ exactly when
$d \ge \log c - \log \varepsilon$. So the fewest places that give error at most
$\varepsilon$ is

$$d = \lceil \log c - \log \varepsilon \rceil.$$

The ceiling matters: $d$ has to be a whole number.

## How errors propagate

Suppose $f$ is computed from approximations $\tilde{x}$ and $\tilde{y}$. The
error in $f(\tilde{x}, \tilde{y})$ has two parts:

- the *propagated* error $|f(\tilde{x}, \tilde{y}) - f(x, y)|$, from the
  inputs being wrong.
- the *evaluation* error, from computing $f(\tilde{x}, \tilde{y})$ to finitely
  many places.

Sums, differences and products of terminating decimals can be computed exactly,
so their evaluation error is 0. For division, square roots and other functions,
evaluate to some number of places and add that error to the total.
[Choosing input places](#choosing-input-places) sets aside half of the error
budget for this. The rest of this section is about the propagated error.

### Exact rules

**Theorem 3.** For approximations $(\tilde{x}, \varepsilon_x)$ and
$(\tilde{y}, \varepsilon_y)$:

| $f$ | Bound on $\lvert f(\tilde{x}, \tilde{y}) - f(x, y) \rvert$ | Condition |
|---|---|---|
| $x + y$ or $x - y$ | $\varepsilon_x + \varepsilon_y$ | |
| $xy$ | $\lvert\tilde{y}\rvert \varepsilon_x + \lvert\tilde{x}\rvert \varepsilon_y + \varepsilon_x \varepsilon_y$ | |
| $x / y$ | $\dfrac{\lvert\tilde{y}\rvert \varepsilon_x + \lvert\tilde{x}\rvert \varepsilon_y}{\lvert\tilde{y}\rvert (\lvert\tilde{y}\rvert - \varepsilon_y)}$ | $\varepsilon_y < \lvert\tilde{y}\rvert$ |

These bounds are exact: nothing is assumed negligible, and they only use values
you have.

**Proof.** Write $r = \tilde{x} - x$ and $s = \tilde{y} - y$, so
$|r| \le \varepsilon_x$ and $|s| \le \varepsilon_y$.

**Sum.** $(\tilde{x} \pm \tilde{y}) - (x \pm y) = r \pm s$.

**Product.**

$$\tilde{x}\tilde{y} - xy = \tilde{x}s + yr.$$

Since $|y| \le |\tilde{y}| + \varepsilon_y$,

$$|\tilde{x}\tilde{y} - xy| \le |\tilde{x}| \varepsilon_y + (|\tilde{y}| + \varepsilon_y) \varepsilon_x.$$

**Quotient.** The condition $\varepsilon_y < |\tilde{y}|$ says $0$ is not in
$I_y$, so $y \ne 0$ and $|y| \ge |\tilde{y}| - \varepsilon_y > 0$. Then

$$\frac{\tilde{x}}{\tilde{y}} - \frac{x}{y} = \frac{\tilde{x}y - x\tilde{y}}{\tilde{y}y} = \frac{\tilde{y}r - \tilde{x}s}{\tilde{y}y},$$

and the bound follows from $|y| \ge |\tilde{y}| - \varepsilon_y$. ∎

If $\varepsilon_y \ge |\tilde{y}|$, then $y$ could be $0$, and no output
accuracy is possible.

### The general rule

**Theorem 4.** Let $f$ be continuously differentiable on the box
$B = I_x \times I_y$, and let

$$A_x \ge \sup_B \left|\frac{\partial f}{\partial x}\right|, \qquad A_y \ge \sup_B \left|\frac{\partial f}{\partial y}\right|.$$

Then

$$|f(\tilde{x}, \tilde{y}) - f(x, y)| \le A_x \varepsilon_x + A_y \varepsilon_y.$$

**Proof.** The segment from $(x, y)$ to $(\tilde{x}, \tilde{y})$ lies in $B$. By
the mean value theorem, applied along it, there is a point $\xi$ on it with

$$f(\tilde{x}, \tilde{y}) - f(x, y) = \frac{\partial f}{\partial x}(\xi) \cdot r + \frac{\partial f}{\partial y}(\xi) \cdot s.$$

Take absolute values. ∎

The same holds for any number of inputs. Theorem 3 is the special case where
the suprema can be worked out:

| $f$ | $A_x$ | $A_y$ |
|---|---|---|
| $x + y$ | $1$ | $1$ |
| $xy$ | $\lvert\tilde{y}\rvert + \varepsilon_y$ | $\lvert\tilde{x}\rvert + \varepsilon_x$ |
| $x / y$ | $\dfrac{1}{\lvert\tilde{y}\rvert - \varepsilon_y}$ | $\dfrac{\lvert\tilde{x}\rvert + \varepsilon_x}{(\lvert\tilde{y}\rvert - \varepsilon_y)^2}$ |
| $\sqrt{x}$ | $\dfrac{1}{2\sqrt{\tilde{x} - \varepsilon_x}}$ | |

For products and quotients, Theorem 4 is slightly weaker than Theorem 3, but
it covers every differentiable function.

### Monotonic functions

For a function of one variable that only goes up or only goes down, there is
an exact answer: the largest input error that keeps the output error within
$\eta$. This is the inverse-function method from the 2015 notes.

**Theorem 5.** Let $f$ be continuous and strictly increasing on an interval
$J$ containing $x$, and let $\eta > 0$. Let

$$\delta^{+} = f^{-1}(f(x) + \eta) - x, \qquad \delta^{-} = x - f^{-1}(f(x) - \eta),$$

taking $\delta^{+} = \infty$ if $f(x) + \eta$ is above every value of $f$ on
$J$, and $\delta^{-} = \infty$ if $f(x) - \eta$ is below every value. Then
$|f(\tilde{x}) - f(x)| \le \eta$ for every $\tilde{x}$ in $J$ with
$|\tilde{x} - x| \le \delta$ if

$$\delta \le \min(\delta^{+}, \delta^{-}).$$

If $J$ reaches past $x + \delta^{+}$ and $x - \delta^{-}$, no larger $\delta$
works.

For a strictly decreasing $f$, swap $f(x) + \eta$ and $f(x) - \eta$ in the
definitions of $\delta^{+}$ and $\delta^{-}$.

**Proof.** Take $\tilde{x} \ge x$ in $J$. Since $f$ is increasing,
$|f(\tilde{x}) - f(x)| = f(\tilde{x}) - f(x)$, and this is at most $\eta$
exactly when $\tilde{x} \le x + \delta^{+}$. That is automatic if
$\delta^{+} = \infty$. If not, it holds because $f^{-1}$ is increasing too,
and it fails for every $\tilde{x}$ just above $x + \delta^{+}$. So the inputs
above $x$ are all fine when $\delta \le \delta^{+}$, and, if $J$ has inputs
just above $x + \delta^{+}$, only then. The inputs below
$x$ work the same way with $\delta^{-}$. For a decreasing $f$, apply this to
$-f$, which is increasing. ∎

Unlike Theorem 4, this gives the largest $\delta$ that works, not just one
that works. The catch is that $\delta^{+}$ and $\delta^{-}$ depend on the true
$x$, which you only know approximately. So use the smallest value they take
over the range $x$ might be in. In the cases below, that is at one end of the
range.

## Choosing input places

The question from the 2015 notes is the reverse: given the output places $d$,
how many places do the inputs need? Each subsection below starts with a rule
in whole numbers that answers this, then an example, then why the rule works.

### Bounds before digits

You choose the input places before computing the inputs, so the rules can't
use the inputs' exact values. They use rough bounds instead, found from a
quick low-accuracy estimate. There are two kinds:

- **Bounds on the true value.** $U_x$ is a number with $|x| \le U_x$, and
  $L_x$ is a positive number with $L_x \le |x|$.
- **Bounds that also cover the approximation.** $\bar{U}_x$ is at least both
  $|x|$ and $|\tilde{x}|$, and $\bar{L}_x$ is positive and at most both.

Which kind a rule needs depends on how it was derived. The square root,
exponential and logarithm rules come from Theorem 5, which fixes the true $x$,
so they only need $U$ and $L$. The product, quotient and power rules come from
error formulas that mix $x$ and $\tilde{x}$, so they need $\bar{U}$ or
$\bar{L}$.

The rules only need the sizes of the bounds, which are digit counts. For
example, $\pi < 4$ gives an upper bound of 4, with $\mathrm{siz}(4) = 1$, and
$\pi > 3$ gives a lower bound of 3, with $\mathrm{siz}(3) = 1$.

You don't know $\tilde{x}$ yet when you choose the bounds, but it is within
$\varepsilon_x$ of $x$, which is tiny next to a rough bound. So a bound on $x$
with a little room also covers $\tilde{x}$. It only matters when $x$ is within
$\varepsilon_x$ of the bound. For $x \le 9.9997$, $U_x = 9.9997$ is valid,
but with 3 places $\tilde{x}$ might come out as $10.000$, which is above it.
So take $\bar{U}_x = 10.1$, with $\mathrm{siz} = 2$. Any valid bound works. A
looser one costs at most a digit or so.

A round bound needs no room. If $U_x$ is a multiple of $10^{-p}$ and
$\tilde{x}$ has $p$ places with an error below $10^{-p}$, then $\tilde{x}$
can't pass $U_x$, since the next multiple up is too far from $x$. So for
$x < 10$, the bound 10 also covers $\tilde{x}$ to any number of places from 0 up.

### The error budget

The target is a computed value within $T = 10^{-(d+k)}$ of the true value,
which Lemma 1 then turns into an output good to $d$ places. That error has two
parts, so split $T$ between them:

$$\eta + (\text{evaluation error}) \le T,$$

where $\eta$ is the budget for the propagated error.

- **Exact evaluation.** Sums, differences and products of terminating
  decimals have no evaluation error, so $\eta = T$.
- **Everything else.** For division, powers, square roots, exponentials,
  logarithms, sines and cosines, take $\eta = T/2$, and compute $f(\tilde{x})$ to $d + k + 1$
  places, rounded or cut off. That has an error of at most
  $10^{-(d+k+1)} = T/10$, well within the other half.

### Where the rules come from

With $n$ inputs, split $\eta$ evenly, so each input needs
$A_i \varepsilon_i \le \eta/n$, where $A_i$ is from Theorem 4. If input $i$ is
good to $d_i$ places, then $\varepsilon_i = c \cdot 10^{-d_i}$, and Lemma 2
gives the exact count

$$d_i = \left\lceil -\log\eta + \log(n c A_i) \right\rceil,$$

where $-\log\eta$ is $d + k$ when $\eta = T$, and $d + k + \log 2$ when
$\eta = T/2$.

Here $c$ is the error constant of the input: its error is at most
$c \cdot 10^{-d_i}$. It is $\frac{1}{2}$ if the input is exactly rounded, and
$c_k = \frac{1}{2} + 10^{-k}$ if it is the rounded output of an earlier step,
which is $0.51$ for $k = 2$. For any $k \ge 1$, $c$ is between $0.5$ and $0.6$.

The rules turn the exact count into whole numbers:

- **Leave out log c.** $\log c$ is between $-0.31$ and $-0.22$, so it is
  negative.
- **Round small constants up,** such as $\log 2 \approx 0.30$, usually to 1.
- **Use siz in place of log.** For an upper bound, $\log U < \mathrm{siz}(U)$.
  For a lower bound, $\log L \ge \mathrm{siz}(L) - 1$.

So a rule never asks for fewer places than the exact count, and usually asks
for the same number or one more.

Splitting evenly is a choice, not a requirement. Any $\varepsilon_i$ with
$\sum A_i \varepsilon_i \le \eta$ works, and $T$ can be split unevenly between
$\eta$ and the evaluation error too. An input that is cheap to get more digits
of can take a smaller share of the error.

### Summary

| Operation | Input places |
|---|---|
| Sum of $n$ terms | $d + k + \mathrm{siz}(n)$ |
| $xy$ | $d_x = d + k + 1 + \mathrm{siz}(\bar{U}_y)$, and $d_y = d + k + 1 + \mathrm{siz}(\bar{U}_x)$ |
| $x_1 \cdots x_n$ | factor $i$: $d + k + \mathrm{siz}(n)$, plus the sizes of the other factors' $\bar{U}$ |
| $x / y$ | $d_x = d + k + 2 - \mathrm{siz}(\bar{L}_y)$, and $d_y = d + k + 3 + \mathrm{siz}(U_x) - 2\mathrm{siz}(\bar{L}_y)$ |
| $x + a$, $a$ with at most $d$ places | $d$ |
| $ax$ | $d + k + \mathrm{siz}(a)$ |
| $x^n$, $n \le 8$ | $d + k + 1 + (n - 1)\mathrm{siz}(\bar{U}_x)$ |
| $x^n$, any $n$ | $d + k + \mathrm{siz}(2n) + (n - 1)\mathrm{siz}(\bar{U}_x)$ |
| $\sqrt{x}$ | $d + k - \lfloor (\mathrm{siz}(L_x) - 1)/2 \rfloor$ |
| $e^x$ | $d + k + 2 + \lfloor 0.44 U_x \rfloor$ for $x \ge 0$, and $\max(1, d + k + 2 - \lceil 0.43 L_x \rceil)$ for $x < 0$ |
| $\ln x$ | $d + k + 2 - \mathrm{siz}(L_x)$ |
| $\sin x$, $\cos x$ | $d + k + 1$, and $\pi$ to $d + k + 1 + \mathrm{siz}(j)$ places when reducing by $j \ne 0$ quarter turns |
| Series term $n$ | $p_n = d + k + 2\mathrm{siz}(n)$ places |
| $\ln x$ by series | terms to $d + k + 1 + 2\mathrm{siz}(n)$ places, $z$ to $d + k + 2$, and $\ln 2$ to $d + k + 1 + \mathrm{siz}(j)$ |

### Sums

**Rule.** Each of $n$ terms needs

$$d_i = d + k + \mathrm{siz}(n).$$

**Example.** For a sum of 30 terms good to $d = 2$ places, with $k = 2$, each
term needs $2 + 2 + \mathrm{siz}(30) = 6$ places.

**Why.** $A_i = 1$ and $\eta = T$, so the exact count is
$\lceil d + k + \log(nc) \rceil$, and $\log(nc) < \log n < \mathrm{siz}(n)$.

For $k = 2$ and $c = c_2 = 0.51$, the exact count is the 2015 result
$d + 2 + \log\frac{51n}{100}$, and gives the same table:

| Number of terms | $d_i$ |
|---|---|
| $n \le 100/51 \approx 1.96$ | $d + 2$ |
| $n \le 1000/51 \approx 19.6$ | $d + 3$ |
| $n \le 10000/51 \approx 196$ | $d + 4$ |
| $n \le 100000/51 \approx 1961$ | $d + 5$ |

With exactly rounded inputs, $c = \frac{1}{2}$ and the cutoffs become
$n \le 2, 20, 200, 2000$. The rule asks for at most one more place than the
table.

### Products

**Rule.** With upper bounds $\bar{U}_x$ on both $|x|$ and $|\tilde{x}|$, and
$\bar{U}_y$ on both $|y|$ and $|\tilde{y}|$,

$$d_x = d + k + 1 + \mathrm{siz}(\bar{U}_y), \qquad d_y = d + k + 1 + \mathrm{siz}(\bar{U}_x).$$

Each input's places depend on the size of the *other* input.

**Example.** For $\pi e$ good to $d = 3$ places, with $k = 2$: $\pi < 4$ and
$e < 3$, both of size 1, so each needs $3 + 2 + 1 + 1 = 7$ places.
[Examples](#examples) works this through.

**Why.** From the proof of Theorem 3,
$\tilde{x}\tilde{y} - xy = \tilde{x}(\tilde{y} - y) + y(\tilde{x} - x)$, so the
propagated error is at most $\bar{U}_x \varepsilon_y + \bar{U}_y \varepsilon_x$.
Strictly, this needs the bound on $|\tilde{x}|$ and the bound on $|y|$ (or the
other way round, splitting the product the other way), but covering both is
simpler. The product is exact, so $\eta = T$, and the exact counts are

$$d_x = \lceil d + k + \log(2c \bar{U}_y) \rceil, \qquad d_y = \lceil d + k + \log(2c \bar{U}_x) \rceil.$$

Since $\log(2c) \le \log 1.2 < 1$ and
$\log \bar{U}_y < \mathrm{siz}(\bar{U}_y)$, the rule is enough.

With $k = 2$ and $\bar{U}_y = 10^{\mathrm{siz}(y)}$, the rule is the 2015 rule
$d_1 \ge d + 3 + \mathrm{siz}(y)$, now without the assumption that $r_1 r_2$
is negligible.

#### Products of more than two factors

**Rule.** For a product $x_1 x_2 \cdots x_n$, with upper bounds $\bar{U}_j$ on
both $|x_j|$ and $|\tilde{x}_j|$, factor $i$ needs

$$d_i = d + k + \mathrm{siz}(n) + \sum_{j \ne i} \mathrm{siz}(\bar{U}_j)$$

places: $d + k + \mathrm{siz}(n)$, plus the sizes of the bounds on all the
*other* factors. For $n = 2$, this is the rule above.

Treat the product as one node, rather than as nested pairs. Nested pairs pay
$k + 1$ extra places at every level.

This assumes the product is computed exactly. With many factors, the exact
product has too many places to carry, so round it as you go, as for
[powers](#powers). Then take $\eta = T/2$, compute the product to $d + k + 1$
places, and use $\mathrm{siz}(2n)$ in place of $\mathrm{siz}(n)$.

**Example.** For $\pi e \sqrt{2}$ good to $d = 3$ places, with $k = 2$: take
$\bar{U} = 4$ for $\pi$, $3$ for $e$ and $1.5$ for $\sqrt{2}$, all of size 1.
Each factor needs $3 + 2 + \mathrm{siz}(3) + 1 + 1 = 8$ places:
$3.14159265$, $2.71828183$ and $1.41421356$. Their product is exactly
$12.077007929547305081711220$, which rounds to $12.077$. The true value is
$12.0770079568\ldots$

The exact counts are 6, 6 and 7 places. As nested pairs, $(\pi e)\sqrt{2}$, the
product node would ask $\pi e$ for $3 + 2 + 1 + 1 = 7$ places, which would ask
$\pi$ and $e$ for $7 + 2 + 1 + 1 = 11$ each, instead of 8.

**Why.** Changing one factor at a time,

$$\tilde x_1 \cdots \tilde x_n - x_1 \cdots x_n = \sum_i \tilde x_1 \cdots \tilde x_{i-1}(\tilde x_i - x_i) x_{i+1} \cdots x_n,$$

so the propagated error is at most
$\sum_i \varepsilon_i \prod_{j \ne i} \bar{U}_j$. The factors before $i$ are
approximations and the ones after are true values, which is why the bounds
have to cover both. The product is exact, so $\eta = T$, and splitting it
evenly, the exact count for factor $i$ is

$$d_i = \left\lceil d + k + \log\left(nc \prod_{j \ne i} \bar{U}_j\right) \right\rceil.$$

Since $\log(nc) < \log n < \mathrm{siz}(n)$, and
$\log \bar{U}_j < \mathrm{siz}(\bar{U}_j)$ for each $j$, the rule is enough.

### Quotients

**Rule.** With an upper bound $U_x \ge |x|$ and a lower bound $\bar{L}_y$ on
both $|y|$ and $|\tilde{y}|$,

$$d_x = d + k + 2 - \mathrm{siz}(\bar{L}_y), \qquad d_y = d + k + 3 + \mathrm{siz}(U_x) - 2\mathrm{siz}(\bar{L}_y).$$

**Example.** For $\pi / e$ good to $d = 3$ places, with $k = 2$: $\pi < 4$ and
$e > 2$, both of size 1. So $\pi$ needs $3 + 2 + 2 - 1 = 6$ places, and $e$
needs $3 + 2 + 3 + 1 - 2 = 7$.

**Why.** For $x / y$,

$$\frac{\tilde{x}}{\tilde{y}} - \frac{x}{y} = \frac{\tilde{x} - x}{\tilde{y}} - \frac{x(\tilde{y} - y)}{\tilde{y}y},$$

so the propagated error is at most
$\varepsilon_x / \bar{L}_y + U_x \varepsilon_y / \bar{L}_y^2$. The lower bound
has to cover both $y$ and $\tilde{y}$, but the upper bound only the true $x$.
The quotient can't be computed exactly, so $\eta = T/2$, and the exact counts
are

$$d_x = \lceil d + k + \log(4c) - \log \bar{L}_y \rceil, \qquad d_y = \lceil d + k + \log(4c) + \log U_x - 2\log \bar{L}_y \rceil.$$

Since $\log(4c) \le \log 2.4 < 1$, $\log U_x < \mathrm{siz}(U_x)$ and
$-\log \bar{L}_y \le 1 - \mathrm{siz}(\bar{L}_y)$, the rule is enough.

With $k = 2$, $U_x = 10^{\mathrm{siz}(x)}$ and $\bar{L}_y = 10^{\mathrm{siz}(y) - 1}$,
and since $\mathrm{nsiz} = \mathrm{siz} - 1$, the rule is the 2015 rules
$d_1 \ge d + 3 - \mathrm{nsiz}(y)$ and
$d_2 \ge d + 3 + \mathrm{siz}(x) - 2\mathrm{nsiz}(y)$, now with nothing
assumed negligible.

#### Division by truncation

The usual long division algorithm truncates: it stops after $p$ places and
drops the rest, which rounds toward zero. For $x, y > 0$, the truncated
quotient $q$ satisfies

$$q \le \frac{x}{y} < q + 10^{-p}.$$

For negative inputs, divide $|x|$ by $|y|$ and attach the sign at the end.

For a quotient of approximations, use the rule above for the input places,
then truncate the quotient to $d + k + 1$ places and round it to $d$ places. The truncation error is below
$10^{-(d+k+1)} = T/10$, inside the half of the budget kept for evaluation, so
the result is good to $d$ places.

For example, for $\pi / e$ to $d = 3$ places, with $k = 2$, the rule above
gives $\tilde{x} = 3.141593$ and $\tilde{y} = 2.7182818$. Their quotient
truncated to 6 places is $1.155727$, which rounds to $1.156$. (The true value
is $1.1557273\ldots$)

### Adding and multiplying by a constant

**Rule.** For an exact constant $a$:

- **Adding.** If $a$ has at most $d$ places, $x + a$ needs $d_x = d$, and
  $\tilde{x} + a$ needs no rounding.
- **Multiplying.** $ax$ needs $d_x = d + k + \mathrm{siz}(a)$.

**Example.** For $7x$ good to $d = 3$ places, with $k = 2$, $x$ needs
$3 + 2 + 1 = 6$ places. For $0.05x$, $\mathrm{siz}(0.05) = -1$, so $x$ needs
only $3 + 2 - 1 = 4$.

**Why.** For $x + a$, Theorem 5 gives $\delta^{+} = \delta^{-} = \eta$, so the
error passes through unchanged. For $ax$, it gives
$\delta^{+} = \delta^{-} = \eta / |a|$. The product $a\tilde{x}$ is exact, so
$\eta = T$, and the exact count is $\lceil d + k + \log(c|a|) \rceil$. Since
$\log(c\lvert a \rvert) < \log\lvert a \rvert < \mathrm{siz}(a)$, the rule is
enough.

With $k = 2$ and $c = c_2$, the exact count is the 2015 rule
$d_1 \ge d + 2 + \log\frac{51|a|}{100}$. The 2015 notes also give
$d_1 \ge d + \log|a|$ for the case where the result is "already rounded". That
makes $a\tilde{x}$ within $c_k \cdot 10^{-d}$ of $ax$. But $a\tilde{x}$ usually
has more than $d$ places, and rounding it adds more error, so that version only
applies when no rounding is needed.

### Powers

**Rule.** For $x^n$ with $n \ge 2$ a whole number, and an upper bound
$\bar{U}_x$ on both $|x|$ and $|\tilde{x}|$,

$$d_x = d + k + 1 + (n - 1)\mathrm{siz}(\bar{U}_x) \quad \text{for } n \le 8, \qquad d_x = d + k + \mathrm{siz}(2n) + (n - 1)\mathrm{siz}(\bar{U}_x) \quad \text{for any } n.$$

Then compute $\tilde{x}^n$ to $d + k + 1$ places.

**Example.** For $\pi^5$ good to $d = 2$ places, with $k = 2$: $\pi < 4$, of
size 1, so $\pi$ needs $2 + 2 + 1 + 4 = 9$ places.

**Why.** $\tilde{x}^n$ is exact in principle, but it has $n$ times as many
decimal places as $\tilde{x}$, which is too many to carry for all but small
$n$. So treat it like the other functions, with $\eta = T/2$. If you do
compute it exactly, as you might for $n = 2$, you can use $\eta = T$ and save
up to one place.

Since
$\tilde{x}^n - x^n = (\tilde{x} - x)(\tilde{x}^{n-1} + \tilde{x}^{n-2}x + \cdots + x^{n-1})$,
and every term in the second factor mixes $x$ and $\tilde{x}$, the bound has to
cover both. Then $A = n\bar{U}_x^{n-1}$, and the exact count is

$$d_x = \left\lceil d + k + \log(2cn\bar{U}_x^{n-1}) \right\rceil.$$

Since $\log(2cn) \le \log(1.2n) < \log(2n) < \mathrm{siz}(2n)$, and
$\log \bar{U}_x < \mathrm{siz}(\bar{U}_x)$, the rule is enough. For $n \le 8$,
$\log(1.2n) < 1$. Theorem 5 gives essentially the same count when $\eta$ is
small.

Computing $\tilde{x}^n$ to $d + k + 1$ places by repeated multiplication is
itself a chain of products. Each product is rounded, so carry enough guard
digits through the chain that the final value is within $10^{-(d+k+1)}$. The
product rule says how many.

### Square roots

**Rule.** With a lower bound $L_x \le x$ on the true value,

$$d_x = d + k - \left\lfloor \frac{\mathrm{siz}(L_x) - 1}{2} \right\rfloor.$$

That is, subtract half of $\mathrm{siz}(L_x) - 1$, rounded down, from $d + k$.
For a negative number, rounding down goes away from zero:
$\lfloor -1/2 \rfloor = -1$. So $\sqrt{0.5}$, with $L_x = 0.5$ and
$\mathrm{siz}(0.5) = 0$, needs $d + k + 1$ places.

The rule needs $\mathrm{siz}(L_x) \ge 3 - 2(d + k)$, which fails only for
extremely small $x$. Then, or with no lower bound at all, use
$d_x = 2(d + k) + 1$. If $\tilde{x}$ comes out negative, use $0$ instead:
since $x \ge 0$, that only moves $\tilde{x}$ closer to $x$.

**Example.** To get $\sqrt{\pi}$ good to $d = 4$ places, with $k = 2$: $\pi > 3$,
and $\mathrm{siz}(3) = 1$, so $\pi$ needs $4 + 2 - 0 = 6$ places.

So $\tilde{x} = 3.141593$. Its square root to $d + k + 1 = 7$ places is
$1.7724539$. The budget is $T = 10^{-6}$ and $\eta = 5 \times 10^{-7}$, so the
total error is at most
$\eta + \frac{1}{2} \cdot 10^{-7} = 5.5 \times 10^{-7} \le T$. By Lemma 1,
$\mathrm{rnd}(1.7724539, 4) = 1.7725$ is good to 4 places. (The true value is
$1.7724538509\ldots$)

**Why.** For $f(x) = \sqrt{x}$, which is increasing on $[0, \infty)$,
Theorem 5 gives

$$\delta^{+} = (\sqrt{x} + \eta)^2 - x = 2\eta\sqrt{x} + \eta^2, \qquad \delta^{-} = x - (\sqrt{x} - \eta)^2 = 2\eta\sqrt{x} - \eta^2,$$

where $\delta^{-}$ is for $\sqrt{x} \ge \eta$. If $\sqrt{x} < \eta$, then
$\sqrt{x} - \eta$ is below every value of $\sqrt{x}$, so $\delta^{-} = \infty$.
So a $\delta$ that works for every $x \ge 0$ is

$$\delta(x) = 2\eta\sqrt{x} - \eta^2 \quad \text{when } \sqrt{x} \ge \eta, \qquad \delta(x) = \eta^2 \quad \text{when } \sqrt{x} < \eta.$$

When $\sqrt{x} \ge \eta$ this is the largest $\delta$. Below that it gives up a
little, since the largest is $2\eta\sqrt{x} + \eta^2$, to keep the formula
simple.

$\delta(x)$ grows with $x$, so the worst case is the lower bound, and the exact
count is

$$d_x = \lceil \log c - \log \delta(L_x) \rceil.$$

For $\sqrt{\pi}$, that is $\lceil 5.46 \rceil = 6$, the same as the rule.

When $\sqrt{L_x} \ge 10\eta$, $2\eta\sqrt{L_x} - \eta^2 \ge 1.9\eta\sqrt{L_x}$, so
with $\eta = T/2$ it is enough that

$$d_x \ge d + k + \log\frac{2c}{1.9} - \tfrac{1}{2}\log L_x.$$

$\log\frac{2c}{1.9}$ is negative because $2c \le 1.2$, and
$-\frac{1}{2}\log L_x \le -\frac{1}{2}(\mathrm{siz}(L_x) - 1)$, which gives the
rule. The condition $\sqrt{L_x} \ge 10\eta$ holds when
$\mathrm{siz}(L_x) \ge 3 - 2(d + k)$. Without it, $\delta = \eta^2$ always
works, which needs $\lceil 2(d + k + \log 2) + \log c \rceil \le 2(d + k) + 1$
places.

The 2015 rule $d_1 \ge d + 2 - \frac{1}{2}\mathrm{nsiz}(x)$ asks for slightly
more than the exact count with $k = 2$. So it was safe, even though it set
nothing aside for evaluation error.

Theorem 4 gives $A = 1/(2\sqrt{L_x - \varepsilon_x})$, which also gives
$\delta \approx 2\eta\sqrt{L_x}$. Theorem 5 only makes a real difference near
$0$, where Theorem 4's $A$ blows up but $\delta = \eta^2$ still works.

### Exponentials

**Rule.** For $x \ge 0$, with an upper bound $U_x \ge x$ on the true value,

$$d_x = d + k + 2 + \lfloor 0.44 U_x \rfloor.$$

For $x < 0$, with a lower bound $L_x \le |x|$ on the true value,

$$d_x = \max(1, d + k + 2 - \lceil 0.43 L_x \rceil).$$

If you don't know the sign of $x$, use the first rule with $U_x \ge |x|$. The
factors $0.44$ and $0.43$ are $\log e \approx 0.4343$ rounded up and down.

**Example.** To get $e^{3\pi}$ good to $d = 3$ places, with $k = 2$: $3\pi < 9.5$,
so take $U_x = 9.5$. Then $\lfloor 0.44 \cdot 9.5 \rfloor = \lfloor 4.18 \rfloor = 4$,
so $3\pi$ needs $3 + 2 + 2 + 4 = 11$ places.

So $\tilde{x} = \mathrm{rnd}(3\pi, 11) = 9.42477796077$. Its exponential to
$d + k + 1 = 6$ places is $12391.647808$. The budget is $T = 10^{-5}$ and
$\eta = 5 \times 10^{-6}$, so the total error is at most
$\eta + \frac{1}{2} \cdot 10^{-6} = 5.5 \times 10^{-6} \le T$. By Lemma 1,
$\mathrm{rnd}(12391.647808, 3) = 12391.648$ is good to 3 places. (The true
value is $12391.6478079\ldots$)

**Why.** For $f(x) = e^x$, Theorem 5 gives

$$\delta^{+} = \ln(e^x + \eta) - x = \ln(1 + \eta e^{-x}), \qquad \delta^{-} = x - \ln(e^x - \eta) = -\ln(1 - \eta e^{-x}),$$

where $\delta^{-}$ is for $e^x > \eta$, and is $\infty$ otherwise. Since
$\ln(1 + u) \le -\ln(1 - u)$ for $0 \le u < 1$, the smaller one is
$\delta^{+}$, so the largest $\delta$ is

$$\delta(x) = \ln(1 + \eta e^{-x}).$$

It shrinks as $x$ grows, so the worst case is where $e^x$ is largest. Let $E$
be an upper bound on $e^x$, and $u = \eta / E$. The exact count is

$$d_x = \lceil \log c - \log\ln(1 + u) \rceil.$$

For $e^{3\pi}$ with $E = e^{9.5} \approx 13360$, that is 10, one less than the
rule.

Since $\ln(1 + u) \ge \frac{u}{1 + u}$, it is enough that

$$d_x \ge \log c - \log u + \log(1 + u) = d + k + \log(2c(E + \eta)),$$

using $\eta = T/2$, so that $2\eta = 10^{-(d+k)}$.

- **If E is at least η,** then $2c(E + \eta) \le 2.4E < 10^{\mathrm{siz}(E) + 1}$,
  so $d + k + 1 + \mathrm{siz}(E)$ is enough.
- **If E is below η,** then $d + k + \log(2c(E + \eta)) = \log(c(E + \eta)/\eta)$,
  which is less than $\log(2c) < 1$, so 1 place is enough.

So $d_x = \max(1, d + k + 1 + \mathrm{siz}(E))$ is enough for any upper bound
$E \ge e^x$. To turn this into a rule on $x$, use $\mathrm{siz}(e^a) = \lfloor a \log e \rfloor + 1$:

- **For x at least 0,** take $E = e^{U_x}$. Since $\log e < 0.44$,
  $\lfloor U_x \log e \rfloor \le \lfloor 0.44 U_x \rfloor$, which gives the
  first rule.
- **For x below 0,** $x \le -L_x$, so take $E = e^{-L_x}$. Since
  $\log e > 0.43$, $\lfloor -L_x \log e \rfloor \le \lfloor -0.43 L_x \rfloor = -\lceil 0.43 L_x \rceil$,
  which gives the second rule.

For example, $e^{-5}$ to 6 places, with $k = 2$, takes $L_x = 5$, and
$\lceil 0.43 \cdot 5 \rceil = \lceil 2.15 \rceil = 3$, so $x$ needs
$6 + 2 + 2 - 3 = 7$ places. The exact count is 6.

With $k = 2$, the 2015 rule
$d_1 \ge (d + 3 + x/\ln 10) H(d + 3 + x/\ln 10)$, where $H$ is the step
function, is $d + k + 1 + \log e^x$: the rule with $\log e^x$ in place of
$\mathrm{siz}(E)$. The argument above shows that is enough too, so it was
safe.

Theorem 4 gives $A = E$, if $E$ also covers $e^{\tilde{x} + \varepsilon_x}$, so
$\delta \approx \eta / E = u$,
about the same as $\ln(1 + u)$ when $u$ is small. Theorem 5 only makes a
difference when $u$ is large, which means $e^x$ is smaller than $\eta$, and the
output is $0$ to $d$ places anyway.

### Logarithms

**Rule.** With a lower bound $L_x \le x$ on the true value,

$$d_x = d + k + 2 - \mathrm{siz}(L_x).$$

**Example.** For $\ln \pi$ good to $d = 4$ places, with $k = 2$: $\pi > 3$, of
size 1, so $\pi$ needs $4 + 2 + 2 - 1 = 7$ places.

**Why.** For $f(x) = \ln x$, which is increasing on $(0, \infty)$ with
inverse $e^y$, Theorem 5 gives

$$\delta^{+} = e^{\ln x + \eta} - x = x(e^{\eta} - 1), \qquad \delta^{-} = x - e^{\ln x - \eta} = x(1 - e^{-\eta}).$$

Since $e^{\eta} + e^{-\eta} \ge 2$, $\delta^{-}$ is the smaller, so
$\delta(x) = x(1 - e^{-\eta})$. It grows with $x$, so the worst case is the
lower bound. Since $\varepsilon_x \le \delta(L_x) < L_x$, $\tilde{x}$ is
automatically positive.

Since $e^{\eta} \ge 1 + \eta$, $1 - e^{-\eta} \ge \frac{\eta}{1 + \eta}$. With
$\eta = T/2$, Lemma 2 gives

$$d_x = \left\lceil d + k + \log(2c) + \log(1 + \eta) - \log L_x \right\rceil.$$

Since $\log(2c) + \log(1 + \eta) \le \log(1.2 \times 1.5) < 1$ and
$-\log L_x \le 1 - \mathrm{siz}(L_x)$, the rule is enough.

### Sine and cosine

**Rule.** For $\sin x$ or $\cos x$,

$$d_x = d + k + 1.$$

No bounds are needed. If $x$ is exactly rounded, $d + k$ places are enough.

**Argument reduction.** A calculator usually first reduces $x$ by a whole
number $j$ of quarter turns, to $r = x - j\pi/2$ with $|r| \le \pi/4$, and then
uses

| $j$ mod 4 | $\sin x$ | $\cos x$ |
|---|---|---|
| 0 | $\sin r$ | $\cos r$ |
| 1 | $\cos r$ | $-\sin r$ |
| 2 | $-\sin r$ | $-\cos r$ |
| 3 | $-\cos r$ | $\sin r$ |

The reduction uses an approximation to $\pi$, whose error is multiplied by
$|j|/2$. So with reduction:

- **x** needs $d + k + 1$ places, as before.
- **π** needs $d + k + 1 + \mathrm{siz}(j)$ places. With $j = 0$ there is no
  reduction, and $\pi$ isn't needed.

Then compute $\tilde{r} = \tilde{x} - j\tilde{\pi}/2$ exactly. It has the
accuracy the rule asks of the input, so evaluate $\sin \tilde{r}$ or
$\cos \tilde{r}$ by its series. $j$ only has to be roughly
$x / (\pi/2)$: being off by one makes $|r|$ at most $3\pi/4 \approx 2.36$,
still within the $|x| \le 2.4$ that the series rule needs.

**Example.** For $\sin(\pi/4)$ good to $d = 6$ places, with $k = 2$, $\pi/4$
needs $6 + 2 + 1 = 9$ places: $\tilde{x} = 0.785398163$.
[Series](#series) works this through.

For $\sin 100$ good to $d = 6$ places, with $k = 2$: $100 / (\pi/2) \approx 63.7$,
so $j = 64$. Since 64 mod 4 is 0, $\sin 100 = \sin r$. $x = 100$ is exact.
$\pi$ needs $6 + 2 + 1 + \mathrm{siz}(64) = 11$ places, so
$\tilde{\pi} = 3.14159265359$, and

$$\tilde{r} = 100 - 32\tilde{\pi} = -0.53096491488.$$

The sine series at $\tilde{r}$, computed as in [Series](#series), sums to
$-0.50636564118$, which rounds to $-0.506366$. The true value is
$\sin 100 = -0.5063656411\ldots$

**Why.** The derivatives of $\sin$ and $\cos$ are $\cos$ and $-\sin$, which are
at most 1 in size, so Theorem 4 gives $A = 1$. Neither can be computed exactly,
so $\eta = T/2$, and the exact count is $\lceil d + k + \log(2c) \rceil$. Since
$\log(2c) \le \log 1.2 < 1$, the rule is enough. For an exactly rounded input,
$c = \frac{1}{2}$ and $\log(2c) = 0$, so $d + k$ is enough.

Near the peaks of $\sin$, where $\cos x$ is close to 0, a smaller $A$ would do,
but the rule doesn't try to use that.

With reduction, the error in $\tilde{r}$ is at most
$\varepsilon_x + \frac{|j|}{2}\varepsilon_\pi$. This is a sum of two inputs
with $A_x = 1$ and $A_\pi = |j|/2$, so with $\eta = T/2$ split between them,
the exact counts are

$$d_x = \lceil d + k + \log(4c) \rceil, \qquad d_\pi = \lceil d + k + \log(2c|j|) \rceil.$$

Since $\log(4c) \le \log 2.4 < 1$, and
$\log(2c|j|) \le \log 1.2 + \log|j| < 1 + \mathrm{siz}(j)$, the rule is enough.

For $\sin 100$, the error in $\tilde{r}$ is at most
$32 \cdot \frac{1}{2} \cdot 10^{-11} = 1.6 \times 10^{-10}$, well within
$T/2$.

### Series

This covers evaluating $f(\tilde{x})$ by a series, such as the Taylor series
for $e^x$ or $\sin x$, computing each term once, from the previous one,
without going back to redo earlier terms. You don't need to know in advance
how many terms there will be.

**Rule.** For a series $t_0 + t_1 + t_2 + \cdots$ whose terms satisfy
$t_n = r_n t_{n-1}$ with $|r_n| \le 1/n$:

- **Budget.** Spend $T/2$ on the input error, using the function's own rule
  for the input places, $T/4$ on the terms left off the end (the *tail*), and
  $T/4$ on rounding the terms.
- **Terms.** Compute each term from the previous one, with exact
  multiplications and one rounded or truncated division, to the number of
  places $p_n$ given below.
- **Sum.** Add the terms as you go. Sums of terminating decimals are exact.
- **Stop** after the first term with
  $\mathrm{siz}(\tilde{t}_N) \le -(d + k + 1)$, including that term. A term
  that rounds to 0 also counts. Then round the sum to $d$ places.

Since $|t| < 10^{\mathrm{siz}(t)}$, the stopping test means
$|\tilde{t}_N| < 10^{-(d+k+1)} = T/10$.

Compute term $n$ to

$$p_n = d + k + 2\mathrm{siz}(n)$$

places. That is $d + k + 2$ places for terms 1 to 9, $d + k + 4$ for terms 10
to 99, and so on. Raising the precision never changes the terms already
computed.

**Example: e to the power π/4.** To get $e^{\pi/4}$ good to $d = 6$ places,
with $k = 2$, the budget is $T = 10^{-8}$.

**Input.** $\pi/4 < 1$, so the exponential rule with $U_x = 1$ gives
$d_x = 6 + 2 + 2 + \lfloor 0.44 \rfloor = 10$, so
$\tilde{x} = \mathrm{rnd}(\pi/4, 10) = 0.7853981634$.

**Terms.** Start with $t_0 = 1$, and compute

$$\tilde t_n = \mathrm{rnd}(\tilde t_{n-1} \cdot \tilde{x} / n, p_n),$$

with $p_n = 10$ for $n \le 9$ and $p_n = 12$ for $n \ge 10$. Stop after the
first term with $\mathrm{siz} \le -(6 + 2 + 1) = -9$.

| $n$ | $p_n$ | $\tilde{t}_n$ | $\mathrm{siz}(\tilde{t}_n)$ |
|---|---|---|---|
| 0 | | $1$ | $1$ |
| 1 | 10 | $0.7853981634$ | $0$ |
| 2 | 10 | $0.3084251375$ | $0$ |
| 3 | 10 | $0.0807455122$ | $-1$ |
| 4 | 10 | $0.0158543442$ | $-1$ |
| 5 | 10 | $0.0024903946$ | $-2$ |
| 6 | 10 | $0.0003259919$ | $-3$ |
| 7 | 10 | $0.0000365762$ | $-4$ |
| 8 | 10 | $0.0000035909$ | $-5$ |
| 9 | 10 | $0.0000003134$ | $-6$ |
| 10 | 12 | $0.000000024614$ | $-7$ |
| 11 | 12 | $0.000000001757$ | $-8$ |
| 12 | 12 | $0.000000000115$ | $-9$ |

$\tilde{t}_{12}$ is the first term with $\mathrm{siz} \le -9$, so stop after
it.

**Sum.** $2.193280050786$, which rounds to $2.193280$.

The true value is $2.1932800507\ldots$, so the sum is off by about
$5 \times 10^{-11}$, well within $T$. Truncating the divisions instead of
rounding them gives $2.193280050176$, which rounds the same way.

**Example: sin(π/4).** To get $\sin(\pi/4)$ good to $d = 6$ places, with
$k = 2$, the budget is again $T = 10^{-8}$.

**Input.** The [sine rule](#sine-and-cosine) gives $d_x = 6 + 2 + 1 = 9$, so
$\tilde{x} = \mathrm{rnd}(\pi/4, 9) = 0.785398163$.

**Terms.** Start with $t_0 = \tilde{x}$, and compute

$$\tilde t_n = \mathrm{rnd}(-\tilde t_{n-1} \cdot \tilde{x} \cdot \tilde{x} / ((2n)(2n+1)), p_n),$$

with $p_n = 10$. Stop after the first term with
$\mathrm{siz} \le -(6 + 2 + 1) = -9$, or that rounds to 0.

| $n$ | $p_n$ | $\tilde{t}_n$ | $\mathrm{siz}(\tilde{t}_n)$ |
|---|---|---|---|
| 0 | | $0.785398163$ | $0$ |
| 1 | 10 | $-0.0807455121$ | $-1$ |
| 2 | 10 | $0.0024903946$ | $-2$ |
| 3 | 10 | $-0.0000365762$ | $-4$ |
| 4 | 10 | $0.0000003134$ | $-6$ |
| 5 | 10 | $-0.0000000018$ | $-8$ |
| 6 | 10 | $0.0000000000$ | — |

$\tilde{t}_5$ has $\mathrm{siz} = -8$, more than $-9$, and $\tilde{t}_6$ rounds
to 0, so stop after it.

**Sum.** $0.7071067809$, which rounds to $0.707107$.

The true value is $\sqrt{2}/2 = 0.7071067811\ldots$, so the sum is off by
about $3 \times 10^{-10}$, within $T$. Truncating the divisions gives the same
sum.

**Why.** Let $e_n = \tilde{t}_n - t_n$ be the error in term $n$, where $t_n$ is
the exact term at $\tilde{x}$. Each step multiplies the previous error by
$r_n$ and adds a new rounding error of at most $u_n = 10^{-p_n}$, which covers
truncation too. So an error made at term $m$ carries into the later terms with
total weight at most

$$1 + |r_{m+1}| + |r_{m+1} r_{m+2}| + \cdots \le 1 + \frac{1}{2} + \frac{1}{2 \cdot 3} + \cdots = e - 1 \approx 1.72,$$

using $|r_n| \le 1/n$. So the total rounding error in the sum is at most
$1.72 \sum u_n$.

With $p_n = d + k + 2\mathrm{siz}(n)$, $u_n = T \cdot 10^{-2\mathrm{siz}(n)}$.
Group the terms by size: the 9 terms of size 1 contribute $9 \cdot 10^{-2}$,
the 90 terms of size 2 contribute $90 \cdot 10^{-4}$, and so on, so

$$\sum u_n = T(0.09 + 0.009 + 0.0009 + \cdots) = 0.1T,$$

and the total rounding error is at most $0.172T$, within $T/4$. A precision
that grows by only 1 place per size, such as $d + k + 1 + \mathrm{siz}(n)$,
wouldn't do: each size would contribute the same amount, and the total would
grow without limit.

For the tail:

- **e to the x.** With $|x| \le 1$, $|t_{N+j}| \le |t_N| / ((N+1)(N+2)\cdots(N+j))$,
  so the tail is at most $|t_N|(1/2 + 1/6 + \cdots) = (e - 2)|t_N| < 0.72|t_N|$.
- **sin x.** The terms alternate in sign and shrink, so the tail is at most
  the first term left off, which is at most
  $|t_N| x^2 / ((2N+2)(2N+3)) \le 0.3|t_N|$ for $|x| \le 2.4$ and
  $N \ge 1$. The test can't stop at $N = 0$ unless $|x| < T/10$, and then the
  tail is tiny anyway.

Either way, the stopping test gives $|\tilde{t}_N| < T/10$, which leaves a
tail well under $T/4$, even allowing for the error in $\tilde{t}_N$.

**Large arguments.** The rule needs $|r_n| \le 1/n$. For $e^x$ that means
$|x| \le 1$. For larger $|x|$, the terms grow until $n \approx |x|$, errors grow
with them, and an alternating series like $e^{-20}$ also cancels
catastrophically. So reduce the argument first. For example, compute
$e^x = (e^{x/2^m})^{2^m}$ with $|x/2^m| \le 1$, and use the power rule to choose
the places for $e^{x/2^m}$. For $\sin x$, reduce by quarter turns into
$[-\pi/4, \pi/4]$, as in [Sine and cosine](#sine-and-cosine). Its ratios are
$|r_n| = x^2/((2n)(2n+1))$, which is at most $1/n$ whenever $|x| \le 2.4$, so
the rule has room to spare.

### Logarithms by series

The usual series $\ln(1 + u) = u - u^2/2 + u^3/3 - \cdots$ doesn't fit the
series rule. The ratio between its terms is $-u(n-1)/n$, which tends to $u$
instead of shrinking like $1/n$, so errors don't die out quickly, and for
$|u|$ near 1 it converges very slowly. Instead, use

$$\ln x = 2\left(z + \frac{z^3}{3} + \frac{z^5}{5} + \cdots\right), \qquad z = \frac{x - 1}{x + 1},$$

after reducing $x$ so that $z$ is small.

**Rule.** To get $\ln x$ good to $d$ places:

- **Input.** Use the [logarithm rule](#logarithms) for the places of $x$.
  That spends $T/2$ of the budget, and the steps below share the rest.
- **Reduce.** Write $\tilde{x} = 2^j m$ with $m$ between $0.7$ and $1.4$, so
  that $\ln x = j \ln 2 + \ln m$. Dividing by 2 is exact in decimal: each
  halving adds one place.
- **ln 2.** Use $\ln 2$ to $d + k + 1 + \mathrm{siz}(j)$ places, like $\pi$ in
  the [sine reduction](#sine-and-cosine).
- **z.** Compute $z = (m - 1)/(m + 1)$ to $d + k + 2$ places, rounded or
  truncated. Then $|z| \le 0.18$, and $z^2 \le 0.032$. Compute $z^2$ exactly.
- **Terms.** Keep a running power, starting from $P_0 = z$, and for each
  $n \ge 1$ compute the power $P_n$ and the term $t_n$ as below, both rounded
  or truncated to $p_n$ places. Add the terms as you go, starting from
  $t_0 = z$.
- **Stop** after the first term with
  $\mathrm{siz}(\tilde{t}_N) \le -(d + k + 1)$, as in the [series](#series)
  rule, including that term.
- **Combine.** $j \cdot \ln 2 + 2 \cdot (\text{sum})$, then round to $d$
  places.

The power and the term are

$$P_n = P_{n-1} \cdot z^2, \qquad t_n = \frac{P_n}{2n + 1},$$

each to

$$p_n = d + k + 1 + 2\mathrm{siz}(n)$$

places. That is one place more than the [series](#series) rule, because the
sum is doubled at the end, which doubles its rounding errors.

**Example.** To get $\ln 3$ good to $d = 6$ places, with $k = 2$, the budget is
$T = 10^{-8}$.

**Reduce.** $3 = 2^2 \cdot 0.75$, so $j = 2$ and $m = 0.75$.

**ln 2.** $\ln 2$ to $6 + 2 + 1 + 1 = 10$ places is $0.6931471806$.

**z.** $z = -0.25/1.75$, which to 10 places is $-0.1428571429$, and
$z^2 = 0.02040816327755102041$ exactly.

**Terms.** Use $p_n = 11$ places. Stop after the first term with
$\mathrm{siz} \le -(6 + 2 + 1) = -9$.

| $n$ | $p_n$ | $\tilde{P}_n$ | $\tilde{t}_n$ | $\mathrm{siz}(\tilde{t}_n)$ |
|---|---|---|---|---|
| 0 | | $-0.1428571429$ | $-0.1428571429$ | $0$ |
| 1 | 11 | $-0.00291545190$ | $-0.00097181730$ | $-3$ |
| 2 | 11 | $-0.00005949902$ | $-0.00001189980$ | $-4$ |
| 3 | 11 | $-0.00000121427$ | $-0.00000017347$ | $-6$ |
| 4 | 11 | $-0.00000002478$ | $-0.00000000275$ | $-8$ |
| 5 | 11 | $-0.00000000051$ | $-0.00000000005$ | $-10$ |

$\tilde{t}_5$ is the first term with $\mathrm{siz} \le -9$, so stop after it. The sum is
$-0.14384103627$.

**Combine.** $2 \cdot 0.6931471806 + 2 \cdot (-0.14384103627) = 1.09861228866$,
which rounds to $1.098612$.

The true value is $\ln 3 = 1.0986122887\ldots$, so the result is off by about
$8 \times 10^{-12}$.

**Why.** The evaluation half of the budget, $T/2$, is split four ways, about
$T/8$ each:

- **ln 2.** Its error is multiplied by $|j|$, and $|j| < 10^{\mathrm{siz}(j)}$,
  so the error in $j \ln 2$ is under $10^{-(d+k+1)} = T/10$.
- **z.** The derivative of $2(z + z^3/3 + \cdots)$ is $2/(1 - z^2)$, at most
  $2.07$ for $z^2 \le 0.032$. So an error below $10^{-(d+k+2)}$ in $z$ gives an
  error below $0.021T$.
- **Rounding.** An error in $P_m$ is multiplied by $z^2$ at each later step, so
  it reaches the later powers with total weight at most
  $1/(1 - z^2) \le 1.04$, and each of those enters the sum divided by
  $2n + 1 \ge 3$. With the term's own rounding, each rounding error of size
  $u_n = 10^{-p_n}$ adds at most $(1.04/3 + 1)u_n < 1.35u_n$ to the sum. As in
  the [series](#series) section, grouping by size gives
  $\sum u_n = 0.01T$ with the extra place. Doubled, the total is at most
  $2 \cdot 1.35 \cdot 0.01T = 0.027T$. Without the extra place it would be
  $0.27T$, more than $T/8$.
- **Tail.** The terms after $t_N$ shrink by at least $z^2$ each, so the tail is
  at most $|t_N| z^2/(1 - z^2) < 0.04|t_N|$. Doubled and with
  $|\tilde{t}_N| < T/10$, it is well under $T/8$.

## Examples

### A sum of 30 terms

To get a sum of 30 terms good to $d = 2$ places, with $k = 2$, the rule gives
each term $2 + 2 + \mathrm{siz}(30) = 6$ places. The exact count,
$\lceil 2 + 2 + \log(30 \cdot 0.51) \rceil = \lceil 5.18 \rceil$, is also 6, in
line with the 2015 table: $20 \le n \le 196$ needs $d + 4$.

### π times e

To get $\pi e$ good to $d = 3$ places, with $k = 2$, the target propagated
error is $T = 10^{-5}$.

**Places.** $\pi < 4$ and $e < 3$, with plenty of room, so take
$\bar{U}_x = 4$ for $x = \pi$ and $\bar{U}_y = 3$ for $y = e$, both of size 1. The product rule gives each input
$3 + 2 + 1 + 1 = 7$ places. Rounding both exactly gives $\tilde{x} = 3.1415927$
and $\tilde{y} = 2.7182818$.

**Computing.** The product is exactly

$$\tilde{f} = 3.1415927 \times 2.7182818 = 8.53973425942286.$$

By Theorem 3, with $\varepsilon_x = \varepsilon_y = 5 \times 10^{-8}$, the
propagated error is at most

$$2.7182818 \cdot \varepsilon_x + 3.1415927 \cdot \varepsilon_y + \varepsilon_x \varepsilon_y \approx 2.93 \times 10^{-7} \le 10^{-5}.$$

**Rounding.** By Lemma 1, $\mathrm{rnd}(\tilde{f}, 3) = 8.540$ is good to 3
places.

(The true value is $8.5397342\ldots$)

The exact counts are 6 places each, so the rule asked for one more than
needed here.

## Changes from the 2015 notes

- **Rounding is defined**, with a tie rule, and $p$ can be negative.
- **One size function.** $\mathrm{siz}$ is extended to all nonzero $x$, and
  replaces $\mathrm{nsiz}$, which is $\mathrm{siz} - 1$.
- **Stated domains.** $\mathrm{prec}$ and $\mathrm{fig}$ are defined on
  nonzero terminating decimals.
- **A wrong formula fixed.** The formula for $\mathrm{fig}(\mathrm{rnd}(x, p))$
  had counterexamples. Theorem 2 replaces it with inequalities, with proofs.
- **Approximations carry their error bound.** This separates a number's value
  from the accuracy claimed for it.
- **The output standard is an explicit invariant** (Lemma 1), with the number
  of guard digits $k$ as a parameter instead of a fixed 2.
- **The product and quotient bounds are exact.** The 2015 notes assumed
  $r_1 r_2$ was negligible and replaced $y(y - r_2)$ with $y^2$.
- **The bounds use values you have**, or magnitude bounds chosen in advance,
  instead of the unknown true $x$ and $y$.
- **Division has a precondition.** It needs $\varepsilon_y < |\tilde{y}|$.
- **One general rule**, Theorem 4, covers sums, products, quotients and any
  other differentiable function.
- **Monotonic functions get an exact bound.** Theorem 5 states the 2015
  inverse-function method with its edge cases. Constants, powers, square
  roots, exponentials and logarithms are worked through, without assuming
  $\varepsilon^2$ is negligible.
- **Evaluation error is budgeted.** Division, powers, square roots,
  exponentials, logarithms, sines and cosines can't be computed exactly, or not in practice,
  so half of the error budget is set aside for computing them.
- **Whole-number rules.** Each operation has a rule for the input places in
  whole numbers, using the sizes of rough bounds instead of logarithms, so the
  places can be chosen before the inputs are computed.
- **The place counts use a ceiling**, since they have to be whole numbers.
- **Series.** Taylor series are evaluated term by term at a slowly growing
  precision, without recomputing earlier terms or knowing how many there will
  be, with $e^x$, $\sin x$ and $\ln x$ worked through.

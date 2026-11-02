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
evaluate to some number of places and add that error to the total. The rest of
this section is about the propagated error.

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

## Choosing input places

The question from the 2015 notes is the reverse: given the output places $d$,
how many places do the inputs need?

The target is a propagated error of at most $T = 10^{-(d+k)}$, which Lemma 1
then turns into an output good to $d$ places. With $n$ inputs, split $T$
evenly, so each input needs $A_i \varepsilon_i \le T/n$. If input $i$ is good
to $d_i$ places, then $\varepsilon_i = c \cdot 10^{-d_i}$, and Lemma 2 gives

$$d_i = \left\lceil d + k + \log(n c A_i) \right\rceil.$$

Here $c = c_k$ if the input is itself the output of an earlier step, and
$c = \frac{1}{2}$ if it is exactly rounded.

**A circular dependency.** $A_i$ depends on the box $B$, which depends on the
$\varepsilon_i$ being chosen. In practice, pick the bounds from a rough first
estimate, with room to spare. For example, if $3 < x < 4$, then $A_y = 4$ works
for $xy$ whatever accuracy $x$ ends up with. A looser bound only costs digits.

**Uneven splits.** Splitting $T$ evenly is a choice, not a requirement. Any
$\varepsilon_i$ with $\sum A_i \varepsilon_i \le T$ works. An input that is
cheap to get more digits of can take a smaller share of the error.

### Sums

$A_i = 1$, so

$$d_i = \lceil d + k + \log(n c) \rceil.$$

For $k = 2$ and $c = c_2 = 0.51$, this is the 2015 result
$d + 2 + \log\frac{51n}{100}$, and gives the same table:

| Number of terms | $d_i$ |
|---|---|
| $n \le 100/51 \approx 1.96$ | $d + 2$ |
| $n \le 1000/51 \approx 19.6$ | $d + 3$ |
| $n \le 10000/51 \approx 196$ | $d + 4$ |
| $n \le 100000/51 \approx 1961$ | $d + 5$ |

With exactly rounded inputs, $c = \frac{1}{2}$ and the cutoffs become
$n \le 2, 20, 200, 2000$.

### Products

For $xy$, take magnitude bounds $M_x \ge |\tilde{x}| + \varepsilon_x$ and
$M_y \ge |\tilde{y}| + \varepsilon_y$. Then $A_x = M_y$ and $A_y = M_x$, so

$$d_x = \lceil d + k + \log(2c M_y) \rceil, \qquad d_y = \lceil d + k + \log(2c M_x) \rceil.$$

If $M_y = 10^{m}$ for a whole number $m$, and $k = 2$, then
$\log(2 c_2 M_y) = m + \log 1.02$ and $d_x = d + 3 + m$. With
$m = \mathrm{siz}(y)$, so $d_x = d + 3 + \mathrm{siz}(y)$, this is the 2015 rule
$d_1 \ge d + 3 + \mathrm{siz}(y)$, now without the assumption that $r_1 r_2$
is negligible. The one caveat is that $M_y$ has to bound $|\tilde{y}|$ as well
as $|y|$. For $y = 9.9996$ that means $M_y = 100$, not $10$, if $\tilde{y}$
might round up to $10.000$.

### Quotients

For $x / y$, take $M_x \ge |\tilde{x}| + \varepsilon_x$ and a lower bound
$0 < L_y \le |\tilde{y}| - \varepsilon_y$. Then $A_x = 1/L_y$ and
$A_y = M_x / L_y^2$, so

$$d_x = \lceil d + k + \log(2c) - \log L_y \rceil, \qquad d_y = \lceil d + k + \log(2c) + \log M_x - 2\log L_y \rceil.$$

With $k = 2$, $M_x = 10^{\mathrm{siz}(x)}$ and $L_y = 10^{\mathrm{siz}(y) - 1}$,
these become

$$d_x = d + 4 - \mathrm{siz}(y), \qquad d_y = d + 5 + \mathrm{siz}(x) - 2\mathrm{siz}(y).$$

Since $\mathrm{nsiz} = \mathrm{siz} - 1$, these are the 2015 rules $d_1 \ge d + 3 - \mathrm{nsiz}(y)$ and
$d_2 \ge d + 3 + \mathrm{siz}(x) - 2\mathrm{nsiz}(y)$. Again, nothing is
assumed negligible, but $L_y$ has to stay below $|\tilde{y}| - \varepsilon_y$,
which needs a little room when $|y|$ is close to $10^{\mathrm{siz}(y) - 1}$.

## Relative error and significant figures

The *relative error* of an approximation is $\rho_x = \varepsilon_x / |\tilde{x}|$.
Dividing the bounds in Theorem 3 by $|\tilde{x}\tilde{y}|$ and
$|\tilde{x}/\tilde{y}|$ gives

$$\rho_{xy} \le \rho_x + \rho_y + \rho_x \rho_y, \qquad \rho_{x/y} \le \frac{\rho_x + \rho_y}{1 - \rho_y}.$$

So for products and quotients, relative errors roughly add, the same way
absolute errors add for sums.

Relative error is what significant figures measure. If $\tilde{x}$ is $x$
rounded to $p$ places, then

$$\rho_x \le \frac{\frac{1}{2} \cdot 10^{-p}}{10^{\mathrm{siz}(\tilde{x}) - 1}} = \tfrac{1}{2} \cdot 10^{1 - s},$$

where $s = p + \mathrm{siz}(\tilde{x})$ is the number of digits
$\tilde{x}$ is written with, counted from its leading digit.

This explains the shape of the results:

- **Sums:** the decimal places of the output depend on the decimal places of
  the inputs, and magnitudes don't matter.
- **Products and quotients:** what carries over is significant figures, so
  the rules for decimal places have $\mathrm{siz}$ terms in them. In the
  product rule with $k = 2$, $\tilde{x}$ is written with
  $d_x + \mathrm{siz}(x) = d + \mathrm{siz}(x) + \mathrm{siz}(y) + 3$
  digits. The output has $d + \mathrm{siz}(xy)$ digits, and
  $\mathrm{siz}(xy)$ is $\mathrm{siz}(x) + \mathrm{siz}(y)$ or one less. So
  each input needs 3 or 4 more significant figures than the output has.

## Correct rounding

An error bound never guarantees that the output is $\mathrm{rnd}(f, d)$, the
true value correctly rounded. In the 2015 example, $f = 0.4499999$ and
$\tilde{f} = 0.45$ are within $10^{-6}$ of each other, but round to $0.4$ and
$0.5$. This is known as the *table maker's dilemma*.

It can still be checked after the fact. The rounding boundaries for $d$ places
are the midpoints $(n + \frac{1}{2}) \cdot 10^{-d}$ for integers $n$.

**Lemma 3.** If $|\tilde{f} - f| \le \eta$, and $\tilde{f}$ is more than $\eta$
away from every rounding boundary, then
$\mathrm{rnd}(\tilde{f}, d) = \mathrm{rnd}(f, d)$.

**Proof.** No boundary lies in $[\tilde{f} - \eta, \tilde{f} + \eta]$, which
contains $f$. So $f$ and $\tilde{f}$ lie strictly between the same two
boundaries, and they round to the same multiple of $10^{-d}$. ∎

If the check fails, recompute $\tilde{f}$ with a smaller $\eta$ and try again.
This finishes unless $f$ is exactly on a boundary, like $f = 0.45$ with
$d = 1$. Then no error bound short of $0$ can settle which way it rounds, and
only an exact computation can.

## Examples

### A sum of 30 terms

To get a sum of 30 terms good to $d = 2$ places, with $k = 2$, each term needs

$$d_i = \lceil 2 + 2 + \log(30 \cdot 0.51) \rceil = \lceil 5.18 \rceil = 6$$

places. That is in line with the 2015 table: $20 \le n \le 196$ needs $d + 4$.

### π times e

To get $\pi e$ good to $d = 3$ places, with $k = 2$, the target propagated
error is $T = 10^{-5}$.

**Bounds.** Roughly, $\pi < 4$ and $e < 3$. So take $M_x = 4$ for $x = \pi$ and
$M_y = 3$ for $y = e$. Round both inputs exactly, so $c = \frac{1}{2}$:

$$d_x = \lceil 5 + \log(2 \cdot 0.5 \cdot 3) \rceil = \lceil 5.48 \rceil = 6, \qquad d_y = \lceil 5 + \log(2 \cdot 0.5 \cdot 4) \rceil = \lceil 5.60 \rceil = 6.$$

**Computing.** With $\tilde{x} = 3.141593$ and $\tilde{y} = 2.718282$, the
product is exactly

$$\tilde{f} = 3.141593 \times 2.718282 = 8.539735703226.$$

By Theorem 3, with $\varepsilon_x = \varepsilon_y = 5 \times 10^{-7}$, the
propagated error is at most

$$2.718282 \cdot \varepsilon_x + 3.141593 \cdot \varepsilon_y + \varepsilon_x \varepsilon_y \approx 2.93 \times 10^{-6} \le 10^{-5}.$$

**Rounding.** By Lemma 1, $\mathrm{rnd}(\tilde{f}, 3) = 8.540$ is good to 3
places.

**Correct rounding.** The nearest rounding boundary to $\tilde{f}$ is
$8.5395$, which is about $2.4 \times 10^{-4}$ away. That is more than
$\eta = 2.93 \times 10^{-6}$, so by Lemma 3, $8.540$ is $\pi e$ correctly
rounded. (The true value is $8.5397342\ldots$)

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
- **The place counts use a ceiling**, since they have to be whole numbers.
- **Relative error** connects significant figures to products and quotients.
- **Correct rounding** has a test (Lemma 3) instead of only a counterexample.

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
$|\tilde{x} - x| \le \delta$ exactly when

$$\delta \le \min(\delta^{+}, \delta^{-}).$$

For a strictly decreasing $f$, swap $f(x) + \eta$ and $f(x) - \eta$ in the
definitions of $\delta^{+}$ and $\delta^{-}$.

**Proof.** Take $\tilde{x} \ge x$ in $J$. Since $f$ is increasing,
$|f(\tilde{x}) - f(x)| = f(\tilde{x}) - f(x)$, and this is at most $\eta$
exactly when $\tilde{x} \le x + \delta^{+}$. That is automatic if
$\delta^{+} = \infty$. If not, it holds because $f^{-1}$ is increasing too,
and it fails for every $\tilde{x}$ just above $x + \delta^{+}$. So the inputs
above $x$ are all fine exactly when $\delta \le \delta^{+}$. The inputs below
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
quick low-accuracy estimate:

- **Upper bound.** $U_x$ is a number with $|x| \le U_x$.
- **Lower bound.** $L_x$ is a positive number with $L_x \le |x|$.

The rules only need the sizes of these bounds, $\mathrm{siz}(U_x)$ and
$\mathrm{siz}(L_x)$, which are digit counts. For example, $\pi < 4$ gives
$U = 4$ with $\mathrm{siz}(U) = 1$, and $\pi > 3$ gives $L = 3$ with
$\mathrm{siz}(L) = 1$.

The bounds have to hold for the approximation $\tilde{x}$ as well as for $x$,
so leave a little room. For $x \approx 9.9996$, $\tilde{x}$ might round up to
$10.000$, so use $U_x = 11$, with $\mathrm{siz} = 2$, rather than $10$. Any
valid bound works. A looser one costs at most a digit or so.

### The error budget

The target is a computed value within $T = 10^{-(d+k)}$ of the true value,
which Lemma 1 then turns into an output good to $d$ places. That error has two
parts, so split $T$ between them:

$$\eta + (\text{evaluation error}) \le T,$$

where $\eta$ is the budget for the propagated error.

- **Exact evaluation.** Sums, differences and products of terminating
  decimals have no evaluation error, so $\eta = T$.
- **Everything else.** For division, powers, square roots, exponentials and
  logarithms, take $\eta = T/2$, and compute $f(\tilde{x})$ to $d + k + 1$
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
| $xy$ | $d_x = d + k + 1 + \mathrm{siz}(U_y)$, and $d_y = d + k + 1 + \mathrm{siz}(U_x)$ |
| $x / y$ | $d_x = d + k + 2 - \mathrm{siz}(L_y)$, and $d_y = d + k + 3 + \mathrm{siz}(U_x) - 2\mathrm{siz}(L_y)$ |
| $x + a$ | $d$ |
| $ax$ | $d + k + \mathrm{siz}(a)$ |
| $x^n$, $n \le 8$ | $d + k + 1 + (n - 1)\mathrm{siz}(U_x)$ |
| $x^n$, any $n$ | $d + k + \mathrm{siz}(2n) + (n - 1)\mathrm{siz}(U_x)$ |
| $\sqrt{x}$ | $d + k - \lfloor (\mathrm{siz}(L_x) - 1)/2 \rfloor$ |
| $e^x$ | $\max(1, d + k + 1 + \mathrm{siz}(E))$, for an upper bound $E \ge e^x$ |
| $\ln x$ | $d + k + 2 - \mathrm{siz}(L_x)$ |

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

**Rule.** With upper bounds $U_x \ge |x|$ and $U_y \ge |y|$,

$$d_x = d + k + 1 + \mathrm{siz}(U_y), \qquad d_y = d + k + 1 + \mathrm{siz}(U_x).$$

Each input's places depend on the size of the *other* input.

**Example.** For $\pi e$ good to $d = 3$ places, with $k = 2$: $\pi < 4$ and
$e < 3$, both of size 1, so each needs $3 + 2 + 1 + 1 = 7$ places.
[Examples](#examples) works this through.

**Why.** For $xy$, Theorem 4 gives $A_x = U_y$ and $A_y = U_x$, where the
bounds also cover $\tilde{x}$ and $\tilde{y}$. The product is exact, so
$\eta = T$, and the exact counts are

$$d_x = \lceil d + k + \log(2c U_y) \rceil, \qquad d_y = \lceil d + k + \log(2c U_x) \rceil.$$

Since $\log(2c) \le \log 1.2 < 1$ and $\log U_y < \mathrm{siz}(U_y)$, the rule
is enough.

With $k = 2$ and $U_y = 10^{\mathrm{siz}(y)}$, the rule is the 2015 rule
$d_1 \ge d + 3 + \mathrm{siz}(y)$, now without the assumption that $r_1 r_2$
is negligible.

### Quotients

**Rule.** With an upper bound $U_x \ge |x|$ and a lower bound
$L_y \le |y|$,

$$d_x = d + k + 2 - \mathrm{siz}(L_y), \qquad d_y = d + k + 3 + \mathrm{siz}(U_x) - 2\mathrm{siz}(L_y).$$

**Example.** For $\pi / e$ good to $d = 3$ places, with $k = 2$: $\pi < 4$ and
$e > 2$, both of size 1. So $\pi$ needs $3 + 2 + 2 - 1 = 6$ places, and $e$
needs $3 + 2 + 3 + 1 - 2 = 7$.

**Why.** For $x / y$, Theorem 4 gives $A_x = 1/L_y$ and $A_y = U_x / L_y^2$,
with $L_y \le |\tilde{y}| - \varepsilon_y$. The quotient can't be computed
exactly, so $\eta = T/2$, and the exact counts are

$$d_x = \lceil d + k + \log(4c) - \log L_y \rceil, \qquad d_y = \lceil d + k + \log(4c) + \log U_x - 2\log L_y \rceil.$$

Since $\log(4c) \le \log 2.4 < 1$, $\log U_x < \mathrm{siz}(U_x)$ and
$-\log L_y \le 1 - \mathrm{siz}(L_y)$, the rule is enough.

With $k = 2$, $U_x = 10^{\mathrm{siz}(x)}$ and $L_y = 10^{\mathrm{siz}(y) - 1}$,
and since $\mathrm{nsiz} = \mathrm{siz} - 1$, the rule is the 2015 rules
$d_1 \ge d + 3 - \mathrm{nsiz}(y)$ and
$d_2 \ge d + 3 + \mathrm{siz}(x) - 2\mathrm{nsiz}(y)$, now with nothing
assumed negligible.

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
$U_x \ge |x|$,

$$d_x = d + k + 1 + (n - 1)\mathrm{siz}(U_x) \quad \text{for } n \le 8, \qquad d_x = d + k + \mathrm{siz}(2n) + (n - 1)\mathrm{siz}(U_x) \quad \text{for any } n.$$

Then compute $\tilde{x}^n$ to $d + k + 1$ places.

**Example.** For $\pi^5$ good to $d = 2$ places, with $k = 2$: $\pi < 4$, of
size 1, so $\pi$ needs $2 + 2 + 1 + 4 = 9$ places.

**Why.** $\tilde{x}^n$ is exact in principle, but it has $n$ times as many
decimal places as $\tilde{x}$, which is too many to carry for all but small
$n$. So treat it like the other functions, with $\eta = T/2$. If you do
compute it exactly, as you might for $n = 2$, you can use $\eta = T$ and save
up to one place.

By Theorem 4, with $A = nU_x^{n-1}$, the exact count is

$$d_x = \left\lceil d + k + \log(2cnU_x^{n-1}) \right\rceil.$$

Since $\log(2cn) \le \log(1.2n) < \log(2n) < \mathrm{siz}(2n)$, and
$\log U_x < \mathrm{siz}(U_x)$, the rule is enough. For $n \le 8$,
$\log(1.2n) < 1$. Theorem 5 gives essentially the same count when $\eta$ is
small.

Computing $\tilde{x}^n$ to $d + k + 1$ places by repeated multiplication is
itself a chain of products. Each product is rounded, so carry enough guard
digits through the chain that the final value is within $10^{-(d+k+1)}$. The
product rule says how many.

### Square roots

**Rule.** With a lower bound $L_x \le x$,

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
$\mathrm{rnd}(1.7724539, 4) = 1.7725$ is good to 4 places. The nearest
rounding boundary, $1.77245$, is about $3.9 \times 10^{-6}$ away, more than
$5.5 \times 10^{-7}$, so by Lemma 3 this is $\sqrt{\pi}$ correctly rounded.
(The true value is $1.7724538509\ldots$)

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

**Rule.** With an upper bound $E \ge e^x$,

$$d_x = \max(1, d + k + 1 + \mathrm{siz}(E)).$$

$E$ only has to be rough: one significant figure, rounded up, is enough.

**Example.** To get $e^{3\pi}$ good to $d = 3$ places, with $k = 2$: a quick
low-accuracy calculation gives $e^{3\pi} \approx 12000$, so $E = 20000$ is a
safe upper bound, of size 5. So $3\pi$ needs $3 + 2 + 1 + 5 = 11$ places.

So $\tilde{x} = \mathrm{rnd}(3\pi, 11) = 9.42477796077$. Its exponential to
$d + k + 1 = 6$ places is $12391.647808$. The budget is $T = 10^{-5}$ and
$\eta = 5 \times 10^{-6}$, so the total error is at most
$\eta + \frac{1}{2} \cdot 10^{-6} = 5.5 \times 10^{-6} \le T$. By Lemma 1,
$\mathrm{rnd}(12391.647808, 3) = 12391.648$ is good to 3 places. The nearest
rounding boundary, $12391.6475$, is about $3.1 \times 10^{-4}$ away, so by
Lemma 3 this is $e^{3\pi}$ correctly rounded. (The true value is
$12391.6478079\ldots$)

**Why.** For $f(x) = e^x$, Theorem 5 gives

$$\delta^{+} = \ln(e^x + \eta) - x = \ln(1 + \eta e^{-x}), \qquad \delta^{-} = x - \ln(e^x - \eta) = -\ln(1 - \eta e^{-x}),$$

where $\delta^{-}$ is for $e^x > \eta$, and is $\infty$ otherwise. Since
$\ln(1 + u) \le -\ln(1 - u)$ for $0 \le u < 1$, the smaller one is
$\delta^{+}$, so the largest $\delta$ is

$$\delta(x) = \ln(1 + \eta e^{-x}).$$

It shrinks as $x$ grows, so the worst case is where $e^x$ is largest, which
is at most $E$. Let $u = \eta / E$. The exact count is

$$d_x = \lceil \log c - \log\ln(1 + u) \rceil.$$

For $e^{3\pi}$ with $E = 20000$, that is 10, one less than the rule.

Since $\ln(1 + u) \ge \frac{u}{1 + u}$, it is enough that

$$d_x \ge \log c - \log u + \log(1 + u) = d + k + \log(2c(E + \eta)),$$

using $\eta = T/2$, so that $2\eta = 10^{-(d+k)}$.

- **If E is at least η,** then $2c(E + \eta) \le 2.4E < 10^{\mathrm{siz}(E) + 1}$,
  so $d + k + 1 + \mathrm{siz}(E)$ is enough.
- **If E is below η,** then $d + k + \log(2c(E + \eta)) = \log(c(E + \eta)/\eta)$,
  which is less than $\log(2c) < 1$, so 1 place is enough.

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

**Rule.** With a lower bound $L_x \le x$,

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

To get a sum of 30 terms good to $d = 2$ places, with $k = 2$, the rule gives
each term $2 + 2 + \mathrm{siz}(30) = 6$ places. The exact count,
$\lceil 2 + 2 + \log(30 \cdot 0.51) \rceil = \lceil 5.18 \rceil$, is also 6, in
line with the 2015 table: $20 \le n \le 196$ needs $d + 4$.

### π times e

To get $\pi e$ good to $d = 3$ places, with $k = 2$, the target propagated
error is $T = 10^{-5}$.

**Places.** $\pi < 4$ and $e < 3$, so take $U_x = 4$ for $x = \pi$ and
$U_y = 3$ for $y = e$, both of size 1. The product rule gives each input
$3 + 2 + 1 + 1 = 7$ places. Rounding both exactly gives $\tilde{x} = 3.1415927$
and $\tilde{y} = 2.7182818$.

**Computing.** The product is exactly

$$\tilde{f} = 3.1415927 \times 2.7182818 = 8.53973425942286.$$

By Theorem 3, with $\varepsilon_x = \varepsilon_y = 5 \times 10^{-8}$, the
propagated error is at most

$$2.7182818 \cdot \varepsilon_x + 3.1415927 \cdot \varepsilon_y + \varepsilon_x \varepsilon_y \approx 2.93 \times 10^{-7} \le 10^{-5}.$$

**Rounding.** By Lemma 1, $\mathrm{rnd}(\tilde{f}, 3) = 8.540$ is good to 3
places.

**Correct rounding.** The nearest rounding boundary to $\tilde{f}$ is
$8.5395$, which is about $2.3 \times 10^{-4}$ away. That is more than
$2.93 \times 10^{-7}$, so by Lemma 3, $8.540$ is $\pi e$ correctly rounded.
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
  exponentials and logarithms can't be computed exactly, or not in practice,
  so half of the error budget is set aside for computing them.
- **Whole-number rules.** Each operation has a rule for the input places in
  whole numbers, using the sizes of rough bounds instead of logarithms, so the
  places can be chosen before the inputs are computed.
- **The place counts use a ceiling**, since they have to be whole numbers.
- **Relative error** connects significant figures to products and quotients.
- **Correct rounding** has a test (Lemma 3) instead of only a counterexample.

# Input places for arithmetic

How many decimal places the inputs to a sum, product, quotient or power need
so that the output, rounded to $d$ places, is accurate.

*Xin-Xin*

This builds on
[Rounding and error bounds](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md),
and uses its notation:
$\mathrm{rnd}$, $\mathrm{siz}$, approximations $\tilde{x}$ with error
$\varepsilon_x$, and values good to $d$ places with $k$ guard digits.

Throughout, $\log$ means $\log_{10}$.

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

## Choosing input places

The question from the 2015 notes is the reverse: given the output places $d$,
how many places do the inputs need? Each subsection below starts with a rule
in whole numbers that answers this, then an example, then why the rule works.

### Bounds before digits

You choose the input places before computing the inputs, so the rules can't
use the inputs' exact values. They use rough bounds on the true values
instead, found from a quick low-accuracy estimate: an upper bound $U_x$ with
$|x| \le U_x$, and a lower bound $L_x$, a positive number with $L_x \le |x|$.

The rules only need the sizes of the bounds, which are digit counts. For
example, $\pi < 4$ gives an upper bound of 4, with $\mathrm{siz}(4) = 1$, and
$\pi > 3$ gives a lower bound of 3, with $\mathrm{siz}(3) = 1$. Any valid
bound works, and a looser one costs at most a digit or so.

### Covering the approximation

The product, quotient and power rules below come from error formulas that mix
$x$ and $\tilde{x}$, so they need bounds that also cover $|\tilde{x}|$. The
reciprocal, square root, exponential and logarithm rules in
[Input places for functions](../2026-11-02%203%20Input%20places%20for%20functions/README.md) fix the true $x$, so they don't.

You don't know $\tilde{x}$ yet when you choose the places, but it will be
within $\varepsilon_x$ of $x$. So widening the bounds by a margin covers it
too:

$$\bar{U}_x = 1.01U_x, \qquad \bar{L}_x = 0.99L_x.$$

These cover $\tilde{x}$ as long as $\varepsilon_x$ is under 1% of the bound.
That holds if $x$ has at least

$$3 - \mathrm{siz}(M)$$

places, where $M$ is $U_x$ for $\bar{U}_x$ and $L_x$ for $\bar{L}_x$. Call
these the *minimum places* of $x$. The product, quotient and power rules
include them, as a maximum with the rest of the rule. If both
bounds of an input are used, the minimum for $L_x$ is the larger, since
$L_x \le U_x$.

**Why.** With $d_x$ places, the error is at most $0.6 \cdot 10^{-d_x}$. With
$d_x \ge 3 - \mathrm{siz}(M)$, that is at most
$0.6 \cdot 10^{\mathrm{siz}(M) - 3}$, and since
$M \ge 10^{\mathrm{siz}(M) - 1}$, it is under $0.01M$. Then
$|\tilde{x}| \le 1.01U_x = \bar{U}_x$ and $|\tilde{x}| \ge 0.99L_x = \bar{L}_x$.

The margin matters when $x$ is close to its bound. For $x \le 9.9997$,
$U_x = 9.9997$ is valid, but with 3 places $\tilde{x}$ might come out as
$10.000$, which is above it. $\bar{U}_x = 10.0997$ covers that.

**Choosing the margin.** The 1% is a choice. The same argument with a margin
of $10^{-m}$ gives $m + 1 - \mathrm{siz}(M)$ minimum places, so a wider
margin needs fewer. But it also changes the sizes of the bounds more often,
and the rules use those sizes:

| Margin | $\bar{U}$ and $\bar{L}$ | Minimum places | Sizes change when $U$ or $L$ is |
|---|---|---|---|
| 10% | $1.1U$ and $0.9L$ | $2 - \mathrm{siz}(M)$ | within about 10% of a power of 10 |
| 1% | $1.01U$ and $0.99L$ | $3 - \mathrm{siz}(M)$ | within about 1% of a power of 10 |
| 0.1% | $1.001U$ and $0.999L$ | $4 - \mathrm{siz}(M)$ | within about 0.1% of a power of 10 |

$U$ is affected just below a power of 10, and $L$ just above one. The two
costs aren't equal. The minimum rarely matters, because the rules usually ask
for more places anyway. A change of size goes straight into the rules, and
for a divisor it costs 2 places, through $-2\mathrm{siz}(\bar{L}_y)$. A small
margin like 1% keeps that rare, while the minimum stays low.

### The error budget

The target is a computed value within $T = 10^{-(d+k)}$ of the true value,
which [Lemma 1](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#the-invariant) then turns into an output good to $d$ places. That error has two
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
good to $d_i$ places, then $\varepsilon_i = c \cdot 10^{-d_i}$, and [Lemma 2](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#from-an-error-bound-to-decimal-places)
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
| $xy$ | $d_x = \max(d + k + 1 + \mathrm{siz}(1.01U_y), 3 - \mathrm{siz}(U_x))$, and the same with $x$ and $y$ swapped |
| $x_1 \cdots x_n$ | factor $i$: $\max\left(d + k + \mathrm{siz}(n) + \sum_{j \ne i} \mathrm{siz}(1.01U_j), 3 - \mathrm{siz}(U_i)\right)$ |
| $x / y$ | $d_x = d + k + 2 - \mathrm{siz}(0.99L_y)$, and $d_y = \max(d + k + 3 + \mathrm{siz}(U_x) - 2\mathrm{siz}(0.99L_y), 3 - \mathrm{siz}(L_y))$ |
| $x + a$, $a$ with at most $d$ places | $d$ |
| $ax$ | $d + k + \mathrm{siz}(a)$ |
| $x^n$, $n \le 8$ | $\max(d + k + 1 + (n - 1)\mathrm{siz}(1.01U_x), 3 - \mathrm{siz}(U_x))$ |
| $x^n$, any $n$ | $\max(d + k + \mathrm{siz}(2n) + (n - 1)\mathrm{siz}(1.01U_x), 3 - \mathrm{siz}(U_x))$ |

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

**Rule.** With upper bounds $U_x$ and $U_y$,

$$d_x = \max(d + k + 1 + \mathrm{siz}(1.01U_y), 3 - \mathrm{siz}(U_x)),$$

and the same for $d_y$ with $x$ and $y$ swapped. The second part is the
[minimum places](#covering-the-approximation) of the input.

Each input's places depend on the size of the *other* input.

**Example.** For $\pi e$ good to $d = 3$ places, with $k = 2$: $\pi < 4$ and
$e < 3$, so $\bar{U}$ is $4.04$ and $3.03$, both of size 1, and each needs
$3 + 2 + 1 + 1 = 7$ places. The minimum, $3 - 1 = 2$, is well below that.
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

With $k = 2$ and a tight bound, where $\mathrm{siz}(\bar{U}_y) = \mathrm{siz}(y)$,
the rule is the 2015 rule $d_1 \ge d + 3 + \mathrm{siz}(y)$, now without the
assumption that $r_1 r_2$ is negligible.

#### Products of more than two factors

**Rule.** For a product $x_1 x_2 \cdots x_n$, with upper bounds $U_j$, factor
$i$ needs

$$d_i = \max\left(d + k + \mathrm{siz}(n) + \sum_{j \ne i} \mathrm{siz}(1.01U_j), 3 - \mathrm{siz}(U_i)\right)$$

places: $d + k + \mathrm{siz}(n)$, plus the sizes of the bounds on all the
*other* factors, but at least the factor's minimum places. For $n = 2$, this
is the rule above.

Treat the product as one node, rather than as nested pairs. Nested pairs pay
$k + 1$ extra places at every level.

This assumes the product is computed exactly. With many factors, the exact
product has too many places to carry, so round it as you go, as for
[powers](#powers). Then take $\eta = T/2$, compute the product to $d + k + 1$
places, and use $\mathrm{siz}(2n)$ in place of $\mathrm{siz}(n)$.

**Example.** For $\pi e \sqrt{2}$ good to $d = 3$ places, with $k = 2$: take
$U = 4$ for $\pi$, $3$ for $e$ and $1.5$ for $\sqrt{2}$, so $\bar{U}$ is $4.04$,
$3.03$ and $1.515$, all of size 1.
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

**Rule.** With an upper bound $U_x$ and a lower bound $L_y$,

$$d_x = d + k + 2 - \mathrm{siz}(0.99L_y),$$

$$d_y = \max(d + k + 3 + \mathrm{siz}(U_x) - 2\mathrm{siz}(0.99L_y), 3 - \mathrm{siz}(L_y)).$$

The second part of $d_y$ is the
[minimum places](#covering-the-approximation) of $y$. $x$ needs no minimum,
because the rule only uses a bound on its true value.

**Example.** For $\pi / e$ good to $d = 3$ places, with $k = 2$: $\pi < 4$ and
$e > 2$, so $U_x = 4$ and $\bar{L}_y = 1.98$, both of size 1. So $\pi$ needs
$3 + 2 + 2 - 1 = 6$ places, and $e$ needs $3 + 2 + 3 + 1 - 2 = 7$.

The minimum matters when the dividend is very small. For $10^{-20} / y$ with
$y$ in $[0.9 \cdot 10^{-5}, 1.1 \cdot 10^{-5}]$ and $d = 2$, $L_y$ and
$\bar{L}_y$ both have size $-5$, and the rule asks $y$ for
$2 + 2 + 3 - 19 + 10 = -2$ places, which would round $y$ to 0. The minimum
asks for $3 - (-5) = 8$.

For $1/y$, use the [reciprocal rule](../2026-11-02%203%20Input%20places%20for%20functions/README.md#reciprocals) instead. It
asks for one place fewer, because there is no dividend error to budget for.

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

With $k = 2$ and tight bounds, where $\mathrm{siz}(U_x) = \mathrm{siz}(x)$ and
$\mathrm{siz}(\bar{L}_y) = \mathrm{siz}(y)$, and since
$\mathrm{nsiz} = \mathrm{siz} - 1$, the rule is the 2015 rules
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

**Why.** For $x + a$, $(\tilde{x} + a) - (x + a) = \tilde{x} - x$, so the
error passes through unchanged. For $ax$, Theorem 4 gives $A = |a|$. The product $a\tilde{x}$ is exact, so
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

**Rule.** For $x^n$ with $n \ge 2$ a whole number and an upper bound $U_x$,

$$d_x = \max(d + k + 1 + (n - 1)\mathrm{siz}(1.01U_x), 3 - \mathrm{siz}(U_x)) \quad \text{for } n \le 8,$$

$$d_x = \max(d + k + \mathrm{siz}(2n) + (n - 1)\mathrm{siz}(1.01U_x), 3 - \mathrm{siz}(U_x)) \quad \text{for any } n.$$

The second part is the [minimum places](#covering-the-approximation) of $x$.
Then compute $\tilde{x}^n$ to $d + k + 1$ places.

**Example.** For $\pi^5$ good to $d = 2$ places, with $k = 2$: $\pi < 4$, so
$\bar{U}_x = 4.04$, of size 1, and $\pi$ needs $2 + 2 + 1 + 4 = 9$ places.

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
$\log(1.2n) < 1$.

Computing $\tilde{x}^n$ to $d + k + 1$ places by repeated multiplication is
itself a chain of products. Each product is rounded, so carry enough guard
digits through the chain that the final value is within $10^{-(d+k+1)}$. The
product rule says how many.

## Examples

### A sum of 30 terms

To get a sum of 30 terms good to $d = 2$ places, with $k = 2$, the rule gives
each term $2 + 2 + \mathrm{siz}(30) = 6$ places. The exact count,
$\lceil 2 + 2 + \log(30 \cdot 0.51) \rceil = \lceil 5.18 \rceil$, is also 6, in
line with the 2015 table: $20 \le n \le 196$ needs $d + 4$.

### π times e

To get $\pi e$ good to $d = 3$ places, with $k = 2$, the target propagated
error is $T = 10^{-5}$.

**Places.** $\pi < 4$ and $e < 3$, so $\bar{U}_x = 4.04$ for $x = \pi$ and
$\bar{U}_y = 3.03$ for $y = e$, both of size 1. The product rule gives each input
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

Next: [Input places for functions](../2026-11-02%203%20Input%20places%20for%20functions/README.md).

# Input places for atan and atan2

How many decimal places the inputs to $\mathrm{atan}(x)$ and
$\mathrm{atan2}(y, x)$ need so that the output is good to $d$ places.

*Xin-Xin*

This builds on
[Input places for functions](../2026-11-02%203%20Input%20places%20for%20functions/README.md),
and uses its error budget, its Theorem 4 bounds and its notation: the output
places $d$, the budget $T = 10^{-d}$, the propagated
error budget $\eta$, the error constant $c$, lower bounds $L$ and upper bounds
$U$ on the true values, and the minimum places $3 - \mathrm{siz}(L)$ that keep
an approximation within 1% of its bound. Throughout, $\log$ means $\log_{10}$.

For atan2 it also uses
[atan2 identities revisited](../2026-11-03%20atan2%20identities%20revisited/README.md),
mainly the cut, where atan2 jumps, and the stable half-angle form for computing
it.

Every rule here was checked at random points with
[`check_rules.py`](check_rules.py), which uses 50-digit arithmetic. Each trial
moves the inputs by the largest allowed error and checks the output against
the budget. It also checks that each rule asks for at least the exact count.

## Summary

| Operation | Input places | Needs |
|---|---|---|
| $\mathrm{atan}(x)$ | $d + 1$ | nothing |
| $\mathrm{atan}(x)$ | $\max(d + 1 - 2\max(0, \mathrm{siz}(0.99L_x) - 1), 3 - \mathrm{siz}(L_x))$ | $L_x$ |
| $\mathrm{atan2}(y, x)$ | $d + 2 - \mathrm{siz}(0.99M)$ for both $x$ and $y$ | $L_y$, or $L_x$ with $x > 0$ |

For atan2, $M$ is the larger of the lower bounds you have, and each input
whose lower bound you use also needs its minimum places.

Neither function can be computed exactly, so as for the other functions take
$\eta = T/2$, and compute the output to $d + 1$ places.

## Arctangent

**Rule.** With no bounds,

$$d_x = d + 1.$$

With a lower bound $L_x \le |x|$ on the true value,

$$d_x = \max(d + 1 - 2\max(0, \mathrm{siz}(0.99L_x) - 1), 3 - \mathrm{siz}(L_x)).$$

The bound only helps when $|x|$ is above about 10, where it saves 2 places for
every factor of 10.

**Example.** For $\mathrm{atan}(10\pi)$ rounded to 6 places, take $d = 8$:
$10\pi > 31$, and $\mathrm{siz}(0.99 \cdot 31) = \mathrm{siz}(30.69) = 2$, so
$10\pi$ needs $8 + 1 - 2 = 7$ places.

So $\tilde{x} = 31.4159265$. Its arctangent to $d + 1 = 9$ places is
$1.538976082$, which rounds to $1.538976$. (The true value is
$1.5389760821\ldots$) With $c = \frac{1}{2}$, the exact count is 6, one less
than the rule.

**Why.** The derivative of $\mathrm{atan}$ is $\frac{1}{1 + t^2}$, which is at
most 1. So Theorem 4 gives $A = 1$, and the exact count is
$\lceil d + \log(2c) \rceil$, the same as for sine and cosine. Since
$\log(2c) \le \log 2 < 1$, $d + 1$ is enough.

With the minimum places, $\varepsilon_x \le 0.01L_x$, so $\tilde{x}$ has the
same sign as $x$, and every $t$ between them has $|t| \ge 0.99L_x$. Write
$\bar{L}_x = 0.99L_x$. Then $A = \frac{1}{1 + \bar{L}_x^2}$, and the exact count is

$$d_x = \left\lceil d + \log(2c) - \log(1 + \bar{L}_x^2) \right\rceil.$$

Since $\log(1 + \bar{L}_x^2)$ is at least 0, and more than
$2\log\bar{L}_x \ge 2(\mathrm{siz}(\bar{L}_x) - 1)$, the rule is enough.

The rule gives away up to 2 places for large $x$, because it uses $\mathrm{siz}$
in place of $\log$ for a squared bound. If that matters, use the exact count.

atan is increasing, so the exact method of Theorem 5 would also work. But
$\delta^{\pm} = \tan(\mathrm{atan}(x) \pm \eta) - x$ is awkward to bound, and it
only gains where the derivative bound is loose.

## Two-argument arctangent

**Rule.** Use whichever lower bounds you have, $L_x \le |x|$ and
$L_y \le |y|$, and let $M$ be the larger. Then

$$d_x = d_y = d + 2 - \mathrm{siz}(0.99M),$$

and each input whose lower bound you use also needs its minimum places,
$3 - \mathrm{siz}(L)$.

The rule needs $L_y$, or else $L_x$ together with knowing that $x > 0$.
Without either, no number of places is enough: see
[the cut](#the-cut-and-the-origin) below.

An exact input takes no share of the error, so it needs no places.

**Example.** For $\mathrm{atan2}(1, \pi)$ rounded to 6 places, take $d = 8$:
$\pi > 3$, so take $L_x = 3$, and $\pi > 0$. With $L_y = 1$ too, $M = 3$ and
$\mathrm{siz}(2.97) = 1$, so $\pi$ needs $8 + 2 - 1 = 9$ places. The 1 is
exact.

So $\tilde{x} = 3.141592654$. Then $\mathrm{atan2}(1, \tilde{x})$ to 9 places is
$0.308169071$, which rounds to $0.308169$. (The true value is
$0.3081690711\ldots$) With $c = \frac{1}{2}$, the exact count is 8, one less
than the rule.

**Example near the cut.** Take $\mathrm{atan2}(y, x)$ with $L_y = 0.001$ and
$L_x = 1$, for a point just above the negative x-axis, such as
$\mathrm{atan2}(0.001, -1) = 3.1405926539\ldots$ Then $M = 1$ and
$\mathrm{siz}(0.99) = 0$, so both inputs need $d + 2$ places. That is
no more than far from the cut. The only extra demand is that $y$ has its
minimum places, $3 - \mathrm{siz}(0.001) = 5$, which pin down its sign.

**Why.** With $r = \sqrt{x^2 + y^2}$, the partial derivatives are

$$\frac{\partial}{\partial x} \mathrm{atan2}(y, x) = -\frac{y}{r^2}, \qquad
\frac{\partial}{\partial y} \mathrm{atan2}(y, x) = \frac{x}{r^2}.$$

Both are at most $\frac{1}{r}$ in size, since $|x|$ and $|y|$ are at most $r$.
As in the proof of Theorem 4, only the points on the segment from $(x, y)$ to
$(\tilde{x}, \tilde{y})$ matter. On that segment:

- **With a lower bound on y.** The minimum places keep $\varepsilon_y \le 0.01L_y$, so $y$ and
  $\tilde{y}$ have the same sign, and every point has $|y| \ge 0.99L_y$.
- **With x positive.** The same argument with $L_x$ gives $x \ge 0.99L_x > 0$ at
  every point.

Either way the segment stays off the cut, where atan2 isn't differentiable,
and $r \ge 0.99M$ on it, since $r$ is at least $|x|$ and at least $|y|$. So
Theorem 4 holds with $A_x = A_y = \frac{1}{0.99M}$.

With two inputs, split $\eta = T/2$ evenly, so each input needs
$A\varepsilon \le T/4$. The exact count is

$$d_x = d_y = \left\lceil d + \log(4c) - \log(0.99M) \right\rceil.$$

Since $\log(4c) \le \log 4 < 1$ and
$-\log(0.99M) \le 1 - \mathrm{siz}(0.99M)$, the rule is enough.

**A sharper split.** The bound $\frac{1}{r}$ treats both inputs the same. A
closer bound is $A_x \le \frac{\bar{U}_y}{(0.99M)^2}$ and
$A_y \le \frac{\bar{U}_x}{(0.99M)^2}$. When one coordinate is much smaller than
the other, this lets the larger coordinate get by with fewer places. For
example, near the positive x-axis, $x$ barely affects the angle. The rule above
doesn't use this, and `check_rules.py` doesn't test it.

## The cut and the origin

The rule fails in two places, and in both no input places are enough.

**The origin.** The derivatives grow like $\frac{1}{r}$, so as $M$ shrinks,
the rule asks for more places, without limit. Near the origin a tiny move
changes the angle a lot. Without a lower bound on $r$ there is no rule.

**The cut.** atan2 jumps from $\pi$ to just above $-\pi$ across the negative
x-axis. If $x$ might be negative and $y$ might be 0, the true angle could be
near $\pi$ or near $-\pi$, and more places in $x$ can't tell which. Only the
sign of $y$ decides it. That is why the rule needs $L_y$, or $x > 0$. It
mirrors the condition for a divisor in the quotient rule, that the interval
of possible values must not contain 0.

Being close to the cut costs nothing, as the example above shows. Only
crossing it matters. If you can't pin down the sign of $y$, you can still get
the angle up to a multiple of $2\pi$. Points on either side of the cut are
then close together.

## Evaluating atan2

The rule assumes $\mathrm{atan2}(\tilde{y}, \tilde{x})$ can be computed to
$d + 1$ places. In decimal arithmetic it's computed from other operations,
using the stable half-angle form from the revisited doc:

$$
\mathrm{atan2}(y, x) = 2 \mathrm{atan}(q), \qquad
q =
\begin{cases}
\dfrac{y}{r + x}, & x \ge 0 \\
\dfrac{r - x}{y}, & x < 0
\end{cases}
$$

Each step is an operation from the earlier docs, so its places come from their
rules, working back from the output:

- **Doubling.** $2\mathrm{atan}(q)$ is $ax$ with $a = 2$, which needs one
  more place from $\mathrm{atan}(q)$.
- **atan of q.** For $x \ge 0$, $|q| \le 1$, and for $x < 0$, $|q| \ge 1$.
  Either way the arctangent rule here gives $d + 1$ places, since a lower
  bound of 1 doesn't save any.
- **The quotient.** For $x \ge 0$, the divisor $r + x$ is at least $r$, so
  $0.99M$ is a lower bound. For $x < 0$, the divisor is $y$, with lower bound
  $L_y$. Both are bounds the atan2 rule already requires.
- **The square root.** $\tilde{x}^2 + \tilde{y}^2$ is exact, and
  $(0.99M)^2$ is a lower bound for it.

The stable form matters here too. The naive form $\frac{y}{r + x}$ for
$x < 0$ divides by $r + x$, which is close to 0 near the cut. The quotient rule
would then need a lower bound on $r + x$, and it would cost 2 places for every
factor of 10 that bound shrinks.

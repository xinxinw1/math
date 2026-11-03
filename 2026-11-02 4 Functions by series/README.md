# Functions by series

How to evaluate a function by its series to a chosen number of places, term
by term, without knowing in advance how many terms there will be.

*Xin-Xin*

This builds on
[Input places for functions](../2026-11-02%203%20Input%20places%20for%20functions/README.md),
which says how many places the input needs. Throughout, $\log$ means
$\log_{10}$, and $T = 10^{-(d+k)}$ is the error budget from
[Input places for arithmetic](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md#the-error-budget).

The [series rule](#the-series-rule) works for any series whose terms shrink
fast enough. The sections after it apply it to exponentials, sines and
cosines, and logarithms.

## The series rule

This covers evaluating $f(\tilde{x})$ by a series, computing each term once,
from the previous one, without going back to redo earlier terms.

**Rule.** For a series $t_0 + t_1 + t_2 + \cdots$ with $t_0$ exact, whose
terms satisfy $t_n = r_n t_{n-1}$ with $|r_n| \le 1/n$:

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

For the tail, $|r_n| \le 1/n$ gives
$|t_{N+j}| \le |t_N| / ((N+1)(N+2)\cdots(N+j))$. For $N \ge 1$, the tail is
at most $|t_N|(1/2 + 1/6 + \cdots) = (e - 2)|t_N| < 0.72|t_N|$. Each rounding
error only shrinks on its way to later terms, so the error in $\tilde{t}_N$ is
at most $\sum u_n = 0.1T$, and $|t_N| < T/10 + 0.1T = 0.2T$. So the tail is
under $0.15T$, within $T/4$. If the test stops at $N = 0$, $t_0$ is exact and
the tail is at most $(e - 1)|t_0| < 0.18T$.

**Large arguments.** The condition $|r_n| \le 1/n$ limits how large the
argument can be. Beyond that, reduce the argument first. Each function below
says how.

## Exponentials

The series is

$$e^x = 1 + x + \frac{x^2}{2!} + \frac{x^3}{3!} + \cdots,$$

with $t_0 = 1$ and $r_n = x/n$. So $|r_n| \le 1/n$ exactly when $|x| \le 1$.
Then the series rule applies directly, with the input places from the
[exponential rule](../2026-11-02%203%20Input%20places%20for%20functions/README.md#exponentials).

For larger $|x|$, the terms grow until $n \approx |x|$, and the rounding
errors grow with them. For negative $x$, as in $e^{-20}$, the terms also
alternate in sign and cancel catastrophically. So pick $m$ with
$|x/2^m| \le 1$, and compute

$$e^x = \left(e^{x/2^m}\right)^{2^m}.$$

Use the [power rule](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md#powers) to choose the places for $e^{x/2^m}$, and
the series rule to compute it. Squaring $m$ times is a chain of products, so
carry guard digits through it, as for powers.

**Example.** To get $e^{\pi/4}$ good to $d = 6$ places,
with $k = 2$, the budget is $T = 10^{-8}$.

**Input.** $\pi/4 < 1$, so the [exponential rule](../2026-11-02%203%20Input%20places%20for%20functions/README.md#exponentials) with $U_x = 1$ gives
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

## Sine and cosine

The series are

$$\sin x = x - \frac{x^3}{3!} + \frac{x^5}{5!} - \cdots, \qquad \cos x = 1 - \frac{x^2}{2!} + \frac{x^4}{4!} - \cdots.$$

For sine, $t_0 = x$ and $r_n = -x^2/((2n)(2n+1))$. For cosine, $t_0 = 1$ and
$r_n = -x^2/((2n-1)(2n))$. Both ratios are largest compared with $1/n$ at
$n = 1$, so $|r_n| \le 1/n$ holds for $|x| \le \sqrt{6} \approx 2.45$ for
sine, and $|x| \le \sqrt{2} \approx 1.41$ for cosine. Use the
[sine rule](../2026-11-02%203%20Input%20places%20for%20functions/README.md#sine-and-cosine) for the input places. For larger $|x|$,
reduce the argument first, as below.

**Example.** To get $\sin(\pi/4)$ good to $d = 6$ places, with
$k = 2$, the budget is again $T = 10^{-8}$.

**Input.** The sine rule gives $d_x = 6 + 2 + 1 = 9$, so
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

### Argument reduction

Reduce $x$ by a whole number $j$ of quarter turns, to $r = x - j\pi/2$, and
then use

| $j$ mod 4 | $\sin x$ | $\cos x$ |
|---|---|---|
| 0 | $\sin r$ | $\cos r$ |
| 1 | $\cos r$ | $-\sin r$ |
| 2 | $-\sin r$ | $-\cos r$ |
| 3 | $-\cos r$ | $\sin r$ |

With $j$ the nearest whole number to $x / (\pi/2)$, $|r| \le \pi/4 \approx 0.79$,
well within both series' limits. $j$ only has to be roughly right: rounding an
estimate of $x / (\pi/2)$ that is off by up to 0.4 still gives
$|r| \le 0.9 \cdot \pi/2 < \sqrt{2}$.

The reduction uses an approximation to $\pi$, whose error is multiplied by
$|j|/2$. So with reduction:

- **x** needs $d + k + 1$ places, as in the sine rule, even if it is exactly
  rounded.
- **π** needs $d + k + 1 + \mathrm{siz}(j)$ places. With $j = 0$ there is no
  reduction, and $\pi$ isn't needed.

Then compute $\tilde{r} = \tilde{x} - j\tilde{\pi}/2$ exactly. It has the
accuracy the sine rule asks of the input, so evaluate $\sin \tilde{r}$ or
$\cos \tilde{r}$ by its series.

**Example.** For $\sin 100$ good to $d = 6$ places, with $k = 2$:
$100 / (\pi/2) \approx 63.7$, so $j = 64$. Since 64 mod 4 is 0,
$\sin 100 = \sin r$. $x = 100$ is exact. $\pi$ needs
$6 + 2 + 1 + \mathrm{siz}(64) = 11$ places, so $\tilde{\pi} = 3.14159265359$,
and

$$\tilde{r} = 100 - 32\tilde{\pi} = -0.53096491488.$$

The sine series at $\tilde{r}$ sums to $-0.50636564118$, which rounds to
$-0.506366$. The true value is $\sin 100 = -0.5063656411\ldots$

**Why.** The error in $\tilde{r}$ is at most
$\varepsilon_x + \frac{|j|}{2}\varepsilon_\pi$. This is a sum of two inputs
with $A_x = 1$ and $A_\pi = |j|/2$, so with $\eta = T/2$ split between them,
the exact counts are

$$d_x = \lceil d + k + \log(4c) \rceil, \qquad d_\pi = \lceil d + k + \log(2c|j|) \rceil.$$

Since $\log(4c) \le \log 2.4 < 1$, and
$\log(2c|j|) \le \log 1.2 + \log|j| < 1 + \mathrm{siz}(j)$, these are enough.

For $\sin 100$, the error in $\tilde{r}$ is at most
$32 \cdot \frac{1}{2} \cdot 10^{-11} = 1.6 \times 10^{-10}$, well within
$T/2$.

## Logarithms

The usual series $\ln(1 + u) = u - u^2/2 + u^3/3 - \cdots$ doesn't fit the
series rule. The ratio between its terms is $-u(n-1)/n$, which tends to $u$
instead of shrinking like $1/n$, so errors don't die out quickly, and for
$|u|$ near 1 it converges very slowly. Instead, use

$$\ln x = 2\left(z + \frac{z^3}{3} + \frac{z^5}{5} + \cdots\right), \qquad z = \frac{x - 1}{x + 1},$$

after reducing $x$ so that $z$ is small.

**Rule.** To get $\ln x$ good to $d$ places:

- **Input.** Use the [logarithm rule](../2026-11-02%203%20Input%20places%20for%20functions/README.md#logarithms) for the places of $x$.
  That spends $T/2$ of the budget, and the steps below share the rest.
- **Reduce.** Write $\tilde{x} = 2^j m$ with $m$ between $0.7$ and $1.4$, so
  that $\ln x = j \ln 2 + \ln m$. Dividing by 2 is exact in decimal: each
  halving adds one place.
- **ln 2.** Use $\ln 2$ to $d + k + 1 + \mathrm{siz}(j)$ places, like $\pi$ in
  the [sine reduction](#argument-reduction).
- **z.** Compute $z = (m - 1)/(m + 1)$ to $d + k + 2$ places, rounded or
  truncated. Then $|z| \le 0.18$, and $z^2 \le 0.032$. Compute $z^2$ exactly.
- **Terms.** Keep a running power, starting from $P_0 = z$, and for each
  $n \ge 1$ compute the power $P_n$ and the term $t_n$ as below, both rounded
  or truncated to $p_n$ places. Add the terms as you go, starting from
  $t_0 = z$.
- **Stop** after the first term with
  $\mathrm{siz}(\tilde{t}_N) \le -(d + k + 1)$, as in the [series](#the-series-rule)
  rule, including that term.
- **Combine.** $j \cdot \ln 2 + 2 \cdot (\text{sum})$, then round to $d$
  places.

The power and the term are

$$P_n = P_{n-1} \cdot z^2, \qquad t_n = \frac{P_n}{2n + 1},$$

each to

$$p_n = d + k + 1 + 2\mathrm{siz}(n)$$

places. That is one place more than the [series](#the-series-rule) rule, because the
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
  the [series](#the-series-rule) section, grouping by size gives
  $\sum u_n = 0.01T$ with the extra place. Doubled, the total is at most
  $2 \cdot 1.35 \cdot 0.01T = 0.027T$. Without the extra place it would be
  $0.27T$, more than $T/8$.
- **Tail.** The terms after $t_N$ shrink by at least $z^2$ each, so the tail is
  at most $|t_N| z^2/(1 - z^2) < 0.04|t_N|$. Doubled and with
  $|\tilde{t}_N| < T/10$, it is well under $T/8$.

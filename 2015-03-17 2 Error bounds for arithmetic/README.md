# Error bounds for arithmetic

How many decimal places the inputs to a sum, product or quotient need so that
the result, rounded to $d$ decimal places, is accurate.

*Xin-Xin* — handwritten notes from March 18, 2015, typed up.

This builds on
[Precision functions](../2015-03-17%201%20Precision%20functions/README.md),
and uses its $\mathrm{siz}$ and $\mathrm{nsiz}$.

The original pages:
[page 1](handwritten-notes-page-1.jpg) (accuracy and sums) and
[page 2](handwritten-notes-page-2.jpg) (products and quotients), pages 2 and 3
of 8 in the original set.

Throughout, $\log$ means $\log_{10}$, and $\mathrm{rnd}(x, p)$ means $x$ rounded
to $p$ decimal places.

## Accuracy

*March 18, 2015*

### Setup

Let $f(x, y)$ be a function and $d$ the output accuracy in decimal places. Let
$r_1$ be the error in $x$ and $r_2$ the error in $y$, with

$$|r_1| \le \frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1 + 2}}, \qquad |r_2| \le \frac{1}{2 \cdot 10^{d_2}} + \frac{1}{10^{d_2 + 2}}.$$

The first term is the error from rounding to $d_1$ (or $d_2$) places. The
second allows a little extra error left over from computing the input.

The error in the output is

$$\mathrm{err} = f(x, y) - f(x - r_1, y - r_2),$$

and the goal is

$$|\mathrm{err}| \le \frac{1}{10^{d + 2}}.$$

### Correct rounding can't be guaranteed

No bound on $\mathrm{err}$ guarantees that the computed value rounds the same way
as the true value. If $f(x, y) = 0.4499999$, $f(x - r_1, y - r_2) = 0.45$ and
$d = 1$, then $|\mathrm{err}| \le 1/10^{d + 6}$, yet

$$\mathrm{rnd}(f(x, y), d) = 0.4 \ne 0.5 = \mathrm{rnd}(f(x - r_1, y - r_2), d).$$

What can be guaranteed is

$$|f(x, y) - \mathrm{rnd}(f(x - r_1, y - r_2), d)| \le \frac{1}{2 \cdot 10^d} + \frac{1}{10^{d + 2}}.$$

This is the same form as the input error bound, so outputs can be fed into
further calculations.

### Places needed for an error bound

Let $a$ be an error bound. To get

$$\frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1 + 2}} \le a,$$

factor out $10^{-d_1}$:

$$\left(\frac{1}{2} + \frac{1}{100}\right) \frac{1}{10^{d_1}} = \frac{51}{100} \cdot \frac{1}{10^{d_1}} \le a$$

$$10^{d_1} \ge \frac{51}{100a}$$

$$d_1 \ge \log\frac{51}{100} - \log a.$$

If the input is an exactly rounded value, with only the rounding error, then

$$\frac{1}{2 \cdot 10^{d_{1a}}} \le a$$

$$10^{d_{1a}} \ge \frac{1}{2a}$$

$$d_{1a} \ge -\log 2 - \log a.$$

Comparing the two,

$$d_{1a} - d_1 \ge -\log 2 - \log\frac{51}{100},$$

$$d_{1a} \ge d_1 - \log\frac{51}{100} - \log 2,$$

$$d_{1a} \ge d_1 + \log\frac{50}{51}.$$

## Sums

Let $f(x_1, \ldots, x_n) = x_1 + x_2 + \cdots + x_n$. Then

$$\mathrm{err} = x_1 + \cdots + x_n - \left((x_1 - r_1) + \cdots + (x_n - r_n)\right) = r_1 + r_2 + \cdots + r_n.$$

If every $|r_k| \le \dfrac{1}{n \cdot 10^{d + 2}}$, then
$|\mathrm{err}| \le \dfrac{1}{10^{d + 2}}$. Taking $a = \dfrac{1}{n \cdot 10^{d + 2}}$
above,

$$d_k \ge \log\frac{51}{100} - \log\frac{1}{n \cdot 10^{d + 2}} = \log\frac{51}{100} + \log n + \log 10^{d + 2} = d + 2 + \log\frac{51n}{100}.$$

| Number of terms | Places needed |
|---|---|
| $n \le 100/51 \approx 1.96$ | $d_k \ge d + 2$ |
| $n \le 1000/51 \approx 19.61$ | $d_k \ge d + 3$ |
| $n \le 10000/51 \approx 196.08$ | $d_k \ge d + 4$ |
| $n \le 100000/51 \approx 1960.78$ | $d_k \ge d + 5$ |

If the inputs are exactly rounded values,

$$d_{ka} \ge d_k + \log\frac{50}{51}$$

$$= d + 2 + \log\frac{51n}{100} + \log\frac{50}{51}$$

$$= d + 2 + \log\frac{n}{2}.$$

| Number of terms | Places needed |
|---|---|
| $n \le 2$ | $d_{ka} \ge d + 2$ |
| $n \le 20$ | $d_{ka} \ge d + 3$ |
| $n \le 200$ | $d_{ka} \ge d + 4$ |
| $n \le 2000$ | $d_{ka} \ge d + 5$ |

## Products

Let $f(x, y) = xy$. Then

$$\mathrm{err} = xy - (x - r_1)(y - r_2) = xy - (xy - xr_2 - yr_1 + r_1r_2) = xr_2 + yr_1 - r_1r_2.$$

Assume $r_1r_2$ is negligible. If

$$|xr_2| \le \frac{1}{2 \cdot 10^{d + 2}} \quad \text{and} \quad |yr_1| \le \frac{1}{2 \cdot 10^{d + 2}},$$

then

$$|\mathrm{err}| \le |xr_2| + |yr_1| \le \frac{1}{10^{d + 2}}.$$

The condition on $r_2$ is

$$|r_2| \le \frac{1}{2|x| \cdot 10^{d + 2}},$$

so taking $a = \dfrac{1}{2|x| \cdot 10^{d + 2}}$,

$$d_2 \ge \log\frac{51}{100} - \log\frac{1}{2|x| \cdot 10^{d + 2}} = d + 2 + \log\frac{51}{100} + \log 2 + \log|x|.$$

Since $\log\frac{51}{100} + \log 2 = \log 1.02 < 1$, it is enough that

$$d_2 \ge d + 3 + \log|x|,$$

and since $\log|x| \le \mathrm{siz}(x)$, it is enough that

$$d_2 \ge d + 3 + \mathrm{siz}(x).$$

In the same way, from the condition on $r_1$,

$$d_1 \ge d + 3 + \log|y|,$$

so it is enough that

$$d_1 \ge d + 3 + \mathrm{siz}(y).$$

## Quotients

Let $f(x, y) = x/y$. Then

$$\mathrm{err} = \frac{x}{y} - \frac{x - r_1}{y - r_2} = \frac{xy - xr_2 - (xy - yr_1)}{y(y - r_2)} \approx \frac{yr_1 - xr_2}{y^2} = \frac{r_1}{y} - \frac{xr_2}{y^2}.$$

If

$$\left|\frac{r_1}{y}\right| \le \frac{1}{2 \cdot 10^{d + 2}} \quad \text{and} \quad \left|\frac{xr_2}{y^2}\right| \le \frac{1}{2 \cdot 10^{d + 2}},$$

then

$$|\mathrm{err}| \le \left|\frac{r_1}{y}\right| + \left|\frac{xr_2}{y^2}\right| \le \frac{1}{10^{d + 2}}.$$

For $r_1$, the condition is $|r_1| \le \dfrac{|y|}{2 \cdot 10^{d + 2}}$, so

$$d_1 \ge \log\frac{51}{100} + d + 2 + \log 2 - \log|y|$$

$$d_1 \ge d + 3 - \log|y|$$

$$d_1 \ge d + 3 - \mathrm{nsiz}(y).$$

For $r_2$, the condition is $|r_2| \le \dfrac{y^2}{2|x| \cdot 10^{d + 2}}$, so

$$d_2 \ge \log\frac{51}{100} + d + 2 + \log 2 + \log|x| - 2\log|y|$$

$$d_2 \ge d + 3 + \log|x| - 2\log|y|$$

$$d_2 \ge d + 3 + \mathrm{siz}(x) - 2 \mathrm{nsiz}(y).$$

## Notes on the derivations

*Added when typing up the notes.*

- Rounding $2 + \log 1.02 \approx 2.0086$ up to $3$ in the product and quotient
  bounds leaves almost a whole extra digit of slack.
- The product bound drops $r_1r_2$, and the quotient bound replaces
  $y(y - r_2)$ with $y^2$. So both are approximations as written. The slack
  from the previous point is presumably what covers those dropped terms, but
  the notes don't show that.
- Replacing $\log|x|$ with $\mathrm{siz}(x)$, and $-\log|y|$ with
  $-\mathrm{nsiz}(y)$, only increases the required places, since
  $\mathrm{nsiz}(y) \le \log|y| \le \mathrm{siz}(y)$. Those steps are sound.

Next: [Error bounds from inverse functions](../2015-03-17%203%20Error%20bounds%20from%20inverse%20functions/README.md).

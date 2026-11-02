# Precision and accuracy

How many decimal places the inputs to a calculation need so that the result,
rounded to $d$ decimal places, is accurate.

*Xin-Xin* — handwritten notes from March 17–18 and October 12, 2015, typed up.

The original pages:
[page 1](handwritten-notes-page-1.jpg) (precision functions),
[page 2](handwritten-notes-page-2.jpg) (accuracy and sums),
[page 3](handwritten-notes-page-3.jpg) (products and quotients),
[page 4](handwritten-notes-page-4.jpg) (input error from output error),
[pages 5](handwritten-notes-page-5.jpg) and
[6](handwritten-notes-page-6.jpg) (adding and multiplying by a constant),
[page 7](handwritten-notes-page-7.jpg) (square roots) and
[page 8](handwritten-notes-page-8.jpg) (exponentials).

Throughout, $\log$ means $\log_{10}$, and $\mathrm{rnd}(x, p)$ means $x$ rounded
to $p$ decimal places.

## Precision functions

*March 17, 2015*

The size of the whole-number part of $x$ (for $|x| \ge 1$, it is the number of
digits before the decimal point):

$$\mathrm{siz}(x) = \lfloor \log|x| \rfloor + 1$$

$$\mathrm{nsiz}(x) = \lfloor \log|x| \rfloor$$

So

$$\mathrm{nsiz}(x) \le \log|x| \le \mathrm{siz}(x), \qquad \mathrm{siz}(x) = \mathrm{nsiz}(x) + 1.$$

The precision of $x$ is the number of decimal places it needs:

$$\mathrm{prec}(x) = \text{the smallest } p \text{ such that } \mathrm{rnd}(x, p) = x.$$

The number of significant figures in $x$ is

$$\mathrm{fig}(x) = \mathrm{prec}(x) + \mathrm{siz}(x).$$

For example, $\mathrm{fig}(0.005) = 3 + (-2) = 1$ and
$\mathrm{fig}(1200) = -2 + 4 = 2$.

Rounding interacts with these as follows:

$$\mathrm{prec}(\mathrm{rnd}(x, p)) \le p$$

$$\mathrm{siz}(\mathrm{rnd}(x, p)) \le \mathrm{siz}(x) + 1$$

$$\mathrm{fig}(\mathrm{rnd}(x, p)) = \min(p + \mathrm{siz}(x), \mathrm{fig}(x))$$

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

$$d_{ka} \ge d_k + \log\frac{50}{51} = d + 2 + \log\frac{51n}{100} + \log\frac{50}{51} = d + 2 + \log\frac{n}{2}.$$

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

By symmetry,

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

## Error bound on input given error bound on output

*March 17, 2015*

Let $f$ be a function and $r$ the error in its input. The question is how
small $|r| \le \delta$ has to be to guarantee

$$|f(x) - f(x - r)| \le \varepsilon.$$

Unpacking the absolute value:

$$-\varepsilon \le f(x) - f(x - r) \le \varepsilon$$

$$-f(x) - \varepsilon \le -f(x - r) \le -f(x) + \varepsilon$$

$$f(x) + \varepsilon \ge f(x - r) \ge f(x) - \varepsilon.$$

### Increasing functions

If $f$ is always increasing, then so is $f^{-1}$, and applying it keeps the
inequalities:

$$f^{-1}(f(x) + \varepsilon) \ge x - r \ge f^{-1}(f(x) - \varepsilon)$$

$$-x + f^{-1}(f(x) + \varepsilon) \ge -r \ge -x + f^{-1}(f(x) - \varepsilon)$$

$$x - f^{-1}(f(x) + \varepsilon) \le r \le x - f^{-1}(f(x) - \varepsilon).$$

Every $r$ with $|r| \le \delta$ satisfies this when

$$x - f^{-1}(f(x) + \varepsilon) \le -\delta \quad \text{and} \quad x - f^{-1}(f(x) - \varepsilon) \ge \delta,$$

that is, when

$$\delta \le f^{-1}(f(x) + \varepsilon) - x \quad \text{and} \quad \delta \le x - f^{-1}(f(x) - \varepsilon).$$

### Decreasing functions

If $f$ is always decreasing, then so is $f^{-1}$, and applying it reverses the
inequalities:

$$f^{-1}(f(x) + \varepsilon) \le x - r \le f^{-1}(f(x) - \varepsilon).$$

The rest is the same as above with the inequalities reversed:

$$x - f^{-1}(f(x) + \varepsilon) \ge r \ge x - f^{-1}(f(x) - \varepsilon)$$

$$x - f^{-1}(f(x) - \varepsilon) \le r \le x - f^{-1}(f(x) + \varepsilon),$$

so the conditions are

$$x - f^{-1}(f(x) - \varepsilon) \le -\delta \quad \text{and} \quad x - f^{-1}(f(x) + \varepsilon) \ge \delta,$$

$$\delta \le f^{-1}(f(x) - \varepsilon) - x \quad \text{and} \quad \delta \le x - f^{-1}(f(x) + \varepsilon).$$

## Adding and multiplying by a constant

### Adding a constant

Let $f(x) = x + a$, so $f^{-1}(x) = x - a$ and $f$ is increasing. Let the
result be already rounded, so the output error is the full $d$-place bound and
the input error is the $d_1$-place bound:

$$\varepsilon = \frac{1}{2 \cdot 10^d} + \frac{1}{10^{d+2}}, \qquad \delta = \frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1+2}}.$$

Then

$$\delta \le f^{-1}(f(x) + \varepsilon) - x = x + a + \varepsilon - a - x = \varepsilon$$

$$\delta \le x - f^{-1}(f(x) - \varepsilon) = x - (x + a - \varepsilon - a) = \varepsilon,$$

so

$$d_1 \ge d.$$

### Multiplying by a positive constant

Let $f(x) = ax$ with $a > 0$, so $f^{-1}(x) = x/a$ and $f$ is increasing. Let the
result be already rounded, with $\varepsilon$ and $\delta$ as above. Then

$$\delta \le \frac{1}{a}(ax + \varepsilon) - x = x + \frac{\varepsilon}{a} - x = \frac{\varepsilon}{a}$$

$$\delta \le x - \frac{1}{a}(ax - \varepsilon) = x - x + \frac{\varepsilon}{a} = \frac{\varepsilon}{a}.$$

So the condition is

$$\frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1+2}} \le \frac{\varepsilon}{a},$$

and, as in [Places needed for an error bound](#places-needed-for-an-error-bound),

$$d_1 \ge \log\frac{51}{100} - \log\frac{\varepsilon}{a} = \log\frac{51}{100} - \log\left(\frac{51}{100} \cdot \frac{1}{10^d}\right) + \log a = d + \log a.$$

### Multiplying by a negative constant

Let $f(x) = ax$ with $a < 0$, so $f^{-1}(x) = x/a$ and $f$ is decreasing. With
the result already rounded,

$$\delta \le \frac{1}{a}(ax - \varepsilon) - x = x - \frac{\varepsilon}{a} - x = -\frac{\varepsilon}{a}$$

$$\delta \le x - \frac{1}{a}(ax + \varepsilon) = x - x - \frac{\varepsilon}{a} = -\frac{\varepsilon}{a},$$

so

$$d_1 \ge d + \log(-a).$$

For any $a \ne 0$, then,

$$d_1 \ge d + \log|a|.$$

### When the result is not already rounded

Let $f(x) = ax$ with $a > 0$, but now with the result not already rounded. The
output has to be within $\varepsilon = 1/10^{d+2}$ before rounding:

$$|f(x) - f(x - r)| \le \varepsilon = \frac{1}{10^{d+2}}, \qquad |r| \le \delta = \frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1+2}}.$$

As before, $\delta \le \varepsilon / a$, so

$$d_1 \ge \log\frac{51}{100} - \log\frac{1}{10^{d+2}} + \log a = d + 2 + \log\left(\frac{51}{100}a\right).$$

For any $a \ne 0$ (the notes say "for any $x$", but mean any $a$),

$$d_1 \ge d + 2 + \log\left(\frac{51}{100}|a|\right).$$

## Square roots

*October 12, 2015*

Let $f(x) = \sqrt{x}$, so $f^{-1}(x) = x^2$ and $f$ is increasing. Let

$$|f(x) - f(x - r)| \le \varepsilon = \frac{1}{10^{d+2}}, \qquad |r| \le \delta = \frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1+2}}.$$

Then

$$\delta \le f^{-1}(f(x) + \varepsilon) - x = (\sqrt{x} + \varepsilon)^2 - x = x + 2\varepsilon\sqrt{x} + \varepsilon^2 - x$$

$$\delta \le x - f^{-1}(f(x) - \varepsilon) = x - (\sqrt{x} - \varepsilon)^2 = x - x + 2\varepsilon\sqrt{x} - \varepsilon^2.$$

Assume $\varepsilon^2$ is negligible. Then

$$\delta \le 2\varepsilon\sqrt{x}$$

$$\frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1+2}} \le 2\varepsilon\sqrt{x} = \frac{2\sqrt{x}}{10^{d+2}}$$

$$d_1 \ge \log\frac{51}{100} - \log\frac{2\sqrt{x}}{10^{d+2}} = d + 2 - \log 2 + \log\frac{51}{100} - \tfrac{1}{2}\log x = d + 2 - \log\frac{200}{51} - \tfrac{1}{2}\log x.$$

Since $\log\frac{200}{51} > 0$, it is enough that

$$d_1 \ge d + 2 - \tfrac{1}{2}\log x.$$

Since $\mathrm{nsiz}(x) \le \log x$,

$$d + 2 - \tfrac{1}{2}\mathrm{nsiz}(x) \ge d + 2 - \tfrac{1}{2}\log x,$$

so it is enough that

$$d_1 \ge d + 2 - \tfrac{1}{2}\mathrm{nsiz}(x).$$

## Exponentials

*October 12, 2015*

Let $f(x) = e^x$, so $f^{-1}(x) = \ln x$ and $f$ is increasing. Then

$$\delta \le f^{-1}(f(x) + \varepsilon) - x = \ln(e^x + \varepsilon) - x = \ln\frac{e^x + \varepsilon}{e^x} = \ln\left(1 + \frac{\varepsilon}{e^x}\right)$$

$$\delta \le x - f^{-1}(f(x) - \varepsilon) = x - \ln(e^x - \varepsilon) = \ln\frac{e^x}{e^x - \varepsilon} = -\ln\frac{e^x - \varepsilon}{e^x} = -\ln\left(1 - \frac{\varepsilon}{e^x}\right).$$

Since $\ln(1 + u) \le -\ln(1 - u)$, the first condition is the one that matters:

$$\delta \le \ln\left(1 + \frac{\varepsilon}{e^x}\right).$$

So the condition is

$$\frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1+2}} \le \ln\left(1 + \frac{\varepsilon}{e^x}\right),$$

which gives

$$d_1 \ge \log\frac{51}{100} - \log\ln\left(1 + \frac{\varepsilon}{e^x}\right) = \frac{1}{\ln 10}\left(-\ln\ln\left(1 + \frac{\varepsilon}{e^x}\right)\right) + \log\frac{51}{100}.$$

To bound the $\ln\ln$ term, let $H$ be the step function

$$H(x) = \begin{cases} 1, & x \ge 0 \\ 0, & x < 0. \end{cases}$$

Then

$$(x + 1)H(x + 1) > -\ln\ln\left(1 + \frac{1}{e^x}\right).$$

Replacing $x$ with $x - \ln\varepsilon$, which turns $1/e^x$ into
$\varepsilon/e^x$,

$$(x - \ln\varepsilon + 1)H(x - \ln\varepsilon + 1) > -\ln\ln\left(1 + \frac{\varepsilon}{e^x}\right).$$

So

$$d_1 \ge \frac{1}{\ln 10}(x - \ln\varepsilon + 1)H(x - \ln\varepsilon + 1) + \log\frac{51}{100}$$

$$d_1 \ge (\log e^x - \log\varepsilon + \log e)H(\log e^x - \log\varepsilon + \log e) + \log\frac{51}{100}.$$

With $\varepsilon = 1/10^{d+2}$,

$$d_1 \ge (d + 2 + (x + 1)\log e)H(d + 2 + (x + 1)\log e) + \log\frac{51}{100}$$

$$d_1 \ge \left(d + 3 + \frac{x}{\ln 10}\right)H\left(d + 3 + \frac{x}{\ln 10}\right).$$

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
- The inverse-function method on page 4 is exact for a monotonic function of
  one variable: it gives the largest $\delta$ that works, with nothing assumed
  negligible.
- It needs $f(x) \pm \varepsilon$ to be in the range of $f$. If
  $\sqrt{x} < \varepsilon$ or $e^x \le \varepsilon$, then
  $f^{-1}(f(x) - \varepsilon)$ doesn't exist. In that case that side of the
  bound is no constraint at all, so the results still hold, but the notes
  don't say so.
- Dropping $\varepsilon^2$ in the square root bound goes the unsafe way, since
  the binding bound is $\delta \le 2\varepsilon\sqrt{x} - \varepsilon^2$. It is
  covered by the $\log\frac{200}{51}$ that was also dropped, as long as
  $\sqrt{x} \ge \varepsilon / 1.49$.
- Near $x = 0$, the square root bound asks for far more places than needed.
  $|\sqrt{x} - \sqrt{y}| \le \sqrt{|x - y|}$, so $\delta = \varepsilon^2$
  always works.
- The inequality $(x + 1)H(x + 1) > -\ln\ln(1 + e^{-x})$ holds for all $x$.
  For $x < -1$, the right side is negative. For $x \ge -1$, let
  $u = e^{-x} \le e$. If $u \le e - 1$, then $\ln(1 + u) \ge u/(1 + u) > u/e$,
  and if $e - 1 < u \le e$, then $\ln(1 + u) > 1 \ge u/e$. Either way
  $\ln(1 + u) > e^{-(x+1)}$, which is the inequality.
- The last step of the exponential bound is safe: it rounds $\log e \approx 0.434$
  up to 1 and drops $\log\frac{51}{100} < 0$, and $tH(t)$ never decreases as
  $t$ grows.
- These bounds also use the true $x$, and $d_1$ has to be a whole number, so it
  needs a ceiling. That matters for the square root, where
  $\frac{1}{2}\mathrm{nsiz}(x)$ can be a half-integer.

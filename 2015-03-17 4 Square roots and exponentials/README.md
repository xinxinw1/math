# Square roots and exponentials

How many decimal places the input to $\sqrt{x}$ or $e^x$ needs so that the
result, rounded to $d$ decimal places, is accurate.

*Xin-Xin* — handwritten notes from October 12, 2015, typed up.

This builds on
[Error bounds from inverse functions](../2015-03-17%203%20Error%20bounds%20from%20inverse%20functions/README.md),
and uses its method.

The original pages:
[page 1](handwritten-notes-page-1.jpg) (square roots) and
[page 2](handwritten-notes-page-2.jpg) (exponentials), pages 7 and 8 of 8 in
the original set.

Throughout, $\log$ means $\log_{10}$, and $\mathrm{rnd}(x, p)$ means $x$ rounded
to $p$ decimal places.

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

- The inverse-function method needs $f(x) \pm \varepsilon$ to be in the range
  of $f$. If
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

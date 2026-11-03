# Reciprocals

How many decimal places the input to $1/x$ needs so that the result, rounded to
$d$ decimal places, is accurate.

*Xin-Xin* — undated handwritten notes from 2015, typed up.

This builds on
[Square roots and exponentials](../2015-03-17%204%20Square%20roots%20and%20exponentials/README.md),
and uses the inverse-function method from
[Error bounds from inverse functions](../2015-03-17%203%20Error%20bounds%20from%20inverse%20functions/README.md).

The original pages:
[page 1](handwritten-notes-page-1.jpg) (the reciprocal) and
[page 2](handwritten-notes-page-2.jpg) (proof of the max inequality, written on
the back of page 1).

Throughout, $\log$ means $\log_{10}$, and $\mathrm{rnd}(x, p)$ means $x$ rounded
to $p$ decimal places. As in the square root and exponential docs, the output
error bound and the input error bound are

$$\varepsilon = \frac{1}{10^{d+2}}, \qquad \delta = \frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1+2}}.$$

## The reciprocal

Let $f(x) = 1/x$ for $0 < x < \infty$. Then $f^{-1}(x) = 1/x$, and $f$ is
decreasing. The conditions are

$$f(x + \delta) \ge f(x) - \varepsilon, \qquad f(x - \delta) \le f(x) + \varepsilon, \qquad x - \delta \ge 0.$$

From the first,

$$\delta \le f^{-1}(f(x) - \varepsilon) - x = \frac{1}{\frac{1}{x} - \varepsilon} - x = \frac{x}{1 - \varepsilon x} - x$$

$$= \frac{x - (x - \varepsilon x^2)}{1 - \varepsilon x} = \frac{\varepsilon x^2}{1 - \varepsilon x}.$$

From the second,

$$\delta \le x - f^{-1}(f(x) + \varepsilon) = x - \frac{1}{\frac{1}{x} + \varepsilon} = x - \frac{x}{1 + \varepsilon x}$$

$$= \frac{x + \varepsilon x^2 - x}{1 + \varepsilon x} = \frac{\varepsilon x^2}{1 + \varepsilon x}.$$

The third gives $\delta \le x$, so

$$d_1 \ge \log\frac{51}{100} - \log x.$$

Since

$$\frac{\varepsilon x^2}{1 + \varepsilon x} \le \frac{\varepsilon x^2}{1 - \varepsilon x},$$

the second condition is the one that matters:

$$\delta \le \frac{\varepsilon x^2}{1 + \varepsilon x},$$

so

$$d_1 \ge \log\frac{51}{100} - \log\frac{\varepsilon x^2}{1 + \varepsilon x}.$$

To simplify this, use the inequality proved in the next section:

$$\max(1 - \log x, 1 - \log \varepsilon x^2) > -\log\frac{\varepsilon x^2}{1 + \varepsilon x}.$$

Then it is enough that

$$d_1 \ge \log\frac{51}{100} + \max(1 - \log x, 1 - \log \varepsilon x^2).$$

With $\varepsilon = 1/10^{d+2}$, $1 - \log \varepsilon x^2 = d + 3 - 2\log x$, and
$\log\frac{51}{100} < 0$, so it is enough that

$$d_1 \ge \max(1 - \log x, d + 3 - 2\log x).$$

Since $\mathrm{nsiz}(x) \le \log x$, it is enough that

$$d_1 \ge \max(1 - \mathrm{nsiz}(x), d + 3 - 2\mathrm{nsiz}(x)).$$

## Proof of the max inequality

The claim is

$$\max(1 - \log x, 1 - \log \varepsilon x^2) > -\log\frac{\varepsilon x^2}{1 + \varepsilon x}.$$

### Where the two terms cross

$$1 - \log x = 1 - \log \varepsilon x^2$$

$$\log x = \log \varepsilon x^2$$

$$x = \varepsilon x^2$$

$$\varepsilon x^2 - x = 0$$

$$x(\varepsilon x - 1) = 0.$$

Since $x \ne 0$, $\varepsilon x = 1$, so $x = 1/\varepsilon$.

### When the first term is greater

$$1 - \log x > -\log\frac{\varepsilon x^2}{1 + \varepsilon x}$$

$$1 > \log x - \log \varepsilon x^2 + \log(1 + \varepsilon x)$$

$$= -\log \varepsilon x + \log(1 + \varepsilon x)$$

$$= \log\left(1 + \frac{1}{\varepsilon x}\right)$$

$$10 > 1 + \frac{1}{\varepsilon x}$$

$$9 > \frac{1}{\varepsilon x}$$

$$\varepsilon x > \frac{1}{9}$$

$$x > \frac{1}{9\varepsilon}.$$

### When the second term is greater

$$1 - \log \varepsilon x^2 > -\log\frac{\varepsilon x^2}{1 + \varepsilon x}$$

$$1 > \log \varepsilon x^2 - \log \varepsilon x^2 + \log(1 + \varepsilon x)$$

$$1 > \log(1 + \varepsilon x)$$

$$10 > 1 + \varepsilon x$$

$$\varepsilon x < 9$$

$$x < \frac{9}{\varepsilon}.$$

### Putting them together

| | $0 < x < \frac{1}{9\varepsilon}$ | $\frac{1}{9\varepsilon} < x < \frac{9}{\varepsilon}$ | $x > \frac{9}{\varepsilon}$ |
|---|---|---|---|
| First term is greater | No | Yes | Yes |
| Second term is greater | Yes | Yes | No |

At any $x$, one of $1 - \log x$ and $1 - \log \varepsilon x^2$ is greater than
$-\log\frac{\varepsilon x^2}{1 + \varepsilon x}$, so the larger of the two is
too.

## Notes on the derivations

*Added when typing up the notes.*

- The notes write the terms as $-\log x + 1$ and $-\log \varepsilon x^2 + 1$.
  They are written here as $1 - \log x$ and $1 - \log \varepsilon x^2$, so
  they can't be misread as $-\log(x + 1)$.
- The table leaves out the endpoints $x = \frac{1}{9\varepsilon}$ and
  $x = \frac{9}{\varepsilon}$, where one term only equals the right side. At
  each of them the other term is still greater, so every $x$ is covered.
- The condition $\delta \le x$ isn't needed. Since
  $\frac{\varepsilon x^2}{1 + \varepsilon x} < x$ for every $x > 0$, the
  main condition already implies it. Strictly, the condition should be
  $x - \delta > 0$, since $1/0$ is undefined, and that is implied too.
- The first side of the bound needs $\varepsilon x < 1$, so that
  $f(x) - \varepsilon$ is in the range of $f$. If $\varepsilon x \ge 1$, that
  side puts no limit on $\delta$, as with the square root and exponential, and
  the result still holds.
- The last two steps only increase $d_1$: they drop
  $\log\frac{51}{100} < 0$ and replace $\log x$ with
  $\mathrm{nsiz}(x) \le \log x$. The result is then a whole number, so unlike
  the square root bound it needs no ceiling.
- The max asks for less than one place more than the exact bound. The gaps
  are $1 - \log(1 + \frac{1}{\varepsilon x})$ and
  $1 - \log(1 + \varepsilon x)$, and both are less than 1.
- Like the other bounds, this one uses the true $x$.

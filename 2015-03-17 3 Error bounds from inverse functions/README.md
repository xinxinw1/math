# Error bounds from inverse functions

How small the error in the input of a monotonic function has to be to keep the
error in the output within a bound, and what that gives for adding and
multiplying by a constant.

*Xin-Xin* — handwritten notes from March 17, 2015, typed up.

This builds on
[Error bounds for arithmetic](../2015-03-17%202%20Error%20bounds%20for%20arithmetic/README.md),
and uses its error bounds of the form $\frac{1}{2 \cdot 10^d} + \frac{1}{10^{d+2}}$.

The original pages:
[page 1](handwritten-notes-page-1.jpg) (input error from output error),
[pages 2](handwritten-notes-page-2.jpg) and
[3](handwritten-notes-page-3.jpg) (adding and multiplying by a constant),
pages 4 to 6 of 8 in the original set.

Throughout, $\log$ means $\log_{10}$, and $\mathrm{rnd}(x, p)$ means $x$ rounded
to $p$ decimal places.

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

and, as in [Places needed for an error bound](../2015-03-17%202%20Error%20bounds%20for%20arithmetic/README.md#places-needed-for-an-error-bound),

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

## Notes on the derivations

*Added when typing up the notes.*

- The inverse-function method is exact for a monotonic function of
  one variable: it gives the largest $\delta$ that works, with nothing assumed
  negligible.

Next: [Square roots and exponentials](../2015-03-17%204%20Square%20roots%20and%20exponentials/README.md).

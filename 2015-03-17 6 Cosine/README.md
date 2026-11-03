# Cosine

How many decimal places the input to $\cos x$ needs so that the result, rounded
to $d$ decimal places, is accurate.

*Xin-Xin* — an undated handwritten page from 2015, typed up.

This builds on [Reciprocals](../2015-03-17%205%20Reciprocals/README.md), and
uses the inverse-function method from
[Error bounds from inverse functions](../2015-03-17%203%20Error%20bounds%20from%20inverse%20functions/README.md).

The original page: [page 1](handwritten-notes-page-1.jpg).

Throughout, $\log$ means $\log_{10}$, and $\mathrm{rnd}(x, p)$ means $x$ rounded
to $p$ decimal places. As in the earlier docs on functions, the output error
bound and the input error bound are

$$\varepsilon = \frac{1}{10^{d+2}}, \qquad \delta = \frac{1}{2 \cdot 10^{d_1}} + \frac{1}{10^{d_1+2}}.$$

The page doesn't state $\varepsilon$, but its last step uses this value.

## The cosine

Let $f(x) = \cos x$ for $0 \le x \le \frac{\pi}{2}$. Then
$f^{-1}(x) = \cos^{-1} x$, and $f$ is decreasing. So

$$\delta \le f^{-1}(f(x) - \varepsilon) - x = \cos^{-1}(\cos x - \varepsilon) - x.$$

Let

$$g(x) = \cos^{-1}(\cos x - \varepsilon) - x.$$

Then

$$g'(x) = -\frac{-\sin x}{\sqrt{1 - (\cos x - \varepsilon)^2}} - 1$$

$$= \frac{\sin x}{\sqrt{1 - \cos^2 x + 2\varepsilon\cos x - \varepsilon^2}} - 1$$

$$= \frac{\sin x - \sqrt{\sin^2 x + 2\varepsilon\cos x - \varepsilon^2}}{\sqrt{\sin^2 x + 2\varepsilon\cos x - \varepsilon^2}}.$$

This is 0 when

$$\sin x = \sqrt{\sin^2 x + 2\varepsilon\cos x - \varepsilon^2}$$

$$2\varepsilon\cos x = \varepsilon^2$$

$$\cos x = \frac{\varepsilon}{2}$$

$$x = \cos^{-1}\frac{\varepsilon}{2}.$$

At that point,

$$g(x) = \cos^{-1}\left(\frac{\varepsilon}{2} - \varepsilon\right) - \cos^{-1}\frac{\varepsilon}{2}$$

$$= \cos^{-1}\left(-\frac{\varepsilon}{2}\right) - \cos^{-1}\frac{\varepsilon}{2}$$

$$= \pi - 2\cos^{-1}\frac{\varepsilon}{2}.$$

So $g(x) \ge \varepsilon$, and it is enough that $\delta \le \varepsilon$:

$$d_1 \ge \log\frac{51}{100} - \log\varepsilon = d + 2 + \log\frac{51}{100}.$$

The notes write the right side as $d + 2$. Since $\log\frac{51}{100} < 0$, it is
enough that

$$d_1 \ge d + 2.$$

At the bottom, the page also has

$$\cos(a + b) = \cos a\cos b - \sin a\sin b,$$

which isn't used.

## Notes on the derivations

*Added when typing up the notes.*

- After $2\varepsilon\cos x = \varepsilon^2$, the next two lines of the notes
  look like $\frac{\varepsilon^2}{2}$ rather than $\frac{\varepsilon}{2}$,
  possibly with something crossed out. The line after them uses
  $\frac{\varepsilon}{2}$, which is the correct value, so it is used throughout
  here.
- The notes don't show that $x = \cos^{-1}\frac{\varepsilon}{2}$ is where $g$
  is smallest. The numerator of $g'(x)$ is negative when
  $\cos x > \frac{\varepsilon}{2}$ and positive when
  $\cos x < \frac{\varepsilon}{2}$, so $g$ falls and then rises, and this is
  its smallest value on $[0, \frac{\pi}{2}]$.
- The notes also don't show that $\pi - 2\cos^{-1}\frac{\varepsilon}{2} \ge \varepsilon$.
  It equals $2\sin^{-1}\frac{\varepsilon}{2}$, and $\sin^{-1} t \ge t$ for
  $t \ge 0$, so it is at least $\varepsilon$.
- For a decreasing function, the method also needs
  $\delta \le x - \cos^{-1}(\cos x + \varepsilon)$, which the notes leave out.
  It holds too. Let $y = \cos^{-1}(\cos x + \varepsilon)$. Then
  $x = \cos^{-1}(\cos y - \varepsilon)$, so this side equals $g(y)$, which is
  at least $\varepsilon$. Near $x = 0$, $\cos x + \varepsilon > 1$ is outside
  the range of $f$, and that side puts no limit on $\delta$.
- The bound holds for every $x$, not just $0 \le x \le \frac{\pi}{2}$, and
  there is a shorter proof. Since $|\sin| \le 1$,
  $|\cos x - \cos y| \le |x - y|$, so $\delta = \varepsilon$ always works. The
  same argument gives $d_1 \ge d + 2$ for $\sin x$.

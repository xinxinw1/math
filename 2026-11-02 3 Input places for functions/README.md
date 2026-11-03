# Input places for functions

How many decimal places the input to a square root, exponential, logarithm,
sine or cosine needs so that the output, rounded to $d$ places, is accurate.

*Xin-Xin*

This builds on
[Input places for arithmetic](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md),
and uses its error budget and the way its rules are derived. Throughout,
$\log$ means $\log_{10}$.

## Monotonic functions

For a function of one variable that only goes up or only goes down, there is
an exact answer: the largest input error that keeps the output error within
$\eta$. This is the inverse-function method from the 2015 notes.

**Theorem 5.** Let $f$ be continuous and strictly increasing on an interval
$J$ containing $x$, and let $\eta > 0$. Let

$$\delta^{+} = f^{-1}(f(x) + \eta) - x, \qquad \delta^{-} = x - f^{-1}(f(x) - \eta),$$

taking $\delta^{+} = \infty$ if $f(x) + \eta$ is above every value of $f$ on
$J$, and $\delta^{-} = \infty$ if $f(x) - \eta$ is below every value. Then
$|f(\tilde{x}) - f(x)| \le \eta$ for every $\tilde{x}$ in $J$ with
$|\tilde{x} - x| \le \delta$ if

$$\delta \le \min(\delta^{+}, \delta^{-}).$$

If $J$ reaches past $x + \delta^{+}$ and $x - \delta^{-}$, no larger $\delta$
works.

For a strictly decreasing $f$, swap $f(x) + \eta$ and $f(x) - \eta$ in the
definitions of $\delta^{+}$ and $\delta^{-}$.

**Proof.** Take $\tilde{x} \ge x$ in $J$. Since $f$ is increasing,
$|f(\tilde{x}) - f(x)| = f(\tilde{x}) - f(x)$, and this is at most $\eta$
exactly when $\tilde{x} \le x + \delta^{+}$. That is automatic if
$\delta^{+} = \infty$. If not, it holds because $f^{-1}$ is increasing too,
and it fails for every $\tilde{x}$ just above $x + \delta^{+}$. So the inputs
above $x$ are all fine when $\delta \le \delta^{+}$, and, if $J$ has inputs
just above $x + \delta^{+}$, only then. The inputs below
$x$ work the same way with $\delta^{-}$. For a decreasing $f$, apply this to
$-f$, which is increasing. ∎

Unlike
[Theorem 4](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md#the-general-rule),
this gives the largest $\delta$ that works, not just one that works. The catch is that $\delta^{+}$ and $\delta^{-}$ depend on the true
$x$, which you only know approximately. So use the smallest value they take
over the range $x$ might be in. In the cases below, that is at one end of the
range.

Because the theorem fixes the true $x$, the rules derived from it only need
bounds on the true value, $U_x$ and $L_x$, not the barred bounds that also
cover $\tilde{x}$.

## Summary

| Operation | Input places |
|---|---|
| $\sqrt{x}$ | $d + k - \lfloor (\mathrm{siz}(L_x) - 1)/2 \rfloor$ |
| $e^x$ | $d + k + 2 + \lfloor 0.44 U_x \rfloor$ for $x \ge 0$, and $\max(1, d + k + 2 - \lceil 0.43 L_x \rceil)$ for $x < 0$ |
| $\ln x$ | $d + k + 2 - \mathrm{siz}(L_x)$ |
| $\sin x$, $\cos x$ | $d + k + 1$ |

## Square roots

**Rule.** With a lower bound $L_x \le x$ on the true value,

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
$\eta + \frac{1}{2} \cdot 10^{-7} = 5.5 \times 10^{-7} \le T$. By [Lemma 1](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#the-invariant),
$\mathrm{rnd}(1.7724539, 4) = 1.7725$ is good to 4 places. (The true value is
$1.7724538509\ldots$)

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

## Exponentials

**Rule.** For $x \ge 0$, with an upper bound $U_x \ge x$ on the true value,

$$d_x = d + k + 2 + \lfloor 0.44 U_x \rfloor.$$

For $x < 0$, with a lower bound $L_x \le |x|$ on the true value,

$$d_x = \max(1, d + k + 2 - \lceil 0.43 L_x \rceil).$$

If you don't know the sign of $x$, use the first rule with $U_x \ge |x|$. The
factors $0.44$ and $0.43$ are $\log e \approx 0.4343$ rounded up and down.

**Example.** To get $e^{3\pi}$ good to $d = 3$ places, with $k = 2$: $3\pi < 9.5$,
so take $U_x = 9.5$. Then $\lfloor 0.44 \cdot 9.5 \rfloor = \lfloor 4.18 \rfloor = 4$,
so $3\pi$ needs $3 + 2 + 2 + 4 = 11$ places.

So $\tilde{x} = \mathrm{rnd}(3\pi, 11) = 9.42477796077$. Its exponential to
$d + k + 1 = 6$ places is $12391.647808$. The budget is $T = 10^{-5}$ and
$\eta = 5 \times 10^{-6}$, so the total error is at most
$\eta + \frac{1}{2} \cdot 10^{-6} = 5.5 \times 10^{-6} \le T$. By Lemma 1,
$\mathrm{rnd}(12391.647808, 3) = 12391.648$ is good to 3 places. (The true
value is $12391.6478079\ldots$)

**Why.** For $f(x) = e^x$, Theorem 5 gives

$$\delta^{+} = \ln(e^x + \eta) - x = \ln(1 + \eta e^{-x}), \qquad \delta^{-} = x - \ln(e^x - \eta) = -\ln(1 - \eta e^{-x}),$$

where $\delta^{-}$ is for $e^x > \eta$, and is $\infty$ otherwise. Since
$\ln(1 + u) \le -\ln(1 - u)$ for $0 \le u < 1$, the smaller one is
$\delta^{+}$, so the largest $\delta$ is

$$\delta(x) = \ln(1 + \eta e^{-x}).$$

It shrinks as $x$ grows, so the worst case is where $e^x$ is largest. Let $E$
be an upper bound on $e^x$, and $u = \eta / E$. The exact count is

$$d_x = \lceil \log c - \log\ln(1 + u) \rceil.$$

For $e^{3\pi}$ with $E = e^{9.5} \approx 13360$, that is 10, one less than the
rule.

Since $\ln(1 + u) \ge \frac{u}{1 + u}$, it is enough that

$$d_x \ge \log c - \log u + \log(1 + u) = d + k + \log(2c(E + \eta)),$$

using $\eta = T/2$, so that $2\eta = 10^{-(d+k)}$.

- **If E is at least η,** then $2c(E + \eta) \le 2.4E < 10^{\mathrm{siz}(E) + 1}$,
  so $d + k + 1 + \mathrm{siz}(E)$ is enough.
- **If E is below η,** then $d + k + \log(2c(E + \eta)) = \log(c(E + \eta)/\eta)$,
  which is less than $\log(2c) < 1$, so 1 place is enough.

So $d_x = \max(1, d + k + 1 + \mathrm{siz}(E))$ is enough for any upper bound
$E \ge e^x$. To turn this into a rule on $x$, use $\mathrm{siz}(e^a) = \lfloor a \log e \rfloor + 1$:

- **For x at least 0,** take $E = e^{U_x}$. Since $\log e < 0.44$,
  $\lfloor U_x \log e \rfloor \le \lfloor 0.44 U_x \rfloor$, which gives the
  first rule.
- **For x below 0,** $x \le -L_x$, so take $E = e^{-L_x}$. Since
  $\log e > 0.43$, $\lfloor -L_x \log e \rfloor \le \lfloor -0.43 L_x \rfloor = -\lceil 0.43 L_x \rceil$,
  which gives the second rule.

For example, $e^{-5}$ to 6 places, with $k = 2$, takes $L_x = 5$, and
$\lceil 0.43 \cdot 5 \rceil = \lceil 2.15 \rceil = 3$, so $x$ needs
$6 + 2 + 2 - 3 = 7$ places. The exact count is 6.

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

## Logarithms

**Rule.** With a lower bound $L_x \le x$ on the true value,

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
$\eta = T/2$, [Lemma 2](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#from-an-error-bound-to-decimal-places) gives

$$d_x = \left\lceil d + k + \log(2c) + \log(1 + \eta) - \log L_x \right\rceil.$$

Since $\log(2c) + \log(1 + \eta) \le \log(1.2 \times 1.5) < 1$ and
$-\log L_x \le 1 - \mathrm{siz}(L_x)$, the rule is enough.

## Sine and cosine

**Rule.** For $\sin x$ or $\cos x$,

$$d_x = d + k + 1.$$

No bounds are needed. If $x$ is exactly rounded, $d + k$ places are enough.

**Example.** For $\sin(\pi/4)$ good to $d = 6$ places, with $k = 2$, $\pi/4$
needs $6 + 2 + 1 = 9$ places.

**Why.** The derivatives of $\sin$ and $\cos$ are $\cos$ and $-\sin$, which are
at most 1 in size, so Theorem 4 gives $A = 1$. Neither can be computed exactly,
so $\eta = T/2$, and the exact count is $\lceil d + k + \log(2c) \rceil$. Since
$\log(2c) \le \log 1.2 < 1$, the rule is enough. For an exactly rounded input,
$c = \frac{1}{2}$ and $\log(2c) = 0$, so $d + k$ is enough.

Near the peaks of $\sin$, where $\cos x$ is close to 0, a smaller $A$ would do,
but the rule doesn't try to use that.

Next: [Functions by series](../2026-11-02%204%20Functions%20by%20series/README.md).

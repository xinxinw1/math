# Correct rounding

How to tell whether a computed value, rounded to $d$ places, is the true value
correctly rounded, and what to do when that can't be told.

*Xin-Xin*

This uses the notation of
[Rounding and error bounds](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md)
and the input-places docs that follow it:
$\mathrm{rnd}(x, d)$ rounds to $d$ places with ties away from zero, $k$ is the
number of guard digits, and $T = 10^{-(d+k)}$. The rules there produce a value
$\tilde{f}$ within $T$ of the true value $f$, and then round it to $d$ places.

## The problem

An error bound never guarantees that the output is $\mathrm{rnd}(f, d)$, the
true value correctly rounded. In the example from the
[2015 notes](../2015-03-17%202%20Error%20bounds%20for%20arithmetic/README.md#correct-rounding-cant-be-guaranteed),
$f = 0.4499999$ and $\tilde{f} = 0.45$ are within $10^{-6}$ of each other, but
round to $0.4$ and $0.5$. However small the error, a value close enough to a
rounding boundary can land on the wrong side of it. This is known as the
*table maker's dilemma*.

The rounding boundaries for $d$ places are the midpoints
$(n + \frac{1}{2}) \cdot 10^{-d}$ for integers $n$. Between two neighbouring
boundaries, $\mathrm{rnd}(x, d)$ is the same for every $x$.

## The check

**Lemma 1.** If $|\tilde{f} - f| \le \eta$, and $\tilde{f}$ is more than $\eta$
away from every rounding boundary, then
$\mathrm{rnd}(\tilde{f}, d) = \mathrm{rnd}(f, d)$.

**Proof.** No boundary lies in $[\tilde{f} - \eta, \tilde{f} + \eta]$, which
contains $f$. So $f$ and $\tilde{f}$ lie strictly between the same two
boundaries, and they round to the same multiple of $10^{-d}$. ∎

The check uses $\tilde{f}$ before the final rounding. After it, the value is a
multiple of $10^{-d}$, which is always exactly $\frac{1}{2} \cdot 10^{-d}$
from the nearest boundary, so the check would tell you nothing.

Usually $\eta = T$, since that is what the rules guarantee. If a better bound
is known, use it. For example, an exact product has no evaluation error, so
its propagated error bound alone will do.

To find the distance, write $\tilde{f}$ to $d + 1$ places or more and look at
the digits after place $d$. The nearest boundary is where they would read
$5000\ldots$ For $\tilde{f} = 1.7724539$ and $d = 4$, the digits after place
4 are $39$, and the nearest boundary is $1.77245$, about
$3.9 \times 10^{-6}$ away.

## When the check fails

Compute $\tilde{f}$ again with a smaller $\eta$, and check again. The simplest
way is one more guard digit, which makes $T$ ten times smaller. Every rule
asks for $d + k$ plus something, so this adds one place to every input.

The check fails only when $\tilde{f}$ is within $\eta$ of a boundary.
Boundaries are $10^{-d}$ apart, so for a value with no reason to be near one,
that happens about $2\eta \cdot 10^d = 2 \cdot 10^{-k}$ of the time: 2% with
$k = 2$, and each retry makes it 10 times rarer.

Retrying finishes unless $f$ is exactly on a boundary. Then $\tilde{f}$ can
be on either side of it, however small $\eta$ is, so cap the number of
retries.

## Exact ties

A boundary is a terminating decimal, so only a terminating decimal can be
exactly on one: one with $d + 1$ places, ending in 5, such as $0.45$ to 1
place. Values like $\pi$, $\sqrt{2}$ or $\ln 3$ never are, so for them the
retries always finish.

When $f$ might be on a boundary, no error bound short of 0 can settle which
way it rounds. Only an exact computation can. Sums, differences and products
of exact inputs can be computed exactly, and then rounding them is correct by
definition. For $\sqrt{x}$ with $x$ exact, a tie at the boundary $b$ means
$x = b^2$, which can be checked by squaring $b$. Quotients are covered by the
next lemma.

### Exact quotients

Long division truncates: it stops after $p$ places and drops the rest. For
$x, y > 0$, the truncated quotient $q$ satisfies

$$q \le \frac{x}{y} < q + 10^{-p}.$$

If $x$ and $y$ are exact, for example integers or decimals given exactly,
truncating to $d + 1$ places and then rounding is already correct, with no
guard digits and no check.

**Lemma 2.** Let $x, y > 0$, and let $q$ be $x / y$ truncated to $d + 1$
places. Then $\mathrm{rnd}(q, d) = \mathrm{rnd}(x / y, d)$.

**Proof.** The rounding boundaries for $d$ places are multiples of
$10^{-(d+1)}$, and so is $q$. Since $q \le x / y < q + 10^{-(d+1)}$, no
boundary lies strictly between $q$ and $x / y$, and a boundary at or below
$x / y$ is also at or below $q$. So $q$ and $x / y$ are on the same side of
every boundary, including when $x / y$ is exactly on one, where both round
away from zero. ∎

For negative inputs, divide $|x|$ by $|y|$ and attach the sign at the end.

For example, $22 / 7$ truncated to 4 places is $3.1428$, which rounds to
$3.143$. The true value, $3.142857\ldots$, also rounds to $3.143$. And
$1 / 8$ truncated to 3 places is $0.125$, exactly on a boundary, which rounds
to $0.13$, the correct result with ties away from zero.

The lemma relies on ties going away from zero. With round-half-to-even, a
truncated digit 5 in place $d + 1$ can't be rounded correctly without also
knowing whether the remainder is zero.

## Examples

These are the examples from
[Input places for arithmetic](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md),
[Input places for functions](../2026-11-02%203%20Input%20places%20for%20functions/README.md) and
[Functions by series](../2026-11-02%204%20Functions%20by%20series/README.md), all with $k = 2$. Each $\tilde{f}$ is the value before the final rounding.

| Example | $d$ | $\tilde{f}$ | $\eta$ | Nearest boundary | Distance | Result |
|---|---|---|---|---|---|---|
| [π times e](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md#π-times-e) | 3 | $8.53973425942286$ | $2.93 \times 10^{-7}$ | $8.5395$ | $2.3 \times 10^{-4}$ | $8.540$ |
| [π e √2](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md#products-of-more-than-two-factors) | 3 | $12.0770079295\ldots$ | $10^{-5}$ | $12.0775$ | $4.9 \times 10^{-4}$ | $12.077$ |
| [π / e](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md#division-by-truncation) | 3 | $1.155727$ | $10^{-5}$ | $1.1555$ | $2.3 \times 10^{-4}$ | $1.156$ |
| [√π](../2026-11-02%203%20Input%20places%20for%20functions/README.md#square-roots) | 4 | $1.7724539$ | $5.5 \times 10^{-7}$ | $1.77245$ | $3.9 \times 10^{-6}$ | $1.7725$ |
| [e to the 3π](../2026-11-02%203%20Input%20places%20for%20functions/README.md#exponentials) | 3 | $12391.647808$ | $5.5 \times 10^{-6}$ | $12391.6475$ | $3.1 \times 10^{-4}$ | $12391.648$ |
| [sin 100](../2026-11-02%204%20Functions%20by%20series/README.md#argument-reduction) | 6 | $-0.50636564118$ | $10^{-8}$ | $-0.5063655$ | $1.4 \times 10^{-7}$ | $-0.506366$ |
| [e to the π/4](../2026-11-02%204%20Functions%20by%20series/README.md#exponentials) | 6 | $2.193280050786$ | $10^{-8}$ | $2.1932805$ | $4.5 \times 10^{-7}$ | $2.193280$ |
| [sin(π/4)](../2026-11-02%204%20Functions%20by%20series/README.md#sine-and-cosine) | 6 | $0.7071067809$ | $10^{-8}$ | $0.7071065$ | $2.8 \times 10^{-7}$ | $0.707107$ |
| [ln 3](../2026-11-02%204%20Functions%20by%20series/README.md#logarithms) | 6 | $1.09861228866$ | $10^{-8}$ | $1.0986125$ | $2.1 \times 10^{-7}$ | $1.098612$ |

Every distance is more than $\eta$, so by Lemma 1 every result is correctly
rounded.

For a check that fails, see
[1/(e^(π√43) − 884736744)](../2026-11-03%20Precision%20for%20whole%20expressions/README.md#1eπ43--884736744-to-4-places)
in Precision for whole expressions. There $\tilde{f} = -4493.6960503$ is only
about $3 \times 10^{-7}$ from the boundary $-4493.69605$, less than
$T = 10^{-6}$. One more guard digit makes $\eta = 10^{-7}$, and the check
then passes.

# Precision for whole expressions

How to work out, automatically, how many decimal places every part of an
expression needs, so that the final result is good to a chosen number of
places.

*Xin-Xin*

This builds on the rules in
[Input places for arithmetic](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md)
and [Input places for functions](../2026-11-02%203%20Input%20places%20for%20functions/README.md),
which say how many places the inputs of one operation need. Here they are
applied to every operation in an expression at once. Notation is as in
[Rounding and error bounds](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md):
$d$ is the number of places an operation's output needs, $k$ the guard digits,
and $\mathrm{siz}$ the size of a number. Here every node has its own $d$. A
value is **good to d places** if its error is at most $c \cdot 10^{-d}$ with
$c \le 0.6$. Unlike there, it may have more than $d$ places: extra places only
make it more accurate.

The 0.6 comes from the
[definition](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#good-to-d-places)
there: a value rounded after computing it with $k$ guard digits has
$c_k = \frac{1}{2} + 10^{-k}$, which is at most 0.6 for any $k \ge 1$. Every
rule only assumes $c \le 0.6$, so the same bound covers exactly rounded
values, any choice of $k$ at each node, and values with extra places.

## Overview

The rules compose because of the
[invariant](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#the-invariant)
from Rounding and error bounds. Each operation rounds its own result to the places its
parent asked for, so its output is good to those places, which is exactly what
the parent's rule assumes of its inputs.

So the method works on the expression as a tree, in three passes:

1. **Bounds, bottom-up.** Find a cheap interval for the value of every part.
   Where a lower bound is needed and the interval contains 0, tighten it by
   evaluating that part to more places.
2. **Places, top-down.** Starting from the places wanted for the result, use each
   operation's rule to give its parts their places.
3. **Evaluate, bottom-up.** Compute every part to its places.

Then check at the top whether the result is correctly rounded.

## The expression tree

Each operation in the expression is a *node*, and its inputs are its
*children*. The leaves are:

- **Exact numbers,** such as a typed-in $0.00001$. They have no error.
- **Constants,** such as $\pi$, $e$ and $\ln 2$, which can be computed to any
  number of places.
- **Inputs** that come from elsewhere, already good to some number of places.

Two changes to the tree help:

- **Flatten sums and products.** Treat $w + x + y + z$ as one sum of 4 terms,
  not as nested pairs. Each level of nesting would cost $k + 1$ extra places,
  while a flat sum costs $k + \mathrm{siz}(n)$ once. Products flatten the same
  way.
- **Share repeated parts.** If the same subexpression or constant appears
  twice, make it one node with two parents. It is then computed once, to the
  most places either parent needs. The tree becomes a graph, with no cycles.

## Pass 1: bounds

The place rules need rough bounds on the values of the nodes, before anything
is computed precisely. This pass finds an interval $[\ell, h]$ containing the
true value of every node. It uses only two operations:

- **Cheap bounds.** A fixed, crude interval for every node, computed once.
- **Evaluation.** Passes 2 and 3 on a part of the expression, to some number
  of places $p$, when a cheap bound isn't good enough.

A value good to $p$ places is itself an interval: the true value is within
$0.6 \cdot 10^{-p}$ of it. So the only precise operation needed is the
evaluation that is needed anyway.

### Cheap bounds

Go through the nodes from the bottom up. Round the results of arithmetic
outward to 5 significant figures: lower ends down and upper ends up, so that
the true value stays inside. Use constants and function values exactly as
computed, without rounding them again.

Here $x$ is in $[\ell_x, h_x]$ and $y$ in $[\ell_y, h_y]$, or $x$ is in
$[\ell, h]$ for a function of one argument.

| Node | Cheap interval |
|---|---|
| Exact number $a$ | $[a, a]$ |
| Constant | $[c - 0.6 \cdot 10^{-5}, c + 0.6 \cdot 10^{-5}]$, where $c$ is the constant to 5 places |
| $x + y$ | $[\ell_x + \ell_y, h_x + h_y]$ |
| $x - y$ | $[\ell_x - h_y, h_x - \ell_y]$ |
| $xy$ | $[\min(\ell_x \ell_y, \ell_x h_y, h_x \ell_y, h_x h_y), \max(\ell_x \ell_y, \ell_x h_y, h_x \ell_y, h_x h_y)]$ |
| $x / y$ | $[\min(\ell_x / \ell_y, \ell_x / h_y, h_x / \ell_y, h_x / h_y), \max(\ell_x / \ell_y, \ell_x / h_y, h_x / \ell_y, h_x / h_y)]$, after [tightening](#tightening-by-evaluation) $y$ if $\ell_y \le 0 \le h_y$ |
| $x^n$, $n$ odd | $[\ell^n, h^n]$ |
| $x^n$, $n$ even | $[\min(\ell^n, h^n), \max(\ell^n, h^n)]$, or $[0, \max(\ell^n, h^n)]$ if $\ell \le 0 \le h$ |
| $\sqrt{x}$ | $[\max(0, s_1 - 0.6 \cdot 10^{-5}), s_2 + 0.6 \cdot 10^{-5}]$, where $s_1$ and $s_2$ are $\sqrt{\ell}$ and $\sqrt{h}$ to 5 places, and $s_1 = 0$ if $\ell \le 0$ |
| $e^x$ | $[10^{\lfloor p \rfloor}, 10^{\lceil q \rceil}]$, where $[p, q]$ is the product of $[\ell, h]$ and $[0.43, 0.44]$ |
| $\ln x$ | the product of $[\mathrm{siz}(\ell) - 1, \mathrm{siz}(h)]$ and $[2.30, 2.31]$, after tightening $x$ if $\ell \le 0$ |
| $\sin x$, $\cos x$ | $[-1, 1]$ |

A product of intervals is worked out as in the $xy$ row: the smallest and
largest of the four products of their ends.

#### Exact numbers and constants

An exact number has no error, so its interval is a single point. A constant
such as $\pi$, computed to 5 places, is good to 5 places, so the true value is
within $0.6 \cdot 10^{-5}$ of it. The endpoints already have only 6 places, so
there is nothing to round.

#### Sums and differences

$x + y$ is smallest when both $x$ and $y$ are, and largest when both are. $x - y$
is smallest when $x$ is smallest and $y$ is largest, and largest the other way
round.

#### Products and quotients

With $y$ fixed, $xy$ is a straight-line function of $x$, so it is largest and
smallest at the ends of $x$'s interval, and the same holds with $x$ fixed. So
the extremes over the box $[\ell_x, h_x] \times [\ell_y, h_y]$ are at its
corners, and the interval is the smallest and largest of the four corner
products.

The same holds for $x / y$ as long as $y$ keeps one sign: then $x / y$ only
goes up or only goes down in each of $x$ and $y$. If $y$'s interval contains
0, $x / y$ can be arbitrarily large, so the divisor has to be
[tightened](#tightening-by-evaluation) first.

#### Powers

For odd $n$, $x^n$ is increasing, so the ends of the interval go to the ends.
For even $n$, $x^n$ decreases for negative $x$ and increases for positive $x$.
If the interval doesn't contain 0, $x^n$ is monotonic on it, and taking the
smaller and larger of $\ell^n$ and $h^n$ handles either sign. If it contains 0,
the smallest value is $0^n = 0$, and the largest is at whichever end is
further from 0.

#### Square roots

$\sqrt{x}$ is increasing, so the interval is $[\sqrt{\ell}, \sqrt{h}]$. Its ends
are computed to 5 places, so each is within $0.6 \cdot 10^{-5}$ of the true
root, and widening each end by that much keeps the true value inside. A square
root is never negative, so the lower end is at least 0. If $\ell \le 0$, the
true $x$ can be as small as 0, so $s_1 = 0$.

#### Exponentials

$e^x$ is increasing, so the true value is in $[e^\ell, e^h]$. Instead of
computing these, write $e^x = 10^{x \log e}$. Since $\log e \approx 0.4343$ is
in $[0.43, 0.44]$, the $xy$ row puts $x \log e$ in the product of
$[\ell, h]$ and $[0.43, 0.44]$, which is $[p, q]$. Rounding $p$ down and $q$ up
to whole numbers keeps $x \log e$ inside, so $e^x$ is in
$[10^{\lfloor p \rfloor}, 10^{\lceil q \rceil}]$. A power of 10 is all the
rules need, since they mostly use sizes.

The floor and ceiling can each lose a factor of 10, and the width of
$[0.43, 0.44]$ loses a little more when $|x|$ is large.

#### Logarithms

$\ln x$ is increasing, so the true value is in $[\ln \ell, \ln h]$, which needs
$\ell > 0$. If $\ell \le 0$, tighten $x$ first. Instead of computing the
logarithms, write $\ln x = \ln 10 \cdot \log x$. Since
$\log \ell \ge \mathrm{siz}(\ell) - 1$ and $\log h < \mathrm{siz}(h)$, $\log x$ is
in $[\mathrm{siz}(\ell) - 1, \mathrm{siz}(h)]$. And $\ln 10 \approx 2.3026$ is in
$[2.30, 2.31]$. So the $xy$ row puts $\ln x$ in the product of the two
intervals.

Using sizes in place of logarithms loses up to $\ln 10 \approx 2.3$ at each
end.

#### Sine and cosine

Sines and cosines are always between $-1$ and 1. A narrower interval is
possible when $x$'s interval is short, but $[-1, 1]$ is usually enough: as
an upper bound it has size 1. A sine or cosine used as a divisor or a
logarithm argument contains 0, so it gets
[tightened](#tightening-by-evaluation) anyway.

#### How crude the bounds are

The bounds for $e^x$ and $\ln x$ are crude: they can be off by a factor of 10
or more. Most rules use an upper bound only through $\mathrm{siz}$, so there
a looser $U$ costs a place or so. Two things are more sensitive:

- **Lower bounds,** which can contain 0. See
  [Tightening by evaluation](#tightening-by-evaluation).
- **Exponents.** The exponential rule uses $h_x$ itself, not its size, so a
  loose upper bound on an exponent costs places in proportion. In $e^{e^x}$
  with $x$ in $[20.600, 20.601]$, the inner exponential's cheap interval is
  $[10^8, 10^{10}]$, and the outer rule asks for about $0.44 \cdot 10^{10}$
  places, 10 times more than needed. When an exponent's interval is wide,
  evaluate it to a few places first to narrow it.

### Tightening by evaluation

The rules need a lower bound above 0 for:

- **Divisors.** The quotient rule uses $\bar{L}_y$.
- **Logarithm arguments.** The logarithm rule uses $L_x$.

Square root arguments aren't tightened. If one's interval contains 0, the
square root rule uses $2(d + k) + 1$ places, which is what it needs anyway
when the argument is close to 0.

If a node's cheap interval contains 0 but its parent needs such a lower bound,
evaluate the node to $p = 5$ places, then 10, 20, 40, and so on, until the
interval $[\tilde{x} - 0.6 \cdot 10^{-p}, \tilde{x} + 0.6 \cdot 10^{-p}]$
excludes 0, or $p$ passes a cap, such as 80. Use that interval for the node
from then on, and carry on with the cheap pass.

The cap is needed because a node whose true value is 0, such as $\sin \pi$,
never gets an interval that excludes 0, however many places are used.
Reaching the cap means the value is 0 or within about $10^{-80}$ of it, and
more places can't tell which. Then give up and report that the divisor or
logarithm argument can't be shown to be nonzero. See
[Exact singularities](#exact-singularities).

Evaluating a node to $p$ places means running passes 2 and 3 on the part of
the expression below it, with that node as the top. Those use the bounds
already found for its descendants, which were handled first, and tighten them the same way if they
need to. So the recursion only goes down the tree, and only where a value is
close to 0.

Keep the most precise value found for every node, and reuse it later: having
more places than needed is always safe. Doubling $p$ means the trials cost
less than the last one again, and starting at 5 means most succeed at once.

### The bounds the rules use

From each node's interval $[\ell, h]$:

- **Bounds on the true value.** The upper bound $U = \max(|\ell|, |h|)$, and,
  if $0$ is not in the interval, the lower bound $L = \min(|\ell|, |h|)$.
- **Bounds that also cover the approximation.** $\bar{U} = 1.01U$ and
  $\bar{L} = 0.99L$.

The product, quotient and power rules need bounds that cover both the true
value $x$ and the computed value $\tilde{x}$. See
[Bounds before digits](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md#bounds-before-digits).
Pass 1 only bounds the true value, and $\tilde{x}$ isn't computed until pass 3.
But $\tilde{x}$ will be within its error of $x$, so widening $U$ and $L$ by a
margin also covers $\tilde{x}$, as long as that error stays inside the
margin. Pass 2 makes sure it does, by giving the node at least its
[minimum places](#minimum-places).

The 1% margin is a choice. A wider margin absorbs more error, so it needs
fewer minimum places, but it changes the sizes of the bounds more often, and
the rules use those sizes:

| Margin | $\bar{U}$ and $\bar{L}$ | Minimum places | Sizes change when $U$ or $L$ is |
|---|---|---|---|
| 10% | $1.1U$ and $0.9L$ | $2 - \mathrm{siz}(M)$ | within about 10% of a power of 10 |
| 1% | $1.01U$ and $0.99L$ | $3 - \mathrm{siz}(M)$ | within about 1% of a power of 10 |
| 0.1% | $1.001U$ and $0.999L$ | $4 - \mathrm{siz}(M)$ | within about 0.1% of a power of 10 |

Here $M$ is $L$ or $U$. $U$ is affected just below a power of 10, and $L$ just
above one. The two costs aren't equal. The minimum rarely matters, because the
rules usually ask for more places anyway. A change of size goes straight into
the rules, and for a divisor it costs 2 places, through
$-2\mathrm{siz}(\bar{L}_y)$. A small margin like 1% keeps that rare, while
the minimum stays low.

## Pass 2: places

Give the top node the places wanted for the result. Then go through the nodes
from the top down, so that every parent has made its request before a child is
handled. Each node, with its own places $d$, uses its operation's rule to ask
its children for places. A child with several parents takes the most places
any of them asks for.

### Rules for each operation

These are the rules from the input-places docs, written with the bounds from
pass 1. A node with $d$ places asks its children for:

| Node | Places for its children |
|---|---|
| Sum or difference with $n \ge 2$ inexact terms | each inexact term: $d + k + \mathrm{siz}(n)$ |
| Sum or difference with 1 inexact term | $d$ |
| Product of $n$ inexact factors | factor $i$: $d + k + \mathrm{siz}(n)$ plus the sizes of the other factors' $\bar{U}$ |
| $x / y$ | $x$: $d + k + 2 - \mathrm{siz}(\bar{L}_y)$, and $y$: $d + k + 3 + \mathrm{siz}(U_x) - 2\mathrm{siz}(\bar{L}_y)$ |
| $x^n$, $n \le 8$ | $d + k + 1 + (n - 1)\mathrm{siz}(\bar{U}_x)$ |
| $x^n$, any $n$ | $d + k + \mathrm{siz}(2n) + (n - 1)\mathrm{siz}(\bar{U}_x)$ |
| $\sqrt{x}$ | $\min(d + k - \lfloor (\mathrm{siz}(L_x) - 1)/2 \rfloor, 2(d + k) + 1)$, or $2(d + k) + 1$ if $\ell_x \le 0$ |
| $e^x$ | $d + k + 2 + \lfloor 0.44 h_x \rfloor$ if $h_x \ge 0$, and $\max(1, d + k + 2 - \lceil 0.43 \lvert h_x \rvert \rceil)$ if $h_x < 0$ |
| $\ln x$ | $d + k + 2 - \mathrm{siz}(\ell_x)$ |
| $\sin x$, $\cos x$ | $x$: $d + k + 1$, and $\pi$: $d + k + 1 + \mathrm{siz}(j)$, reducing by $j \ne 0$ quarter turns |

Notes:

- **Exact children** need nothing. An exact number with more places than asked
  for is rounded to those places, with $c = \frac{1}{2}$, but never to fewer
  than its [minimum places](#minimum-places).
- **Sums with exact terms** count only the inexact terms in $n$. Exact terms
  with at most $d$ places add no error and need no rounding. An exact term
  with more places counts as inexact, since it gets rounded.
- **A sum with one inexact term** passes that term's error straight through,
  as for $x + a$ in Input places for arithmetic, so it needs no guard digits. Pass 3 leaves
  it unrounded. The top node is the exception: it asks for $d + k + 1$, the
  general sum rule with $n = 1$, so that the
  [correct-rounding check](#correct-rounding) has its guard digits.
- **Products with one inexact factor,** such as $3x$, can use one place fewer:
  $d + k$ plus the sizes of the exact factors.
- **Exponentials** use the upper end $h_x$ of the interval, since that is where
  $e^x$ is largest.
- **Sine and cosine** take $j$ from the interval of $x / (\pi/2)$: the largest
  $|j|$ the reduction might use. If $j$ can only be 0, there is no reduction
  and no $\pi$.

### Minimum places

Some rules use a child's barred bound, $\bar{U}$ or $\bar{L}$:

- **Products** use the $\bar{U}$ of every factor but one.
- **Powers** use the $\bar{U}$ of the base.
- **Quotients** use the $\bar{L}$ of the divisor. The dividend's bound, $U_x$,
  isn't barred.

The square root, exponential and logarithm rules use unbarred bounds, so they
don't need this.

A child whose barred bound is used also needs its error to stay within the 1%
margin of [the bound](#the-bounds-the-rules-use). That holds if it has at least

$$3 - \mathrm{siz}(M)$$

places, where $M$ is $L$ for a lower bound and $U$ for an upper bound. The
parent asks for the larger of this and its rule's count. If both bounds of a
node are used, by different parents, the minimum for $L$ is the larger one,
since $L \le U$. This applies to exact children too: an exact divisor rounded
to too few places could become 0.

Why: with $d$ places, the error is at most $0.6 \cdot 10^{-d}$. With
$d \ge 3 - \mathrm{siz}(M)$, that is at most $0.6 \cdot 10^{\mathrm{siz}(M) - 3}$,
and since $M \ge 10^{\mathrm{siz}(M) - 1}$, it is under $0.01M$. Then
$|\tilde{x}| \ge 0.99L = \bar{L}$ and $|\tilde{x}| \le 1.01U = \bar{U}$. The
same argument with a margin of $10^{-m}$ gives $m + 1 - \mathrm{siz}(M)$ places,
which is where the other rows of the margin table come from.

Usually the rule already asks for more. The minimum matters when the other
operand is very small. For example, take $10^{-20} / y$ with $y$ in
$[0.9 \cdot 10^{-5}, 1.1 \cdot 10^{-5}]$ and $d = 2$. Then $L_y$ and
$\bar{L}_y$ both have size $-5$, and the quotient rule asks $y$ for
$2 + 2 + 3 - 19 + 10 = -2$ places, which would round $y$ to 0. The minimum
asks for $3 - (-5) = 8$.

## Pass 3: evaluate

Go through the nodes from the bottom up. Each node computes its value from its
children's values, and rounds it to its own places $d$:

- **Exact operations,** sums, differences and products, are computed exactly
  and then rounded. A sum with one inexact term, other than the top, isn't
  rounded.
- **Other operations** are computed to $d + k + 1$ places, rounded or cut off,
  and then rounded to $d$. This covers division by the usual truncating
  algorithm, and functions by
  [series](../2026-11-02%204%20Functions%20by%20series/README.md#the-series-rule).
  The series need small arguments, so reduce first:
  [by quarter turns](../2026-11-02%204%20Functions%20by%20series/README.md#argument-reduction) for sine and cosine, and
  [with repeated squaring](../2026-11-02%204%20Functions%20by%20series/README.md#exponentials) for exponentials.

Keeping more places than a node was given is always safe, so an implementation
can skip the rounding of inner nodes if that is easier. Only the top node must
be rounded to $d$.

Why it works: the leaves are good to their places. If a node's children are
good to the places it asked for, its rule guarantees that its computed value
is within $10^{-(d+k)}$ of the true value, and rounding to $d$ places then
makes it good to $d$ places. A sum with one inexact term is the exception: it
isn't rounded, so its error is the term's, at most $0.6 \cdot 10^{-d}$. So by
induction, from the leaves up, the top node is good to $d$ places.

### Correct rounding

The result is good to $d$ places, but that doesn't make it the correctly
rounded value. Check it as in
[Correct rounding](../2026-11-03%20Correct%20rounding/README.md#the-check),
before the final rounding: if the top node's computed value is more than
$10^{-(d+k)}$ from the nearest rounding boundary, rounding it to $d$ places is
correct.

If the check fails, which is rare, run passes 2 and 3 again with one more
guard digit for the top node only. Most rules ask for $d$ plus a constant,
so this adds about one place to every node below the top. Raising $k$
everywhere would instead add one place per level. Cap the retries, because a
result exactly on a boundary never passes. See [Exact ties](#exact-ties).

## Examples

### (π + e)/√2 to 4 places

Take $d = 4$ and $k = 2$.

**Bounds.** $\pi$ is in $[3.141584, 3.141596]$ and $e$ in
$[2.718274, 2.718286]$, so $\pi + e$ is in $[5.8598, 5.8599]$. $\sqrt{2}$ to 5
places is $1.41421$, so $\sqrt{2}$ is in $[1.414204, 1.414216]$. No divisor's
interval contains 0, so nothing needs tightening. The bounds used are
$U = 5.8599$ for $\pi + e$, of size 1, and
$\bar{L} = 0.99 \cdot 1.414204 = 1.40006\ldots$ for $\sqrt{2}$, also of size 1.

**Places.**

| Node | Asks | For |
|---|---|---|
| $(\pi + e)/\sqrt{2}$, with 4 places | $4 + 2 + 2 - 1 = 7$ | $\pi + e$ |
| | $4 + 2 + 3 + 1 - 2 = 8$ | $\sqrt{2}$ |
| $\pi + e$, with 7 places | $7 + 2 + 1 = 10$ | each of $\pi$ and $e$ |
| $\sqrt{2}$, with 8 places | $8 + 2 - 0 = 10$ | $2$, which is exact |

The minimum places for $\sqrt{2}$, $3 - 1 = 2$, are well below 8.

**Evaluate.**

- $\pi + e$: $3.1415926536 + 2.7182818285 = 5.8598744821$, rounded to 7 places:
  $5.8598745$.
- $\sqrt{2}$ to $8 + 2 + 1 = 11$ places, rounded to 8: $1.41421356$.
- The quotient cut off at $4 + 2 + 1 = 7$ places: $4.1435570$.

It is about $7 \times 10^{-6}$ from the nearest rounding boundary, $4.14355$,
more than $10^{-(4+2)} = 10^{-6}$, so rounding it gives the correctly rounded
result, $4.1436$. The true value is $4.14355698\ldots$

### 1/sin(π − 0.00001) to 4 places

This is close to $1/0$, since $\sin(\pi - 0.00001) = \sin(0.00001) \approx 10^{-5}$.
Take $d = 4$ and $k = 2$.

**Bounds.** The cheap bound for the sine is $[-1, 1]$. It contains 0, and the
sine is a divisor, so tighten it: evaluate $\sin(\pi - 0.00001)$ to 5 places.
That gives $0.00001$, so the sine is in $[0.000004, 0.000016]$, which excludes
0 at the first try. So $\bar{L} = 0.99 \cdot 0.000004$, of size $-5$. The
argument's cheap interval is $[3.141574, 3.141586]$, about 2 quarter turns, so
$j = 2$.

**Places.**

| Node | Asks | For |
|---|---|---|
| $1/\sin(\ldots)$, with 4 places | $4 + 2 + 3 + 1 + 10 = 20$ | the sine |
| $\sin(\ldots)$, with 20 places | $20 + 2 + 1 = 23$ | its argument |
| | $23 + \mathrm{siz}(2) = 24$ | $\pi$, for the reduction |
| $\pi - 0.00001$, with 23 places | $23$, since $0.00001$ is exact | $\pi$ |

$\pi$ has two parents, asking for 24 and 23 places, so it gets 24. The extra
10 places at the top come from $-2\mathrm{siz}(\bar{L})$: the derivative of
$1/y$ is $-1/y^2$, about $10^{10}$ here, so the rules are charging for how
sensitive the expression really is.

**Evaluate.** The argument is $\tilde{\pi} - 0.00001$, with 24 places. It has
one inexact term, so it isn't rounded to 23. The reduction by
$j = 2$ quarter turns gives $r \approx -0.00001$, and since $j$ is 2 more than a
multiple of 4, $\sin x = -\sin r \approx 0.0000099999999998333$. The quotient
rounds to $100000.0000$. The true value is $100000.0000016667\ldots$

Because $\pi$ is one shared node, both uses get the same $\tilde{\pi}$, and they
cancel exactly in the reduction: $r$ comes out as exactly $-0.00001$. Had the
argument been rounded to 23 places, $r$ would be off by about
$3 \times 10^{-24}$, still well within what the sine asked for. The rules
don't know about that cancellation, so they ask for more places than needed,
but never fewer.

### 1/(e^(π√43) − 884736744) to 4 places

$e^{\pi\sqrt{43}} = 884736743.99977746\ldots$ is very close to a whole number,
so the divisor is about $-0.00022253$, and 12 digits cancel in the subtraction.
Take $d = 4$ and $k = 2$.

**Bounds.** From the bottom up:

| Node | Cheap interval |
|---|---|
| $\pi$ | $[3.141584, 3.141596]$ |
| $\sqrt{43}$, which is $6.55744$ to 5 places | $[6.557434, 6.557446]$ |
| $x = \pi\sqrt{43}$ | $[20.600, 20.601]$ |
| $E = e^x$ | $x \log e$ is in $[20.600, 20.601] \cdot [0.43, 0.44] = [8.858, 9.06444]$, so $E$ is in $[10^8, 10^{10}]$ |
| $y = E - 884736744$ | contains 0 |

$y$ is a divisor, so tighten it. Evaluating $y$ to 5 places needs no bounds on
the terms of the difference, and the rest of its place counts come from the
cheap bounds below it. That gives $-0.00022$, so $y$ is in
$[-0.000226, -0.000214]$, which excludes 0 at the first try. So
$\bar{L} = 0.99 \cdot 0.000214$, of size $-3$.

**Places.** Using the upper bounds $h_x = 20.601$, $\bar{U} = 6.62$ for
$\sqrt{43}$ and $\bar{U} = 3.17$ for $\pi$:

| Node | Asks | For |
|---|---|---|
| $1/y$, with 4 places | $4 + 2 + 3 + 1 + 6 = 16$ | $y$ |
| $y$, with 16 places | $16$, since $884736744$ is exact | $E$ |
| $E$, with 16 places | $16 + 2 + 2 + \lfloor 0.44 \cdot 20.601 \rfloor = 29$ | $x$ |
| $x$, with 29 places | $29 + 2 + 1 + 1 = 33$ | each of $\pi$ and $\sqrt{43}$ |

**Evaluate.** $E$ comes out as $884736743.9997774660349067$, $y$ as
$-0.0002225339650933$, and the quotient as $-4493.6960503\ldots$ That rounds
to $-4493.6961$, which is correct, but it is only about $3.1 \times 10^{-7}$
from the rounding boundary $-4493.69605$, less than $10^{-6}$, so the
correct-rounding check fails.

Running passes 2 and 3 again with $k = 3$ for the top node asks $y$ for 17
places, $E$ for 17, $x$ for 30, and $\pi$ and $\sqrt{43}$ for 34: one more
place each. The check then needs a distance above $10^{-7}$, and passes.

## Corner cases

### Exact singularities

For $1/\sin(\pi)$, tightening never excludes 0 from the sine's interval, and
the [cap on p](#tightening-by-evaluation) stops it with an error. No numeric
method can tell a true zero from a very small number. Symbolic simplification
can catch some cases, such as $\sin(\pi) = 0$, before the passes start.

### Exact ties

If the true result is exactly on a rounding boundary, such as $0.45$ to 1
place, the correct-rounding check never passes. Cap the retries. With exact
inputs, exact arithmetic can settle it: see
[Exact ties](../2026-11-03%20Correct%20rounding/README.md#exact-ties) in
Correct rounding. Otherwise, report the result as good to $d$ places.

### Zero bounds

A node whose interval is $[0, 0]$, such as a product with an exact factor 0,
has $U = 0$, and $\mathrm{siz}(0)$ is undefined. When pass 1 finds such a node,
replace it with an exact 0.

### Deep expressions

Each level of the tree adds about $k + 1$ places, so deep expressions need many
places near the leaves. Flattening sums and products helps. So does using
$k = 1$ for inner nodes: every rule holds for any $k \ge 1$, since the rules
only assume $c \le 0.6$. Keep a larger $k$ only at the top.

### Cancellation the rules can't see

As in the second example, the rules treat every input as independent, so they
can't see that two errors cancel. The result is still right, just with more
places than needed. Sharing repeated constants and subexpressions, or
rewriting symbolically first, such as $\sin(\pi - a) = \sin a$, can avoid the
extra work.

## Outline of an implementation

```python
from decimal import Decimal


def precision_for(expr, wanted, k=2, retries=5):
    graph = flatten_and_share(expr)          # flatten sums/products, merge repeats
    intervals, best = {}, {}                 # best: most precise value per node

    # Pass 1: cheap bounds, tightening where a lower bound is needed
    for node in graph.bottom_up():
        for child in node.children_needing_lower_bound():  # divisors, log args
            if contains_zero(intervals[child]):
                intervals[child] = tighten(child, intervals, best, k)
        intervals[node] = cheap_bounds(node, intervals)  # 5 figures, outward
        if intervals[node] == (0, 0):
            node.replace_with_exact_zero()

    # Passes 2 and 3, with one more guard digit at the top on each retry
    for k_top in range(k, k + retries + 1):
        value = evaluate(graph.root, wanted, intervals, best, k, k_top)
        if distance_to_boundary(value, wanted) > Decimal(10) ** -(wanted + k_top):
            return rnd(value, wanted), True       # correctly rounded
    return rnd(value, wanted), False         # good to wanted places only


def tighten(node, intervals, best, k):
    p = 5
    while p <= 80:
        v = evaluate(node, p, intervals, best, k, k)
        w = Decimal(6).scaleb(-(p + 1))      # 0.6 * 10^-p
        if v - w > 0 or v + w < 0:
            return (v - w, v + w)
        p *= 2
    raise ValueError(f"can't show {node} is nonzero")


def evaluate(top, top_places, intervals, best, k, k_top):
    # Pass 2: places, parents before children
    places = {top: top_places}
    for node in top.top_down():
        d = places[node]
        is_top = node is top
        rule = rule_for(node, is_top)        # a sum with one inexact term uses
                                             # the n = 1 sum rule at the top
        for child, wanted in rule.child_places(d, k_top if is_top else k, intervals):
            wanted = max(wanted, minimum_places(node, child, intervals))
            places[child] = max(places.get(child, wanted), wanted)

    # Pass 3: evaluate, children before parents
    for node in top.bottom_up():
        d = places[node]
        is_top = node is top
        # Inner nodes must be good to d places. The top must be within
        # 10^-(d + k_top) for the check, which being good to d + k_top ensures.
        needed = d + k_top if is_top else d
        if node in best and best[node].places >= needed:
            continue                                   # reuse a better value
        if node.is_exact_op():
            v = node.compute_exactly(best)
        else:
            v = node.compute_to(best, d + (k_top if is_top else k) + 1)  # truncating is fine
        if is_top:
            good_to = d + k_top - 1      # within 10^-(d + k_top) = 0.1 * 10^-(d + k_top - 1)
        else:
            good_to = d
            if not node.is_sum_with_one_inexact_term():
                v = rnd(v, d)
        best[node] = Value(v, places=good_to)
    return best[top].value
```

`rule_for(node, is_top).child_places` is the table in
[Rules for each operation](#rules-for-each-operation), and `minimum_places`
is the rule in [Minimum places](#minimum-places).

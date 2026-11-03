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
a value is
[good to d places](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#good-to-d-places)
if it is within $10^{-d}$ of the true value, however many places it has, and
$\mathrm{siz}$ is the size of a number. Here every node has its own places
$d$: its value has to be good to $d$ places.

## Overview

The rules compose because of the
[invariant](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#the-invariant)
from Rounding and error bounds. Each operation computes its result good to
the places its parent asked for, which is exactly what the parent's rule
assumes of its inputs. Nothing has to be rounded along the way.

So the method works on the expression as a tree, in three passes:

1. **Bounds, bottom-up.** Find a cheap interval for the value of every part.
   Where a lower bound is needed and the interval contains 0, tighten it by
   evaluating that part to more places.
2. **Places, top-down.** Starting from the places wanted for the result, use each
   operation's rule to give its parts their places.
3. **Evaluate, bottom-up.** Compute every part to its places.

Then round the result to the places wanted, and check whether it is
correctly rounded.

## The expression tree

Each operation in the expression is a *node*, and its inputs are its
*children*. The leaves are:

- **Exact numbers,** such as a typed-in $0.00001$. They have no error.
- **Constants,** such as $\pi$, $e$ and $\ln 2$, which can be computed to any
  number of places.
- **Inputs** that come from elsewhere, already good to some number of places.

Two changes to the tree help:

- **Flatten sums and products.** Treat $w + x + y + z$ as one sum of 4 terms,
  not as nested pairs. Each level of nesting would cost a place, for
  $\mathrm{siz}(2)$, while a flat sum costs $\mathrm{siz}(n)$ once. Products
  flatten the same way.
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
$10^{-p}$ of it. So the only precise operation needed is the
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
| Constant | $[c - 10^{-5}, c + 10^{-5}]$, where $c$ is the constant to 5 places |
| $x + y$ | $[\ell_x + \ell_y, h_x + h_y]$ |
| $x - y$ | $[\ell_x - h_y, h_x - \ell_y]$ |
| $xy$ | $[\min(\ell_x \ell_y, \ell_x h_y, h_x \ell_y, h_x h_y), \max(\ell_x \ell_y, \ell_x h_y, h_x \ell_y, h_x h_y)]$ |
| $x / y$ | $[\min(\ell_x / \ell_y, \ell_x / h_y, h_x / \ell_y, h_x / h_y), \max(\ell_x / \ell_y, \ell_x / h_y, h_x / \ell_y, h_x / h_y)]$, after [tightening](#tightening-by-evaluation) $y$ if $\ell_y \le 0 \le h_y$ |
| $x^n$, $n$ odd | $[\ell^n, h^n]$ |
| $x^n$, $n$ even | $[\min(\ell^n, h^n), \max(\ell^n, h^n)]$, or $[0, \max(\ell^n, h^n)]$ if $\ell \le 0 \le h$ |
| $\sqrt{x}$ | $[\max(0, s_1 - 10^{-5}), s_2 + 10^{-5}]$, where $s_1$ and $s_2$ are $\sqrt{\ell}$ and $\sqrt{h}$ to 5 places, and $s_1 = 0$ if $\ell \le 0$ |
| $e^x$ | $[10^{\lfloor p \rfloor}, 10^{\lceil q \rceil}]$, where $[p, q]$ is the product of $[\ell, h]$ and $[0.43, 0.44]$ |
| $\ln x$ | the product of $[\mathrm{siz}(\ell) - 1, \mathrm{siz}(h)]$ and $[2.30, 2.31]$, after tightening $x$ if $\ell \le 0$ |
| $\sin x$, $\cos x$ | $[-1, 1]$ |

A product of intervals is worked out as in the $xy$ row: the smallest and
largest of the four products of their ends.

#### Exact numbers and constants

An exact number has no error, so its interval is a single point. A constant
such as $\pi$, computed to 5 places, is good to 5 places, so the true value is
within $10^{-5}$ of it. The endpoints already have only 5 places, so there is
nothing to round.

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
are computed to 5 places, so each is within $10^{-5}$ of the true
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

- **Divisors.** The quotient and reciprocal rules use a lower bound on the
  divisor.
- **Logarithm arguments.** The logarithm rule uses $L_x$.

Square root arguments aren't tightened. If one's interval contains 0, the
square root rule uses $2d + 1$ places, which is what it needs anyway
when the argument is close to 0.

If a node's cheap interval contains 0 but its parent needs such a lower bound,
evaluate the node to $p = 5$ places, then 10, 20, 40, and so on, until the
interval $[\tilde{x} - 10^{-p}, \tilde{x} + 10^{-p}]$
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

From each node's interval $[\ell, h]$, take the upper bound
$U = \max(|\ell|, |h|)$, and, if $0$ is not in the interval, the lower bound
$L = \min(|\ell|, |h|)$. These bound the true value. The product, quotient and
power rules widen them to $1.01U$ and $0.99L$ to cover the computed value
too, and add a minimum number of places, as explained in
[Covering the approximation](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md#covering-the-approximation).

## Pass 2: places

To round the result to $r$ places, give the top node $d = r + 2$ places, for
2 guard digits, as in
[Rounding and error bounds](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#the-invariant).
Then go through the nodes
from the top down, so that every parent has made its request before a child is
handled. Each node, with its own places $d$, uses its operation's rule to ask
its children for places. A child with several parents takes the most places
any of them asks for.

### Rules for each operation

These are the rules from the input-places docs, written with the bounds from
pass 1. For a child $x$, $U_x$ and $L_x$ are its bounds from
[The bounds the rules use](#the-bounds-the-rules-use): $U_x \ge |x|$, and
$L_x \le |x|$, which exists only when $x$'s interval doesn't contain 0. The
exponential rule uses $h_x$, the upper end of $x$'s interval, instead, since
the sign of $x$ matters there. A node with $d$ places asks its children for:

| Node | Places for its children |
|---|---|
| Sum or difference with $n \ge 2$ inexact terms | each inexact term: $d + \mathrm{siz}(n)$ |
| Sum or difference with 1 inexact term | $d$ |
| Product of $n$ inexact factors | factor $i$: $\max\left(d + \mathrm{siz}(n) + \sum_{j \ne i} \mathrm{siz}(1.01U_j), 3 - \mathrm{siz}(U_i)\right)$ |
| $x / y$ | $x$: $d + 2 - \mathrm{siz}(0.99L_y)$, and $y$: $\max(d + 3 + \mathrm{siz}(U_x) - 2\mathrm{siz}(0.99L_y), 3 - \mathrm{siz}(L_y))$ |
| $1/x$ | $\max(d + 3 - 2\mathrm{siz}(L_x), 2 - \mathrm{siz}(L_x))$ |
| $x^n$, $n \le 5$ | $\max(d + 1 + (n - 1)\mathrm{siz}(1.01U_x), 3 - \mathrm{siz}(U_x))$ |
| $x^n$, any $n$ | $\max(d + \mathrm{siz}(2n) + (n - 1)\mathrm{siz}(1.01U_x), 3 - \mathrm{siz}(U_x))$ |
| $\sqrt{x}$ | $\min(d + 1 - \lfloor \mathrm{siz}(L_x)/2 \rfloor, 2d + 1)$, or $2d + 1$ if there is no $L_x$ |
| $e^x$ | $d + 2 + \lfloor 0.44 h_x \rfloor$ if $h_x \ge 0$, and $\max(1, d + 2 - \lceil 0.43 \lvert h_x \rvert \rceil)$ if $h_x < 0$ |
| $\ln x$ | $d + 2 - \mathrm{siz}(L_x)$ |
| $\sin x$, $\cos x$ | $d + 1$ |

Notes:

- **Exact children** need nothing, except the
  [minimum places](../2026-11-02%202%20Input%20places%20for%20arithmetic/README.md#covering-the-approximation) in the product,
  quotient and power rules: an exact divisor rounded to too few places could
  become 0. An exact number with more places than asked for can be kept as it
  is, or rounded to those places, with $c = \frac{1}{2}$.
- **Sums with exact terms** count only the inexact terms in $n$. Exact terms
  add no error, as long as they aren't rounded.
- **A sum with one inexact term** passes that term's error straight through,
  as for $x + a$ in Input places for arithmetic, so the term needs only $d$
  places.
- **A quotient whose dividend is exactly 1** uses the reciprocal rule, which
  asks for one place fewer.
- **Products with one inexact factor,** such as $3x$, can use one place fewer:
  $d$ plus the sizes of the exact factors.
- **Exponentials** use the upper end $h_x$ of the interval, since that is where
  $e^x$ is largest.

## Pass 3: evaluate

Go through the nodes from the bottom up. Each node computes its value from its
children's values, good to its own places $d$:

- **Exact operations,** sums, differences and products, are computed exactly,
  and kept that way.
- **Other operations** are computed to $d + 1$ places, rounded or cut off.
  This covers division by the usual truncating algorithm, and functions by
  series, as in
  [Functions by series](../2026-11-02%204%20Functions%20by%20series/README.md).

Nothing is rounded to $d$ places. Rounding would add up to
$\frac{1}{2} \cdot 10^{-d}$ of error that the rules haven't budgeted for. To
keep a long exact product short, plan it in pass 2 as if it needed $d + 1$
places, then round it to $d$ places. By
[Lemma 1](../2026-11-02%201%20Rounding%20and%20error%20bounds/README.md#the-invariant),
it is still good to $d$ places.

Why it works: the leaves are good to their places. If a node's children are
good to the places it asked for, its rule guarantees that its computed value
is within $10^{-d}$ of the true value, which is what good to $d$ places means.
So by induction, from the leaves up, the top node is good to its $d$ places.
Finally, round it to $r$ places. By Lemma 1 its error is then at most
$\frac{1}{2} \cdot 10^{-r} + 10^{-d}$.

### Correct rounding

The error bound doesn't make the result the correctly rounded value. Check it
as in [Correct rounding](../2026-11-03%20Correct%20rounding/README.md#the-check),
before the final rounding: if the top node's computed value is more than
$10^{-d}$ from the nearest rounding boundary for $r$ places, rounding it to
$r$ places is correct.

If the check fails, which is rare, run passes 2 and 3 again with one more
place for the top node, $d + 1$. Most rules ask for $d$ plus a constant, so
this adds about one place to every node. Cap the retries, because a result
exactly on a boundary never passes. See [Exact ties](#exact-ties).

## Examples

### (π + e)/√2 to 4 places

Take $d = 6$ for the top node: 2 guard digits for rounding to 4 places.

**Bounds.** $\pi$ is in $[3.14158, 3.14160]$ and $e$ in
$[2.71827, 2.71829]$, so $\pi + e$ is in $[5.8598, 5.8599]$. $\sqrt{2}$ to 5
places is $1.41421$, so $\sqrt{2}$ is in $[1.41420, 1.41422]$. No divisor's
interval contains 0, so nothing needs tightening. The bounds used are
$U = 5.8599$ for $\pi + e$, of size 1, and
$0.99L = 0.99 \cdot 1.41420 = 1.40005\ldots$ for $\sqrt{2}$, also of size 1.

**Places.**

| Node | Asks | For |
|---|---|---|
| $(\pi + e)/\sqrt{2}$, with 6 places | $6 + 2 - 1 = 7$ | $\pi + e$ |
| | $6 + 3 + 1 - 2 = 8$ | $\sqrt{2}$ |
| $\pi + e$, with 7 places | $7 + 1 = 8$ | each of $\pi$ and $e$ |
| $\sqrt{2}$, with 8 places | nothing | $2$, which is exact |

The minimum places for $\sqrt{2}$ as a divisor, $3 - 1 = 2$, are well below
8.

**Evaluate.**

- $\pi + e$: $3.14159265 + 2.71828183 = 5.85987448$, exactly.
- $\sqrt{2}$ to $8 + 1 = 9$ places: $1.414213562$.
- The quotient cut off at $6 + 1 = 7$ places: $4.1435569$.

It is about $6.9 \times 10^{-6}$ from the nearest rounding boundary,
$4.14355$, more than $10^{-6}$, so rounding it gives the correctly rounded
result, $4.1436$. The true value is $4.14355698\ldots$

If every node rounded its result with 2 guard digits, as in the 2015 notes,
$\pi$ and $e$ would need 10 places each here, instead of 8.

### 1/sin(π − 0.00001) to 4 places

This is close to $1/0$, since $\sin(\pi - 0.00001) = \sin(0.00001) \approx 10^{-5}$.
Take $d = 6$ for the top node.

**Bounds.** The cheap bound for the sine is $[-1, 1]$. It contains 0, and the
sine is a divisor, so tighten it. Evaluated to 5 places, the sine comes out
as $0.000010$, so it is in $[0, 0.00002]$, which doesn't exclude 0. Evaluated
to 10 places, it is $0.00001000000$, so it is in
$[0.0000099999, 0.0000100001]$. So $L = 0.0000099999$, of size $-5$.

**Places.**

| Node | Asks | For |
|---|---|---|
| $1/\sin(\ldots)$, with 6 places | $\max(6 + 3 + 10, 2 + 5) = 19$ | the sine |
| $\sin(\ldots)$, with 19 places | $19 + 1 = 20$ | its argument |
| $\pi - 0.00001$, with 20 places | $20$, since $0.00001$ is exact | $\pi$ |

The extra 10 places at the top come from $-2\mathrm{siz}(L)$: the derivative of
$1/y$ is $-1/y^2$, about $10^{10}$ here, so the rules are charging for how
sensitive the expression really is.

**Evaluate.** The argument is $\tilde{\pi} - 0.00001$, with $\pi$ to 20 places.
Its sine, to $19 + 1 = 20$ places, is $0.00000999999999983334$. The
reciprocal, cut off at $6 + 1 = 7$ places, is $100000.0000016$, which rounds
to $100000.0000$. The true value is $100000.0000016667\ldots$

### 1/(e^(π√43) − 884736744) to 4 places

$e^{\pi\sqrt{43}} = 884736743.99977746\ldots$ is very close to a whole number,
so the divisor is about $-0.00022253$, and 12 digits cancel in the subtraction.
Take $d = 6$ for the top node.

**Bounds.** From the bottom up:

| Node | Cheap interval |
|---|---|
| $\pi$ | $[3.14158, 3.14160]$ |
| $\sqrt{43}$, which is $6.55744$ to 5 places | $[6.55743, 6.55745]$ |
| $x = \pi\sqrt{43}$ | $[20.600, 20.601]$ |
| $E = e^x$ | $x \log e$ is in $[20.600, 20.601] \cdot [0.43, 0.44] = [8.858, 9.06444]$, so $E$ is in $[10^8, 10^{10}]$ |
| $y = E - 884736744$ | contains 0 |

$y$ is a divisor, so tighten it. Evaluating $y$ to 5 places needs no bounds on
the terms of the difference, and the rest of its place counts come from the
cheap bounds below it. That gives $-0.000223$, so $y$ is in
$[-0.000233, -0.000213]$, which excludes 0 at the first try. So
$L = 0.000213$, of size $-3$.

**Places.** Using the upper bounds $h_x = 20.601$, $1.01U = 6.62$ for
$\sqrt{43}$ and $1.01U = 3.17$ for $\pi$:

| Node | Asks | For |
|---|---|---|
| $1/y$, with 6 places | $\max(6 + 3 + 6, 2 + 3) = 15$ | $y$ |
| $y$, with 15 places | $15$, since $884736744$ is exact | $E$ |
| $E$, with 15 places | $15 + 2 + \lfloor 0.44 \cdot 20.601 \rfloor = 26$ | $x$ |
| $x$, with 26 places | $26 + 1 + 1 = 28$ | each of $\pi$ and $\sqrt{43}$ |

**Evaluate.** $E$ comes out as $884736743.9997774660349067$, $y$ as
$-0.0002225339650933$, and the reciprocal, cut off at 7 places, as
$-4493.6960503$. That rounds to $-4493.6961$, which is correct, but it is only
about $3 \times 10^{-7}$ from the rounding boundary $-4493.69605$, less than
$10^{-6}$, so the correct-rounding check fails.

Running passes 2 and 3 again with $d = 7$ for the top node asks $y$ for 16
places, $E$ for 16, $x$ for 27, and $\pi$ and $\sqrt{43}$ for 29: one more
place each. The reciprocal, cut off at 8 places, is $-4493.69605031$, about
$3.1 \times 10^{-7}$ from the boundary. The check now needs a distance above
$10^{-7}$, so it passes.

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
Correct rounding. Otherwise, report the rounded result with its error bound,
$\frac{1}{2} \cdot 10^{-r} + 10^{-d}$.

### Zero bounds

A node whose interval is $[0, 0]$, such as a product with an exact factor 0,
has $U = 0$, and $\mathrm{siz}(0)$ is undefined. When pass 1 finds such a node,
replace it with an exact 0.

### Deep expressions

Each level of the tree adds the places its rule asks for beyond its own $d$:
1 for a sum of 2 terms or a sine, and more for products, quotients and
exponentials with large bounds, or divisors with small ones. So deep
expressions still need more places near the leaves. Flattening sums and
products helps. Guard digits don't add to this: they are only used once, at
the top.

### Cancellation the rules can't see

The rules treat every input as independent, so they can't see that two errors
cancel, as in $(x + 1) - x$, where the error in $x$ drops out. The result is
still right, just with more places than needed. Sharing repeated
subexpressions, or rewriting symbolically first, such as
$(x + 1) - x = 1$ or $\sin(\pi - a) = \sin a$, can avoid the extra work.

## Outline of an implementation

```python
from decimal import Decimal


def precision_for(expr, wanted, guard=2, retries=5):
    graph = flatten_and_share(expr)          # flatten sums/products, merge repeats
    intervals, best = {}, {}                 # best: most precise value per node

    # Pass 1: cheap bounds, tightening where a lower bound is needed
    for node in graph.bottom_up():
        for child in node.children_needing_lower_bound():  # divisors, log args
            if contains_zero(intervals[child]):
                intervals[child] = tighten(child, intervals, best)
        intervals[node] = cheap_bounds(node, intervals)  # 5 figures, outward
        if intervals[node] == (0, 0):
            node.replace_with_exact_zero()

    # Passes 2 and 3, with one more guard digit at the top on each retry
    for d in range(wanted + guard, wanted + guard + retries + 1):
        value = evaluate(graph.root, d, intervals, best)
        if distance_to_boundary(value, wanted) > Decimal(10) ** -d:
            return rnd(value, wanted), True       # correctly rounded
    return rnd(value, wanted), False         # error at most 10^-wanted / 2 + 10^-d


def tighten(node, intervals, best):
    p = 5
    while p <= 80:
        v = evaluate(node, p, intervals, best)
        w = Decimal(10) ** -p                # v is good to p places
        if v - w > 0 or v + w < 0:
            return (v - w, v + w)
        p *= 2
    raise ValueError(f"can't show {node} is nonzero")


def evaluate(top, top_places, intervals, best):
    # Pass 2: places, parents before children
    places = {top: top_places}
    for node in top.top_down():
        for child, wanted in rule_for(node).child_places(places[node], intervals):
            places[child] = max(places.get(child, wanted), wanted)

    # Pass 3: evaluate, children before parents. Each value only has to be
    # good to its own places, so nothing needs rounding.
    for node in top.bottom_up():
        d = places[node]
        if node in best and best[node].places >= d:
            continue                                   # reuse a better value
        if node.is_exact_op():
            v = node.compute_exactly(best)
        else:
            v = node.compute_to(best, d + 1)           # truncating is fine
        best[node] = Value(v, places=d)
    return best[top].value
```

`rule_for(node, is_top).child_places` is the table in
[Rules for each operation](#rules-for-each-operation), including the minimum
places.

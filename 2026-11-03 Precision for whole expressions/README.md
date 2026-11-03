# Precision for whole expressions

How to work out, automatically, how many decimal places every part of an
expression needs, so that the final result is good to a chosen number of
places.

*Xin-Xin*

This builds on the rules in
[Rounding and error bounds](../2026-11-02%20Rounding%20and%20error%20bounds/README.md),
which say how many places the inputs of one operation need. Here they are
applied to every operation in an expression at once. Notation is as there:
$d$ is the output places, $k$ the guard digits, $\mathrm{siz}$ the size of a
number, and a value is *good to $d$ places* if its error is at most
$c \cdot 10^{-d}$ with $c \le 0.6$.

## Overview

The rules compose because of the
[invariant](../2026-11-02%20Rounding%20and%20error%20bounds/README.md#the-invariant)
from the rules doc. Each operation rounds its own result to the places its
parent asked for, so its output is good to those places, which is exactly what
the parent's rule assumes of its inputs.

So the method works on the expression as a tree, in three passes:

1. **Bounds, bottom-up.** Find a rough interval for the value of every part,
   refining until the intervals are good enough.
2. **Places, top-down.** Starting from the $d$ wanted at the top, use each
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

- **Flatten sums and products.** Treat $a + b + c + d$ as one sum of 4 terms,
  not as nested pairs. Each level of nesting would cost $k + 1$ extra places,
  while a flat sum costs $k + \mathrm{siz}(n)$ once. Products flatten the same
  way.
- **Share repeated parts.** If the same subexpression or constant appears
  twice, make it one node with two parents. It is then computed once, to the
  most places either parent needs. The tree becomes a graph, with no cycles.

## Pass 1: bounds

The place rules need rough bounds on the values of the nodes, before anything
is computed precisely. This pass finds an interval $[\ell, h]$ containing the
true value of every node, using *interval arithmetic*.

### Interval arithmetic

Work to $s$ significant figures, and always round outward: lower ends down and
upper ends up, so that the true value stays inside.

| Operation | Interval |
|---|---|
| $x + y$, $x - y$ | add or subtract the matching ends |
| $xy$ | the smallest and largest of the four products of ends |
| $x / y$ | $x$ times $[1/h_y, 1/\ell_y]$, if $0$ is not in $y$'s interval |
| $x^n$ | each end raised to the power $n$, and $0$ if $n$ is even and the interval contains $0$ |
| $\sqrt{x}$, $e^x$, $\ln x$ | the function at the two ends, since these only go up |
| $\sin x$, $\cos x$ | see [Sine and cosine](#sine-and-cosine) below |
| Constants | the value rounded down and up, such as $[3.1415, 3.1416]$ for $\pi$ |

For functions, the value at an end isn't known exactly either. Compute it
with the rules to be good to some number of places $p$, then widen by the
error bar: the true value is within $0.6 \cdot 10^{-p}$ of the result.

### Sine and cosine

There are two ways to bound $\sin x$ for $x$ in $[\ell, h]$.

**Midpoint plus slope.** This is simple, and good for narrow intervals. The
*midpoint* and *half-width* of the interval are

$$m = \frac{\ell + h}{2}, \qquad w = \frac{h - \ell}{2},$$

so every $x$ in the interval is within $w$ of $m$. For example, $[3.141582, 3.141583]$
has midpoint $3.1415825$ and half-width $0.0000005$.

Since $|\sin'| = |\cos| \le 1$, $|\sin x - \sin m| \le |x - m| \le w$, so

$$\sin([\ell, h]) \subseteq [\sin m - w, \sin m + w] \cap [-1, 1],$$

using the enclosure of $\sin m$ from its error bar. It is at most $2w$ wider
than the true range, and tightest where $\sin x$ is near 0, which is where
precision matters most.

**Monotone pieces.** This is tighter for wide intervals, or near a peak.

1. **Full turn.** If $h - \ell \ge 2\pi$, the answer is $[-1, 1]$.
2. **Ends.** Enclose $\sin \ell$ and $\sin h$. The range lies between them,
   unless the interval contains a peak or a trough.
3. **Turning points.** In quarter turns, $q = x / (\pi/2)$, the peaks are where
   $q$ is 1 more than a multiple of 4, and the troughs where it is 3 more.
   Compute $q$ at the two ends, rounding outward, with whichever end of
   $\pi$'s interval widens the range.
4. **Result.** Take the smallest and largest of the end enclosures. If the
   interval of $q$ contains a peak, the upper end is $1$. If it contains a
   trough, the lower end is $-1$.

If $\pi$'s uncertainty leaves it unclear whether a turning point is inside,
count it as inside. That only widens the interval.

For $\cos x$, the peaks are where $q$ is a multiple of 4, and the troughs where
it is 2 more. Or use $\cos x = \sin(x + \pi/2)$.

Use the midpoint method by default, and monotone pieces when $w > 0.1$, or when
the result feeds a square root or logarithm where a peak matters.

### Refining

Start with $s = 5$ significant figures, and double $s$ until every interval
meets these conditions:

- **Divisors** don't contain $0$.
- **Logarithm arguments** are above $0$.
- **Square root arguments** aren't entirely below $0$. If the lower end is
  below 0, treat it as $0$.

If $s$ reaches a cap, such as 50, give up and report that a divisor or
logarithm argument can't be shown to be nonzero. See
[Exact singularities](#exact-singularities).

Refining only recomputes these rough bounds, never the precise values.
Starting at a generous $s$, such as 10, means it rarely needs to refine at all.

### The bounds the rules use

From each node's interval $[\ell, h]$:

- **Bounds on the true value.** The upper bound $U = \max(|\ell|, |h|)$, and,
  if $0$ is not in the interval, the lower bound $L = \min(|\ell|, |h|)$.
- **Bounds that also cover the approximation.** $\bar{U} = 1.01U$ and
  $\bar{L} = 0.99L$.

The barred bounds have 1% of room for the node's own error, so pass 2 has to
keep that error under 1% of its size. See
[Minimum places](#minimum-places).

## Pass 2: places

Give the top node the $d$ wanted. Then go through the nodes from the top down,
so that every parent has made its request before a child is handled. Each node
uses its operation's rule to ask its children for places. A child with several
parents takes the most places any of them asks for.

### Rules for each operation

These are the rules from the rules doc, written with the bounds from pass 1. A
node with $D$ places asks its children for:

| Node | Places for its children |
|---|---|
| Sum or difference of $n$ terms | each: $D + k + \mathrm{siz}(n)$ |
| Product of $n$ inexact factors | factor $i$: $D + k + \mathrm{siz}(n)$ plus the sizes of the other factors' $\bar{U}$ |
| $x / y$ | $x$: $D + k + 2 - \mathrm{siz}(\bar{L}_y)$, and $y$: $D + k + 3 + \mathrm{siz}(U_x) - 2\mathrm{siz}(\bar{L}_y)$ |
| $x^n$, $n \le 8$ | $D + k + 1 + (n - 1)\mathrm{siz}(\bar{U}_x)$ |
| $\sqrt{x}$ | $D + k - \lfloor (\mathrm{siz}(L_x) - 1)/2 \rfloor$, or $2(D + k) + 1$ if $\ell_x \le 0$ or $\mathrm{siz}(L_x) < 3 - 2(D + k)$ |
| $e^x$ | $D + k + 2 + \lfloor 0.44 h_x \rfloor$ if $h_x \ge 0$, and $\max(1, D + k + 2 - \lceil 0.43 \lvert h_x \rvert \rceil)$ if $h_x < 0$ |
| $\ln x$ | $D + k + 2 - \mathrm{siz}(\ell_x)$ |
| $\sin x$, $\cos x$ | $x$: $D + k + 1$, and $\pi$: $D + k + 1 + \mathrm{siz}(j)$, reducing by $j$ quarter turns |

Notes:

- **Exact children** need nothing. An exact number with more places than asked
  for is rounded to those places, with $c = \frac{1}{2}$.
- **Products with one inexact factor,** such as $3x$, can use one place fewer:
  $D + k$ plus the sizes of the exact factors.
- **Exponentials** use the upper end $h_x$ of the interval, since that is where
  $e^x$ is largest.
- **Sine and cosine** take $j$ from the interval of $x / (\pi/2)$: the largest
  $|j|$ the reduction might use.

### Minimum places

A child whose $\bar{U}$ or $\bar{L}$ is used by its parent also needs its error
to stay within the 1% of room those bounds leave. That holds if it has at
least

$$3 - \mathrm{siz}(M)$$

places, where $M$ is $L$ for a lower bound and $U$ for an upper bound. If the
rule asks for fewer, use this instead.

Why: with $D$ places, the error is at most $0.6 \cdot 10^{-D}$. With
$D \ge 3 - \mathrm{siz}(M)$, that is at most $0.6 \cdot 10^{\mathrm{siz}(M) - 3}$,
and since $M \ge 10^{\mathrm{siz}(M) - 1}$, it is under $0.01M$.

Usually the rule already asks for more. The minimum matters when the other
operand is very small. For example, in $10^{-20} / y$ with $y \approx 10^{-5}$
and $D = 2$, the quotient rule asks $y$ for $2 + 2 + 3 - 19 + 10 = -2$ places,
which would round $y$ to 0. The minimum asks for $3 + 5 = 8$.

## Pass 3: evaluate

Go through the nodes from the bottom up. Each node computes its value from its
children's values, and rounds it to its own places $D$:

- **Exact operations,** sums, differences and products, are computed exactly
  and then rounded.
- **Other operations** are computed to $D + k + 1$ places, rounded or cut off,
  and then rounded to $D$. This covers division by the usual truncating
  algorithm, and functions by
  [series](../2026-11-02%20Rounding%20and%20error%20bounds/README.md#series).

Keeping more places than a node was given is always safe, so an implementation
can skip the rounding of inner nodes if that is easier. Only the top node must
be rounded to $d$.

Why it works: the leaves are good to their places. If a node's children are
good to the places it asked for, its rule guarantees that its computed value
is within $10^{-(D+k)}$ of the true value, and rounding to $D$ places then
makes it good to $D$ places. So by induction, from the leaves up, the top node
is good to $d$ places.

### Correct rounding

The result is good to $d$ places, but that doesn't make it the correctly
rounded value. Check with
[Lemma 3](../2026-11-02%20Rounding%20and%20error%20bounds/README.md#correct-rounding)
before the final rounding: if the top node's computed value is more than
$10^{-(d+k)}$ from the nearest rounding boundary, rounding it to $d$ places is
correct.

If the check fails, which is rare, run passes 2 and 3 again with a few more
places at the top. Cap the retries, because a result exactly on a boundary
never passes. See [Exact ties](#exact-ties).

## Examples

### (π + e)/√2 to 4 places

Take $d = 4$ and $k = 2$.

**Bounds.** With $s = 5$: $\pi$ is in $[3.1415, 3.1416]$ and $e$ in
$[2.7182, 2.7183]$, so $\pi + e$ is in $[5.8597, 5.8599]$, and $\sqrt{2}$ is in
$[1.4142, 1.4143]$. No divisor contains $0$, so one round is enough. The bounds
used are $U = 5.8599$ for $\pi + e$, of size 1, and
$\bar{L} = 0.99 \cdot 1.4142 = 1.4000$ for $\sqrt{2}$, also of size 1.

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

**Bounds.** With $s = 5$, $\pi$ is in $[3.1415, 3.1416]$, so the argument is in
$[3.14149, 3.14159]$, and the sine's interval contains 0. That is a divisor, so
refine. With $s = 10$, $\pi$ is in $[3.141592653, 3.141592654]$, the argument
is in $[3.141582653, 3.141582654]$, and the midpoint method gives a sine
interval of about $[0.9999 \cdot 10^{-5}, 1.0001 \cdot 10^{-5}]$. That excludes
0, so $\bar{L} = 0.99 \cdot 0.9999 \cdot 10^{-5}$, of size $-5$. The argument is
about 2 quarter turns, so $j = 2$.

**Places.**

| Node | Asks | For |
|---|---|---|
| $1/\sin(\ldots)$, with 4 places | $4 + 2 + 3 + 1 + 10 = 20$ | the sine |
| $\sin(\ldots)$, with 20 places | $20 + 2 + 1 = 23$ | its argument |
| | $23 + \mathrm{siz}(2) = 24$ | $\pi$, for the reduction |
| $\pi - 0.00001$, with 23 places | $23 + 2 + 1 = 26$ | $\pi$ |

$\pi$ has two parents, asking for 24 and 26 places, so it gets 26. The extra
10 places at the top come from $-2\mathrm{siz}(\bar{L})$: the derivative of
$1/y$ is $-1/y^2$, about $10^{10}$ here, so the rules are charging for how
sensitive the expression really is.

**Evaluate.** The argument is $\tilde{\pi} - 0.00001$. The reduction by
$j = 2$ quarter turns gives $r \approx -0.00001$, and since $j$ is 2 more than a
multiple of 4, $\sin x = -\sin r \approx 0.0000099999999998333$. The quotient
rounds to $100000.0000$. The true value is $100000.0000016667\ldots$

Because $\pi$ is one shared node, both uses get the same $\tilde{\pi}$, and they
cancel exactly in the reduction: $r$ comes out as exactly $-0.00001$. The rules
don't know about that cancellation, so they ask for more places than needed,
but never fewer.

## Corner cases

### Exact singularities

For $1/\sin(\pi)$, refining never excludes 0 from the sine's interval, however
many figures are used. The cap on $s$ catches this. No numeric method can tell
a true zero from a very small number. Symbolic simplification can catch some
cases, such as $\sin(\pi) = 0$, before the passes start.

### Exact ties

If the true result is exactly on a rounding boundary, such as $0.45$ to 1
place, the correct-rounding check never passes. Cap the retries. With exact
inputs, exact arithmetic can settle it. For example,
[division by truncation](../2026-11-02%20Rounding%20and%20error%20bounds/README.md#division-by-truncation)
handles exact quotients. Otherwise, report the result as good to $d$ places.

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
def precision_for(expr, d, k=2):
    graph = flatten_and_share(expr)          # flatten sums/products, merge repeats

    # Pass 1: bounds
    s = 10
    while True:
        intervals = interval_eval(graph, sig_figs=s)   # outward rounding
        problem = find_problem(graph, intervals)       # divisor or log arg near 0
        if problem is None:
            break
        s *= 2
        if s > 50:
            raise ValueError(f"can't bound {problem} away from 0")

    # Pass 2: places, parents before children
    places = {graph.root: d}
    for node in graph.top_down():
        D = places[node]
        for child, wanted in rule_for(node).child_places(D, k, intervals):
            wanted = max(wanted, minimum_places(node, child, intervals))
            places[child] = max(places.get(child, wanted), wanted)

    # Pass 3: evaluate, children before parents
    values = {}
    for node in graph.bottom_up():
        D = places[node]
        if node.is_exact_op():
            v = node.compute_exactly(values)
        else:
            v = node.compute_to(values, D + k + 1)     # truncating is fine
        values[node] = v if node is graph.root else rnd(v, D)

    result = values[graph.root]
    correct = distance_to_boundary(result, d) > 10 ** -(d + k)
    return rnd(result, d), correct
```

`rule_for(node).child_places` is the table in
[Rules for each operation](#rules-for-each-operation), and `minimum_places`
is the rule in [Minimum places](#minimum-places).

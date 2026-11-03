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

1. **Bounds, bottom-up.** Find a cheap interval for the value of every part.
   Where a lower bound is needed and the interval contains 0, tighten it by
   evaluating that part to more places.
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
true value of every node. It uses only two operations:

- **Cheap bounds.** A fixed, crude interval for every node, computed once.
- **Evaluation.** Passes 2 and 3 on a part of the expression, to some number
  of places $p$, when a cheap bound isn't good enough.

A value good to $p$ places is itself an interval: the true value is within
$0.6 \cdot 10^{-p}$ of it. So the only precise operation needed is the
evaluation that is needed anyway.

### Cheap bounds

Go through the nodes from the bottom up. Use interval arithmetic rounded
outward to 5 significant figures: lower ends down and upper ends up, so that
the true value stays inside.

| Node | Cheap interval |
|---|---|
| Exact numbers | the number itself |
| Constants | the constant evaluated to 5 places, widened by $0.6 \cdot 10^{-5}$, such as $[3.1415, 3.1416]$ for $\pi$ |
| $x + y$, $x - y$ | add or subtract the matching ends |
| $xy$ | the smallest and largest of the four products of ends |
| $x / y$ | $x$ times $[1/h_y, 1/\ell_y]$, after [tightening](#tightening-by-evaluation) $y$ if its interval contains 0 |
| $x^n$ | each end raised to the power $n$, and $0$ if $n$ is even and the interval contains $0$ |
| $\sqrt{x}$ | $[10^{\lfloor (\mathrm{siz}(\ell) - 1)/2 \rfloor}, 10^{\lceil \mathrm{siz}(h)/2 \rceil}]$, with lower end $0$ if $\ell \le 0$ |
| $e^x$ | lower end $10^{\lfloor a\ell \rfloor}$, upper end $10^{\lceil bh \rceil}$ |
| $\ln x$ | $\ln 10$ times $[\mathrm{siz}(\ell) - 1, \mathrm{siz}(h)]$, after tightening $x$ if $\ell \le 0$ |
| $\sin x$, $\cos x$ | $[-1, 1]$ |

For $e^x$, the factors are $\log e$ rounded the safe way: $a = 0.43$ if
$\ell \ge 0$ and $0.44$ if $\ell < 0$, and $b = 0.44$ if $h \ge 0$ and $0.43$
if $h < 0$. For $\ln x$, use $2.30 < \ln 10 < 2.31$, again rounded the safe way
for the sign of each end.

The function bounds are crude: they can be off by a factor of 10 or more. That
is fine for upper bounds, where a looser $U$ only costs a place or so, through
$\mathrm{siz}$. It only matters for lower bounds.

### Tightening by evaluation

The rules need a lower bound above 0 for:

- **Divisors.** The quotient rule uses $\bar{L}_y$.
- **Logarithm arguments.** The logarithm rule uses $L_x$.
- **Square root arguments,** optionally. Without a lower bound, the square
  root rule falls back to $2(D + k) + 1$ places.

If a node's cheap interval contains 0 but its parent needs such a lower bound,
evaluate the node to $p = 5$ places, then 10, 20, 40, and so on, until the
interval $[\tilde{x} - 0.6 \cdot 10^{-p}, \tilde{x} + 0.6 \cdot 10^{-p}]$
excludes 0. Use that interval for the node from then on, and carry on with the
cheap pass.

Evaluating a node to $p$ places is passes 2 and 3 on the part of the
expression below it, with $d = p$. Those use the bounds already found for its
descendants, which were handled first, and tighten them the same way if they
need to. So the recursion only goes down the tree, and only where a value is
close to 0.

Keep the most precise value found for every node, and reuse it later: having
more places than needed is always safe. Doubling $p$ means the trials cost
less than the last one again, and starting at 5 means most succeed at once.

If $p$ reaches a cap, such as 80, give up and report that the divisor or
logarithm argument can't be shown to be nonzero. See
[Exact singularities](#exact-singularities).

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

**Bounds.** $\pi$ is in $[3.1415, 3.1416]$ and $e$ in $[2.7182, 2.7183]$, so
$\pi + e$ is in $[5.8597, 5.8599]$. The cheap bound for $\sqrt{2}$, with
$\mathrm{siz}(2) = 1$, is $[10^0, 10^1] = [1, 10]$. No divisor's interval
contains 0, so nothing needs tightening. The bounds used are $U = 5.8599$ for
$\pi + e$, of size 1, and $\bar{L} = 0.99$ for $\sqrt{2}$, of size 0.

**Places.**

| Node | Asks | For |
|---|---|---|
| $(\pi + e)/\sqrt{2}$, with 4 places | $4 + 2 + 2 - 0 = 8$ | $\pi + e$ |
| | $4 + 2 + 3 + 1 - 0 = 10$ | $\sqrt{2}$ |
| $\pi + e$, with 8 places | $8 + 2 + 1 = 11$ | each of $\pi$ and $e$ |
| $\sqrt{2}$, with 10 places | $10 + 2 - 0 = 12$ | $2$, which is exact |

The crude bound for $\sqrt{2}$ costs a place or two compared with a tight one,
which would give 7 and 8 places at the top.

**Evaluate.**

- $\pi + e$: $3.14159265359 + 2.71828182846 = 5.85987448205$, rounded to 8
  places: $5.85987448$.
- $\sqrt{2}$ to $10 + 2 + 1 = 13$ places, rounded to 10: $1.4142135624$.
- The quotient cut off at $4 + 2 + 1 = 7$ places: $4.1435569$.

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
argument's cheap interval is about $[3.1415, 3.1416]$, about 2 quarter turns, so
$j = 2$.

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

### 1/(e^(π√43) − 884736744) to 4 places

$e^{\pi\sqrt{43}} = 884736743.99977746\ldots$ is very close to a whole number,
so the divisor is about $-0.00022253$, and 12 digits cancel in the subtraction.
Take $d = 4$ and $k = 2$.

**Bounds.** From the bottom up:

| Node | Cheap interval |
|---|---|
| $\pi$ | $[3.1415, 3.1416]$ |
| $\sqrt{43}$, with $\mathrm{siz}(43) = 2$ | $[10^0, 10^1] = [1, 10]$ |
| $x = \pi\sqrt{43}$ | $[3.1415, 31.416]$ |
| $E = e^x$ | $[10^{\lfloor 0.43 \cdot 3.1415 \rfloor}, 10^{\lceil 0.44 \cdot 31.416 \rceil}] = [10, 10^{14}]$ |
| $y = E - 884736744$ | contains 0 |

$y$ is a divisor, so tighten it. Evaluating $y$ to 5 places needs no bounds on
the terms of the difference, and the rest of its place counts come from the
cheap bounds below it. That gives $-0.00022$, so $y$ is in
$[-0.000226, -0.000214]$, which excludes 0 at the first try. So
$\bar{L} = 0.99 \cdot 0.000214$, of size $-3$.

**Places.** Using the cheap upper bounds $h_x = 31.416$, $\bar{U} = 10.1$ for
$\sqrt{43}$ and $\bar{U} = 3.17$ for $\pi$:

| Node | Asks | For |
|---|---|---|
| $1/y$, with 4 places | $4 + 2 + 3 + 1 + 6 = 16$ | $y$ |
| $y$, with 16 places | $16 + 2 + 1 = 19$ | $E$ |
| $E$, with 19 places | $19 + 2 + 2 + \lfloor 0.44 \cdot 31.416 \rfloor = 36$ | $x$ |
| $x$, with 36 places | $36 + 2 + 1 + 2 = 41$ | $\pi$ |
| | $36 + 2 + 1 + 1 = 40$ | $\sqrt{43}$ |

The crude bounds cost a few places: with $x$'s tight upper bound of about
$20.6$, $x$ would need 32 places instead of 36.

**Evaluate.** $E$ comes out as $884736743.9997774660\ldots$, $y$ as
$-0.0002225339650933\ldots$, and the quotient as $-4493.6960503\ldots$ That
rounds to $-4493.6961$, which is correct, but it is only about
$3.1 \times 10^{-7}$ from the rounding boundary $-4493.69605$, less than
$10^{-6}$, so the correct-rounding check fails. Running passes 2 and 3 again
with $k = 3$ adds a place everywhere, and then the check passes.

## Corner cases

### Exact singularities

For $1/\sin(\pi)$, tightening never excludes 0 from the sine's interval,
however many places are used. The cap on $p$ catches this. No numeric method can tell
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

    intervals, best = {}, {}                 # best: most precise value per node

    # Pass 1: cheap bounds, tightening where a lower bound is needed
    for node in graph.bottom_up():
        for child in node.children_needing_lower_bound():
            if contains_zero(intervals[child]):
                intervals[child] = tighten(child, intervals, best, k)
        intervals[node] = cheap_bounds(node, intervals)  # 5 figures, outward

    value = evaluate(graph.root, d, intervals, best, k)
    correct = distance_to_boundary(value, d) > 10 ** -(d + k)
    return rnd(value, d), correct


def tighten(node, intervals, best, k):
    p = 5
    while p <= 80:
        v = evaluate(node, p, intervals, best, k)
        lo, hi = v - 6 * 10 ** -(p + 1), v + 6 * 10 ** -(p + 1)
        if lo > 0 or hi < 0:
            return (lo, hi)
        p *= 2
    raise ValueError(f"can't bound {node} away from 0")


def evaluate(top, d, intervals, best, k):
    # Pass 2: places, parents before children
    places = {top: d}
    for node in top.top_down():
        D = places[node]
        for child, wanted in rule_for(node).child_places(D, k, intervals):
            wanted = max(wanted, minimum_places(node, child, intervals))
            places[child] = max(places.get(child, wanted), wanted)

    # Pass 3: evaluate, children before parents
    for node in top.bottom_up():
        D = places[node]
        if node in best and best[node].places >= D:
            continue                                   # reuse a better value
        if node.is_exact_op():
            v = node.compute_exactly(best)
        else:
            v = node.compute_to(best, D + k + 1)       # truncating is fine
        best[node] = Value(v if node is top else rnd(v, D), places=D)
    return best[top].value
```

`rule_for(node).child_places` is the table in
[Rules for each operation](#rules-for-each-operation), and `minimum_places`
is the rule in [Minimum places](#minimum-places).

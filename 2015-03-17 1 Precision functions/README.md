# Precision functions

Functions for the size, precision and number of significant figures of a
number. This is the first of four docs on how many decimal places the inputs to
a calculation need so that the result, rounded to $d$ decimal places, is
accurate.

*Xin-Xin* — handwritten notes from March 17, 2015, typed up.

The original page: [page 1](handwritten-notes-page-1.jpg) (page 1 of 8 in the
original set).

Throughout, $\log$ means $\log_{10}$, and $\mathrm{rnd}(x, p)$ means $x$ rounded
to $p$ decimal places.

*March 17, 2015*

The size of the whole-number part of $x$ (for $|x| \ge 1$, it is the number of
digits before the decimal point):

$$\mathrm{siz}(x) = \lfloor \log|x| \rfloor + 1$$

$$\mathrm{nsiz}(x) = \lfloor \log|x| \rfloor$$

So

$$\mathrm{nsiz}(x) \le \log|x| \le \mathrm{siz}(x), \qquad \mathrm{siz}(x) = \mathrm{nsiz}(x) + 1.$$

The precision of $x$ is the number of decimal places it needs:

$$\mathrm{prec}(x) = \text{the smallest } p \text{ such that } \mathrm{rnd}(x, p) = x.$$

The number of significant figures in $x$ is

$$\mathrm{fig}(x) = \mathrm{prec}(x) + \mathrm{siz}(x).$$

For example (these examples are not in the notes),
$\mathrm{fig}(0.005) = 3 + (-2) = 1$ and $\mathrm{fig}(1200) = -2 + 4 = 2$.

Rounding interacts with these as follows:

$$\mathrm{prec}(\mathrm{rnd}(x, p)) \le p$$

$$\mathrm{siz}(\mathrm{rnd}(x, p)) \le \mathrm{siz}(x) + 1$$

$$\mathrm{fig}(\mathrm{rnd}(x, p)) = \min(p + \mathrm{siz}(x), \mathrm{fig}(x))$$

Next: [Error bounds for arithmetic](../2015-03-17%202%20Error%20bounds%20for%20arithmetic/README.md).

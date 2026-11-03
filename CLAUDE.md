# Notes for Claude

## Workflow

- **Push changes directly to `main`.** Don't open pull requests unless asked.
  If you're working on another branch, fast-forward `main` to it and push, for
  example `git push origin HEAD:main`, after checking that `origin/main` is an
  ancestor of your commit.

## Directory structure

Each topic gets its own top-level directory named `YYYY-MM-DD Title`, for
example `2026-11-01 Cubic formula identities`.

- The date is when the topic was started, as given by the user. It can be
  earlier than the commit date.
- When a topic is split into docs meant to be read in order, put a number
  between the date and the title, so the directories sort in reading order:
  `2026-11-02 1 Rounding and error bounds`, `2026-11-02 2 Input places for
  arithmetic`. Each doc says which one it builds on near the top and links to
  the next one at the end.
- The title is in sentence case: only the first word and proper nouns are
  capitalized (`Investigating Antihydra`). Use spaces, not hyphens or
  underscores.
- Each directory has a `README.md` with the write-up.
- Photos of handwritten notes go in the topic directory, named like
  `handwritten-notes-page-1.jpg`, and the README links to them near the top.
- Lean proofs go in the same directory, next to the README, with a
  `lean-toolchain` file. A proof that uses Mathlib also needs a
  `lakefile.toml`, plus a `.gitignore` containing `.lake/`.
- Shared material, such as the Lean install instructions, goes in the root
  `README.md`. Topic READMEs link to it with `../README.md`.

## Checking Lean proofs

**Don't try to install Lean when running in the claude.ai cloud environment**
(Claude Code on the web, where `CLAUDE_CODE_REMOTE` is `true`). The network
policy there blocks GitHub and the Mathlib cache hosts, so elan can't download
a toolchain and `lake exe cache get` fails. Building Mathlib from source isn't
practical either.

Instead:

- Keep changes to a proof small and easy to review.
- Set the status note in the README to say the current version hasn't been
  checked.
- Ask the user to check the file at
  <https://live.lean-lang.org/#project=mathlib-stable>, which opens the editor
  on its stable release with Mathlib. Once they confirm there are no errors or
  warnings, update the status note to say so.

## Writing math in GitHub Markdown

The notes in this repo are Markdown files rendered by GitHub, which displays
`$...$` and `$$...$$` with MathJax. GitHub runs its Markdown parser *before*
the math renderer, which causes several problems. Each rule below came from
something that rendered wrong in this repo.

### Rules

- **No line inside a `$$` block may start with `+ `, `- ` or `* `.** GitHub
  reads it as a bullet-list item and the equation breaks into raw LaTeX plus a
  bullet. Put the operator at the end of the previous line instead:

  ```latex
  $$
  \sqrt[3]{a + b} +
  \sqrt[3]{a - b} = x
  $$
  ```

- **No line inside a `$$` block may consist only of `=` or `-` signs.**
  Markdown reads it as a setext heading underline, so the `$$` above it turns
  into a heading and the rest shows as raw LaTeX. Keep the `=` on the same line
  as what follows it: `= \begin{cases}`.

- **Don't use `\,` (thin space).** Markdown treats it as an escaped comma, so
  `3\sqrt{3}\,i` renders as "3√3,i". Reorder the terms instead, for example
  `3i\sqrt{3}` or `p\sqrt{3}`. Other backslash-punctuation commands such as `\;`
  or `\!` are likely to have the same problem.

- **Don't use `\operatorname`.** GitHub's renderer rejects it with "The
  following macros are not allowed: operatorname". Use `\mathrm{Im}(z)`
  instead.

- **Don't use `\mathbb`.** `\mathbb{Q}` renders as a plain italic Q. Write the
  Unicode characters ℚ, ℤ, ℝ and ℂ in ordinary text instead, for example
  `$u$ lies in ℚ(*i*)`.

- **Keep math out of `*italic*` and `**bold**` text.** Math inside emphasis
  shows up as raw `$x$`. Put the label in bold and the math after it:
  `**Step 1.** $x$ and $m$ are integers.`

- **Don't put display math inside a list item.** An indented `$$...$$` in a
  numbered or bulleted list isn't recognized as math: GitHub shows the `$$`
  and the raw LaTeX. End the list, or write the steps as paragraphs with bold
  labels, and put the `$$` block at the top level.

- **Watch for underscores that Markdown can read as italics.** In
  `$\tilde{t}_n = \mathrm{rnd}(-\tilde{t}_{n-1} \cdot \ldots)$`, GitHub read
  `_n` as opening italics and `}_{` as closing them, and showed the formula as
  raw LaTeX. A subscript right after `}` or `)`, followed later by `_{`, is the
  risky pattern. Avoid the `}` before the first subscript, for example
  `\tilde t_n` instead of `\tilde{t}_n`, which displays the same.

- **Don't run letters straight on after inline math.** In `the $n$th power`,
  GitHub didn't treat the second `$` as closing the math, because a letter
  follows it, and showed `$n$th` as plain text. Reword instead, for example
  `the power $n$`.

- **Don't put a quotation mark right before inline math.** In
  `such as "$y \ne 0$ or $x > 0$"`, GitHub didn't treat the `$` after the quote
  as opening math and showed `$y \ne 0$` as plain text. Drop the quotes, or
  reword so the math doesn't sit inside them.

- **Long display equations scroll sideways on phones.** Split very wide
  equations across lines, or accept the horizontal scroll.

### Used without problems so far

`$...$`, `$$...$$`, `aligned` with `\\` line breaks, `\frac`, `\tfrac`,
`\dfrac`, `\sqrt[3]{}`, `\boxed`, `\qquad`, `\mathrm`, `\varphi`, `\omega`,
`\bar`, `\ne`, `\pm`, and inline math inside table cells.

### Checking a file

Find lines that start with a list marker inside `$$` blocks:

```bash
awk '/^\$\$$/{m=!m;next} m && /^[-+*] /{print FILENAME": "NR": "$0}' path/to/README.md
```

Find lines inside `$$` blocks that Markdown can read as a heading underline:

```bash
awk '/^\$\$$/{m=!m;next} m && /^ *(=+|-+) *$/{print FILENAME": "NR": "$0}' path/to/README.md
```

Find the commands that are known to break:

```bash
grep -n '\\,\|\\operatorname\|\\mathbb' path/to/README.md
```

Find display math inside list items:

```bash
grep -n '^ \+\$\$' path/to/README.md
```

Find math where an underscore could open and close italics:

```bash
grep -n '\$[^$]*[})]_[A-Za-z0-9][^$]*_{[^$]*\$' path/to/README.md
```

Find inline math followed directly by a letter or digit:

```bash
grep -n '\(^\|[^$]\)\$[^$ ]\+\$[A-Za-z0-9]' path/to/README.md
```

Find inline math opened right after a quotation mark:

```bash
grep -n '["“‘]\$[^$]' path/to/README.md
```

Find math inside italic or bold text:

```bash
grep -n '^\*[^*][^*]*\$[^*]*\*\|\*\*[^*]*\$[^*]*\*\*' path/to/README.md
```

The `awk` check assumes `$$` sits on a line by itself to open and close a
block.

# Investigating Antihydra

Notes from exploring the map a ↦ ⌊3a/2⌋, the Collatz-like map behind the
BB(6) "Antihydra" Turing machine, starting from the factorizations of 3^k + 1.

## What's proved here

`ThreePowPlusOne.lean` proves, using only core Lean 4 (no Mathlib), how many
factors of 2 divide 3^k + 1:

| Theorem | Statement |
|---|---|
| `three_pow_mod_eight` | 3^k mod 8 is 1 when k is even and 3 when k is odd |
| `odd_mod_eight` | k odd → 3^k + 1 ≡ 4 (mod 8) |
| `even_mod_eight` | k even → 3^k + 1 ≡ 2 (mod 8) |
| `odd_exact` | k odd → 4 ∣ 3^k + 1 and ¬ 8 ∣ 3^k + 1 (exactly 2²) |
| `even_exact` | k even → 2 ∣ 3^k + 1 and ¬ 4 ∣ 3^k + 1 (exactly 2¹) |
| `not_eight_dvd` | 8 never divides 3^k + 1 |

The key lemma is proved by induction on k: `Nat.pow_succ` rewrites 3^(k+1) as
3^k · 3, and `omega` (Lean's linear-arithmetic decision procedure) treats 3^k as
an opaque variable and finishes the argument mod 8.

The file has been checked with Lean 4.15.0.

## Installing Lean

Lean is installed through **elan**, its version manager (similar to `rustup`).

### macOS / Linux

```bash
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
```

Then restart your shell, or run:

```bash
source ~/.elan/env
```

### Windows (PowerShell)

```powershell
curl -O --location https://raw.githubusercontent.com/leanprover/elan/master/elan-init.ps1
powershell -ExecutionPolicy Bypass -f elan-init.ps1
del elan-init.ps1
```

### Editor support (optional)

Install [VS Code](https://code.visualstudio.com/) and the **lean4** extension.
Opening a `.lean` file then shows proof goals and errors as you type.

### No install

Paste the contents of `ThreePowPlusOne.lean` into the web editor at
<https://live.lean-lang.org>.

## Checking the proof

From this directory:

```bash
lean ThreePowPlusOne.lean
```

The `lean-toolchain` file pins Lean 4.15.0, so elan downloads and uses that
version automatically the first time. No output means every theorem checked.
A failing proof prints an error with its line number.

### If elan can't download Lean

elan fetches toolchains from `release.lean-lang.org`. If a firewall blocks that
host but GitHub is reachable, install the release by hand and register it with
elan:

```bash
curl -L -o lean.zip https://github.com/leanprover/lean4/releases/download/v4.15.0/lean-4.15.0-linux.zip
```

```bash
unzip lean.zip
```

```bash
elan toolchain link lean415 "$PWD/lean-4.15.0-linux"
```

```bash
elan override set lean415
```

Use the `-darwin` or `-windows` archive instead of `-linux` on other systems.

# math

## Installing Lean

The Lean proofs in this repo are checked with Lean 4. Lean is installed through
**elan**, its version manager (similar to `rustup`).

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

Paste a `.lean` file into the web editor at <https://live.lean-lang.org>.

## Checking a proof

From the directory containing the proof:

```bash
lean <file>.lean
```

If the directory has a `lean-toolchain` file, elan downloads and uses the Lean
version it names automatically the first time. No output means every theorem
checked. A failing proof prints an error with its line number.

### If elan can't download Lean

elan fetches toolchains from `release.lean-lang.org`. If a firewall blocks that
host but GitHub is reachable, install the release by hand and register it with
elan. For example, for Lean 4.15.0 on Linux:

```bash
curl -L -o lean.zip https://github.com/leanprover/lean4/releases/download/v4.15.0/lean-4.15.0-linux.zip
```

```bash
unzip lean.zip
```

```bash
elan toolchain link lean415 "$PWD/lean-4.15.0-linux"
```

Then, from the proof's directory:

```bash
elan override set lean415
```

Use the `-darwin` or `-windows` archive instead of `-linux` on other systems.

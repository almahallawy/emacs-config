# emacs-config

My Emacs configuration, written as literate Org files, including my gptel
(LLM chat) setup and extensions.

## Files

| File | What it is | In git? |
|------|------------|---------|
| `emacs.org` | **The config.** All settings, with notes. Edit this one. | yes |
| `.emacs` | Bootstrap, hand-written. Tangles any `.org` whose `.el` is missing or older, loads `kia-config`, compiles `my-gptel*.el`. | yes |
| `kia-config.el` | Generated from `emacs.org` (tangle). General config. | no |
| `emacs_bash` | Generated from `emacs.org` (*Shell > ~/.emacs_bash*). Committed so `~/.emacs_bash` can symlink to it. | yes |
| `my-gptel.org` | gptel settings and personal extensions. Loaded from `emacs.org` (section *gptel*). | yes |
| `my-gptel.el` | Generated from `my-gptel.org`. | no |
| `my-gptel.elc` | Compiled `my-gptel.el`, rebuilt automatically after each tangle. | no |
| `my-gptel-*.el` | Optional private gptel extensions (not in this repo); loaded automatically if present. | no |

Never edit `kia-config.el`, `emacs_bash` or `my-gptel*.el` by hand. They are
overwritten on every tangle. Edit the `.org` files; `.emacs` is the only
hand-edited code file.

## Setting up a new machine

1. **Clone the repos into `~/src`:**
   ```sh
   cd ~/src
   git clone https://github.com/almahallawy/emacs-config.git
   git clone https://github.com/karthink/gptel.git
   git clone https://github.com/karthink/gptel-agent.git
   git clone https://github.com/jeremy-compostella/cscope
   ```
2. **System packages:**
   ```
   sudo apt install pandoc            # markdown preview/export
   sudo apt install libpoppler-glib-dev libpoppler-private-dev libpng-dev \
        zlib1g-dev autoconf automake gcc make pkg-config   # pdf-tools
   ```
   pdf-tools compiles its `epdfinfo` server on the first start (~30 s).
   After a pdf-tools upgrade, run `M-x pdf-tools-install` to rebuild it.
3. **`~/.emacs`:** one line. Keep Emacs' `custom-set-variables` block below it,
   so Custom's writes stay out of git:
   ```elisp
   (load "~/src/emacs-config/.emacs")
   ```
4. **Start Emacs.** The first start tangles `emacs.org` and `my-gptel.org`,
   installs packages from MELPA/GNU ELPA and compiles
   `my-gptel*.el`. Takes a minute; later starts are normal.
5. **Shell (optional):** `ln -s ~/src/emacs-config/emacs_bash ~/.emacs_bash`
   (see `emacs.org`, *Shell > ~/.emacs_bash*). Needed for prompt colours and
   directory tracking in `M-x shell` and `M-x ssh`; remote hosts need nothing.
6. **Secrets** go in `~/.authinfo.gpg` (never in this repo).

## Day-to-day: changing the config

1. Edit `emacs.org` or `my-gptel.org`.
2. Restart Emacs: `.emacs` re-tangles the changed `.org` and recompiles.
   Or, to apply without restarting: `C-c C-v t` in that org buffer (tangles,
   and compiles `my-gptel*.el`), then eval the changed block.
3. Commit the `.org` file (and `.emacs`, and `emacs_bash` if the shell
   section changed).

`.emacs` is hand-written (not tangled): edit it directly and commit.

**After `git pull` on another machine:** just restart Emacs.

### How tangling works

| Source | Tangles to | Then |
|--------|------------|------|
| `emacs.org` | `kia-config.el`, `emacs_bash` | `.emacs` does `(require 'kia-config)` (not compiled). |
| `my-gptel.org` | `my-gptel.el` | Byte-compiled to `.elc`; required from `emacs.org` (*gptel*). |

On every start `.emacs`:
1. Tangles each `.org` whose `.el` is missing or older than the `.org`, then
   touches the `.el` (Org skips writing an unchanged file, so a prose-only
   edit would otherwise re-tangle on every start).
2. Loads `kia-config`, which loads `my-gptel` and any `my-gptel-*.el`.
   `load-prefer-newer` makes a fresh `.el` win over a stale `.elc`.
3. Recompiles each `my-gptel*.el` whose `.elc` is missing or older (used from
   the next start). Compile warnings don't pop up.

`C-c C-v t` does the same by hand: tangles, and a post-tangle hook (in
`emacs.org`, *gptel*) compiles `my-gptel*.el`.

## gptel (LLM chat)

Default backend: **GitHub Copilot**, model `claude-opus-5.5`.
Switch backend/model with `M-x gptel-menu` (or `C-u C-c RET` in a chat
buffer); `C-c RET` alone sends.

Settings and personal additions are in `my-gptel.org`:

| Command / key | What it does |
|---------------|--------------|
| `M-x my-gptel-sessions` | List all gptel buffers and running requests/sub-agents. `RET` visit, `k` abort, `u` toggle unleash, `g` refresh. |
| `C-c C-u` (in a gptel buffer) | Toggle tool-call confirmation for this buffer only ("unleash"). |
| `M-x my-gptel-gh-reset-token` | Clear the cached Copilot session token. Use after a network change (e.g. VPN on/off) if Copilot returns **HTTP 403**. |

Text yanked into a gptel buffer, or copied/killed out of one, is stripped of
gptel's internal properties, so pasting part of a response doesn't turn into
a bogus assistant turn or tool call.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Copilot: HTTP 403 after a network change | `M-x my-gptel-gh-reset-token`, then retry. |
| A config change has no effect | Restart Emacs (or `C-c C-v t` and eval the block). |
| Startup error after a change | Fix the `.org`, then `C-c C-v t` in it (or `touch` it and restart). |

## Credits

Shell setup follows Mickey Petersen (Mastering Emacs) and Protesilaos
Stavrou; company setup from jao. Links are in `emacs.org`.

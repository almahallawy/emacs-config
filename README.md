# emacs

My Emacs configuration, written as a literate Org file.

## Files

| File | What it is | In git? |
|------|------------|---------|
| `emacs.org` | **The config.** All settings, with notes. Edit this one. | yes |
| `.emacs` | Bootstrap: sets `load-prefer-newer`, adds this directory to `load-path`, loads `kia-config`. | yes |
| `kia-config.el` | Generated from `emacs.org` (tangle). General config. | no |
| `my-gptel.el` | Generated from `emacs.org`. Personal gptel extensions (see below). | no |
| `my-gptel.elc` | Compiled `my-gptel.el`, rebuilt automatically after each tangle. | no |
| `cscope-update`, `ec` | Helper scripts. | yes |
| `emacs-gdb.txt` | Notes on debugging Emacs with gdb. | yes |

Never edit `kia-config.el` or `my-gptel*.el` by hand. They are overwritten on
every tangle.

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
4. **Generate the config files.** The first time, nothing is generated yet, so
   tangle from the command line and compile once:
   ```sh
   cd ~/src/emacs-config
   emacs --batch --eval '(progn (require (quote org)) (org-babel-tangle-file "emacs.org"))'
   emacs --batch -L ~/src/gptel -L ~/src/gptel-agent -f batch-byte-compile my-gptel.el
   ```
5. **Start Emacs.** Packages from MELPA/GNU ELPA install on first start.
6. **Shell (optional):** append the `~/.bashrc` snippet from `emacs.org`,
   section *Shell > Directory tracking (OSC 7)*. Needed for prompt colours and
   directory tracking in `M-x shell`.
7. **Secrets** go in `~/.authinfo.gpg` (never in this repo), e.g. tokens

## Day-to-day: changing the config

2. `C-c C-v t` (`org-babel-tangle`) in that org buffer. This writes
   `my-gptel*.el` files.
3. Restart Emacs (or eval the changed block).
4. Commit `emacs.org` (and `.emacs` if changed).

**After `git pull` on another machine:** tangle again (step 2) and restart.
If that Emacs predates the auto-compile hook, run the compile command from
setup step 4 once.

## gptel (LLM chat)

Default backend: **GitHub Copilot**, model `claude-opus-5.5`.
Switch backend/model with `M-x gptel-menu` (or `C-u C-c RET` in a chat
buffer); `C-c RET` alone sends.

Personal additions (all in `my-gptel.el`, section *gptel setup* in `emacs.org`):

| Command / key | What it does |
|---------------|--------------|
| `M-x my-gptel-sessions` | List all gptel buffers and running requests/sub-agents. `RET` visit, `k` abort, `u` toggle unleash, `g` refresh. |
| `C-c C-u` (in a gptel buffer) | Toggle tool-call confirmation for this buffer only ("unleash"). |
| `M-x my-gptel-gh-reset-token` | Clear the cached Copilot session token. Use after switching VPN on/off if Copilot returns **HTTP 403**. |

Text yanked into a gptel buffer is stripped of gptel's internal properties,
so pasting part of a response doesn't confuse the request.


## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Copilot: HTTP 403 after VPN on/off | `M-x my-gptel-gh-reset-token`, then retry. |
| A config change has no effect | Did you tangle (`C-c C-v t`) and restart? |

## Credits

Shell setup follows Mickey Petersen (Mastering Emacs) and Protesilaos
Stavrou; company setup from jao. Links are in `emacs.org`.

# Publishing the docs site

The site at <https://dwf.bigpencil.net/specs_of_theseus/> is built from `docs/`. Editing a page and pushing to main is all it takes. GitHub Actions rebuilds and publishes it.

## 1. Preview locally

### Get the theme (the git submodule)

The Hextra theme isn't copied into this repo. `site/themes/hextra` is a *git submodule*: a pointer to one commit of Hextra's own repo (github.com/imfing/hextra), recorded in `.gitmodules`. Git doesn't download it unless you ask. Without it, the theme folder is empty, Hugo warns `found no layout file for "html"`, and the preview shows blank pages.

**New clone:** fetch the theme along with the repo.

```sh
git clone --recurse-submodules https://github.com/infews/specs_of_theseus.git
```

**Existing checkout** (cloned without that flag, or the folder is empty): fetch it now.

```sh
git submodule update --init
```

**Check it's there:**

```sh
git submodule status
#  adf732f8... site/themes/hextra (v0.13.0)
```

A leading `-` means it isn't downloaded yet (run the `--init` command). A leading `+` means the checked-out theme isn't the commit this repo pins, usually after pulling a theme update. Run `git submodule update` to match it.

**To keep it in step automatically:** once it's downloaded, set this so `git pull` and `git checkout` also move the theme to the pinned commit:

```sh
git config submodule.recurse true
```

### Run the preview

```sh
hugo server --source site       # http://localhost:1313/specs_of_theseus/
```

The preview reloads as you save. Needs Hugo (`brew install hugo`).

## 2. Edit

**Changing an existing page:** edit its file in `docs/`. That's all.

- Write plain Markdown with no front matter. The page title comes from `site/hugo.toml`, so the `# Heading` at the top of a file is only for reading it on GitHub. The site doesn't show it.
- Link to other pages by their file, e.g. `[evals](evals.md)`. The site turns these into page links, and they work on GitHub too.
- Show a diagram with `![Alt text](img/name.svg)`. It goes into the page inline, and clicking it opens the full-size SVG.

**Adding a page:** create `docs/<name>.md`, then add two entries to `site/hugo.toml`:

```toml
# In the sidebar section (menus.sidebar). Weight 25 puts it after Where Things Live (24).
[[menus.sidebar]]
  name = "My New Page"
  pageRef = "/<name>"
  weight = 25

# With the other cascades at the bottom. Sets the title, the "Edit this page" link, and
# the prev/next order: weight 95 puts it between Where Things Live (90) and Adopting (100).
[[cascade]]
  title = "My New Page"
  weight = 95
  editURL = "https://github.com/infews/specs_of_theseus/edit/main/docs/<name>.md"
  [cascade.target]
    path = "/<name>"
```

Keep the two weights in step, so the sidebar and the prev/next links agree on the order.

**Changing a diagram:** edit `docs/src/0_specs_of_theseus.mmd` or `docs/src/6_adopting.mmd` (the stage diagrams are generated from the overview), then run `bin/build-diagrams` and commit the new SVGs in `docs/img/`. The README's Diagrams section covers setup. CI doesn't render diagrams. It publishes the committed SVGs.

**Changing the look:** styles are in `site/assets/css/custom.css`, fonts are in `site/layouts/_partials/custom/head-end.html` and the footer is in `site/layouts/_partials/custom/footer.html`.

## 3. Check the build

```sh
hugo --source site --panicOnWarning -d /tmp/sot-site
```

CI builds with `--panicOnWarning`, so any warning (a missing diagram, a broken setting) fails the deploy. Running this first catches those.

## 4. Publish

Commit and push to main. The **Publish docs site** workflow (`.github/workflows/pages.yml`) runs on any push that changes `docs/`, `site/` or the workflow itself, and the site updates a minute or two later.

```sh
gh run watch                    # follow the deploy
gh workflow run pages.yml       # republish without a change, e.g. if a run got stuck
```

## Updating the Hextra theme

Hextra is a git submodule pinned to a release (`site/themes/hextra`).

```sh
cd site/themes/hextra && git fetch --tags && git checkout v<new version> && cd -
git add site/themes/hextra
```

Before committing, preview the site and compare `site/layouts/_partials/sidebar.html` with the theme's own `layouts/_partials/sidebar.html`. Ours is a copy of it, changed to show only our menu, so changes in the new release need copying over. The empty `breadcrumb.html` and the heading and image hooks in `site/layouts/_markup/` override theme files too.

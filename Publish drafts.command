#!/bin/zsh
# ─────────────────────────────────────────────────────────────
# 0xKeep blog publisher — double-click this file in Finder.
#
# Publishes every draft in blog/drafts/ to the live blog:
#   drafts/<slug>.md  → src/pages/posts/<slug>.md
#   (banners are pre-made in public/images/banners/, nothing to move)
# Checks the blog still builds first. If the build fails, nothing
# is pushed and the drafts stay where they are.
# ─────────────────────────────────────────────────────────────

cd "$(dirname "$0")" || exit 1

finish() { echo; read -k1 "?Press any key to close this window…"; exit ${1:-0}; }

echo "━━━ 0xKeep blog publisher ━━━"
echo

# Scripts opened from Finder don't always load your shell setup, so make sure node/npm are findable.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
command -v npm >/dev/null || { echo "✗ npm not found. Open Terminal, run 'which npm', and send the result to Claude."; finish 1; }

status() { node scripts/drafts-status.mjs 2>/dev/null; }   # refreshes the routine page's "drafts waiting" box

drafts=(drafts/*.md(N))
if (( ${#drafts} == 0 )); then
  status
  echo "No drafts waiting in blog/drafts/. Nothing to do."
  finish 0
fi

echo "Drafts ready to publish:"
for f in $drafts; do echo "  • ${${f:t}:r}"; done
echo
read -k1 "?Publish now? (y/n) " answer; echo
if [[ "$answer" != [yY] ]]; then
  echo "Cancelled. Nothing published."
  finish 0
fi
echo

echo "Getting the latest version of the blog…"
git checkout -q main || { echo "✗ Could not switch to main."; finish 1; }
git pull -q --ff-only || { echo "✗ git pull failed (see message above). Nothing published."; finish 1; }

added=()
for f in $drafts; do
  slug=${${f:t}:r}
  cp "$f" "src/pages/posts/$slug.md"
  added+=("src/pages/posts/$slug.md")
  if [[ -f "drafts/$slug.jpg" ]]; then
    mkdir -p public/images/posts
    cp "drafts/$slug.jpg" "public/images/posts/$slug.jpg"
    added+=("public/images/posts/$slug.jpg")
  fi
  echo "  + $slug"
done

echo
echo "Checking the blog builds (about 10–30 seconds)…"
if ! npm run build > /tmp/0xkeep-blog-build.log 2>&1; then
  echo "✗ BUILD FAILED — nothing was published. Undoing…"
  for p in $added; do
    if git ls-files --error-unmatch "$p" >/dev/null 2>&1; then git checkout -q -- "$p"; else rm -f "$p"; fi
  done
  echo "Drafts are untouched in blog/drafts/. Last lines of the build log:"
  tail -n 20 /tmp/0xkeep-blog-build.log
  echo "(Full log: /tmp/0xkeep-blog-build.log — paste it to Claude.)"
  finish 1
fi
echo "✓ Build OK"

git add -- $added
names=$(for f in $drafts; do echo -n "${${f:t}:r} "; done)
git commit -q -m "Publish: ${names% }" || { echo "✗ Commit failed."; finish 1; }
if ! git push -q origin main; then
  echo "✗ Push failed (see message above). The commit is saved locally; run 'git push' later or ask Claude."
  finish 1
fi

# Published: clear the drafts that went live.
for f in $drafts; do
  slug=${${f:t}:r}
  rm -f "$f" "drafts/$slug.jpg"
done
status

echo
echo "✓ Published. Live in about 2 minutes at:"
for f in $drafts; do echo "  https://blog.0x-keep.xyz/posts/${${f:t}:r}/"; done

# ── Hand each new post to X (free: no API). Rewrites have no x_post and are skipped. ──
xposts=()
for f in $drafts; do
  slug=${${f:t}:r}
  post="src/pages/posts/$slug.md"
  [[ -n "$(node scripts/x-post.mjs text "$post" 2>/dev/null)" ]] && xposts+=("$post")
done

if (( ${#xposts} > 0 )); then
  echo
  echo "Waiting for the post to go live before opening X (so the link preview works)…"
  for post in $xposts; do
    url="https://blog.0x-keep.xyz/posts/${${post:t}:r}/"
    for i in {1..18}; do   # up to ~3 minutes
      [[ "$(curl -s -o /dev/null -w '%{http_code}' "$url")" == "200" ]] && break
      sleep 10
    done
  done

  # Clipboard: all X texts (one per post, separated by a line), as a backup to the X window.
  clip=""
  for post in $xposts; do
    clip+="$(node scripts/x-post.mjs text "$post")"$'\n\n———\n\n'
  done
  printf "%s" "${clip%$'\n\n———\n\n'}" | pbcopy

  # Open X with the text already filled in, one tab per post. You just click Post.
  for post in $xposts; do
    open "$(node scripts/x-post.mjs intent "$post")"
  done

  echo "✓ X is open with the post filled in (also copied to your clipboard)."
  echo "  Check it, then click Post on X."
fi
finish 0

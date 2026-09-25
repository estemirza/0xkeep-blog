#!/bin/zsh
# ─────────────────────────────────────────────────────────────
# One-time setup: makes the "Publish blog" button on 0xKeep-routine.html work.
# Double-click this file in Finder. Safe to run again.
#
# It builds a tiny app, ~/Applications/0xKeep Publisher.app, that listens for
# links starting with oxkeep://publish and then opens "Publish drafts.command".
# The publisher still lists the drafts and asks y/n before pushing anything.
# ─────────────────────────────────────────────────────────────

finish() { echo; read -k1 "?Press any key to close this window…"; exit ${1:-0}; }

BLOG="$(cd "$(dirname "$0")/.." && pwd)"
PUBLISHER="$BLOG/Publish drafts.command"
APP="$HOME/Applications/0xKeep Publisher.app"
SRC="$(mktemp -t oxkeep).applescript"

echo "━━━ Installing the 0xKeep publish button ━━━"
[[ -f "$PUBLISHER" ]] || { echo "✗ Can't find $PUBLISHER"; finish 1; }
mkdir -p "$HOME/Applications"
rm -rf "$APP"

cat > "$SRC" <<EOF
on open location theURL
	if theURL starts with "oxkeep://publish" then
		do shell script "open " & quoted form of "$PUBLISHER"
	end if
end open location

on run
	display dialog "0xKeep Publisher is installed. Use the Publish button on your routine page." buttons {"OK"} default button 1 with title "0xKeep"
end run
EOF

osacompile -o "$APP" "$SRC" || { echo "✗ osacompile failed."; finish 1; }
rm -f "$SRC"

PL="$APP/Contents/Info.plist"
PB=/usr/libexec/PlistBuddy
$PB -c "Set :CFBundleIdentifier xyz.0x-keep.publisher" "$PL" 2>/dev/null || $PB -c "Add :CFBundleIdentifier string xyz.0x-keep.publisher" "$PL"
$PB -c "Delete :CFBundleURLTypes" "$PL" 2>/dev/null
$PB -c "Add :CFBundleURLTypes array" \
    -c "Add :CFBundleURLTypes:0 dict" \
    -c "Add :CFBundleURLTypes:0:CFBundleURLName string 0xKeep Publisher" \
    -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes array" \
    -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string oxkeep" "$PL"
$PB -c "Add :LSUIElement bool true" "$PL" 2>/dev/null

# Info.plist changed, so re-sign (ad-hoc, local only) or macOS refuses to open it.
codesign --force --deep --sign - "$APP" >/dev/null 2>&1 || { echo "✗ codesign failed."; finish 1; }

# Tell macOS the app handles oxkeep:// links.
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP"

echo "✓ Installed: $APP"
echo
echo "Test it: open your routine page in Brave and click \"Publish blog\"."
echo "Brave will ask \"Open 0xKeep Publisher?\" the first time. Tick 'Always allow' and click Open."
finish 0

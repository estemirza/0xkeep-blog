// Writes ../docs/x/drafts.js: the list of drafts waiting in blog/drafts/.
// The routine page (0xKeep-routine.html) reads it to show "N drafts waiting".
// Run from the blog folder: node scripts/drafts-status.mjs
// Called by "Publish drafts.command"; the content agent writes the same file after saving a draft.

import { readdirSync, readFileSync, writeFileSync, existsSync } from "node:fs";

const DIR = "drafts";
const OUT = "../docs/x/drafts.js";

const drafts = existsSync(DIR)
  ? readdirSync(DIR).filter((f) => f.endsWith(".md")).map((f) => {
      const src = readFileSync(`${DIR}/${f}`, "utf8");
      const title = (src.match(/^title:\s*(.+)$/m)?.[1] ?? f).trim().replace(/^["']|["']$/g, "");
      const date = src.match(/^date:\s*(.+)$/m)?.[1]?.trim() ?? "";
      return { slug: f.replace(/\.md$/, ""), title, date };
    })
  : [];

if (existsSync("../docs/x")) {
  writeFileSync(
    OUT,
    "// Drafts waiting in blog/drafts/. Rewritten by the publisher and the content agent.\n" +
      `window.X_DRAFTS = ${JSON.stringify(drafts, null, 2)};\n` +
      `window.X_DRAFTS_UPDATED = ${JSON.stringify(new Date().toISOString())};\n`
  );
}

// Reads the `x_post:` text the content agent put in a post's frontmatter and
// prints what "Publish drafts.command" needs to hand the post to X.
//
//   node scripts/x-post.mjs text   src/pages/posts/<slug>.md   → "<x_post>\n\n<article url>"
//   node scripts/x-post.mjs intent src/pages/posts/<slug>.md   → https://x.com/intent/post?text=…
//
// Prints nothing (exit 0) if the post has no x_post. No API, no keys, no cost:
// the intent link just opens X with the text pre-filled; Mirza clicks Post.

import { readFileSync } from "node:fs";

const SITE = "https://blog.0x-keep.xyz";
const [mode, file] = process.argv.slice(2);

function readXPost(path) {
  const src = readFileSync(path, "utf8");
  const fm = src.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!fm) return null;
  const lines = fm[1].split(/\r?\n/);
  const i = lines.findIndex((l) => /^x_post:/.test(l));
  if (i === -1) return null;
  const rest = lines[i].replace(/^x_post:\s*/, "");
  if (rest === "|" || rest === ">") {
    const block = [];
    for (let j = i + 1; j < lines.length && (/^\s+/.test(lines[j]) || lines[j] === ""); j++) {
      block.push(lines[j].replace(/^\s{2}/, ""));
    }
    return block.join(rest === "|" ? "\n" : " ").trim();
  }
  return rest.replace(/^["']|["']$/g, "").trim();
}

const slug = file.split("/").pop().replace(/\.md$/, "");
const url = `${SITE}/posts/${slug}/`;
const text = readXPost(file);
if (!text) process.exit(0);

const full = `${text}\n\n${url}`;
if (mode === "intent") {
  process.stdout.write(`https://x.com/intent/post?text=${encodeURIComponent(full)}`);
} else {
  process.stdout.write(full);
}

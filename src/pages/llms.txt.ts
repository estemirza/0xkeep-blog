// Generates /llms.txt at build time: a plain-text index of every post for AI tools.
import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ site }) => {
  const posts: any[] = Object.values(import.meta.glob('./posts/*.md', { eager: true }));
  posts.sort((a, b) => new Date(b.frontmatter.date).valueOf() - new Date(a.frontmatter.date).valueOf());

  const origin = (site?.href ?? 'https://blog.0x-keep.xyz/').replace(/\/$/, '');
  const line = (p: any) =>
    `- [${p.frontmatter.title}](${origin}${p.url.replace(/\/$/, '')}/): ${p.frontmatter.description ?? ''}`.trim();

  const isNews = (p: any) => (p.frontmatter.tags ?? []).includes('News');
  const guides = posts.filter((p) => !isNews(p));
  const news = posts.filter(isNews);

  const body = `# 0xKeep Blog

> Guides, research and security analysis on liquidity locks, token vesting and rug-pull prevention, from the team behind 0xKeep: an immutable, non-custodial ERC-20 locker and vesting contract on Base (free), Arbitrum and Optimism.

Product facts, contract addresses and the read-only JSON API are in https://0x-keep.xyz/llms.txt

## Guides and explainers

${guides.map(line).join('\n')}

## Optional

News and incident write-ups (time-sensitive):

${news.map(line).join('\n')}
`;

  return new Response(body, { headers: { 'Content-Type': 'text/plain; charset=utf-8' } });
};

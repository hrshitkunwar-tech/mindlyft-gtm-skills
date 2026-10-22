# GTM Skills for Claude

Three Claude agent skills for go-to-market work: writing outbound that gets replies, checking
whether a "free" tool is really free, and validating and pricing an offer. Each skill is a single
`SKILL.md` with frontmatter, so it works anywhere Claude skills are supported.

## Skills

- **[cold-email-that-books](skills/cold-email-that-books/SKILL.md)**: reply-first B2B cold email and short sequences, built on triggers, deliverability basics and clear refusal rules.
- **[free-claim-audit](skills/free-claim-audit/SKILL.md)**: a ten-failure-mode check, plus a one-command GitHub repo audit, for any "free" or "open-source" claim.
- **[offer-validation-and-pricing](skills/offer-validation-and-pricing/SKILL.md)**: validate demand from competitor reviews and proof of payment, then match the price argument to the price point.

## Install

Clone the repo and copy the skill folders you want into your Claude skills directory:

```bash
git clone https://github.com/hrshitkunwar-tech/mindlyft-gtm-skills.git
cp -r mindlyft-gtm-skills/skills/cold-email-that-books "$HOME/.claude/skills/"
```

Or install a single skill with the `skills` CLI:

```bash
npx skills add hrshitkunwar-tech/mindlyft-gtm-skills/cold-email-that-books
```

The `free-claim-audit` script needs
`bash`, `curl` and `python3`; set `GITHUB_TOKEN` to raise GitHub API rate limits.

## License

MIT. See [LICENSE](LICENSE).

---

Built by Mindlyft (https://mindlyft.io). Free GTM review: https://mindlyft.io/start. More skill packs: https://mindlyft.shop

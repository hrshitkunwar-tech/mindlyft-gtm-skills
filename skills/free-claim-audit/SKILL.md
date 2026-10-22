---
name: free-claim-audit
description: Audit any "free", "open-source", "free forever" or "$0" claim about a tool, repo, model or website before adopting it, recommending it, or repeating the claim in your own content. A ten-failure-mode checklist plus a one-command GitHub repo audit (identity and renames, licence red flags, README cost and requirement lines, same-name copy check). Use when a post, video, tweet or colleague says a tool is free; when building a list of free tools; or when someone asks "is X actually free, open source, or OK to use commercially".
---

# Free Claim Audit

Social posts about "free" tools are marketing. The repository's own files, the licence text and the
vendor's pricing page are the source of truth. A large share of "free" claims fail on inspection,
usually in one of the ten ways below.

## The ten ways "free" fails

| # | Failure | What it looks like | How to catch it |
|---|---|---|---|
| 1 | **The repo does not exist, or it is the wrong one** | A name shown on screen returns 404 | Query the GitHub API for `repos/OWNER/NAME` |
| 2 | **A low-star copy was filmed instead of the original** | Same project name, a handful of stars, while the original has thousands | Search the repo name sorted by stars; check the "forked from" field |
| 3 | **The licence is not free for commercial use** | Creative Commons NonCommercial, or a custom licence the API reports as `NOASSERTION`. AGPL-3.0 is fine to run internally but has obligations if you modify and offer it over a network | Read the LICENSE file itself, never only the API's SPDX field |
| 4 | **The licence carves out territory, scale or use** | Some model licences exclude whole regions or require a separate licence above a monthly-active-user threshold | Search the LICENSE for territory, "monthly active", "non-commercial", "research purposes" |
| 5 | **The code is free, the weights or data are not** | MIT code alongside model weights under a vendor licence, often gated behind a sign-up | Read the README licence section and the model card separately |
| 6 | **Free to clone, paid to run** | Requires a paid model plan, a paid scraping API, usage credits or a hosted service to do anything useful | README lines mentioning paid, pricing, credits, "requires", API keys; any model or vendor name visible in a demo |
| 7 | **The name is withheld** ("comment a keyword for the link") | Repo names blurred or cropped | Resolve by vendor org, description and star count; label the result "inferred", never "confirmed" |
| 8 | **The "free tool" is the author's own email-gated funnel** | Several separately branded single-page tools that all share one owner, ask for marketing consent and end by selling one paid product | Visit each domain; read the footer, the consent checkbox and the after-submit call to action |
| 9 | **A public framework renamed as a proprietary system** | "The N-step system" that turns out to be a well-known loop (OODA, PDCA, AIDA, Jobs-to-be-Done) with a filler step added, sold behind a consultation | Count the steps against known frameworks; a padding step like "repeat" is the tell |
| 10 | **Provenance claims the project itself contradicts, or no pricing at all** | A news piece credits a project to reverse-engineering while the README says it was a clean-room implementation; a product announced as "now free" with no pricing page | Search the README for clean-room, provenance, "not affiliated"; request `/pricing` and record the HTTP status |

## Procedure

1. **Get the exact owner and name from the screen or a file, never from audio or a transcript.**
   Speech-to-text mangles names. If the name is withheld, use check 7 and label the result as
   inferred.
2. **Run the repo audit** (requires `curl` and `python3`; no token needed):
   ```bash
   bash scripts/fca.sh OWNER/NAME
   ```
   It prints identity (following renames), stars, the API licence, archived flag, last push date and
   fork parent; LICENSE lines matching common restriction terms; README lines about cost and
   requirements; and the top three same-name repositories by stars.
   Unauthenticated GitHub search is rate limited to a few requests a minute. If the output says
   `SEARCH UNAVAILABLE`, wait a minute and rerun; do not read it as "no copies exist". Set
   `GITHUB_TOKEN` in your environment to raise the limit.
3. **Read what it flags.** The script finds lines; a human judges them. `NOASSERTION` always means
   "open the LICENSE file and read it".
4. **Price the runtime.** For every "requires" line, open the vendor's own pricing page and write
   down the free-tier limit and the date you checked. For models that need a GPU, note the minimum
   VRAM.
5. **If the claim names websites rather than repos, visit each one.** Record the owner (footer,
   terms page), what the sign-up consents you to, and where the after-submit flow sends you. A
   single-page tool that costs an email address plus marketing consent and ends by selling one
   product is failure mode 8. Describe it as "free tier, owned by X, leads to Y", not as a neutral
   find.
6. **Check the terms-of-service surface.** Anything that automates a social network, scrapes behind
   a login, or sends email at volume carries account-restriction risk. Name that risk explicitly in
   the verdict.
7. **Write a one-line verdict:**
   - `REAL`: free, permissive licence, no runtime bill.
   - `MIXED: <which failure modes>`: usable, with the named caveats.
   - `HYPE: <what the files say instead>`: the claim is contradicted by the source.

## Pre-flight before shipping a verdict or any copy that says "free"

- [ ] The owner and name came from a screen or a file, not from audio.
- [ ] The audit ran, and its key lines are quoted with the date.
- [ ] The LICENSE text was read whenever the SPDX field is `NOASSERTION` or a custom licence.
- [ ] Every runtime dependency has a price or "free tier: X, checked on <date>".
- [ ] Every website named as a "free tool" was visited, and its owner and paid destination are
      written down.
- [ ] The copy never says "free forever". Prefer precise wording such as "MIT licensed, free to
      self-host; runs on your own API key".
- [ ] AGPL, non-commercial and territory-restricted licences are named wherever the tool is
      recommended.

## Where results go

- **A list or catalogue of free tools:** each entry carries its verdict, its licence and the date
  checked.
- **A contradicted claim in something you saved or were sent:** add a short correction note next to
  it so the claim does not get repeated later.
- **A "free" claim in your own content:** fix the copy before it ships.

## Notes

- This is not legal advice. For anything you will redistribute, host for others or build a
  business on, have someone qualified read the licence.
- Licences and pricing change. A verdict is only as good as the date on it.

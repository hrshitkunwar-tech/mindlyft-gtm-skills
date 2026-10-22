#!/usr/bin/env bash
# free-claim-audit: fca.sh OWNER/NAME
# Prints repo identity, licence red flags, README cost/requirement lines, and a same-name copy check.
# Requires curl and python3. Optional: export GITHUB_TOKEN to raise GitHub API rate limits.
set -u
R="${1:-}"
[ -z "$R" ] && { echo "usage: fca.sh OWNER/NAME"; exit 2; }

AUTH=()
[ -n "${GITHUB_TOKEN:-}" ] && AUTH=(-H "Authorization: Bearer $GITHUB_TOKEN")

META=$(curl -sL ${AUTH[@]+"${AUTH[@]}"} "https://api.github.com/repos/$R")
FULL=$(printf '%s' "$META" | python3 -c '
import json, sys
d = json.load(sys.stdin)
if "full_name" not in d:
    print("NOT FOUND:", d.get("message"), file=sys.stderr); sys.exit(1)
p = (d.get("parent") or {}).get("full_name")
print("repo:", d["full_name"], "| stars:", d["stargazers_count"],
      "| licence:", (d.get("license") or {}).get("spdx_id"),
      "| archived:", d["archived"], "| last push:", (d.get("pushed_at") or "")[:10],
      "| fork of:", p, file=sys.stderr)
print(d["full_name"])') || exit 1

L=""
for f in LICENSE LICENSE.md LICENSE.txt COPYING; do
  L=$(curl -sfL "https://raw.githubusercontent.com/$FULL/HEAD/$f") && break
done
echo "-- LICENSE red flags:"
if [ -z "$L" ]; then
  echo "   no LICENSE file found at the repo root (no licence = all rights reserved)"
else
  printf '%s\n' "$L" | grep -n -i -E "non-?commercial|territory|monthly active|european union|does not apply|research purpose|personal use|attribution-noncommercial|acceptable use" | head -5 | cut -c1-180
fi

echo "-- README cost/requirement lines:"
curl -sfL "https://raw.githubusercontent.com/$FULL/HEAD/README.md" \
  | grep -n -i -E "paid|pricing|pay-as-you-go|subscription|credits|requires? (a|an) |_API_KEY|api key|free tier|license" \
  | head -8 | cut -c1-180

echo "-- same-name copies (by stars):"
N="${FULL#*/}"
curl -s ${AUTH[@]+"${AUTH[@]}"} "https://api.github.com/search/repositories?q=$N+in:name&sort=stars&per_page=3" | python3 -c '
import json, sys
d = json.load(sys.stdin); it = d.get("items")
if it is None:
    print("   SEARCH UNAVAILABLE (", (d.get("message") or "?")[:60], ") - rerun in 60 s; do NOT read as no copies")
elif not it:
    print("   no same-name repos found")
else:
    for r in it: print("  ", r["full_name"], r["stargazers_count"])'

#!/usr/bin/env bash
# Regenerates labels.json: every label defined inside a block -> that block's doc-title. lib.typ reads it so that a plain @label can degrade gracefully when its block is not part of the current build.
# Requires bash, grep, sed and awk.
#
set -euo pipefail
cd "$(dirname "$0")/.."

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# Labels defined in the given files, one per line.
labels_in() {
    # <label> definitions. A citation key is also written <key>, so skip those:
    # they follow "(" (#cite(<key>)) or are followed by "," or ")" (a key on
    # its own line inside a multi-line #cite(...) call).
    grep -ohE '(^|[^(])<[A-Za-z0-9_.:-]+>([^,)]|$)' "$@" | grep -oE '<[A-Za-z0-9_.:-]+>' | tr -d '<>' || true
    # tag: "name" arguments (block-layout and sourced-figure)
    grep -ohE 'tag:[[:space:]]*"[^"]+"' "$@" | sed -E 's/.*"([^"]+)"/\1/' || true
}

# Files OUTSIDE the block directories that also define labels, as
# "path|name shown when the label is referenced but the file is not in the build".
# Paths are relative to the project root. Add the preface here, and any
# other front/back matter that blocks might point at.
extras=(
    "preface.typ|Preface"
)

# A block template is any <dir>/*.typ that calls block-layout(
for tpl in $(grep -l 'block-layout(' */*.typ); do
    dir=$(dirname "$tpl")
    title=$(sed -nE 's/^[[:space:]]*doc-title:[[:space:]]*"(.*)",?[[:space:]]*$/\1/p' "$tpl" | head -n1)
    if [[ -z "$title" ]]; then
        echo "labels.sh: no doc-title found in $tpl" >&2
        exit 1
    fi
    labels_in "$dir"/*.typ | sort -u | awk -v t="$title" '{ print $0 "\t" t }' >>"$tmp"
done

for entry in "${extras[@]}"; do
    file=${entry%%|*}
    name=${entry#*|}
    if [[ ! -f "$file" ]]; then
        echo "labels.sh: extra file $file not found (check the extras list)" >&2
        exit 1
    fi
    labels_in "$file" | sort -u | awk -v t="$name" '{ print $0 "\t" t }' >>"$tmp"
done

# A label defined twice (in two blocks, or a block and an extra file) is an error (Typst labels must be unique
# across the whole document anyway).
awk -F'\t' '
  { if ($1 in owner && owner[$1] != $2) {
      printf "labels.sh: label <%s> is defined in both \"%s\" and \"%s\"\n", $1, owner[$1], $2 > "/dev/stderr"
      bad = 1
    }
    owner[$1] = $2 }
  END { if (bad) exit 1; for (k in owner) print k "\t" owner[k] }
' "$tmp" | sort -t "$(printf '\t')" -k1,1 | awk -F'\t' '
  { key[NR] = $1; val[NR] = $2 }
  END {
    printf "{\n"
    for (i = 1; i <= NR; i++) {
      v = val[i]; gsub(/\\/, "\\\\", v); gsub(/"/, "\\\"", v)
      printf "  \"%s\": \"%s\"%s\n", key[i], v, (i < NR ? "," : "")
    }
    printf "}\n"
  }' >labels.json.new
mv labels.json.new labels.json
echo "labels.sh: wrote labels.json ($(grep -c '": "' labels.json) labels)"

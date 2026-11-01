#!/usr/bin/env bash
# Adds missing label tags to every block and to its level 3 and 4 headings.
#
#   block template     tag: "block-name"                (block-name = directory name)
#   level 3/4 heading  <block-name_heading-name>        (heading-name = slugified title)
#
#This script only adds labels, it doesn't overwrite.
set -euo pipefail
cd "$(dirname "$0")/.."

# Labels defined in the given files (same rules as labels.sh).
labels_in() {
    grep -ohE '(^|[^(])<[A-Za-z0-9_.:-]+>([^,)]|$)' "$@" | grep -oE '<[A-Za-z0-9_.:-]+>' | tr -d '<>' || true
    grep -ohE 'tag:[[:space:]]*"[^"]+"' "$@" | sed -E 's/.*"([^"]+)"/\1/' || true
}

used=$(mktemp)
trap 'rm -f "$used"' EXIT

for tpl in $(grep -l 'block-layout(' */*.typ); do
    dir=$(dirname "$tpl")
    block=$(basename "$dir")

    # 1. The block's own tag, inserted after the `standalone: standalone,` line.
    if ! grep -qE '^[[:space:]]*tag:' "$tpl"; then
        if grep -qE '^[[:space:]]*standalone:[[:space:]]*standalone,' "$tpl"; then
            sed -i -E "s/^([[:space:]]*)standalone:[[:space:]]*standalone,[[:space:]]*$/&\n\1tag: \"$block\",/" "$tpl"
            echo "tags.sh: $tpl: added tag: \"$block\"" >&2
            echo "$tpl"
        else
            echo "tags.sh: warning: $tpl has no 'standalone: standalone,' line to anchor a tag on; add tag: \"$block\" by hand" >&2
        fi
    fi

    # 2. Headings in every other .typ file of the block.
    labels_in "$dir"/*.typ | sort -u >"$used"
    files=()
    for f in "$dir"/*.typ; do
        [[ "$f" == "$tpl" ]] || files+=("$f")
    done
    [[ ${#files[@]} -gt 0 ]] || continue

    awk -v block="$block" -v usedfile="$used" '
    function slug(t,   s) {
      s = t
      gsub(/#(footnote|index|index-main|index-start|index-end)\[[^]]*\]/, "", s)
      gsub(/#[A-Za-z-]+\[/, "", s)
      gsub(/\]/, "", s)
      gsub(/[_*]/, "", s)
      s = tolower(s)
      gsub("ä", "ae", s); gsub("ö", "oe", s); gsub("ü", "ue", s); gsub("ß", "ss", s)
      gsub("Ä", "ae", s); gsub("Ö", "oe", s); gsub("Ü", "ue", s)
      gsub("[áàâãå]", "a", s); gsub("[éèêë]", "e", s); gsub("[íìîï]", "i", s)
      gsub("[óòôõø]", "o", s); gsub("[úùû]", "u", s); gsub("ç", "c", s); gsub("ñ", "n", s)
      gsub("’", "", s); gsub("\047", "", s)
      gsub(/[^a-z0-9]+/, "-", s)
      sub(/^-+/, "", s); sub(/-+$/, "", s)
      return s
    }
    FILENAME == usedfile { used[$0] = 1; next }
    FNR == 1 { if (out != "") close(out); out = FILENAME ".tagnew" }
    {
      line = $0; level = 0; title = ""
      haslabel = (line ~ /<[A-Za-z0-9_.:-]+>[ \t]*$/)
      if (line ~ /^(===|====)[ \t]/) {
        tmp = line; sub(/[ \t].*$/, "", tmp); level = length(tmp)
        title = line; sub(/^(===|====)[ \t]+/, "", title); sub(/[ \t]*<[A-Za-z0-9_.:-]+>[ \t]*$/, "", title)
      } else if (line ~ /^[ \t]*#heading\([ \t]*$/) {
        print "tags.sh: warning: " FILENAME ":" FNR ": multi-line #heading( not tagged, add its label by hand" > "/dev/stderr"
      } else if (line ~ /^[ \t]*#heading\(.*level:[ \t]*[34]/ && line ~ /\)\[.*\][ \t]*(<[A-Za-z0-9_.:-]+>)?[ \t]*$/) {
        match(line, /level:[ \t]*[34]/); level = substr(line, RSTART + RLENGTH - 1, 1) + 0
        title = line; sub(/^.*\)\[/, "", title); sub(/\][ \t]*(<[A-Za-z0-9_.:-]+>)?[ \t]*$/, "", title)
      }
      if (level > 0) {
        s = slug(title)
        if (s == "") {
          print "tags.sh: warning: " FILENAME ":" FNR ": cannot make a label from this heading, add one by hand" > "/dev/stderr"
        } else {
          if (!haslabel) {
            cand = block "_" s
            if ((cand in used) && level == 4 && parent != "") cand = block "_" parent "_" s
            base = cand; n = 2
            while (cand in used) { cand = base "-" n; n++ }
            used[cand] = 1
            sub(/[ \t]+$/, "", line); line = line " <" cand ">"
            print "tags.sh: " FILENAME ":" FNR ": added <" cand ">" > "/dev/stderr"
          }
          if (level == 3) parent = s
        }
      }
      print line > out
    }
    END { close(out) }
  ' "$used" "${files[@]}"

    for f in "${files[@]}"; do
        [[ -f "$f.tagnew" ]] || continue
        if cmp -s "$f" "$f.tagnew"; then rm -f "$f.tagnew"; else
            mv "$f.tagnew" "$f"
            echo "$f"
        fi
    done
done

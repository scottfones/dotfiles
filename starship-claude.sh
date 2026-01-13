#!/bin/bash
# Claude Code Status Line - Gruvbox Dark Theme
# Matches starship.toml configuration with powerline segments

# ═══════════════════════════════════════════════════════════════════════════════
# Unicode Characters (bash escape sequences - hex-verified from starship.toml)
# ═══════════════════════════════════════════════════════════════════════════════

# Powerline separators
ARROW=$'\ue0b0'              # U+E0B0 - Right powerline arrow
ARROW_LEFT=$'\ue0b6'         # U+E0B6 - Left rounded cap

# Nerd Font icons (3-byte UTF-8)
ICON_STAR=$'\uf005'          # U+F005 - Star (for model)
ICON_CLOCK=$'\uf017'         # U+F017 - Clock
ICON_HOURGLASS=$'\uf252'     # U+F252 - Hourglass
ICON_BRANCH=$'\uf418'        # U+F418 - Git branch
ICON_C=$'\ue61e'             # U+E61E
ICON_CPP=$'\ue61d'           # U+E61D
ICON_CMAKE=$'\ue794'         # U+E794
ICON_DENO=$'\ue7c0'          # U+E7C0
ICON_DOCKER=$'\uf308'        # U+F308
ICON_ELIXIR=$'\ue62d'        # U+E62D
ICON_GO=$'\ue627'            # U+E627
ICON_GRADLE=$'\ue660'        # U+E660
ICON_HASKELL=$'\ue777'       # U+E777
ICON_JAVA=$'\ue256'          # U+E256
ICON_KOTLIN=$'\ue634'        # U+E634
ICON_LUA=$'\ue620'           # U+E620
ICON_NIX=$'\uf313'           # U+F313
ICON_NODEJS=$'\ue718'        # U+E718
ICON_OCAML=$'\ue67a'         # U+E67A
ICON_PERL=$'\ue67e'          # U+E67E
ICON_PHP=$'\ue608'           # U+E608
ICON_PYTHON=$'\ue235'        # U+E235
ICON_RUBY=$'\ue791'          # U+E791
ICON_SCALA=$'\ue737'         # U+E737
ICON_SWIFT=$'\ue755'         # U+E755
ICON_ZIG=$'\ue6a9'           # U+E6A9

# Nerd Font icons (4-byte UTF-8 - need capital U)
ICON_RUST=$'\U000f1617'      # U+F1617

# ═══════════════════════════════════════════════════════════════════════════════
# Gruvbox Dark Color Palette (ANSI escape sequences)
# ═══════════════════════════════════════════════════════════════════════════════

# Background colors
BG_ORANGE="\e[48;2;214;93;14m"     # #d65d0e
BG_YELLOW="\e[48;2;215;153;33m"    # #d79921
BG_AQUA="\e[48;2;104;157;106m"     # #689d6a
BG_BLUE="\e[48;2;69;133;136m"      # #458588
BG_BG3="\e[48;2;102;92;84m"        # #665c54
BG_BG1="\e[48;2;60;56;54m"         # #3c3836

# Foreground colors
FG_FG0="\e[38;2;251;241;199m"      # #fbf1c7 (light cream text)
FG_BG1="\e[38;2;60;56;54m"         # #3c3836 (dark text)

# Transition colors (fg=leaving, bg=entering)
FG_ORANGE="\e[38;2;214;93;14m"
FG_YELLOW="\e[38;2;215;153;33m"
FG_AQUA="\e[38;2;104;157;106m"
FG_BLUE="\e[38;2;69;133;136m"
FG_BG3="\e[38;2;102;92;84m"

RESET="\e[0m"

# ═══════════════════════════════════════════════════════════════════════════════
# Constants
# ═══════════════════════════════════════════════════════════════════════════════

FIVE_HOURS_MS=$((5 * 60 * 60 * 1000))
HISTORY_FILE="$HOME/.claude/history.jsonl"

# Effective context percentage: auto-compact and other features reserve ~38% of
# the 200K context window. This value should match what terminal shows as "Context
# left until auto-compaction". Adjust if your settings differ.
EFFECTIVE_CONTEXT_PCT=62

# ═══════════════════════════════════════════════════════════════════════════════
# Read JSON Input
# ═══════════════════════════════════════════════════════════════════════════════

INPUT=$(cat)

# ═══════════════════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════════════════

format_duration() {
    local ms=$1
    local total_min=$((ms / 60000))
    local hours=$((total_min / 60))
    local mins=$((total_min % 60))

    if [[ $hours -gt 0 ]]; then
        printf "%dh %dm" "$hours" "$mins"
    else
        printf "%dm" "$mins"
    fi
}

format_minutes() {
    local total_min=$1
    local hours=$((total_min / 60))
    local mins=$((total_min % 60))

    if [[ $hours -gt 0 ]]; then
        printf "%dh %dm" "$hours" "$mins"
    else
        printf "%dm" "$mins"
    fi
}

format_tokens() {
    local tokens=$1
    if [[ $tokens -ge 1000000 ]]; then
        printf "%dM" "$((tokens / 1000000))"
    elif [[ $tokens -ge 1000 ]]; then
        printf "%dK" "$((tokens / 1000))"
    else
        printf "%d" "$tokens"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# Line 1 Segments
# ═══════════════════════════════════════════════════════════════════════════════

# Segment 1: Directory (orange)
directory_segment() {
    local dir

    if command -v jq &>/dev/null && [[ -n "$INPUT" ]]; then
        dir=$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // empty' 2>/dev/null)
    fi

    [[ -z "$dir" ]] && dir=$(pwd)

    # Replace home with ~
    [[ "$dir" == "$HOME"* ]] && dir="~${dir#$HOME}"

    # Truncate to last 3 components
    IFS='/' read -ra ADDR <<< "$dir"
    if [[ ${#ADDR[@]} -gt 3 ]] && [[ "$dir" != "~" ]]; then
        dir=".../${ADDR[-2]}/${ADDR[-1]}"
    fi

    # Add rounded left cap to match line 2's style
    printf "${FG_ORANGE}${ARROW_LEFT}${RESET}${BG_ORANGE}${FG_FG0} ${dir} ${RESET}"
}

# Segment: Model (yellow) - starts line 2 with rounded left cap
model_segment() {
    if command -v jq &>/dev/null && [[ -n "$INPUT" ]]; then
        local model=$(echo "$INPUT" | jq -r '.model.display_name // empty' 2>/dev/null)

        if [[ -n "$model" ]] && [[ "$model" != "null" ]]; then
            printf "${FG_YELLOW}${ARROW_LEFT}${RESET}${BG_YELLOW}${FG_BG1} ${ICON_STAR} ${model} ${RESET}"
        else
            printf "${FG_YELLOW}${ARROW_LEFT}${RESET}"
        fi
    else
        printf "${FG_YELLOW}${ARROW_LEFT}${RESET}"
    fi
}

# Segment 3: Reset time (aqua) - time until 5-hour window resets
reset_time_segment() {
    local remaining_formatted="5h"

    if [[ -f "$HISTORY_FILE" ]]; then
        local now_ms=$(($(date +%s) * 1000))
        local window_start=$((now_ms - FIVE_HOURS_MS))

        local earliest
        earliest=$(jq -s "[.[] | select(.timestamp >= $window_start)] | min_by(.timestamp) | .timestamp // null" "$HISTORY_FILE" 2>/dev/null)

        if [[ -n "$earliest" ]] && [[ "$earliest" != "null" ]]; then
            local floored=$((earliest / 3600000 * 3600000))
            local window_end=$((floored + FIVE_HOURS_MS))
            local remaining_ms=$((window_end - now_ms))

            if [[ $remaining_ms -le 0 ]]; then
                remaining_formatted="reset"
            else
                local remaining_min=$((remaining_ms / 60000))
                remaining_formatted=$(format_minutes "$remaining_min")
            fi
        fi
    fi

    printf "${FG_YELLOW}${BG_AQUA}${ARROW}${RESET}${BG_AQUA}${FG_FG0} ${ICON_HOURGLASS} ${remaining_formatted} ${RESET}"
}

# Segment 4: Session time (blue)
session_time_segment() {
    local formatted=""

    if command -v jq &>/dev/null && [[ -n "$INPUT" ]]; then
        local duration_ms=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0' 2>/dev/null)

        if [[ "$duration_ms" -gt 0 ]]; then
            formatted=$(format_duration "$duration_ms")
        fi
    fi

    if [[ -n "$formatted" ]]; then
        printf "${FG_AQUA}${BG_BLUE}${ARROW}${RESET}${BG_BLUE}${FG_FG0} ${ICON_CLOCK} ${formatted} ${RESET}"
    else
        printf "${FG_AQUA}${BG_BLUE}${ARROW}${RESET}"
    fi
}

# Segment: Context (bg3/yellow/orange) - with compaction warning colors
# Uses cache_read_input_tokens (matches terminal display) and calculates % USED
# based on effective context limit (EFFECTIVE_CONTEXT_PCT of context_window_size)
# This is now the LAST segment on line 2, so it outputs its own trailing arrow
context_segment() {
    if command -v jq &>/dev/null && [[ -n "$INPUT" ]]; then
        # Use cache_read_input_tokens - this matches the terminal's "X tokens" display
        local cache_tokens=$(echo "$INPUT" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0' 2>/dev/null)
        local context_size=$(echo "$INPUT" | jq -r '.context_window.context_window_size // 200000' 2>/dev/null)
        local formatted_tokens=$(format_tokens "$cache_tokens")

        # Calculate effective limit and used percentage
        # Auto-compact reserves ~38% of context, so effective limit is ~62% of 200K
        local effective_limit=$((context_size * EFFECTIVE_CONTEXT_PCT / 100))
        local used_pct=0
        if [[ $effective_limit -gt 0 ]] && [[ $cache_tokens -gt 0 ]]; then
            used_pct=$((cache_tokens * 100 / effective_limit))
            # Cap at 100% to avoid overflow display
            [[ $used_pct -gt 100 ]] && used_pct=100
        fi

        # Determine colors based on context usage
        local ctx_bg="$BG_BG3"
        local ctx_fg_prev="${FG_BLUE}${BG_BG3}"
        local ctx_fg_trail="$FG_BG3"  # For trailing arrow

        # Warn when usage is HIGH (approaching compaction)
        if [[ $used_pct -ge 90 ]]; then
            # Critical: 90%+ used - compaction imminent
            ctx_bg="$BG_ORANGE"
            ctx_fg_prev="\e[38;2;69;133;136m\e[48;2;214;93;14m"
            ctx_fg_trail="$FG_ORANGE"
        elif [[ $used_pct -ge 75 ]]; then
            # Warning: 75%+ used - compaction approaching
            ctx_bg="$BG_YELLOW"
            ctx_fg_prev="\e[38;2;69;133;136m\e[48;2;215;153;33m"
            ctx_fg_trail="$FG_YELLOW"
        fi

        if [[ $cache_tokens -gt 0 ]]; then
            # Show formatted token count + USED percentage (increasing toward compaction)
            # Include trailing arrow with correct color
            printf "${ctx_fg_prev}${ARROW}${RESET}${ctx_bg}${FG_FG0} ${formatted_tokens} ${used_pct}%% ${RESET}${ctx_fg_trail}${ARROW}${RESET}"
        else
            # No tokens - just show transition through and trailing arrow
            printf "${FG_BLUE}${BG_BG3}${ARROW}${RESET}${FG_BG3}${ARROW}${RESET}"
        fi
    else
        # No jq/input - just show transition through and trailing arrow
        printf "${FG_BLUE}${BG_BG3}${ARROW}${RESET}${FG_BG3}${ARROW}${RESET}"
    fi
}

# Segment 6: Language detection (bg1) - detects ALL languages like starship
language_segment() {
    local dir

    if command -v jq &>/dev/null && [[ -n "$INPUT" ]]; then
        dir=$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // empty' 2>/dev/null)
    fi
    [[ -z "$dir" ]] && dir=$(pwd)

    # Collect ALL detected languages (not just first match)
    local -a langs=()  # Array of "icon|version" pairs

    # Check each language independently (no elif - collect all!)
    if [[ -f "$dir/Cargo.toml" ]]; then
        local v=$(rustc --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        langs+=("${ICON_RUST}|${v}")
    fi
    if [[ -f "$dir/go.mod" ]]; then
        local v=$(go version 2>/dev/null | grep -oE 'go[0-9]+\.[0-9]+(\.[0-9]+)?' | sed 's/go//' | head -1)
        langs+=("${ICON_GO}|${v}")
    fi
    if [[ -f "$dir/package.json" ]] || [[ -d "$dir/node_modules" ]]; then
        local v=$(node --version 2>/dev/null | tr -d 'v')
        langs+=("${ICON_NODEJS}|${v}")
    fi
    if [[ -f "$dir/pyproject.toml" ]] || [[ -f "$dir/requirements.txt" ]]; then
        local v=$(python --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        langs+=("${ICON_PYTHON}|${v}")
    fi
    if [[ -f "$dir/Gemfile" ]]; then
        local v=$(ruby --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        langs+=("${ICON_RUBY}|${v}")
    fi
    if [[ -f "$dir/mix.exs" ]]; then
        local v=$(elixir --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        langs+=("${ICON_ELIXIR}|${v}")
    fi
    if ls "$dir"/*.cabal &>/dev/null || [[ -f "$dir/stack.yaml" ]]; then
        local v=$(ghc --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        langs+=("${ICON_HASKELL}|${v}")
    fi
    if ls "$dir"/build.gradle* &>/dev/null; then
        local v=$(gradle --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
        langs+=("${ICON_GRADLE}|${v}")
    fi
    if [[ -f "$dir/pom.xml" ]]; then
        local v=$(java --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        langs+=("${ICON_JAVA}|${v}")
    fi
    if [[ -f "$dir/CMakeLists.txt" ]]; then
        local v=$(cmake --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        langs+=("${ICON_CMAKE}|${v}")
    fi
    if [[ -f "$dir/Makefile" ]]; then
        langs+=("${ICON_C}|")
    fi
    if [[ -f "$dir/deno.json" ]] || [[ -f "$dir/deno.jsonc" ]]; then
        local v=$(deno --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        langs+=("${ICON_DENO}|${v}")
    fi
    if [[ -f "$dir/flake.nix" ]] || [[ -f "$dir/shell.nix" ]]; then
        langs+=("${ICON_NIX}|")
    fi
    if [[ -f "$dir/composer.json" ]]; then
        local v=$(php --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        langs+=("${ICON_PHP}|${v}")
    fi
    if ls "$dir"/*.scala &>/dev/null || [[ -f "$dir/build.sbt" ]]; then
        local v=$(scala --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        langs+=("${ICON_SCALA}|${v}")
    fi
    if ls "$dir"/*.swift &>/dev/null || [[ -f "$dir/Package.swift" ]]; then
        local v=$(swift --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
        langs+=("${ICON_SWIFT}|${v}")
    fi
    if ls "$dir"/*.kt &>/dev/null || ls "$dir"/*.kts &>/dev/null; then
        local v=$(kotlin -version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        langs+=("${ICON_KOTLIN}|${v}")
    fi
    if ls "$dir"/*.zig &>/dev/null; then
        local v=$(zig version 2>/dev/null)
        langs+=("${ICON_ZIG}|${v}")
    fi

    # Output: transition from previous segment (now directory/orange), then all detected languages
    if [[ ${#langs[@]} -gt 0 ]]; then
        printf "${FG_ORANGE}${BG_BG1}${ARROW}${RESET}${BG_BG1}${FG_FG0}"
        for entry in "${langs[@]}"; do
            local icon="${entry%%|*}"
            local ver="${entry#*|}"
            if [[ -n "$ver" ]]; then
                printf " ${icon} ${ver}"
            else
                printf " ${icon}"
            fi
        done
        printf " ${RESET}${FG_BG1}${ARROW}${RESET}"
    else
        printf "${FG_ORANGE}${ARROW}${RESET}"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# Line 2 Segments (Git Info)
# ═══════════════════════════════════════════════════════════════════════════════

# Git: Repository name (aqua start)
repo_name_segment() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
        return 1
    fi

    local repo_path
    repo_path=$(git rev-parse --show-toplevel 2>/dev/null)
    local repo_name=$(basename "$repo_path")

    printf "${FG_AQUA}${ARROW_LEFT}${RESET}${BG_AQUA}${FG_FG0} ${repo_name} ${RESET}"
    return 0
}

# Git: Branch and status (blue)
branch_status_segment() {
    local branch
    branch=$(git branch --show-current 2>/dev/null)
    [[ -z "$branch" ]] && return

    local status=""

    # Check git states (fast, no lock)
    git diff --quiet --no-lock-index 2>/dev/null || status="${status}*"
    git diff --cached --quiet --no-lock-index 2>/dev/null || status="${status}+"
    [[ -n $(git ls-files --others --exclude-standard 2>/dev/null | head -1) ]] && status="${status}?"

    # Check ahead/behind
    local upstream
    upstream=$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
    local ahead_behind=""

    if [[ -n "$upstream" ]]; then
        local ahead behind
        ahead=$(git rev-list --count '@{upstream}..HEAD' 2>/dev/null)
        behind=$(git rev-list --count 'HEAD..@{upstream}' 2>/dev/null)

        [[ "$ahead" -gt 0 ]] && ahead_behind="${ahead_behind}+${ahead}"
        [[ "$behind" -gt 0 ]] && ahead_behind="${ahead_behind}-${behind}"
    fi

    printf "${FG_AQUA}${BG_BLUE}${ARROW}${RESET}${BG_BLUE}${FG_FG0} ${ICON_BRANCH} ${branch}${status}${ahead_behind} ${RESET}"
}

# Git: Upstream tracking (bg3)
tracking_segment() {
    local upstream
    upstream=$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)

    if [[ -n "$upstream" ]]; then
        printf "${FG_BLUE}${BG_BG3}${ARROW}${RESET}${BG_BG3}${FG_FG0} ${upstream} ${RESET}"
    else
        printf "${FG_BLUE}${BG_BG3}${ARROW}${RESET}"
    fi
}

# Git: Last commit time (bg1)
last_commit_segment() {
    local commit_time
    commit_time=$(git log -1 --format='%ct' 2>/dev/null)

    if [[ -z "$commit_time" ]]; then
        printf "${FG_BG3}${ARROW}${RESET}"
        return
    fi

    local now=$(date +%s)
    local diff=$((now - commit_time))

    # Format time difference
    local time_str
    if [[ $diff -lt 60 ]]; then
        time_str="now"
    elif [[ $diff -lt 3600 ]]; then
        time_str="$((diff / 60))m"
    elif [[ $diff -lt 86400 ]]; then
        time_str="$((diff / 3600))h"
    elif [[ $diff -lt 604800 ]]; then
        time_str="$((diff / 86400))d"
    elif [[ $diff -lt 2592000 ]]; then
        time_str="$((diff / 604800))w"
    else
        time_str="$((diff / 2592000))mo"
    fi

    # Check if working tree is clean
    local clean_indicator=""
    if git diff --quiet --no-lock-index 2>/dev/null && \
       git diff --cached --quiet --no-lock-index 2>/dev/null && \
       [[ -z $(git ls-files --others --exclude-standard 2>/dev/null | head -1) ]]; then
        clean_indicator=" ok"
    fi

    printf "${FG_BG3}${BG_BG1}${ARROW}${RESET}${BG_BG1}${FG_FG0} @ ${time_str}${clean_indicator} ${RESET}${FG_BG1}${ARROW}${RESET}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════════════════════════

main() {
    printf "${RESET}"

    # Line 1: Directory + Language only (short line)
    directory_segment
    language_segment

    # Line 2: Claude info
    printf "\n"
    model_segment
    reset_time_segment
    session_time_segment
    context_segment

    # Line 3: Git info (only if in a git repo)
    if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
        printf "\n"
        repo_name_segment
        branch_status_segment
        tracking_segment
        last_commit_segment
    fi
}

main

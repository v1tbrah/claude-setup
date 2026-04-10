#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
AGENTS_DIR="$HOME/.claude/agents"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }

echo ""
echo "=========================================="
echo "  Claude Code — установка для FoodTech"
echo "=========================================="
echo ""

# ── 1. Проверка зависимостей ──

if ! command -v claude &>/dev/null; then
    error "Claude Code не установлен. Установите: https://docs.anthropic.com/en/docs/claude-code"
    exit 1
fi
info "Claude Code найден"

# ── 2. Установка плагина superpowers ──

echo ""
echo "── Плагин superpowers ──"

if claude plugin list 2>/dev/null | grep -q "superpowers"; then
    info "superpowers уже установлен"
else
    echo "Устанавливаю superpowers..."
    claude plugin add superpowers@claude-plugins-official
    info "superpowers установлен"
fi

# Включение плагина в user settings
USER_SETTINGS="$HOME/.claude/settings.json"
if [ -f "$USER_SETTINGS" ]; then
    if grep -q '"superpowers@claude-plugins-official": true' "$USER_SETTINGS"; then
        info "superpowers уже включён в settings.json"
    elif grep -q '"superpowers@claude-plugins-official"' "$USER_SETTINGS"; then
        # Плагин есть, но выключен — включаем
        TMP=$(mktemp)
        sed 's/"superpowers@claude-plugins-official":[[:space:]]*false/"superpowers@claude-plugins-official": true/' "$USER_SETTINGS" > "$TMP"
        mv "$TMP" "$USER_SETTINGS"
        info "superpowers включён в settings.json (был выключен)"
    else
        # Добавляем enabledPlugins если нет, или дополняем существующий
        TMP=$(mktemp)
        if grep -q '"enabledPlugins"' "$USER_SETTINGS"; then
            # enabledPlugins есть — добавляем плагин внутрь
            sed 's/"enabledPlugins"[[:space:]]*:[[:space:]]*{/"enabledPlugins": { "superpowers@claude-plugins-official": true,/' "$USER_SETTINGS" > "$TMP"
        else
            # enabledPlugins нет — добавляем перед последней }
            sed '$ s/}$/,\n  "enabledPlugins": {\n    "superpowers@claude-plugins-official": true\n  }\n}/' "$USER_SETTINGS" > "$TMP"
        fi
        mv "$TMP" "$USER_SETTINGS"
        info "superpowers включён в settings.json"
    fi
else
    mkdir -p "$(dirname "$USER_SETTINGS")"
    cat > "$USER_SETTINGS" <<'SETTINGS'
{
  "enabledPlugins": {
    "superpowers@claude-plugins-official": true
  }
}
SETTINGS
    info "settings.json создан с superpowers"
fi

# ── 3. Установка скиллов ──

echo ""
echo "── Скиллы ──"

mkdir -p "$SKILLS_DIR"

for skill_dir in "$SCRIPT_DIR"/skills/*/; do
    skill_name="$(basename "$skill_dir")"
    target_dir="$SKILLS_DIR/$skill_name"

    if [ -d "$target_dir" ]; then
        cp -r "$skill_dir"* "$target_dir/"
        info "$skill_name — обновлён"
    else
        cp -r "$skill_dir" "$target_dir"
        info "$skill_name — установлен"
    fi
done

# ── 4. Установка агентов ──

echo ""
echo "── Агенты ──"

mkdir -p "$AGENTS_DIR"

for agent_file in "$SCRIPT_DIR"/agents/*.md; do
    agent_name="$(basename "$agent_file")"
    if [ -f "$AGENTS_DIR/$agent_name" ]; then
        cp "$agent_file" "$AGENTS_DIR/$agent_name"
        info "$agent_name — обновлён"
    else
        cp "$agent_file" "$AGENTS_DIR/$agent_name"
        info "$agent_name — установлен"
    fi
done

# ── Готово ──

echo ""
echo "=========================================="
echo "  Установка завершена!"
echo "=========================================="
echo ""
echo "Что установлено:"
echo "  • Плагин superpowers"
echo "  • Скиллы: $(ls "$SKILLS_DIR" | tr '\n' ', ' | sed 's/,$//')"
echo "  • Агенты: $(ls "$AGENTS_DIR" | tr '\n' ', ' | sed 's/,$//')"
echo ""
echo "Настройка MCP-серверов: https://confluence.uzum.com/pages/viewpage.action?pageId=514658828"
echo ""

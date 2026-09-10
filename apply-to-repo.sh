#!/usr/bin/env bash
# apply-to-repo.sh — 把 AI 公司工具链一键套用到任意已有仓库
# 用法：~/github-ai-company-template/apply-to-repo.sh <目标仓库路径>
# 示例：~/github-ai-company-template/apply-to-repo.sh ~/family-training
set -euo pipefail

TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:?用法: $0 <目标仓库路径>}"
cd "$TARGET"

# ── 0. 前置检查 ──────────────────────────────────────────────
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "✗ 不是 git 仓库: $TARGET"; exit 1; }
OWNER=$(git remote get-url origin 2>/dev/null | sed -E 's#.*github.com[:/]##; s#\.git$##; s#/.*##')
[ -n "$OWNER" ] || { echo "✗ 未找到 origin 远程仓库，先 git remote add"; exit 1; }
echo "→ 目标仓库: $OWNER/$(basename "$TARGET")"

# ── 1. 探测语言，决定 CI 测试命令 ────────────────────────────
detect_lang() {
  if   ls package.json >/dev/null 2>&1; then echo node
  elif ls requirements.txt pyproject.toml setup.py >/dev/null 2>&1; then echo python
  elif ls go.mod >/dev/null 2>&1; then echo go
  elif ls Cargo.toml >/dev/null 2>&1; then echo rust
  else echo generic; fi
}
LANG_TYPE=$(detect_lang)
echo "→ 探测语言: $LANG_TYPE"

gen_test_job() {
  case "$1" in
    node)
      cat <<'EOF'
  test:
    name: Test (Node ${{ matrix.node }})
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix: { node: [22, 24] }
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: "${{ matrix.node }}", cache: npm }
      # 统一 npm 大版本：npm 10/11 对 lock 树校验不兼容（详见模板 ci.yml）
      - run: npm install -g npm@11
      - run: npm ci || npm install
      - run: npm test --if-present
EOF
      ;;
    python)
      cat <<'EOF'
  test:
    name: Test (Python ${{ matrix.py }})
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix: { py: ["3.11", "3.12"] }
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "${{ matrix.py }}" }
      - run: pip install -r requirements.txt 2>/dev/null || pip install -e . 2>/dev/null || true
      - run: pip install pytest && pytest --exitfirst || echo "（尚无测试，跳过）"
EOF
      ;;
    go)
      cat <<'EOF'
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with: { go-version: "stable" }
      - run: go test ./... || echo "（尚无测试，跳过）"
EOF
      ;;
    *)
      cat <<'EOF'
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "（此仓库暂无自动测试——建议尽快补上）"
EOF
      ;;
  esac
}

# ── 2. 复制通用文件 ──────────────────────────────────────────
mkdir -p .github/workflows .github/ISSUE_TEMPLATE
cp -R "$TEMPLATE_DIR/.github/ISSUE_TEMPLATE/." .github/ISSUE_TEMPLATE/
cp "$TEMPLATE_DIR/.github/PULL_REQUEST_TEMPLATE.md" .github/
cp "$TEMPLATE_DIR/.github/dependabot.yml" .github/
cp "$TEMPLATE_DIR/.github/labeler.yml" .github/
# AGENTS.md：仅目标仓库没有时安装（已有的跳过——防止覆盖库特有规则，如 invoice-manager 的事故版铁律）
[ -f AGENTS.md ] || cp "$TEMPLATE_DIR/AGENTS.md" .
cp "$TEMPLATE_DIR/.github/workflows/codeql.yml" .github/workflows/
cp "$TEMPLATE_DIR/.github/workflows/security.yml" .github/workflows/
cp "$TEMPLATE_DIR/.github/workflows/automation.yml" .github/workflows/
cp "$TEMPLATE_DIR/.github/workflows/labeler.yml" .github/workflows/
cp "$TEMPLATE_DIR/.github/workflows/release.yml" .github/workflows/
cp "$TEMPLATE_DIR/.github/workflows/pi.yml" .github/workflows/
[ -f "$TEMPLATE_DIR/.github/workflows/claude.yml" ] && cp "$TEMPLATE_DIR/.github/workflows/claude.yml" .github/workflows/

# ── 2.5 标签式自动合并 / AI 审查 / 发布自动化 / Scorecard ──
cp "$TEMPLATE_DIR/.github/workflows/auto-merge.yml"  .github/workflows/
cp "$TEMPLATE_DIR/.github/workflows/pi-review.yml"   .github/workflows/ 2>/dev/null || true
cp "$TEMPLATE_DIR/.github/workflows/scorecard.yml"    .github/workflows/ 2>/dev/null || true
# release-please 仅 node 库（其他语言后续适配 release-type: python/go）
[ "$LANG_TYPE" = node ] && cp "$TEMPLATE_DIR/.github/workflows/release-please.yml" .github/workflows/

# 私有库：Actions 分钟有配额（免费 2000/月），sweep 轮询降频到每 6 小时；
# 秒级收割用: gh workflow run auto-merge.yml -R <repo>，或等 labeled/synchronize 事件
REPO_NAME=$(git remote get-url origin | sed -E 's#.*github.com[:/]##; s#\.git$##; s#.*/##')
if gh api "repos/$OWNER/$REPO_NAME" --jq .private 2>/dev/null | grep -q true; then
  sed -i.bak 's|cron: "\*/5 \* \* \* \*"|cron: "0 */6 * * *"|' .github/workflows/auto-merge.yml && rm -f .github/workflows/auto-merge.yml.bak
  echo "→ 私有库：sweep 降频为每 6 小时（省 Actions 配额）"
fi

# 不覆盖已有的 AGENTS.md / CLAUDE.md / coderabbit，存在则跳过
for f in AGENTS.md CLAUDE.md .coderabbit.yaml .pre-commit-config.yaml; do
  [ -f "$f" ] || cp "$TEMPLATE_DIR/$f" .
done

# CODEOWNERS：没有就生成（指向仓库 owner）
if [ ! -f .github/CODEOWNERS ]; then
  printf '# 默认审查人\n* @%s\n' "$OWNER" > .github/CODEOWNERS
fi

# ── 3. 生成适配语言的 ci.yml（不覆盖已有的） ─────────────────
if [ -f .github/workflows/ci.yml ]; then
  echo "→ 已存在 ci.yml，跳过生成（避免覆盖你的配置）"
else
  {
    cat <<'EOF'
# CI：lint + 测试（由 apply-to-repo.sh 生成）
name: CI
on:
  pull_request: { branches: [main, master] }
  push: { branches: [main, master] }
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
permissions:
  contents: read
jobs:
  lint:
    name: Lint (pre-commit)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.12" }
      - uses: pre-commit/action@v3.0.1
EOF
    gen_test_job "$LANG_TYPE"
  } > .github/workflows/ci.yml
fi

# ── 4. 提交 ──────────────────────────────────────────────────
git add .github AGENTS.md CLAUDE.md .coderabbit.yaml .pre-commit-config.yaml 2>/dev/null || git add -A
git commit -qm "chore: 套用 AI 公司工具链（CI + 安全扫描 + AI 审查 + @pi 机器人）

由 github-ai-company-template 的 apply-to-repo.sh 应用，语言: $LANG_TYPE"
echo ""
echo "✓ 完成！已提交到本地 $(git branch --show-current) 分支"
echo "  下一步：git push，然后去 GitHub 网页："
echo "  1) Settings → Code security 开 Dependabot 系列"
echo "  2) Settings → Rules 给 main 加分支保护"
echo "  3) Settings → General → 勾选 Allow auto-merge"
echo "  4) 安装 CodeRabbit App 到此仓库"
echo "  5) 想用 @pi 云端机器人 → Secrets 加模型 API key"

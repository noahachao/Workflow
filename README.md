# GitHub 一人公司 · AI 自动化工具链模板

一套开箱即用的 GitHub 工具链模板：**Issue → AI 写代码 → PR → CI + AI 审查 → 安全扫描 → 自动合并 → 发布部署**。
人只负责两件事：写清楚 Issue、最终把关合并，其余交给自动化。

## 流水线全景

```
            ┌─────────────────────────── 你（人类）───────────────────────────┐
            │   写 Issue / 验收 / 打 approved 标签（= 人类签章）               │
            └───────────────▲───────────────────────────────▲─────────────────┘
                            │ 指派任务                        │ 审查结果
┌──────────┐   ┌───────────┴──────────┐   ┌─────────────────┴──────────────┐
│  Issue   │──▶│  AI Coding Agent      │──▶│  Pull Request                  │
│ (模板+   │   │  · Copilot Coding     │   │  ① CI: lint / test / build     │
│  AI 分诊)│   │  · @claude / @codex   │   │  ② AI Review: CodeRabbit 等    │
└──────────┘   └───────────────────────┘   │  ③ 安全: CodeQL / Dependabot   │
                                           │  ④ 全绿 + auto-merge → main    │
                                           └────────────────┬───────────────┘
                                                            ▼
                            release-please 自动攒版 → Release PR → 再签章 → 发版 + 产物
```

## 仓库内容

| 文件 / 目录 | 作用 | 需要的动作 |
|---|---|---|
| `.github/workflows/ci.yml` | CI：lint（pre-commit）+ 测试（Node 22/24 矩阵）+ 构建冒烟 | 无，开箱即用 |
| `.github/workflows/codeql.yml` | CodeQL 静态安全扫描（含定时扫描） | 无 |
| `.github/workflows/labeler.yml` | PR 按改动路径自动打标签 | 无 |
| `.github/workflows/automation.yml` | 定时清理不活跃 issue/PR（housekeeping） | 无 |
| `.github/workflows/release.yml` | 打 tag 自动发布 GitHub Release（CD 挂载点） | 按需改部署段 |
| `.github/workflows/claude.yml` | `@claude` 机器人：改代码 / 修 bug / 回答问题 | 配置 `ANTHROPIC_API_KEY` |
| `.github/workflows/auto-merge.yml` | **收割机**：带 `approved` 标签的 PR，CI 全绿自动 squash 合并+删分支+关 issue（每 5 分钟巡逻） | 无，开箱即用 |
| `.github/workflows/pi-review.yml` | AI Review：每个新 PR 自动出中文逐行审查报告 | 配置 `GEMINI_API_KEY`（可选，未配自动跳过） |
| `.github/workflows/security.yml` | 私有库安全兜底：Gitleaks 密钥扫描 + npm audit（critical 阻断） | 无 |
| `.github/workflows/release-please.yml` | 自动版本管理：攒 conventional commits → Release PR → 打 tag 发版 | 无（node 库；打 `approved` 标签收割 Release PR） |
| `.github/workflows/scorecard.yml` | OSSF 安全评分（仅公开库跑，SARIF 上 Security tab） | 无 |
| `.github/workflows/pi.yml` | `@pi` 机器人：本地同款 pi agent 云端干活（Issue→PR / PR 迭代） | 配置 `ZAI_CODING_CN_API_KEY`（GLM Coding 套餐，默认）或 `DEEPSEEK_API_KEY` |
| `.coderabbit.yaml` | CodeRabbit AI Code Review 配置 | 安装 CodeRabbit App（开源免费） |
| `.github/dependabot.yml` | 依赖自动升级（npm + Actions） | 无 |
| `.github/labeler.yml` | PR 打标签规则 | 无 |
| `.github/CODEOWNERS` | 默认审查人 | **改成你的用户名** |
| `.github/ISSUE_TEMPLATE/` | Bug / Feature 表单 | 无 |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR 检查清单 | 无 |
| `AGENTS.md` | 给 AI coding agent 的项目规范（Copilot/Codex 都读它） | 按项目改 |
| `CLAUDE.md` | Claude Code 入口规范 | 按项目改 |
| `.pre-commit-config.yaml` | 本地 + CI 统一 lint | 本地 `pip install pre-commit` 后 `pre-commit install` |
| `docs/SETUP.md` | **从零启用清单（分支保护 / Copilot / Projects / auto-merge）** | 照着走一遍 |
| `src/` `tests/` `scripts/` | Node.js 零依赖示例（可整体替换为你的项目） | 替换 |

## 快速开始（10 分钟）

```bash
# 1. 用此模板创建你自己的仓库（GitHub 页面绿色按钮 Use this template），或：
git clone <你的仓库地址> && cd <你的仓库>

# 2. 改 CODEOWNERS：把 @YOUR_USERNAME 换成你的 GitHub 用户名

# 3. 装 pre-commit（可选，本地提交时自动 lint）
pip install pre-commit && pre-commit install

# 4. 打开 GitHub 仓库 Settings，按 docs/SETUP.md 逐项启用：
#    分支保护、Copilot、CodeRabbit、Secret Scanning、auto-merge、Projects
```

然后试试 AI 员工：

```bash
# 在 GitHub 上新建一个 Issue（用 feature 模板），assignee 选择 @copilot
# → Copilot 后台开发，完成后提交 PR 给你审查

# 或在任何 Issue 评论里 @pi（主战 agent，GLM Coding 套餐包月）：
#   "@pi 按此 issue 实现，附测试"      → 自动写码 → 开 PR → CI → 等你审批
#
# 或 @claude（需要 ANTHROPIC_API_KEY）：
#   "@claude 帮我实现这个功能并附测试"
#
# 你批准 PR 的方式（二选一）：
#   网页：PR 右侧栏 Labels 齿轮 → 勾 approved
#   命令：gh pr edit <PR号> --add-label approved
# 打完标签后 auto-merge 自动收割（CI 全绿 → 合并 → 关 issue）
```

## 成本参考

| 方案 | 月成本 | 说明 |
|---|---|---|
| 本模板基础栈 | ¥0 | 公开仓库 Actions 免费 + CodeRabbit 开源免费 + CodeQL/Dependabot 免费 |
| + Copilot Pro | ~$10 | coding agent + code review + IDE 补全 |
| + Claude API（@claude） | 按 token | issue 分诊约 $0.015/条，review 每个 PR 几美分级别 |
| + GLM Coding 套餐（@pi 默认） | 包月 | 智谱 aistudio 开通，套餐内 CI 用量不另计费 |
| + DeepSeek（@pi 备用） | 按 token | 极便宜，一次 PR 实现通常 < ¥0.1 |

## 安全红线（一人公司必读）

- **合并的最终权留给人**：AI 可以 review、可以提 PR，但只有人类打上 `approved` 标签后收割机才合并（防 PR 文本里藏 prompt injection）。机器人开的 PR 无 CI 记录时走 `--admin` 通道合并，签章语义不变。
- Actions 尽量 **pin 到 commit SHA**（模板为可读性用了 tag，正式生产建议替换）。
- 所有 secret 放 **GitHub Secrets**，开启 **Push Protection**。
- AI 生成的代码必须过完 CI + 安全扫描才算数，`AGENTS.md` 里已写明此要求。

## 详细启用步骤

见 **[docs/SETUP.md](docs/SETUP.md)** —— 分支保护、Copilot 三件套、CodeRabbit、GitHub Projects 自动化、auto-merge、部署接入，全部有截图级路径说明。

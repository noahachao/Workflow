# GitHub 一人公司 · AI 自动化工具链模板

一套开箱即用的 GitHub 工具链模板：**Issue → AI 写代码 → PR → CI + AI 审查 → 安全扫描 → 自动合并 → 发布部署**。
人只负责两件事：写清楚 Issue、最终把关合并，其余交给自动化。

## 流水线全景

```
            ┌─────────────────────────── 你（人类）───────────────────────────┐
            │   写 Issue / 验收 / 最终 Approve & Merge                         │
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
                                              Release (tag v*) → CD 部署
```

## 仓库内容

| 文件 / 目录 | 作用 | 需要的动作 |
|---|---|---|
| `.github/workflows/ci.yml` | CI：lint（pre-commit）+ 测试（Node 20/22 矩阵）+ 构建冒烟 | 无，开箱即用 |
| `.github/workflows/codeql.yml` | CodeQL 静态安全扫描（含定时扫描） | 无 |
| `.github/workflows/labeler.yml` | PR 按改动路径自动打标签 | 无 |
| `.github/workflows/automation.yml` | 定时清理不活跃 issue/PR（housekeeping） | 无 |
| `.github/workflows/release.yml` | 打 tag 自动发布 GitHub Release（CD 挂载点） | 按需改部署段 |
| `.github/workflows/claude.yml` | `@claude` 机器人：改代码 / 修 bug / 回答问题 | 配置 secret 后可用 |
| `.github/workflows/pi.yml` | `@pi` 机器人：本地同款 pi agent 云端干活（Issue→PR / PR 迭代） | 配置任一模型 API key |
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

# 或在任何 Issue / PR 评论里 @claude，让它：
#   "@claude 帮我实现这个功能并附测试"
#   "@claude 这个 PR 有什么问题？"
```

## 成本参考

| 方案 | 月成本 | 说明 |
|---|---|---|
| 本模板基础栈 | ¥0 | 公开仓库 Actions 免费 + CodeRabbit 开源免费 + CodeQL/Dependabot 免费 |
| + Copilot Pro | ~$10 | coding agent + code review + IDE 补全 |
| + Claude API（@claude） | 按 token | issue 分诊约 $0.015/条，review 每个 PR 几美分级别 |

## 安全红线（一人公司必读）

- **合并的最终权留给人**：AI 可以 review、可以提 PR，但分支保护要求人类 approve 才能合并（防 PR 文本里藏 prompt injection）。
- Actions 尽量 **pin 到 commit SHA**（模板为可读性用了 tag，正式生产建议替换）。
- 所有 secret 放 **GitHub Secrets**，开启 **Push Protection**。
- AI 生成的代码必须过完 CI + 安全扫描才算数，`AGENTS.md` 里已写明此要求。

## 详细启用步骤

见 **[docs/SETUP.md](docs/SETUP.md)** —— 分支保护、Copilot 三件套、CodeRabbit、GitHub Projects 自动化、auto-merge、部署接入，全部有截图级路径说明。

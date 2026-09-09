# SETUP.md — 从零启用清单

照顺序走完，大约 20 分钟。标 ★ 的步骤必须做。

## 1. ★ 创建你自己的仓库

- GitHub 上点 **Use this template**（或 fork）。
- 克隆到本地，改 `.github/CODEOWNERS`：把 `YOUR_USERNAME` 换成你的用户名。

## 2. ★ 分支保护（质量门禁的核心）

仓库 **Settings → Rules → Rulesets → New ruleset → New branch ruleset**：

- Target branches: `main`
- Require a pull request before merging
  - Required approvals: **1**
  - ⚠️ 一人公司注意：默认管理员可绕过，所以你自己的 PR 不会被卡死；多人参与时再开 "Do not allow bypassing"
- Require status checks to pass：
  - `Lint (pre-commit)`、`Test (Node 20)`、`Test (Node 22)`、`Build smoke`、`CodeQL`
  - （CodeRabbit 装好后可加 `coderabbitai/review` 作为 required check）
- Require branches to be up to date before merging

再开启自动合并：**Settings → General → Pull Requests → 勾选 Allow auto-merge**。
效果：PR 达标后自动合并，你不需要守着点按钮。

## 3. ★ 安全三件套（全部免费）

**Settings → Code security**（旧版叫 Code security and analysis），开启：

- ✅ Dependabot alerts
- ✅ Dependabot security updates
- ✅ Dependabot version updates（我们的 dependabot.yml 已配置）
- ✅ Code scanning（CodeQL workflow 已在仓库里，首次 push main 会自动跑）
- ✅ Secret scanning
- ✅ Push protection（阻止密钥被 push）

## 4. ★ Copilot 三件套（$10/月 Pro，强烈推荐）

仓库 **Settings → Copilot** 下逐项开启：

1. **Coding agent** — 之后新建 Issue 时，assignee 里选 `copilot`，它就后台开发并交 PR。
2. **Code review** — 勾选后 Copilot 自动审查每个 PR（可设置 "only on request"）。
3. **Issue triaging** — AI 自动给新 Issue 打标签、判断是否可执行。

> 没有 Pro 订阅也能用免费额度跑通流程验证。

## 5. CodeRabbit（开源仓库免费）

1. 打开 https://github.com/apps/coderabbitai → **Install** → 选择你的仓库/组织。
2. 提交任意 PR，它会自动按 `.coderabbit.yaml` 配置审查（中文、chill 模式）。
3. 想让它成为硬门禁：把 `coderabbitai/review` 加入第 2 步的 required checks，并在 `.coderabbit.yaml` 打开 `request_changes_workflow: true`。

## 6. @claude 机器人（可选，按 token 付费）

**方式 A（推荐，走订阅额度）**：本地装 Claude Code 后运行 `/install-github-app`，按提示安装，自动写入 `CLAUDE_CODE_OAUTH_TOKEN`。

**方式 B（API key）**：
1. https://console.anthropic.com 创建 API Key
2. 仓库 **Settings → Secrets and variables → Actions → New repository secret**：名称 `ANTHROPIC_API_KEY`
3. 之后在任何 Issue / PR 评论 `@claude <任务>` 即可。

## 6b. @pi 机器人（可选，用你熟悉的 pi agent）

不想绑死 Anthropic/OpenAI？模板里的 `pi.yml` 把本地同款 [pi](https://pi.dev) 搬进 Actions：

1. 仓库 **Settings → Secrets → Actions** 添加任一 provider 的 key（`ANTHROPIC_API_KEY` / `OPENAI_API_KEY` / `GEMINI_API_KEY` / `DEEPSEEK_API_KEY` …）。
2. 如果用的不是 Anthropic，同步修改 `pi.yml` 中 Run pi 步骤的 env 行。
3. 之后在任何 **Issue 评论 `@pi 实现这个需求`** → 它新建分支、写代码、开 PR；
   在 **PR 评论 `@pi 按评审意见修改`** → 它直接在 PR 分支上继续迭代。

> 本地零成本玩法（无需任何云端 key）：直接在本地 pi 会话里说
> “看 #12 这个 issue，实现它并用 gh 开 PR”，pi 会用 bash 工具自己完成全流程。

## 7. GitHub Projects 看板自动化

1. 仓库页 **Projects → New project → Board**。
2. 添加字段 `Status`（Todo / In Progress / In Review / Done）。
3. 项目页 **⋯ → Workflows**，逐条启用内置自动化：
   - Item added to project → Status = **Todo**
   - PR 创建 → Status = **In Review** + 添加作者
   - PR merged → Status = **Done**
4. 仓库 Issue 多时可再开 **Settings → Copilot → Issue triaging**（AI 分诊）。

## 8. 部署接入（CD）

编辑 `.github/workflows/release.yml` 部署段，按平台放开对应注释，并在
**Settings → Secrets → Actions** 添加所需 secret（VERCEL_TOKEN / CLOUDFLARE_API_TOKEN / SSH_KEY 等）。

之后发版就是：

```bash
git tag v0.1.0
git push origin v0.1.0
# → 自动测试、构建、发布 Release、部署
```

## 9. 验证一切正常

```bash
# ① 推一个破坏测试的 PR → CI 应该红
# ② 推一个正常 PR → CI 绿 + CodeRabbit 出中文审查报告
# ③ 建 Issue 指派给 @copilot → 等它交 PR
# ④ 在任意 PR 评论 @claude 你好 → 它应回复
# ⑤ merge 后打 tag → Release 页出现新版本
```

## 10. 常见坑

| 症状 | 原因 / 解法 |
|---|---|
| 自己的 PR 合不了（要 1 approval） | 管理员默认可绕过；若被卡，用 ruleset 的 bypass 列表放行自己 |
| CodeQL 没跑 | 先完成一次 main 的 push；矩阵语言要匹配项目 |
| `npm ci` 失败 | 仓库缺 package-lock.json；本地跑一次 `npm install` 并提交 |
| @claude 没反应 | 检查 secret 名称拼写；workflow 必须在默认分支上存在 |
| CodeRabbit 不出报告 | 确认 App 已装到该仓库；draft PR 默认不审 |

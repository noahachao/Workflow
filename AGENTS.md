# AGENTS.md — 项目规范（供所有 AI coding agent 阅读）

> Copilot Coding Agent、Codex、Cursor 等会自动读取本文件。
> 修改这里 = 修改你的 "AI 员工入职手册"。

## 项目概览

- 一个 Node.js (ESM, Node >= 20) 模板项目，零运行时依赖。
- 目录：`src/` 源码，`tests/` 测试（node:test），`scripts/` 构建脚本。

## 硬性规则（违反 = 必须返工）

1. **改动必须附带测试**：新功能/修 bug 都要在 `tests/` 增加或更新用例，`npm test` 必须全绿。
2. **不引入新依赖**，除非 Issue 明确要求；引入时说明理由。
3. **不碰 `.github/workflows/`**，除非 Issue 本身就是改 CI。
4. **安全**：不硬编码密钥、不降低现有权限、不忽略错误。
5. 遵循现有代码风格；ESM (`import/export`)，不用 CommonJS。
6. 提交信息格式：`type(scope): 摘要`，type ∈ feat / fix / test / docs / refactor / chore。

## 操作安全铁律（破坏性操作防护网）

> 来自 2026-09-10 真实事故：生产运行目录被当一次性工作区清空 → 服务 404 四小时无人察觉。
> 任何 agent 在执行目录级 / 破坏性操作前必读本节。

1. **分清运行目录与工作目录**：目录里跑着服务（launchd / systemd / PM2 / Docker）、或躺着活数据库（SQLite 及其 `-wal` / `-shm`），它就是生产——**对它只读**。任何写 / 删 / 重建前先自问一句「这里跑着服务吗」。
2. **实验进沙盒**：CI / 工具链 / 探索性实验一律在临时 clone 或 `git worktree add` 里做，只推 commit，永不接触运行目录。
3. **破坏前三步**（顺序不可颠倒）：
   - `git status` 干净 + 已 push（`git log origin/main..HEAD` 为空）
   - 涉及数据 → 先备份快照（数据库用 backup API，或先停服再拷贝）
   - 然后才允许动手
4. **动手后必验证**：健康检查端点 `200` + 核心页面 `200`。破坏性操作必须自带事后验证，不靠用户当告警。
5. **临时文件不进 main**：`.tmp` / `dbg` / 一次性复现脚本，用完即删，不进提交。
6. **SQLite 与 mmap**：进程握着 `db-shm` 时整目录 rename 会 EPERM。恢复姿势：数据原地不动，代码归位。

## 提交前自检清单

- [ ] `npm test` 全绿
- [ ] `npm run build` 成功
- [ ] 没有新增 secret / 调试输出 / 被注释掉的死代码
- [ ] 公开 API 变更已更新 README

## 工作方式

- 只做 Issue 里明确要求的事，不顺手重构无关代码。
- 拿不准就在 PR 描述里列出假设，不要替人类做产品决定。

## GitHub Actions / 流水线运维纪律
- 批量改动 9 库前先查 Actions 分钟余额(`gh api /users/…/settings/billing/actions`,token 不足时用网页确认);能合并的变更合并成一次 push,一轮 CI 验证多变更
- 批量同步模板文件后必须立即 grep 抽验关键内容(如 action 版本),cp 前先核对源分支是否包含目标改动;一次 cp 用错分支曾把 8 库 actions 从 v7 降回 v4
- 配置文件不得无脑模板化:dependabot.yml 的 package-ecosystem/directory 必须按库实际结构裁剪(如 rush 的 npm 在 /web、go 在 /scheduler;langgraph 只有 pip),错配会报 "/package.json not found"
- Dependabot 的 ignore 是库级策略:关闭 major PR 时必须在每个库的 dependabot.yml 硬编码 ignore-conditions,不能只靠 `@dependabot ignore` 评论(同款 major PR 会在其他库重复开出)
- push 成功与否必须用远端 SHA 核对(`git rev-parse HEAD` vs `gh api repos/…/branches/main`),禁止无条件 echo 假成功;SSH 断连时 push 可能未达
- 批量验证 CI 用 SHA 对账 + `--workflow X --event push` 精确过滤;run 列表会被 Dependabot rebase 洪水挤出窗口,单次列表查询不可信
- 额度耗尽期的失败 run 特征是 job 3 秒内结束、无 step 失败、annotations 提示 billing——定性平台额度问题,等月度重置或加付款,勿当 workflow bug 修
- 开新 PR 前分支必须基于最新 origin/main(rebase 或 -B 重建);基于旧 main 的 diff 会与已合入的同名变更在 PR merge ref 上撞车,报出本地不存在的错误(如 duplicate key),本地文件检查无法发现,必须在 PR checks 层验证
- dependabot.yml 用户配置键是 `ignore`(不是 dependabot-core 内部 JSON 的 `ignore-conditions`);写错键名校验器直接 fail 且静默停摆。配置依据官方 options reference,不依据 job 日志里的内部字段
- 生成结构化配置文件优先 heredoc 直写完整内容;字符串拼接/split 手术易坏缩进与结构且不易自劯,二连败后改 heredoc 一次成型 + 本地 yaml 解析 + pre-commit 验证再推
- 模板库 ruleset 只要求 checks 绿,工具链 chore PR(checks 绿后)可 `gh pr merge --squash --delete-branch` 直合,无需 approved 标签;业务 PR 仍走用户签章流
- main 分支直推仅限 CI 热修(阻断性红灯),常规改动一律开 PR;直推后当天在最近 PR/issue 补一笔说明
- WORKFLOW_PAT 仅用于 auto-merge 与 pi 机器人,不得用于人工日常操作;泄露迹象时立即 revoke 并换 fine-grained PAT

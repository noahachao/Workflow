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

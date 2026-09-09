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

## 提交前自检清单

- [ ] `npm test` 全绿
- [ ] `npm run build` 成功
- [ ] 没有新增 secret / 调试输出 / 被注释掉的死代码
- [ ] 公开 API 变更已更新 README

## 工作方式

- 只做 Issue 里明确要求的事，不顺手重构无关代码。
- 拿不准就在 PR 描述里列出假设，不要替人类做产品决定。

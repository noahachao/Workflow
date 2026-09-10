# Changelog

## [1.0.1](https://github.com/noahachao/Workflow/compare/v1.0.0...v1.0.1) (2026-09-10)


### Bug Fixes

* 仓库名从 remote 提取（目录名≠仓库名时降频探测 404） ([#16](https://github.com/noahachao/Workflow/issues/16)) ([78d9fd8](https://github.com/noahachao/Workflow/commit/78d9fd84a35b450c288bfff8afc1f9f0a5b9a12b))

## 1.0.0 (2026-09-10)


### Features

* 一人公司 AI 自动化工具链模板 ([ad44159](https://github.com/noahachao/Workflow/commit/ad44159335b398a7ede3f96866a59689b718230b))
* 发布自动化升级（release-please + scorecard） ([#9](https://github.com/noahachao/Workflow/issues/9)) ([0479b2c](https://github.com/noahachao/Workflow/commit/0479b2caf0fca4b3680b4ffc88334feaa1efe1e4))
* 实现 subtract 减法函数（附测试） ([#7](https://github.com/noahachao/Workflow/issues/7)) ([fa63c62](https://github.com/noahachao/Workflow/commit/fa63c62e423fb44544457c1865e1cfde933c6e47)), closes [#6](https://github.com/noahachao/Workflow/issues/6)
* 新增 [@pi](https://github.com/pi) 机器人 workflow（本地同款 agent 云端干活，任一 provider key 可用） ([c18fb78](https://github.com/noahachao/Workflow/commit/c18fb788d29599480ea428716fa348f9bacb90db))
* 新增免费 AI 审查（pi + Gemini 免费层，逐行中文报告） ([7d11ef3](https://github.com/noahachao/Workflow/commit/7d11ef319a50e9ec9b70431870bf96a9b235a411))
* 标签式自动合并（私有库免费替代分支保护） ([#8](https://github.com/noahachao/Workflow/issues/8)) ([9a65e1a](https://github.com/noahachao/Workflow/commit/9a65e1a355a50f95537c32e87dc05c970bd57ba5))


### Bug Fixes

* auto-merge 轮询兜底 + pi-review job级secrets非法引用修复 ([#10](https://github.com/noahachao/Workflow/issues/10)) ([07c5c33](https://github.com/noahachao/Workflow/commit/07c5c3378264f170d9165821ed08a5cf1f28e3cf))
* pin pre-commit/action 版本；CodeQL 仅公开仓库跑，私有仓库用 Gitleaks+npm audit 兜底 ([a8b3484](https://github.com/noahachao/Workflow/commit/a8b348402bff854641d1b35be6e45d25faaae308))
* sweep 忽略自身 check（根治 PR 事件版 sweep 自锁/尸 fail 挡合并） ([#12](https://github.com/noahachao/Workflow/issues/12)) ([9c2be8d](https://github.com/noahachao/Workflow/commit/9c2be8d35f11cdabddba7de4ead0dad3ddfa2f25))
* sweep 改单次快照（避免 --watch 对长期 pending 的检查无限等待） ([#11](https://github.com/noahachao/Workflow/issues/11)) ([a2a0b25](https://github.com/noahachao/Workflow/commit/a2a0b2532ee82cf3094787597b4ec9aef7efe3eb))
* 仓库名从 remote 提取（目录名≠仓库名时降频探测 404） ([#15](https://github.com/noahachao/Workflow/issues/15)) ([76ece0d](https://github.com/noahachao/Workflow/commit/76ece0d1c0454c955f2afab5200fc8147ea4eb3c))
* 固化家训实战经验到模板 ([1a69f81](https://github.com/noahachao/Workflow/commit/1a69f81484747bd86b1aa4e96bffaa5be73d2c26))

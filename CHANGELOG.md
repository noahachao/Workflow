# Changelog

## [1.1.0](https://github.com/noahachao/Workflow/compare/v1.0.1...v1.1.0) (2026-09-11)


### Features

* **index:** 增加 multiply(a, b) 乘法工具函数及测试 ([#29](https://github.com/noahachao/Workflow/issues/29)) ([93ef712](https://github.com/noahachao/Workflow/commit/93ef712eab6975a9e330f9448b6c497044b294e6))
* **index:** 新增 clamp(value, min, max) 截断函数 ([#39](https://github.com/noahachao/Workflow/issues/39)) ([9cf29b9](https://github.com/noahachao/Workflow/commit/9cf29b91d060fbc79af6dd3526053f5e9f959988))
* **math:** 增加 divide(a, b) 除法工具函数，除数为 0 抛 Error ([#32](https://github.com/noahachao/Workflow/issues/32)) ([def96e0](https://github.com/noahachao/Workflow/commit/def96e0cc46aa1dc8834bb0470637da3e4c2824a))
* **math:** 增加 power(a, b) 幂函数及测试 ([#34](https://github.com/noahachao/Workflow/issues/34)) ([#35](https://github.com/noahachao/Workflow/issues/35)) ([bbc850c](https://github.com/noahachao/Workflow/commit/bbc850c7a44c8a694a49fe31def2c1755ba7c6b1))
* **src:** 增加 modulo(a, b) 取余工具函数 ([#37](https://github.com/noahachao/Workflow/issues/37)) ([36d2ed9](https://github.com/noahachao/Workflow/commit/36d2ed9337f3cf0306933e487255a90184ac8a44))


### Bug Fixes

* [@pi](https://github.com/pi) 固定 glm-5.3——仅 --provider 不选模型时落到表首 glm-4.6v(视觉小模型)，只会文本汇报不调工具 ([#25](https://github.com/noahachao/Workflow/issues/25)) ([b1294db](https://github.com/noahachao/Workflow/commit/b1294dbbfbd6315d406652bef84bdd4d4ebb3be4))
* apply 脚本分发 AGENTS.md（仅目标缺失时装，防覆盖库特有规则） ([#22](https://github.com/noahachao/Workflow/issues/22)) ([6074af3](https://github.com/noahachao/Workflow/commit/6074af3ac8c7003bd0357763a0b31d498d2c089f))
* apply 脚本分发 AGENTS.md（仅目标缺失时装，防覆盖库特有规则） ([#23](https://github.com/noahachao/Workflow/issues/23)) ([31c7f0d](https://github.com/noahachao/Workflow/commit/31c7f0d3b46d82b143455dc1a81cb36dbbd6a6b7))
* pi 产出检测改 commit 差比对——pi 先 commit 后工作区干净，porcelain 检测永远误判无改动 ([#27](https://github.com/noahachao/Workflow/issues/27)) ([cb7ac60](https://github.com/noahachao/Workflow/commit/cb7ac60ae51f10af951f4d0aeb07bf135d194da1))
* sweep 合并后补刀关 issue——GITHUB_TOKEN 建 PR 的 Closes #N 被 GitHub 忽略（防火墙第四形态） ([#30](https://github.com/noahachao/Workflow/issues/30)) ([48c7505](https://github.com/noahachao/Workflow/commit/48c75056d46e624bed97a60910085b9904fb0460))
* sweep 补 issues:write 权限——gh issue close 静默失败致 issue 不关 ([#33](https://github.com/noahachao/Workflow/issues/33)) ([a5834c0](https://github.com/noahachao/Workflow/commit/a5834c097d102bcdaac001e4d1f929e902dfa5c0))
* 代码审查批次1——pi 身份门禁(防陌生人滥用)、sweep 防 no-checks PR 炸死+单 PR 合并失败不炸循环+并发闸、scorecard 摘幽灵 id-token 权限、pi 改动检测含 untracked、ci 注释缩进、release/pi-review 注释纠偏 ([#21](https://github.com/noahachao/Workflow/issues/21)) ([082a8d2](https://github.com/noahachao/Workflow/commit/082a8d2d925e51917e93f7894590ff730d20dab6))

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

# FurEnglish 初始化（test 分支）

本文件由初始化脚本在 `test/init-project` 分支上提交，用于演示 `test:` 前缀 PR 的 CI 流程（构建 APK 供测试，禁止合并 main）。

- CI 工作流：`.github/workflows/build-apk.yml`
- 分支保护：main 需通过 `build` 状态检查、禁止 force push、禁止 `test:` 前缀 PR 合并
- 词典占位：`assets/dictionary/words.json`

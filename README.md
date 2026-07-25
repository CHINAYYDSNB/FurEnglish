# lexi - 英语词典

> Flutter 跨平台英语词典 · Android 10+ / Windows · 联网优先 · 本地兜底

## 功能

- 🔍 **单词查询**：英→中 / 中→英，< 200ms（本地）/ < 1s（联网）
- 📝 **句子查询**：智能切分短语 → 以短语为单位查 → 降级逐词
- 🔊 **TTS 发音**：离线发音，单词/例句一键朗读
- 📚 **收藏夹**：长按收藏，分组管理
- 🌐 **联网优先**：有道智云 → 百度翻译 → 本地词库（三级兜底）
- ✨ **苹果风 UI**：毛玻璃卡片 + Hero 动画 + 零白屏
- 💻 **Windows 桌面**：侧边栏 + Ctrl+K 快捷键 + 双栏布局

## 技术栈

- Flutter 3.44.6
- Riverpod（状态管理）
- Dio（网络请求）
- Sqflite（本地缓存/历史/收藏）
- flutter_tts（离线发音）
- flutter_animate + BackdropFilter（动效/毛玻璃）

## 快速开始

### 用户

1. 下载最新 APK（GitHub Actions Artifacts）
2. 安装到 Android 10+ 设备
3. 打开 App → 输入有道/百度 API Key（设置页）
4. 开始查词

### 开发者（HY3 / AI）

1. 读 `AI_INSTRUCTIONS.md`（这是你的圣经）
2. 按 Task 编号逐个完成
3. Commit 前缀：`test:` / `wip:` / `done:` / `partial:` / `shell:` / `blocked:`
4. `test:` 构建 APK 给用户测，`done:` 才能合并 main

## API Key 申请（免费）

### 有道智云（主力）
1. 打开 https://ai.youdao.com/
2. 注册账号 → 实名认证（个人免费）
3. 创建应用 → 选"自然语言翻译"服务
4. 获取 `appKey` 和 `appSecret`

### 百度翻译（兜底）
1. 打开 https://fanyi-api.baidu.com/
2. 注册 → 管理控制台 → 开通翻译服务
3. 获取 `appid` 和 `key`（免费版 QPS=1，够个人用）

## 词库格式

`assets/dictionary/words.json` 示例：

```json
{
  "serendipity": {
    "phonetic": "/ˌser.ənˈdɪp.ə.ti/",
    "pos": "n.",
    "definitions": ["意外发现珍奇事物的本领"],
    "frequency": 8500,
    "curriculum": "CET-6",
    "examples": [
      {"en": "A fortunate serendipity changed his life.", "zh": "一次幸运的意外发现改变了他的人生。"}
    ]
  }
}
```

## 验收标准

打开 App → 打字 → 0.2s 出结果 + 音标 + 例句 + 🔊 能发音 = 完成

## License

MIT

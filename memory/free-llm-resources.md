# 🎁 免费/便宜 AI 模型方案汇总

> 更新时间：2026-03-03
> 数据来源：https://github.com/cheahjs/free-llm-api-resources

---

## 🆓 完全免费方案

### 1. OpenRouter ⭐ 推荐
**链接**: https://openrouter.ai

**限制**:
- 20 请求/分钟
- 50 请求/天
- 终身充值 $10 可提升到 1000 请求/天

**免费模型**:
- ✅ Gemma 3 系列 (1B/4B/12B/27B)
- ✅ Llama 3.2 3B / 3.3 70B Instruct
- ✅ Mistral Small 3.1 24B
- ✅ Hermes 3 Llama 3.1 405B
- ✅ Qwen3 系列 (4B/Coder/Next-80B)
- ✅ GPT-OSS 系列 (20B/120B)
- ✅ NVIDIA Nemotron Nano 系列

---

### 2. Google AI Studio ⭐ 推荐
**链接**: https://aistudio.google.com

**限制** (非 UK/CH/EEA/EU 地区数据用于训练):

| 模型 | 限制 |
|------|------|
| Gemini 3 Flash | 25万 tokens/分钟, 20 请求/天 |
| Gemini 3.1 Flash-Lite | 25万 tokens/分钟, 500 请求/天 |
| Gemma 3 27B/12B/4B/1B | 1.5万 tokens/分钟, 14,400 请求/天 |

---

### 3. Cerebras ⭐ 高速
**链接**: https://cloud.cerebras.ai

**限制**:
- 30 请求/分钟
- 60,000 tokens/分钟
- 14,400 请求/天

**免费模型**:
- ✅ Llama 3.3 70B
- ✅ Llama 3.1 8B
- ✅ Qwen 3 32B / Qwen 3 235B
- ✅ GPT-OSS 120B

---

### 4. Groq ⭐ 极速
**链接**: https://console.groq.com

**限制** (按模型):

| 模型 | 限制 |
|------|------|
| Llama 3.1 8B | 14,400 请求/天, 6,000 tokens/分钟 |
| Llama 3.3 70B | 1,000 请求/天, 12,000 tokens/分钟 |
| Llama 4 Scout | 1,000 请求/天, 30,000 tokens/分钟 |
| Kimi K2 Instruct | 1,000 请求/天, 10,000 tokens/分钟 |
| Whisper Large v3 | 2,000 请求/天 |
| GPT-OSS 20B/120B | 1,000 请求/天 |

---

### 5. Cloudflare Workers AI
**链接**: https://developers.cloudflare.com/workers-ai

**限制**: 10,000 neurons/天

**免费模型**:
- Llama 3.1/3.2/3.3 系列
- Gemma 2B/7B
- Mistral 7B
- Qwen 系列
- DeepSeek Coder/Maths
- 数十种开源模型

---

### 6. GitHub Models
**链接**: https://github.com/marketplace/models

**限制**: 取决于 Copilot 订阅等级

**免费模型**:
- GPT-4o / GPT-4o-mini
- Claude 3.5 Sonnet
- Llama 4 系列
- Mistral Large/Small
- Phi-4
- DeepSeek R1

---

### 7. Mistral (La Plateforme)
**链接**: https://console.mistral.ai

**要求**: 手机号验证，需同意数据训练

**限制**: 1 请求/秒, 50万 tokens/分钟, 10亿 tokens/月

---

### 8. Mistral (Codestral)
**链接**: https://codestral.mistral.ai

**限制**: 30 请求/分钟, 2,000 请求/天

---

### 9. NVIDIA NIM
**链接**: https://build.nvidia.com

**要求**: 手机号验证

**限制**: 40 请求/分钟

---

### 10. HuggingFace Inference
**链接**: https://huggingface.co/docs/inference-providers

**限制**: $0.10/月 额度

---

### 11. Cohere
**链接**: https://cohere.com

**限制**: 20 请求/分钟, 1,000 请求/月

---

## 💰 超低价试用方案

| 提供商 | 试用额度 | 链接 |
|--------|----------|------|
| **Fireworks** | $1 | https://fireworks.ai |
| **Baseten** | $30 | https://app.baseten.co |
| **Nebius** | $1 | https://studio.nebius.com |
| **Novita** | $0.50/年 | https://novita.ai |
| **AI21** | $10/3个月 | https://studio.ai21.com |
| **Upstage** | $10/3个月 | https://console.upstage.ai |
| **NLP Cloud** | $15 | https://nlpcloud.com |
| **Alibaba Cloud** | 100万 tokens/模型 | https://bailian.console.aliyun.com |
| **Modal** | $5/月 或 $30/月 | https://modal.com |
| **Inference.net** | $1 + $25 (问卷) | https://inference.net |
| **Hyperbolic** | $1 | https://app.hyperbolic.xyz |
| **SambaNova** | $5/3个月 | https://cloud.sambanova.ai |
| **Scaleway** | 100万 tokens | https://console.scaleway.com |

---

## 🏆 推荐组合方案

### 日常轻量使用
1. **OpenRouter** - 50 请求/天免费 + Gemma/Llama 系列
2. **Google AI Studio** - Gemini Flash 500 请求/天
3. **Groq** - Llama 3.3 70B 1,000 请求/天

### 代码开发
1. **GitHub Models** - Copilot 用户免费
2. **Mistral Codestral** - 2,000 请求/天
3. **Cerebras** - Qwen3 235B 14,400 请求/天

### 高速推理
1. **Groq** - 最快响应速度
2. **Cerebras** - 专用硬件加速
3. **Cloudflare** - 全球边缘部署

---

## ⚠️ 使用建议

1. **不要滥用** - 避免超出限制导致封号
2. **多账号备用** - 注册多个免费服务作为备份
3. **监控用量** - 关注各平台的请求限制
4. **优先本地** - 小模型可考虑本地部署 (Ollama)

---

## 🔧 OpenClaw 配置建议

在 `~/.openclaw/config.yaml` 中添加多个免费提供商：

```yaml
models:
  providers:
    openrouter:
      baseUrl: https://openrouter.ai/api/v1
      apiKey: ${OPENROUTER_API_KEY}
    groq:
      baseUrl: https://api.groq.com/openai/v1
      apiKey: ${GROQ_API_KEY}
    cerebras:
      baseUrl: https://api.cerebras.ai/v1
      apiKey: ${CEREBRAS_API_KEY}
```

---

*最后更新: 2026-03-03*

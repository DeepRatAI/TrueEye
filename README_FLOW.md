# 🧿 TrueEye LangFlow - Direct Flow Usage

**Want to use TrueEye without complex installations?** Use the flow directly in LangFlow.

## 🚀 Ultra-Fast Setup (5 minutes)

### 1. **Install LangFlow**

```bash
pip install langflow
```

### 2. **Run LangFlow**

```bash
langflow run
```

Access: http://localhost:7860

### 3. **Import the Flow**

1. In the LangFlow interface, click on **"Import"**
2. Select the `TrueEyeBeta.json` file
3. The complete flow will load automatically!

### 4. **Configure Credentials**

Configure your Anthropic API key in the AnthropicModel components:

- Go to each "AnthropicModel" node (there are several)
- Add your `ANTHROPIC_API_KEY`
- Or configure it as an environment variable

### 5. **Use it!**

- Run the flow from the playground
- Enter a news URL in the ChatInput
- Receive the complete analysis in the ChatOutput

## ⚙️ **Variable Configuration**

### Required API Keys:

- **ANTHROPIC_API_KEY**: For Claude models (required)

### Environment Variables (optional):

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
langflow run
```

## 🧠 **What Does This Flow Do?**

The `TrueEyeBeta.json` flow implements a complete media analysis pipeline:

1. **📄 Content Extraction**

   - Takes news/article URLs
   - Extracts and parses text automatically

2. **🤖 Multi-Model Analysis**

   - Uses multiple Claude (Anthropic) instances
   - Parallel analysis of different aspects

3. **📊 Bias Detection**

   - Identifies narrative polarization
   - Detects manipulative techniques
   - Classifies political/ideological orientation

4. **🔍 Fact-Checking**

   - Identifies logical fallacies
   - Contrasts with verified sources
   - Provides verification links

5. **👥 Audience Analysis**

   - Profiles target audience
   - Identifies emotional appeals
   - Detects exploited cognitive biases

6. **📈 Risk Assessment**
   - Measures polarization potential
   - Evaluates social impact
   - Suggests alternative sources

## 💡 **Direct Flow Advantages**

- ✅ **Immediate setup**: No need to configure complex environments
- ✅ **Integrated playground**: Visual interface for testing
- ✅ **Modifiable**: You can easily adjust prompts and logic
- ✅ **Extensible**: Add new nodes as needed
- ✅ **Cross-platform**: Works on any OS with Python

## 🆚 **Flow vs Complete App**

| Feature           | LangFlow Flow       | TrueEye App         |
| ----------------- | ------------------- | ------------------- |
| **Setup**         | 5 minutes           | More robust         |
| **Interface**     | LangFlow Playground | Custom web UI       |
| **Customization** | Visual, easy        | Code, more powerful |
| **Deployment**    | Local/development   | Production ready    |
| **Target users**  | Developers/testers  | End users           |

## 📚 **Resources**

- **LangFlow Documentation**: https://langflow.org/
- **Anthropic API**: https://docs.anthropic.com/
- **Complete TrueEye Project**: [Link to main repo]

## 🤝 **Contributions**

Flow improvements? Pull requests welcome!

- Optimize prompts
- Add new analyses
- Improve accuracy
- Integrate new models

---

**🧿 TrueEye Flow - Smart media analysis in minutes**

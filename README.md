# Natural Language Shell (nlsh)

Zsh plugin for generating complex shell commands from natural language. For context-aware coding, use Claude Code or Codex.

![Natural Language Shell Demo](https://github.com/PsychArch/nlsh/blob/main/capture.gif)

## Features

- Converts natural language to shell commands
- Supports OpenAI-compatible API endpoints
- Keyboard shortcuts: `Alt+Enter`/`Ctrl+⬇️` (Linux/Windows), `Option+Return` (macOS)

## Requirements

Zsh, curl, jq, API key from your provider (OpenAI-compatible endpoint)

## Installation

### Using antidote

Add to `.zsh_plugins.txt`:
```text
PsychArch/nlsh
```

### Using zinit

Add to `.zshrc` after sourcing Zinit:
```zsh
zinit light PsychArch/nlsh
```

### Using zsh-snap (znap)

Add to `.zshrc` after sourcing `znap.zsh`:
```zsh
znap source PsychArch/nlsh
```

### Manual

```bash
git clone https://github.com/PsychArch/nlsh ~/.nlsh
echo 'source ~/.nlsh/nlsh.plugin.zsh' >> ~/.zshrc
source ~/.zshrc
```

## Usage

Type natural language, press keyboard shortcut, review and execute generated command.

## Configuration

```bash
export OPENAI_API_KEY="your-provider-api-key"   # Required
export OPENAI_MODEL="z-ai/glm-4.7"              # Optional, default: z-ai/glm-4.7
# Example models: x-ai/grok-4.1-fast, z-ai/glm-4.7
export OPENAI_URL_BASE="https://openrouter.ai/api/v1" # Optional, default: https://openrouter.ai/api/v1
export OPENAI_PROXY="..."                              # Optional
```

## License

MIT License

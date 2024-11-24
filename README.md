# Natural Language Shell (nlsh) 🚀

A Zsh plugin that allows you to interact with your shell using natural language.

![](https://github.com/PsychArch/nlsh/blob/main/capture.gif)

## Features

- 🤖 Converts natural language to shell commands
- 🔄 Supports multiple LLM providers (OpenAI API compatible)
- 🎯 Special support for X.AI's Grok model
- ⌨️ Simple keyboard shortcut (Alt+Enter)

## Requirements

- Zsh
- curl
- jq
- An API key for OpenAI or X.AI

## Installation

### Using antidote

Choose one of these installation methods:

Manual antidote bundle (if you already use antidote)

1. Add to your `.zsh_plugins.txt`:
```text
PsychArch/nlsh
```

2. Or use antidote bundle directly in your `.zshrc`:
```zsh
# Initialize antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Add to your plugins
antidote bundle PsychArch/nlsh
```

## Usage

1. Type your natural language command in the terminal
2. Press `Alt+Enter`
3. The plugin will convert your text to a shell command
4. Press Enter to execute or modify as needed

## Configuration

You can customize the plugin behavior with these environment variables:

```bash
#For OpenAI
export OPENAI_API_KEY="your-api-key"
#For X.AI (Grok)
export XAI_API_KEY="your-xai-api-key
```

## How It Works

1. When triggered, the plugin captures your natural language input
2. Collects system information (OS, distribution, whether root user)
3. Sends the request to the configured LLM provider
4. Replaces your input with the generated shell command

## License

MIT License - See LICENSE file for details.

## Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

# Natural Language Shell (nlsh)

A Zsh plugin that allows you to interact with your shell using natural language.

![Natural Language Shell Demo](https://github.com/PsychArch/nlsh/blob/main/capture.gif)

## Features

- 🤖 Converts natural language to shell commands
- 🔄 Supports OpenAI-compatible API endpoints
- ⌨️ Simple keyboard shortcuts:
  - Linux/Windows: `Alt+Enter` or `Ctrl+⬇️`
  - macOS: `Option+Return`

## Requirements

- Zsh shell
- curl command-line tool
- jq JSON processor
- OpenAI API key or compatible service

## Installation

### Option 1: Using antidote

Add to your `.zsh_plugins.txt`:

```text
PsychArch/nlsh
```

Or add directly to your `.zshrc`:

```zsh
# Initialize antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
source <(antidote init)

# Add nlsh plugin
antidote bundle PsychArch/nlsh
```

### Option 2: Manual Installation

```bash
# 1. Clone the repository
git clone https://github.com/PsychArch/nlsh ~/.nlsh

# 2. Add to your .zshrc
echo 'source ~/.nlsh/nlsh.plugin.zsh' >> ~/.zshrc

# 3. Reload your shell
source ~/.zshrc
```

## Usage

1. Type your natural language command in the terminal
2. Press the keyboard shortcut for your platform:
   - Linux/Windows: `Alt+Enter` or `Ctrl+⬇️`
   - macOS: `Option+Return`
3. Review the generated shell command
4. Press `Enter` to execute or modify as needed

## Configuration

Configure the plugin using these environment variables in your `.zshrc`:

```bash
# Required
export OPENAI_API_KEY="your-api-key"

# Optional configurations
export OPENAI_MODEL="gpt-4"                              # Default: gpt-3.5-turbo
export OPENAI_URL_BASE="https://your-api-endpoint.com"   # Default: https://api.openai.com
export OPENAI_PROXY="http://proxy.example.com:8080"      # Optional: HTTP proxy
```

## How It Works

1. The plugin captures your natural language input when triggered
2. Collects relevant system information:
   - Operating system
   - Distribution details
   - User privileges
3. Sends a request to the configured OpenAI-compatible API
4. Converts the response into an executable shell command

## Security Notes

- Review generated commands before execution
- Be cautious with sensitive system commands
- Keep your API key secure

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


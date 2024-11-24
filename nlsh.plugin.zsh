# Natural Language Shell Plugin for Zsh

# Load dependencies
source "${0:A:h}/src/system_info.zsh"
source "${0:A:h}/src/llm_client.zsh"
source "${0:A:h}/src/ui.zsh"

# Main function to handle natural language input
nlsh-process() {
    local input=$BUFFER  # Get current line content
    
    # Show processing spinner
    nlsh-ui-start-spinner "   🤖 Converting natural language to shell command... ✨      "
    
    # Get system information for context
    local system_context=$(nlsh-get-system-info)
    
    # Send request to LLM
    local command=$(nlsh-llm-get-command "$input" "$system_context")
    
    # Stop spinner
    nlsh-ui-stop-spinner
    
    # Replace current line with the command
    BUFFER="$command"
    CURSOR=${#BUFFER}  # Move cursor to end of line
    zle reset-prompt
}

# Key binding function
nlsh-key-binding() {
    nlsh-process
}

# Register the widget
zle -N nlsh-key-binding
# Bind to Alt+Enter (Option+Return on macOS)
bindkey '^[^M' nlsh-key-binding
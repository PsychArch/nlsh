# Natural Language Shell Plugin for Zsh

# Load dependencies
source "${0:A:h}/src/system_info.zsh"
source "${0:A:h}/src/llm_client.zsh"
source "${0:A:h}/src/ui.zsh"

# Main function to handle natural language input
nlsh-process() {
    local input=$BUFFER  # Get current line content
    local original_buffer=$BUFFER

    # Show processing spinner
    nlsh-ui-start-spinner "   🤖 Converting natural language to shell command... ✨      "

    # Get system information for context
    local system_context=$(nlsh-get-system-info)

    # Send request to LLM
    local command
    command=$(nlsh-llm-get-command "$input" "$system_context" 2>&1)
    local exit_status=$?

    # Stop spinner
    nlsh-ui-stop-spinner

    if (( exit_status != 0 )); then
        # Show error without clobbering the user's buffer
        BUFFER="$original_buffer"
        CURSOR=${#BUFFER}
        zle -M "$command"
        return $exit_status
    fi

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

# Check if using the jeffreytse/zsh-vi-mode plugin
if typeset -f zvm_define_widget &>/dev/null; then
    # For jeffreytse/zsh-vi-mode plugin
    # This function gets auto-executed by the plugin after lazy keybindings are set
    function zvm_after_lazy_keybindings() {
        # Register widget with ZVM
        zvm_define_widget nlsh-key-binding
        
        # Bind in both insert and normal modes
        zvm_bindkey viins '^[^M' nlsh-key-binding     # Alt+Enter in insert mode
        zvm_bindkey vicmd '^[^M' nlsh-key-binding     # Alt+Enter in normal mode
        zvm_bindkey viins '^[[1;5B' nlsh-key-binding  # Ctrl+DownArrow in insert mode
        zvm_bindkey vicmd '^[[1;5B' nlsh-key-binding  # Ctrl+DownArrow in normal mode
    }

    # For jeffreytse/zsh-vi-mode plugin - handle initialization
    function zvm_after_init() {
        # Additional setup after zsh-vi-mode initializes
        # This ensures our keybindings take precedence
        bindkey -M viins '^[^M' nlsh-key-binding
        bindkey -M vicmd '^[^M' nlsh-key-binding
        bindkey -M viins '^[[1;5B' nlsh-key-binding
        bindkey -M vicmd '^[[1;5B' nlsh-key-binding
    }
elif bindkey -lL | grep -q "main.*vi" || bindkey -l | grep -q "viins"; then
    # For built-in zsh vi mode
    bindkey -M viins '^[^M' nlsh-key-binding      # Alt+Enter in insert mode
    bindkey -M vicmd '^[^M' nlsh-key-binding      # Alt+Enter in normal mode
    bindkey -M viins '^[[1;5B' nlsh-key-binding   # Ctrl+DownArrow in insert mode
    bindkey -M vicmd '^[[1;5B' nlsh-key-binding   # Ctrl+DownArrow in normal mode
else
    # Standard bindings for non-vi environments
    # Bind to Alt+Enter (Option+Return on macOS)
    bindkey '^[^M' nlsh-key-binding
    # Bind to Ctrl+DownArrow
    bindkey '^[[1;5B' nlsh-key-binding
fi

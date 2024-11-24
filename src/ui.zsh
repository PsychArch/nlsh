# UI components

# Spinner frames (using fancy Unicode characters)
NLSH_SPINNER_FRAMES=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

# Global variable to control spinner
NLSH_SPINNER_ACTIVE=0

nlsh-ui-start-spinner() {
    local message=$1
    NLSH_SPINNER_ACTIVE=1
    
    # Run spinner in background with proper cursor handling
    (
        # Save cursor position and hide it
        printf "\033[s\033[?25l"
        
        while [[ $NLSH_SPINNER_ACTIVE -eq 1 ]]; do
            for frame in $NLSH_SPINNER_FRAMES; do
                [[ $NLSH_SPINNER_ACTIVE -eq 0 ]] && break
                printf "\r%s %s" "$frame" "$message"
                sleep 0.1
            done
        done
        
        # Restore cursor position and show it
        printf "\r\033[K\033[?25h\033[u"
    ) &!

    NLSH_SPINNER_PID=$!
}

nlsh-ui-stop-spinner() {
    NLSH_SPINNER_ACTIVE=0
    [[ -n $NLSH_SPINNER_PID ]] && kill $NLSH_SPINNER_PID 2>/dev/null
    wait $NLSH_SPINNER_PID 2>/dev/null
    # Ensure cursor is visible and line is cleared
    printf "\r\033[K\033[?25h"
}
  
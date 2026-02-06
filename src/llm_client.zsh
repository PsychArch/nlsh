# LLM client handler for natural language shell commands

# Helper function to validate environment
nlsh-validate-environment() {
    if [[ -z $OPENAI_API_KEY ]]; then
        print -u2 "Error: OPENAI_API_KEY environment variable is not set"
        return 1
    fi
    if ! command -v jq >/dev/null 2>&1; then
        print -u2 "Error: jq is required but not found in PATH"
        return 1
    fi
    if ! command -v curl >/dev/null 2>&1; then
        print -u2 "Error: curl is required but not found in PATH"
        return 1
    fi
    return 0
}

nlsh-parse-response() {
    local response="$1"

    # Extract content using jq with multiple possible JSON paths
    local content
    if ! content=$(print -r -- "$response" | jq -r '
        if .choices[0].message.content != null then
            .choices[0].message.content
        elif .choices[0].text != null then
            .choices[0].text
        else
            "error: unknown response format"
        end' 2>/dev/null); then
        print -u2 "Error: Failed to parse API response: $response"
        return 1
    fi

    # Check for error in content
    if [[ "$content" == "error:"* ]]; then
        print -u2 "Error: $content"
        return 1
    fi

    print -r -- "$content"
}

nlsh-prepare-payload() {
    local input=$1
    local system_context=$2
    local model=${OPENAI_MODEL:-"z-ai/glm-4.7"}

    jq -n         --arg model "$model"         --arg system "You are a shell command generator. Only output the exact command to execute in plain text. Do not include any other text. Do not use Markdown. System context: $system_context"         --arg user "$input"         '{model:$model, messages:[{role:"system", content:$system},{role:"user", content:$user}], temperature:0}'
}

nlsh-make-api-request() {
    local payload=$1
    local url_base=${OPENAI_URL_BASE:-"https://openrouter.ai/api/v1"}
    local endpoint="${url_base%/}/chat/completions"
    local curl_cmd=(curl -s -S)
    
    # Add proxy if configured
    [[ -n $OPENAI_PROXY ]] && curl_cmd+=(--proxy "$OPENAI_PROXY")
    
    # Make API request with error handling
    local response
    if ! response=$("${curl_cmd[@]}" \
         -H "Authorization: Bearer $OPENAI_API_KEY" \
         -H "Content-Type: application/json" \
         --max-time 30 \
         -d "$payload" \
         "$endpoint" 2>&1); then
        print -u2 "Error: Failed to connect to API - $response"
        return 1
    fi
    
    print -r -- "$response"
}

nlsh-check-api-error() {
    local response=$1

    if print -r -- "$response" | jq -e '.error' >/dev/null 2>&1; then
        local error_msg=$(print -r -- "$response" | jq -r '.error.message')
        print -u2 "Error: API request failed - $error_msg"
        return 1
    fi
    return 0
}

nlsh-llm-get-command() {
    local input=$1
    local system_context=$2
    
    # Validate environment
    nlsh-validate-environment || return 1
    
    # Prepare request payload
    local payload
    payload=$(nlsh-prepare-payload "$input" "$system_context")
    
    # Make API request
    local response
    response=$(nlsh-make-api-request "$payload") || return 1
    
    # Check for API errors
    nlsh-check-api-error "$response" || return 1
    
    # Parse and return response
    nlsh-parse-response "$response"
}

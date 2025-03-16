# LLM client handler for natural language shell commands

# Helper function to validate environment
nlsh-validate-environment() {
    if [[ -z $OPENAI_API_KEY ]]; then
        echo "Error: OPENAI_API_KEY environment variable is not set"
        return 1
    fi
    return 0
}

nlsh-parse-response() {
    local response="$1"
    
    # Extract content using jq with multiple possible JSON paths
    local content
    if ! content=$(echo "$response" | jq -r '
        if .choices[0].message.content != null then
            .choices[0].message.content
        else
            "error: unknown response format"
        end' 2>/dev/null); then
        echo "Error: Failed to parse API response: $response"
        return 1
    fi
    
    # Check for error in content
    if [[ "$content" == "error:"* ]]; then
        echo "Error: $content"
        return 1
    fi
    
    printf '%b' "$content"
}

nlsh-prepare-payload() {
    local input=$1
    local system_context=$2
    local model=${OPENAI_MODEL:-"gpt-3.5-turbo"}
    
    cat <<EOF
{
    "model": "$model",
    "messages": [
        {"role": "system", "content": "You are a shell command generator. Only output the exact command to execute in plain text. Do not include any other text. Do not use Markdown. System context: $system_context"},
        {"role": "user", "content": "$input"}
    ],
    "temperature": 0
}
EOF
}

nlsh-make-api-request() {
    local payload=$1
    local url_base=${OPENAI_URL_BASE:-"https://api.openai.com/v1"}
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
         "$url_base/chat/completions" 2>&1); then
        echo "Error: Failed to connect to API - $response"
        return 1
    fi
    
    echo "$response"
}

nlsh-check-api-error() {
    local response=$1
    
    if echo "$response" | jq -e '.error' >/dev/null 2>&1; then
        local error_msg=$(echo "$response" | jq -r '.error.message')
        echo "Error: API request failed - $error_msg"
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

# LLM client handler

nlsh-parse-response() {
    local response="$1"
    
    # Extract content using jq
    local content
    if content=$(echo "$response" | jq -r '.choices[0].message.content'); then
        echo "$content"
    else
        echo "Error: Cannot parse response"
        return 1
    fi
}

nlsh-llm-get-command() {
    local input=$1
    local system_context=$2
    
    # Determine API configuration based on available keys
    local api_key api_base model
    if [[ -n $XAI_API_KEY ]]; then
        api_key=$XAI_API_KEY
        api_base="https://api.x.ai"
        model="grok-beta"
    elif [[ -n $OPENAI_API_KEY ]]; then
        api_key=$OPENAI_API_KEY
        api_base="https://api.openai.com"
        model="gpt-3.5-turbo"
    else
        echo "Error: No supported API key found. Set OPENAI_API_KEY or XAI_API_KEY"
        return 1
    fi
   
    # Prepare request payload
    local payload="{
        \"model\": \"$model\",
        \"messages\": [
            {\"role\": \"system\", \"content\": \"You are a shell command generator. Only output the exact command to execute. System context: $system_context\"},
            {\"role\": \"user\", \"content\": \"$input\"}
        ]
    }"
    
    # Make API request using OpenAI-compatible endpoint
    local response=$(curl -s -S \
         -H "Authorization: Bearer $api_key" \
         -H "Content-Type: application/json" \
         --max-time 30 \
         -d "$payload" \
         "$api_base/v1/chat/completions")
    
    # Check if curl failed
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to connect to API"
        return 1
    fi
    # Check HTTP status code
    if echo "$response" | grep -q "HTTP_STATUS:4\|HTTP_STATUS:5"; then
        echo "Error: API request failed"
        return 1
    fi
    
    nlsh-parse-response "$response"
}
#!/bin/bash

# Load environment variables from ~/.aider.env
ENV_FILE="$HOME/.aider/.env"

DOCKER_IMAGE="paulgauthier/aider-full"

if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
else
    echo "Error: Environment file '$ENV_FILE' not found."
    exit 1
fi

# Ensure required environment variables are set
REQUIRED_VARS=("GIT_EMAIL" "GIT_NAME" "DOCKER_IMAGE" "OPENAI_API_KEY" "DEEPSEEK_API_KEY")
for VAR in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!VAR}" ]]; then
        echo "Error: Environment variable '$VAR' is not set."
        exit 1
    fi
done

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH."
    exit 1
fi

# Setup git configuration
setup_git() {
    git config user.email "$GIT_EMAIL"
    git config user.name "$GIT_NAME"
    echo "Git configured with email '$GIT_EMAIL' and name '$GIT_NAME'."
}

# Display menu and get user choice
display_menu() {
    echo "Select an option:"
    echo "1) OpenAI"
    echo "2) OpenAI with Architect"
    echo "3) Anthropics' Claude"
    echo "4) Anthropics' Claude with Architect"
    echo "5) Deepseek"
    read -p "Enter choice [1-5]: " choice
}

# Run aider in Docker based on user choice
run_aider() {
    case $choice in
        1)
            docker run -it \
                --user "$(id -u):$(id -g)" \
                --volume "$(pwd)":/app \
                "$DOCKER_IMAGE" \
                --openai-api-key "$OPENAI_API_KEY"
            ;;
        2)
            docker run -it \
                --user "$(id -u):$(id -g)" \
                --volume "$(pwd)":/app \
                "$DOCKER_IMAGE" \
                --openai-api-key "$OPENAI_API_KEY" \
            ;;
        3)
            docker run -it \
                --user "$(id -u):$(id -g)" \
                --volume "$(pwd)":/app \
                "$DOCKER_IMAGE" \
                --anthropic-api-key "$ANTHROPIC_API_KEY" \
                --sonnet
            ;;
        4)
            docker run -it \
                --user "$(id -u):$(id -g)" \
                --volume "$(pwd)":/app \
                "$DOCKER_IMAGE" \
                --anthropic-api-key "$ANTHROPIC_API_KEY" \
                --sonnet \ 
                --architect \ 
                --editor-model "claude-2021-10-01" \
                --yes-always

            ;;
        5)
            docker run -it \
                --user "$(id -u):$(id -g)" \
                --volume "$(pwd)":/app \
                -e DEEPSEEK_API_KEY="$DEEPSEEK_API_KEY" \
                "$DOCKER_IMAGE" \
                --deepseek
            ;;
        *)
            echo "Invalid choice."
            exit 1
            ;;
    esac

    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to run aider container."
        exit 1
    fi
}

# Main execution
setup_git
display_menu
run_aider

# Set vi mode.
set -o vi

# Gruvbox Dark colors
GRUVBOX_FG="#ebdbb2"  # Light text
GRUVBOX_BG="#282828"  # Dark background
GRUVBOX_YELLOW="\[\e[38;5;214m\]" # Gruvbox yellow
GRUVBOX_BLUE="\[\e[38;5;109m\]"   # Gruvbox blue
GRUVBOX_GREEN="\[\e[38;5;142m\]"  # Gruvbox green
GRUVBOX_ORANGE="\[\e[38;5;166m\]" # Gruvbox orange
GRUVBOX_RED="\[\e[38;5;167m\]"    # Gruvbox red
GRUVBOX_RESET="\[\e[0m\]"         # Reset color

# Custom PS1 with Gruvbox Dark theme
PS1="${GRUVBOX_YELLOW}\u${GRUVBOX_RESET}"      # Username in yellow
PS1+="@${GRUVBOX_GREEN}\h${GRUVBOX_RESET} "    # Hostname in green
PS1+="[${GRUVBOX_BLUE}\W${GRUVBOX_RESET}]"     # Current directory in blue
PS1+="\n\$ "                                   # Newline + prompt symbol

export PS1


# Get the weather report from the Openweathermap API.
function get_temperature() {
    local response=""
    local response=$(curl --silent 'https://api.openweathermap.org/data/2.5/weather?id=5961564&units=metric&appid=1aeeb13fd7e6a8a9c59f547d2a5a71e8')
    local status=$(echo $response | jq -r '.cod')

    case $status in
        200) printf "Current: %.1f°F\n" "$(echo $response | jq '.main.temp')" 
	     printf "Location: %s %s\n" "$(echo $response | jq '.name' | tr -d '"') $(echo $response | jq '.sys.country' | tr -d '"')"  
             printf "Forecast: %s\n" "$(echo $response | jq '.weather[].description' | tr -d '"')" 
             printf "Min Temp: %.1f°F\n" "$(echo $response | jq '.main.temp_min')" 
             printf "Max Temp: %.1f°F\n" "$(echo $response | jq '.main.temp_max')" 
            ;;
        401) echo "401 error"
            ;;
        *) echo "error"
            ;;
    esac
}

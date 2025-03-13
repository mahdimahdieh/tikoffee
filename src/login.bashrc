#!/bin/bash

CREDENTIALS_FILE="credentials.ini"

# Check if credentials file exists, create if not
if [ ! -f "$CREDENTIALS_FILE" ]; then
    echo "Credentials file not found. Let's create one."
    
    # Prompt for credentials
    read -p "Enter login URL: " url
    read -p "Enter username: " username
    read -sp "Enter password: " password
    echo ""
    
    # Create the credentials.ini file
    cat > "$CREDENTIALS_FILE" << EOL
[login]
url=$url
username=$username
password=$password
EOL
    
    echo "Credentials saved to $CREDENTIALS_FILE"
fi

# Read credentials from the file
url=$(grep "url=" "$CREDENTIALS_FILE" | cut -d= -f2)
username=$(grep "username=" "$CREDENTIALS_FILE" | cut -d= -f2)
password=$(grep "password=" "$CREDENTIALS_FILE" | cut -d= -f2)

# Login function
login() {
    echo "Logging in to $url..."
    
    # Perform login using curl
    response=$(curl -s -X POST "$url" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "username=$username&password=$password")
    
    # Check if login was successful (basic check - you may need to adjust this)
    if [[ $response == *"success"* || $? -eq 0 ]]; then
        echo "Login successful!"
        return 0
    else
        echo "Login failed."
        return 1
    fi
}

# Logout function
logout() {
    echo "Logging out..."
    
    # Perform logout with random credentials
    response=$(curl -s -X POST "${url%/login}/logout" \
        -H "Content-Type: application/json" \
        -d '{"test":"test"}')
    
    echo "Logout completed."
}

# Main script
main() {
    # Login
    login
    login_status=$?
    
    if [ $login_status -eq 0 ]; then
        echo "Logged in successfully. Doing some work..."
        sleep 2  # Simulating some work
        
        # Logout
        logout
    fi
}

# Run the main function
main

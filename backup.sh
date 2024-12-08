#!/bin/bash

# Log file for errors
ERROR_LOG="error.log"

# Redirect all errors to the error.log file
exec 2>$ERROR_LOG

# Display help function
function display_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -d, --directory DIR     Directory to backup"
    echo "  -c, --compression ALGO  Compression algorithm to use (none, gzip, bzip2, xz)"
    echo "  -o, --output FILE       Output file name for the backup"
    echo "  -e, --encrypt PASSWORD  Encryption password for the backup"
    echo "  -h, --help              Display this help message"
    echo ""
    echo "Example:"
    echo "  ./backup.sh -d /my/data -c gzip -o backup.tar.gz -e mypassword"
    exit 0
}

# Check if required dependencies are installed
function check_dependencies() {
    for cmd in tar openssl; do
        if ! command -v $cmd &>/dev/null; then
            echo "Error: $cmd is not installed. Please install it and try again." >&2
            exit 1
        fi
    done
}

# Create a backup archive
function create_backup() {
    local dir="$1"
    local algo="$2"
    local output="$3"

    if [ "$algo" = "none" ]; then
        tar -cf "$output" "$dir" 2>>$ERROR_LOG
    else
        tar --"$algo" -cf "$output" "$dir" 2>>$ERROR_LOG
    fi

    if [ $? -ne 0 ]; then
        echo "Error: Failed to create backup." >&2
        exit 1
    fi
}

# Encrypt the backup
function encrypt_backup() {
    local file="$1"
    local password="$2"
    local encrypted_file="${file}.enc"

    openssl enc -aes-256-cbc -salt -in "$file" -out "$encrypted_file" -pass pass:"$password" 2>>$ERROR_LOG
    if [ $? -ne 0 ]; then
        echo "Error: Failed to encrypt backup." >&2
        exit 1
    fi

    # Remove the unencrypted file after successful encryption
    rm -f "$file"
    echo "Backup encrypted as $encrypted_file"
}

# Main script logic
function main() {
    local directory=""
    local compression="none"
    local output=""
    local password=""

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -d|--directory)
                directory="$2"
                shift
                ;;
            -c|--compression)
                compression="$2"
                shift
                ;;
            -o|--output)
                output="$2"
                shift
                ;;
            -e|--encrypt)
                password="$2"
                shift
                ;;
            -h|--help)
                display_help
                ;;
            *)
                echo "Error: Unknown option $1" >&2
                display_help
                ;;
        esac
        shift
    done

    if [[ -z "$directory" || -z "$output" || -z "$password" ]]; then
        echo "Error: Missing required arguments." >&2
        display_help
    fi

    check_dependencies
    create_backup "$directory" "$compression" "$output"
    encrypt_backup "$output" "$password"
}

# Run the main function
main "$@"

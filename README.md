# Backup Script

## Description

This script creates a backup of a specified directory, compresses it using the chosen compression algorithm, and encrypts the resulting backup file.

## Requirements

- `tar` must be installed for creating backups.
- `openssl` must be installed for encryption.

## Usage

```bash
./backup.sh [options]

Options
-d, --directory DIR
Directory to back up.

-c, --compression ALGO
Compression algorithm to use. Supported values: none, gzip, bzip2, xz.
Default: none.

-o, --output FILE
Name of the output backup file.

-e, --encrypt PASSWORD
Password to encrypt the backup file.

-h, --help
Display help message.

Example
Create a compressed and encrypted backup of the /my/data directory:

bash
Копировать код
./backup.sh -d /my/data -c gzip -o backup.tar.gz -e mypassword
Error Handling
All errors are logged to error.log.

Features
Modular design using functions for better readability and maintainability.
Supports multiple compression algorithms.
Encrypts the backup archive using AES-256 encryption.
Provides a help menu with usage examples.


---

### Как запустить проект?

1. Сохраните скрипт в файл `backup.sh`.
2. Дайте ему права на выполнение:

   ```bash
   chmod +x backup.sh

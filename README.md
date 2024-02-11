# PHP Configuration Update Script

## Introduction

This script is designed to automatically update the `upload_max_filesize` and `post_max_size` settings in all PHP configurations to 1G. It supports multiple PHP versions and SAPIs (cli, fpm, cgi), and includes functionality to restart Apache and PHP-FPM services to apply the changes.

## Requirements

- A Linux server with Apache and PHP installed.
- Multiple PHP versions installed under `/etc/php/`.
- Sudo or root access to run commands that restart web services.

## Usage

1. Download the script to your server.
2. Make the script executable: `chmod +x update_php_configs.sh`
3. Run the script with sudo or as root: `sudo ./update_php_configs.sh`

The script will:
- Find all PHP `php.ini` files for cli, fpm, and cgi SAPIs.
- Update `upload_max_filesize` and `post_max_size` to 1G.
- Restart Apache and PHP-FPM services to apply changes.

**Note**: Please ensure you have backup configurations before running the script. Use this script at your own risk.

## Customization

You may need to adjust paths or service names depending on your server's configuration. The script assumes PHP configurations are located in `/etc/php/` and uses `systemctl` to restart services.

## License

This script is provided "as is", without warranty of any kind, express or implied. Feel free to use, modify, and distribute it as you see fit.

## Contributing

Contributions to this script are welcome. Please submit pull requests or open issues to suggest improvements or report bugs.


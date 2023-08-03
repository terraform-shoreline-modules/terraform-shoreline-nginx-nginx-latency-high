

#!/bin/bash



# Set the path to the Nginx configuration file

nginx_config_file=${PATH_TO_NGINX_CONFIG_FILE}



# Check if the Nginx configuration file exists

if [ ! -f "$nginx_config_file" ]; then

  echo "Error: Nginx configuration file not found at $nginx_config_file"

  exit 1

fi



# Check the configuration file for any syntax errors

nginx -t -c "$nginx_config_file"

if [ $? -ne 0 ]; then

  echo "Error: Nginx configuration file contains syntax errors"

  exit 1

fi



# Restart Nginx to apply any changes to the configuration file

systemctl restart nginx



echo "Nginx configuration file has been checked and Nginx has been restarted"
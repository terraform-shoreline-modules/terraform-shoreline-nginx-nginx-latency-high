

#!/bin/bash



# Check the upstream server's status

upstream_status=$(curl -s -o /dev/null -w "%{http_code}" ${UPSTREAM_SERVER_URL})



# Check if the upstream server is responding with 200 OK status

if [[ "$upstream_status" == "200" ]]; then

    echo "The upstream server is responding with HTTP status code 200."

else

    echo "The upstream server is not responding with HTTP status code 200."

    exit 1

fi



# Ensure that the upstream server is properly configured

upstream_config=$(curl -s ${UPSTREAM_SERVER_URL} | grep "${UPSTREAM_CONFIG_KEY}")



# Check if the upstream server's configuration is correct

if [[ -z "$upstream_config" ]]; then

    echo "The upstream server's configuration is incorrect."

    exit 1

else

    echo "The upstream server's configuration is correct."

fi



# If both upstream status and configuration are correct, exit with success status code

exit 0

### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High Nginx Latency
---

High Nginx latency typically refers to a situation where the response time of Nginx servers is significantly slower than expected. This may occur due to a variety of reasons, such as increased traffic or a misconfiguration in the server settings. High Nginx latency can cause website downtime, slow page load times, and poor user experience. It is important to address this incident type promptly to prevent any negative impact on users or business operations.

### Parameters
```shell
# Environment Variables

export SERVER_IP="PLACEHOLDER"

export PORT="PLACEHOLDER"

export NGINX_CONFIG_FILE="PLACEHOLDER"

export PATH_TO_NGINX_CONFIG_FILE="PLACEHOLDER"

export UPSTREAM_SERVER_URL="PLACEHOLDER"

export UPSTREAM_CONFIG_KEY="PLACEHOLDER"
```

## Debug

### Step 1: Check CPU usage
```shell
top
```

### Step 2: Check memory usage
```shell
free -m
```

### Step 3: Check disk space usage
```shell
df -h
```

### Step 4: Check network traffic
```shell
iftop
```

### Step 5: Check Nginx status
```shell
systemctl status nginx
```

### Step 6: Check Nginx error logs
```shell
tail -f /var/log/nginx/error.log
```

### Step 7: Check Nginx access logs
```shell
tail -f /var/log/nginx/access.log
```

### Step 8: Check Nginx configuration file for errors
```shell
nginx -t
```

### Step 9: Check server load
```shell
uptime
```

### Step 10: Check for any processes consuming high CPU usage
```shell
ps aux --sort=-%cpu | head
```

### Step 11: Check for any network connectivity issues
```shell
ping ${SERVER_IP}
```

### Step 12: Check for port connectivity
```shell
telnet ${SERVER_IP} ${PORT}
```

### Step 13: Check for the response time of the server
```shell
curl -o /dev/null -s -w "Server response time: %{time_total}\n" http://${SERVER_IP}
```

### Step 14: Check for the response time of Nginx
```shell
curl -o /dev/null -s -w "Nginx response time: %{time_total}\n" http://${SERVER_IP}:${PORT}
```

## Repair

### Check if Nginx configuration file exists
```shell
if [ ! -f ${NGINX_CONFIG_FILE} ]; then

  echo "Nginx configuration file does not exist."

  exit 1

fi
```

### Test Nginx configuration file
```shell
nginx -t -c ${NGINX_CONFIG_FILE}
```

### Check if Nginx configuration file test is successful
```shell
if [ $? -eq 0 ]; then

  echo "Nginx configuration file test is successful."

else

  echo "Nginx configuration file test failed."

  exit 1

fi
```

### Check the Nginx configuration file and ensure that all the directives are properly configured.
```shell


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


```

### Check the upstream server's status and ensure that it is properly configured.
```shell


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


```
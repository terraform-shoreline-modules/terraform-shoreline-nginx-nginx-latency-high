if [ $? -eq 0 ]; then

  echo "Nginx configuration file test is successful."

else

  echo "Nginx configuration file test failed."

  exit 1

fi
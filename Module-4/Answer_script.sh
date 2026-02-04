# !/bin/bash

while IFS= read -r line; do
echo "$line" | grep -wE "frame\.time|wlan\.fc\.type|wlan\.fc\.subtype" >> output.txt
done < "input.txt"

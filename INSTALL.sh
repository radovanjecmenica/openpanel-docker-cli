#!/bin/bash
################################################################################
# Script Name: INSTALL.sh
# Description: Create crons and folders needed for various openpanel cli scripts
#              Use: bash /usr/local/admin/scripts/INSTALL.sh
# Author: Stefan Pejcic
# Created: 08.10.2023
# Last Modified: 18.10.2023
# Company: openpanel.co
# Copyright (c) openpanel.co
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
################################################################################

# Define the custom cron file path
custom_cron_dir="/etc/cron.d"
custom_cron_file="$custom_cron_dir/openpanel_cron"

# Create the custom cron directory if it doesn't exist
if [ ! -d "$custom_cron_dir" ]; then
    mkdir -p "$custom_cron_dir"
fi

# Define your cron job entries
cron_jobs=(
  "0 * * * * root bash /usr/local/admin/scripts/docker/collect_stats.sh"
  "0 */3 * * * root certbot renew --post-hook 'systemctl reload nginx'"
  "0 1 * * * root /usr/local/admin/scripts/backup/create.sh"
  "15 0 * * * root /usr/local/admin/scripts/update.sh"
)

# Create the custom cron file and add the cron jobs
for job in "${cron_jobs[@]}"; do
    echo "$job" >> "$custom_cron_file"
done

# Set the appropriate permissions on the custom cron file
chmod 644 "$custom_cron_file"

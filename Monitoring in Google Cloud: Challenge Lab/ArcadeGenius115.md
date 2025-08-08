# ✅ Arcade Genius - Logging & Monitoring Agent Installation

# TASK 1: Install Logging Agent
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh --also-install

# Install Monitoring Agent
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh --also-install

# Configure Apache plugin for Monitoring Agent
(cd /etc/stackdriver/collectd.d/ && sudo curl -O https://raw.githubusercontent.com/Stackdriver/stackdriver-agent-service-configs/master/etc/collectd.d/apache.conf)

# Restart Stackdriver Agent to apply changes
sudo service stackdriver-agent restart

# TASK 3: Generate HTTP requests to Apache
timeout 120 bash -c -- 'while true; do curl localhost | grep -oP ".*"; sleep .1s; done'

# TASK 5: Example Logs Explorer Query (replace with your project ID)
# Use this in the Logs Explorer to check access logs
resource.type="gce_instance"
logName="projects/ENTER_YOUR_PROJECT_ID/logs/apache-access"
textPayload:"200"

# ✅ Done! You've completed the lab.

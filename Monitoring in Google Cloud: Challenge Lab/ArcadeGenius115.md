

### ✅ Lab Task Script (Arcade Genius Format)

```bash
# ✅ TASK 1: Install Logging & Monitoring Agents

# Install Logging Agent
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh --also-install

# Install Monitoring Agent
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh --also-install

# Add Apache config to Monitoring Agent
(cd /etc/stackdriver/collectd.d/ && sudo curl -O https://raw.githubusercontent.com/Stackdriver/stackdriver-agent-service-configs/master/etc/collectd.d/apache.conf)

# Restart Stackdriver agent
sudo service stackdriver-agent restart
```

```bash
# ✅ TASK 3: Simulate Traffic to Apache Server
timeout 120 bash -c -- 'while true; do curl localhost | grep -oP ".*"; sleep .1s; done'
```

```bash
# ✅ TASK 5: Use Logs Explorer with the query below
# Make sure to replace ENTER_YOUR_PROJECT_ID with your actual project ID

resource.type="gce_instance"
logName="projects/ENTER_YOUR_PROJECT_ID/logs/apache-access"
textPayload:"200"
```

---

### ⚠️ Disclaimer

**This script and guide are provided for educational purposes to help you understand Google Cloud services and boost your career. Before using any script, review it carefully and make sure you comply with Google Cloud's Terms of Service and the lab's intended learning objectives.**

### © Credit

**All rights and credits for the original content belong to Google Cloud: [Google Cloud Skills Boost](https://www.cloudskillsboost.google/)**

---

<div>
✅ Follow for more Google Cloud solutions: <br>
<a href="https://www.youtube.com/@ArcadeGenius-z1" target="_blank"><strong>Subscribe to Arcade Genius</strong></a>
</div>


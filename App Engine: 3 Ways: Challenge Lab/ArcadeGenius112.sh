

```bash
# 🚫 Disable and ✅ Re-enable App Engine API (optional reset step)
gcloud services disable appengine.googleapis.com
gcloud services enable appengine.googleapis.com

# 💤 Wait briefly for service activation
sleep 5

# ⬇ Clone sample App Engine code
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git

# 📁 Navigate to Hello World sample directory
cd python-docs-samples/appengine/standard_python3/hello_world

# 🌍 Create App Engine app with your region
gcloud app create --region=$REGION

# 🚀 Deploy the app quietly (no prompts)
gcloud app deploy --quiet
```

---

```bash
# 🖥️ Set up instance and extract zone and region
INSTANCE_NAME=lab-setup
ZONE=$(gcloud compute instances describe $INSTANCE_NAME --format='get(zone)')
REGION=$(echo $ZONE | sed 's/-[^-]*$//')
```

---

```bash
# 🔐 SSH into instance and clone & navigate to sample app
gcloud compute ssh lab-setup \
  --zone=$ZONE \
  --project=$DEVSHELL_PROJECT_ID \
  --quiet \
  --command="git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git && cd python-docs-samples/appengine/standard_python3/hello_world"
```

---

```bash
# 🌐 Open deployed app in browser
gcloud app browse
```

---


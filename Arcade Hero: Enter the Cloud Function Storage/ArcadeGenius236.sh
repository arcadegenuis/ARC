## ✅ Google Cloud Function Deployment Script with Retry (Go Runtime)

```bash
# Authenticate and set region
gcloud auth list
gcloud config set compute/region $REGION

# Set project variables
export PROJECT_ID=$DEVSHELL_PROJECT_ID
export PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')

# Clone the sample repo and navigate to the function directory
git clone https://github.com/GoogleCloudPlatform/golang-samples.git
cd golang-samples/functions/functionsv2/hellostorage/

# Pause to ensure everything is ready
sleep 30

#!/bin/bash

export SERVICE_NAME=cf-demo

deploy_function() {
  gcloud functions deploy $SERVICE_NAME \
    --runtime=go121 \
    --region=$REGION \
    --source=. \
    --entry-point=HelloStorage \
    --trigger-bucket="$PROJECT_ID-bucket"
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully (https://www.youtube.com/@ArcadeGenius-z1).."
    deploy_success=true
  else
    echo "Please subscribe to Arcade Genius (https://www.youtube.com/@ArcadeGenius-z1)."
    sleep 10
  fi
done  

echo "🎉 Congratulations, you're all done with the lab!"
echo "📢 Please like, share, and subscribe to Arcade Genius (https://www.youtube.com/@ArcadeGenius-z1)..."
```

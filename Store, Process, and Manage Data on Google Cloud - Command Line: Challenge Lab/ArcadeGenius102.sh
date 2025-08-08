### 💡 Lab Script — Image Thumbnail Generator using Cloud Functions (Node.js)

---

### ⚠️ Disclaimer  
**This script and guide are provided for educational purposes to help you understand Google Cloud services and boost your career. Before using any script, review it carefully and ensure you comply with Google Cloud's Terms of Service and the lab’s intended learning objectives.**

### © Credit  
**All rights and credits for the original content belong to Google Cloud: [Google Cloud Skills Boost](https://www.cloudskillsboost.google/)**

---

### ✅ Copy and run the following commands in Cloud Shell:

```bash
# Authorize & configure project
gcloud auth list
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set compute/region $REGION

# Enable necessary APIs
gcloud services enable artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com

sleep 15

# Create Cloud Storage bucket & Pub/Sub topic
gsutil mb -l $REGION gs://$BUCKET
gcloud pubsub topics create $TOPIC_ID

# Set IAM permissions for Cloud KMS service account
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher

# Create working directory and files
mkdir ~/arcadegenius && cd $_
touch index.js package.json

# Create index.js file
cat > index.js <<'EOF_CP'
"use strict";
const crc32 = require("fast-crc32c");
const { Storage } = require('@google-cloud/storage');
const gcs = new Storage();
const { PubSub } = require('@google-cloud/pubsub');
const imagemagick = require("imagemagick-stream");

exports.thumbnail = (event, context) => {
  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64"
  const bucket = gcs.bucket(bucketName);
  const topicName = "REPLACE_WITH_YOUR_TOPIC_ID";
  const pubsub = new PubSub();

  if (fileName.search("64x64_thumbnail") == -1) {
    var filename_split = fileName.split('.');
    var filename_ext = filename_split[filename_split.length - 1];
    var filename_without_ext = fileName.substring(0, fileName.length - filename_ext.length );

    if (filename_ext.toLowerCase() == 'png' || filename_ext.toLowerCase() == 'jpg') {
      console.log(\`Processing Original: gs://\${bucketName}/\${fileName}\`);
      const gcsObject = bucket.file(fileName);
      let newFilename = filename_without_ext + size + '_thumbnail.' + filename_ext;
      let gcsNewObject = bucket.file(newFilename);
      let srcStream = gcsObject.createReadStream();
      let dstStream = gcsNewObject.createWriteStream();
      let resize = imagemagick().resize(size).quality(90);
      srcStream.pipe(resize).pipe(dstStream);

      return new Promise((resolve, reject) => {
        dstStream
          .on("error", (err) => {
            console.log(\`Error: \${err}\`);
            reject(err);
          })
          .on("finish", () => {
            console.log(\`Success: \${fileName} → \${newFilename}\`);
            gcsNewObject.setMetadata({
              contentType: 'image/' + filename_ext.toLowerCase()
            }, function(err, apiResponse) {});

            pubsub
              .topic(topicName)
              .publisher()
              .publish(Buffer.from(newFilename))
              .then(messageId => {
                console.log(\`Message \${messageId} published.\`);
              })
              .catch(err => {
                console.error('ERROR:', err);
              });
          });
      });
    } else {
      console.log(\`gs://\${bucketName}/\${fileName} is not a supported image\`);
    }
  } else {
    console.log(\`gs://\${bucketName}/\${fileName} already has a thumbnail\`);
  }
};
EOF_CP

# Inject your topic ID into index.js
sed -i '16c\  const topicName = "'$TOPIC_ID'";' index.js

# Create package.json file
cat > package.json <<EOF_CP
{
  "name": "thumbnails",
  "version": "1.0.0",
  "description": "Create Thumbnail of uploaded image",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@google-cloud/pubsub": "^2.0.0",
    "@google-cloud/storage": "^5.0.0",
    "fast-crc32c": "1.0.4",
    "imagemagick-stream": "4.1.1"
  },
  "engines": {
    "node": ">=4.3.2"
  }
}
EOF_CP

# Deploy function with retry loop
deploy_function () {
  gcloud functions deploy $FUNCTION_NAME \
    --gen2 \
    --runtime nodejs20 \
    --entry-point thumbnail \
    --source . \
    --region $REGION \
    --trigger-bucket $BUCKET \
    --trigger-location $REGION \
    --max-instances 5 \
    --allow-unauthenticated \
    --quiet
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully 🎉"
    deploy_success=true
  else
    echo "Retrying function deployment..."
    sleep 10
  fi
done

# Upload a test image
wget https://storage.googleapis.com/cloud-training/arc102/wildlife.jpg
gsutil cp wildlife.jpg gs://$BUCKET

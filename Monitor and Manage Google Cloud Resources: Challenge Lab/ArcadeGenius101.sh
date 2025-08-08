# Authenticate and configure
gcloud auth list
gcloud services disable run.googleapis.com
gcloud services enable run.googleapis.com

# Create bucket
gsutil mb gs://$BUCKET_NAME

# Add IAM permissions
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER2 \
  --role=roles/storage.objectViewer

# Create Pub/Sub topic
gcloud pubsub topics create $TOPIC

# Create working directory
mkdir arcade-genius
cd arcade-genius

# Create index.js
cat > index.js <<'EOF_CP'
/* globals exports, require */
"use strict";
const crc32 = require("fast-crc32c");
const { Storage } = require('@google-cloud/storage');
const gcs = new Storage();
const { PubSub } = require('@google-cloud/pubsub');
const imagemagick = require("imagemagick-stream");

exports.thumbnail = (event, context) => {
  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64";
  const bucket = gcs.bucket(bucketName);
  const topicName = "REPLACE_WITH_YOUR_TOPIC_ID";
  const pubsub = new PubSub();

  if (fileName.search("64x64_thumbnail") == -1) {
    var filename_split = fileName.split('.');
    var filename_ext = filename_split[filename_split.length - 1];
    var filename_without_ext = fileName.substring(0, fileName.length - filename_ext.length);

    if (filename_ext.toLowerCase() == 'png' || filename_ext.toLowerCase() == 'jpg') {
      console.log(`Processing Original: gs://${bucketName}/${fileName}`);
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
            console.log(`Error: ${err}`);
            reject(err);
          })
          .on("finish", () => {
            console.log(`Success: ${fileName} → ${newFilename}`);
            gcsNewObject.setMetadata({
              contentType: 'image/' + filename_ext.toLowerCase()
            }, function(err, apiResponse) {});

            pubsub
              .topic(topicName)
              .publisher()
              .publish(Buffer.from(newFilename))
              .then(messageId => {
                console.log(`Message ${messageId} published.`);
              })
              .catch(err => {
                console.error('ERROR:', err);
              });
          });
      });
    } else {
      console.log(`gs://${bucketName}/${fileName} is not an image I can handle`);
    }
  } else {
    console.log(`gs://${bucketName}/${fileName} already has a thumbnail`);
  }
};
EOF_CP

# Replace topic placeholder
sed -i "s/REPLACE_WITH_YOUR_TOPIC_ID/${TOPIC}/g" index.js

# Create package.json
cat > package.json <<'EOF_CP'
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
  "devDependencies": {},
  "engines": {
    "node": ">=4.3.2"
  }
}
EOF_CP

# Get project number and service account
export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="value(projectNumber)")
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

# Add IAM policy binding for Artifact Registry access
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/artifactregistry.reader

# Ensure required service is enabled
gcloud services enable run.googleapis.com

# Pause to allow services to stabilize
sleep 45

# Deploy function in loop until success
while true; do
  gcloud functions deploy $FUNCTION_NAME \
    --gen2 \
    --runtime nodejs20 \
    --entry-point thumbnail \
    --source . \
    --region $REGION \
    --trigger-http \
    --timeout 600s \
    --max-instances 2 \
    --min-instances 1 \
    --quiet

  if [ $? -eq 0 ]; then
    echo "Deployment successful."
    break
  else
    echo "Deployment failed. Retrying..."
    sleep 15
  fi
done

# Upload test image
curl -LO https://raw.githubusercontent.com/Techcps/ARC/master/Monitor%20and%20Manage%20Google%20Cloud%20Resources%3A%20Challenge%20Lab/travel.jpg
gsutil cp travel.jpg gs://$BUCKET_NAME

# Create alerting policy config
cat > app-engine-error-percent-policy.json <<EOF_CP
{
  "displayName": "Active Cloud Function Instances",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "Cloud Function - Active instances",
      "conditionThreshold": {
        "filter": "resource.type = \\"cloud_function\\" AND metric.type = \\"cloudfunctions.googleapis.com/function/active_instances\\"",
        "aggregations": [
          {
            "alignmentPeriod": "300s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_MEAN"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 1
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "604800s"
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [],
  "severity": "SEVERITY_UNSPECIFIED"
}
EOF_CP

# Create alerting policy
gcloud alpha monitoring policies create --policy-from-file="app-engine-error-percent-policy.json"

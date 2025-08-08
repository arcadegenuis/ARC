# Authenticate & Set Project ID
gcloud auth list
export PROJECT_ID=$(gcloud config get-value project)

# Enable Required APIs
gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com

sleep 15

# Create Bucket & Pub/Sub Topic
gsutil mb -l $REGION gs://$BUCKET_NAME
gcloud pubsub topics create $TOPIC_NAME

# Set up Permissions
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher

# Create Function Directory and Files
mkdir ~/techcps && cd $_
touch index.js package.json

# Write Cloud Function (index.js)
cat > index.js <<'EOF_CP'
const functions = require('@google-cloud/functions-framework');
const crc32 = require("fast-crc32c");
const { Storage } = require('@google-cloud/storage');
const gcs = new Storage();
const { PubSub } = require('@google-cloud/pubsub');
const imagemagick = require("imagemagick-stream");

functions.cloudEvent('', cloudEvent => {
  const event = cloudEvent.data;
  console.log(`Event: ${event}`);
  console.log(`Hello ${event.bucket}`);

  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64";
  const bucket = gcs.bucket(bucketName);
  const topicName = "";
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
          .on("error", err => {
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
});
EOF_CP

# Inject dynamic variables into index.js
sed -i "8c\functions.cloudEvent('$FUNCTION_NAME', cloudEvent => {" index.js
sed -i "18c\  const topicName = '$TOPIC_NAME';" index.js

# Write package.json
cat > package.json <<'EOF_CP'
{
  "name": "thumbnails",
  "version": "1.0.0",
  "description": "Create Thumbnail of uploaded image",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0",
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

# Wait for services to propagate
sleep 240

# Deployment script
deploy_function() {
  gcloud functions deploy $FUNCTION_NAME \
    --gen2 \
    --runtime nodejs20 \
    --entry-point $FUNCTION_NAME \
    --source . \
    --region $REGION \
    --trigger-bucket $BUCKET_NAME \
    --trigger-location $REGION \
    --max-instances 1 \
    --quiet
}

# Retry deployment until success
deploy_success=false
while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully."
    deploy_success=true
  else
    echo "Retrying deployment in 10 seconds..."
    sleep 10
  fi
done

# Upload image to trigger function (repeat multiple times for test)
for i in {1..5}; do
  curl -O https://raw.githubusercontent.com/arcadegenuis/ARC/main/Store%2C%20Process%2C%20and%20Manage%20Data%20on%20Google%20Cloud%20Challenge%20Lab/Map.jpg
  gsutil cp Map.jpg gs://$BUCKET_NAME/
  sleep 5
done

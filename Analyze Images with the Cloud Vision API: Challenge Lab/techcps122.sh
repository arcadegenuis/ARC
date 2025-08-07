# Authenticate with Google Cloud
gcloud auth list

# Create an API key with the display name "Arcade Genius"
gcloud alpha services api-keys create --display-name="Arcade Genius"

# Fetch the API key name based on display name
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=Arcade Genius")

# Retrieve the actual API key string
API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

# Get your current project ID
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

# Create a new bucket with your project ID
gsutil mb gs://$PROJECT_ID-bucket

# Prepare a TEXT_DETECTION request JSON
cat > request.json <<EOF
{
  "requests": [
    {
      "image": {
        "source": {
          "gcsImageUri": "gs://$PROJECT_ID-bucket/manif-des-sans-papiers.jpg"
        }
      },
      "features": [
        {
          "type": "TEXT_DETECTION",
          "maxResults": 10
        }
      ]
    }
  ]
}
EOF

# Call the Vision API for TEXT_DETECTION
curl -s -X POST -H "Content-Type: application/json" \
  --data-binary @request.json \
  "https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}" \
  -o text-response.json

# Upload the TEXT_DETECTION result
gsutil cp text-response.json gs://$PROJECT_ID-bucket

# Prepare a LANDMARK_DETECTION request JSON
cat > request.json <<EOF
{
  "requests": [
    {
      "image": {
        "source": {
          "gcsImageUri": "gs://$PROJECT_ID-bucket/manif-des-sans-papiers.jpg"
        }
      },
      "features": [
        {
          "type": "LANDMARK_DETECTION",
          "maxResults": 10
        }
      ]
    }
  ]
}
EOF

# Call the Vision API for LANDMARK_DETECTION
curl -s -X POST -H "Content-Type: application/json" \
  --data-binary @request.json \
  "https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}" \
  -o landmark-response.json

# Upload the LANDMARK_DETECTION result
gsutil cp landmark-response.json gs://$PROJECT_ID-bucket
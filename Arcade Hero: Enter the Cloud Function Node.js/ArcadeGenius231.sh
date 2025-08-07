

# 🎮 Arcade Hero: Deploy a Node.js 20 Cloud Function (Gen2)

> ✅ Like, share & subscribe to [Arcade Genius](https://www.youtube.com/@ArcadeGenius-z1)

---

```bash
gcloud auth list
gcloud config set compute/region $REGION

export PROJECT_ID=$DEVSHELL_PROJECT_ID

mkdir arcade-genius && cd arcade-genius
```

### 🧠 Create `index.js`

```bash
cat > index.js <<'EOF_CP'
const functions = require('@google-cloud/functions-framework');

// Register an HTTP function with the Functions Framework
functions.http('helloGET', (req, res) => {
  res.send('Hello from Cloud Functions!');
});
EOF_CP
```

### 📦 Create `package.json`

```bash
cat > package.json <<'EOF_CP'
{
  "dependencies": {
    "@google-cloud/functions-framework": "^3.1.0"
  }
}
EOF_CP
```

```bash
sleep 15
```

### 🚀 Deploy Function with Retry

```bash
deploy_function() {
  gcloud functions deploy cf-demo \
    --gen2 \
    --runtime=nodejs20 \
    --entry-point helloGET \
    --region=$REGION \
    --source=. \
    --trigger-http \
    --allow-unauthenticated \
    --quiet
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "✅ Function deployed successfully! (https://www.youtube.com/@ArcadeGenius-z1)"
    deploy_success=true
  else
    echo "⚠️ Deployment failed. Retrying in 10 seconds..."
    sleep 10
  fi
done

echo "🎉 Congratulations, you're all done with the lab!"
echo "📣 Please like, share, and subscribe to Arcade Genius: https://www.youtube.com/@ArcadeGenius-z1"
```

---


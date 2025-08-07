

# 🎮 Arcade Hero: Deploying a Go Cloud Function (Gen2)

> ✅ Please like, share & subscribe to [Arcade Genius](https://www.youtube.com/@ArcadeGenius-z1)

---

```bash
gcloud auth list

gcloud config set compute/region $REGION

export PROJECT_ID=$DEVSHELL_PROJECT_ID

mkdir arcade-genius && cd arcade-genius

cat > function.go <<'EOF_CP'
package helloworld

import (
  "encoding/json"
  "fmt"
  "html"
  "net/http"

  "github.com/GoogleCloudPlatform/functions-framework-go/functions"
)

func init() {
   functions.HTTP("HelloHTTP", helloHTTP)
}

// helloHTTP is an HTTP Cloud Function with a request parameter.
func helloHTTP(w http.ResponseWriter, r *http.Request) {
  var d struct {
    Name string `json:"name"`
  }
  if err := json.NewDecoder(r.Body).Decode(&d); err != nil {
    fmt.Fprint(w, "Hello, World!")
    return
  }
  if d.Name == "" {
    fmt.Fprint(w, "Hello, World!")
    return
  }
  fmt.Fprintf(w, "Hello, %s!", html.EscapeString(d.Name))
}
EOF_CP
```

```bash
cat > go.mod <<EOF_CP
module example.com/gcf

require (
  github.com/GoogleCloudPlatform/functions-framework-go v1.5.2
)
EOF_CP

sleep 25
```

```bash
#!/bin/bash

deploy_function() {
  gcloud functions deploy cf-demo \
    --gen2 \
    --runtime go122 \
    --entry-point HelloHTTP \
    --source . \
    --region=$REGION \
    --trigger-http \
    --allow-unauthenticated --quiet
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
```

---

### 🎉 Congratulations, you're all done with the lab!

> 🙌 Please like, share, and subscribe to [Arcade Genius](https://www.youtube.com/@ArcadeGenius-z1)



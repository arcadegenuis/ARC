
```bash
gcloud auth list

gcloud config set compute/region $REGION

export PROJECT_ID=$DEVSHELL_PROJECT_ID

mkdir ArcadeGenius && cd ArcadeGenius
```

```ruby
cat > Gemfile <<'EOF_CP'
source "https://rubygems.org"
gem "functions_framework", "~> 0.7"
EOF_CP
```

```ruby
cat > Gemfile.lock <<'EOF_CP'
GEM
  remote: https://rubygems.org/
  specs:
    cloud_events (0.7.0)
    functions_framework (1.2.0)
      cloud_events (>= 0.7.0, < 2.a)
      puma (>= 4.3.0, < 6.a)
      rack (~> 2.1)
    nio4r (2.5.8)
    puma (5.6.5)
      nio4r (~> 2.0)
    rack (2.2.6.4)

PLATFORMS
  ruby
  x86_64-linux

DEPENDENCIES
  functions_framework (~> 1.2)

BUNDLED WITH
   2.4.6
EOF_CP
```

```ruby
cat > app.rb <<'EOF_CP'
require "functions_framework"
require "cgi"
require "json"

FunctionsFramework.http "hello_http" do |request|

  name = request.params["name"] ||
         (request.body.rewind && JSON.parse(request.body.read)["name"] rescue nil) ||
         "World"

  "Hello #{CGI.escape_html name}!"
end
EOF_CP
```

```bash
bundle install

sleep 15
```

```bash
#!/bin/bash

deploy_function() {
  gcloud functions deploy cf-demo \
    --gen2 \
    --runtime=ruby33 \
    --entry-point=hello_http \
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
    echo "please subscribe to Arcade Genius (https://www.youtube.com/@ArcadeGenius-z1)."
    sleep 10
  fi
done  

echo "Congratulations, you're all done with the lab"
echo "Please like, share, and subscribe to Arcade Genius (https://www.youtube.com/@ArcadeGenius-z1)..."
```


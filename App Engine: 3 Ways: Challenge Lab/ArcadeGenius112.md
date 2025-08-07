

````markdown
# Please like, share & subscribe to [Arcade Genius](https://www.youtube.com/@ArcadeGenius-z1)

---

## 🚨 Export the REGION name correctly

```bash
export REGION=
````

```bash
gcloud services enable appengine.googleapis.com
sleep 5
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/appengine/standard_python3/hello_world
gcloud app create --region=$REGION
gcloud app deploy --quiet
```

---

## 🚨 Check if your region/zone name is correct

If it is, type `'Y'` — if not, type `'N'`

![arcadegenius](https://github.com/Techcps/ARC/assets/104138529/385aa9e3-9865-47ee-bcf6-7c10d9c14942)

```bash
INSTANCE_NAME=lab-setup
ZONE=$(gcloud compute instances describe $INSTANCE_NAME --format='get(zone)')
REGION=$(echo $ZONE | sed 's/-[^-]*$//')
gcloud compute ssh lab-setup --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --quiet
```

```bash
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/appengine/standard_python3/hello_world
```

---

## 🚨 Type `exit` to return to Cloud Shell

---

## 🚨 Replace your message

```bash
sed -i 's/Hello World!/REPLACE_YOUR_MESSAGE/g' main.py
```

---

## 🚨 Now run the below command

```bash
gcloud app deploy --quiet
```

---

## 🎉 Congratulations, you're all done with the lab 😄

---

# Thanks for watching 🙌

Subscribe to [Arcade Genius](https://www.youtube.com/@ArcadeGenius-z1) for more Google Cloud content!

```

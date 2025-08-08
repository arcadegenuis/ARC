

## ✅ Create a Secure Data Lake on Cloud Storage: Challenge Lab – ARC119

[Lab Link](https://www.cloudskillsboost.google/focuses/63857?parent=catalog)
📺 [Watch Lab Solution](https://youtu.be/PbIfliCwHQw)

---

### ⚠️ Disclaimer

**This script and guide are provided for educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**

---

### © Credit

**DM for credit or removal request (no copyright intended). All rights and credits for the original content belong to Google Cloud via the [Google Cloud Skills Boost website](https://www.cloudskillsboost.google/)**

---

## 🧪 Instructions

### ✅ Step 1: Export ZONE

```bash
export ZONE=
```

---

### ✅ Step 2: Run Script in Cloud Shell

```bash
curl -LO https://raw.githubusercontent.com/Techcps/ARC/master/Create%20a%20Secure%20Data%20Lake%20on%20Cloud%20Storage%3A%20Challenge%20Lab/techcps119.sh
sudo chmod +x techcps119.sh
./techcps119.sh
```

---

### ✅ Step 3: If prompted: `CP Invalid form number. Please enter 1, 2, 3, or 4:`

Use `Ctrl + G` to find your form number based on task layout.

---

## 🧾 Form Patterns

### 🚀 Form 1

* Task 1: Create a Cloud Storage bucket
* Task 2: Create a lake in Dataplex and add a zone to your lake
* Task 3: Environment Creation for Dataplex Lake
* Task 4: Create a tag template

---

### 🚀 Form 2

* Task 1: Create a lake in Dataplex and add a zone
* Task 2: Environment Creation for Dataplex
* Task 3: Attach an existing Cloud Storage bucket to the zone
* Task 4: Create a tag template

---

### 🚀 Form 3

* Task 1: Create a BigQuery dataset
* Task 2: Add a zone to your lake
* Task 3: Attach existing BigQuery dataset
* Task 4: Create a tag template

---

### 🚀 Form 4

* Task 1: Create a lake in Dataplex and add a zone
* Task 2: Attach an existing Cloud Storage bucket
* Task 3: Attach existing BigQuery Dataset
* Task 4: Create Entities

---

## ✅ Optional Task: Create an Entry Group

```bash
read -p "Enter the REGION: " REGION

ENTRY_GROUP_ID="custom_entry_group"

gcloud data-catalog entry-groups create $ENTRY_GROUP_ID \
  --location=$REGION \
  --display-name="Custom entry group"

gcloud data-catalog entry-groups list --location=$REGION
```

---

### 🎉 Congratulations, you're all done with the lab!

---

### ✅ YouTube Section

<div align="center" style="padding: 5px;"> 
  <h3>📺 Don't forget to Like, Share & Subscribe!</h3>  
  <a href="https://www.youtube.com/@ArcadeGenius-z1"> 
    <img src="https://img.shields.io/badge/YouTube-Arcade%20Genius-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube Channel"> 
  </a> 
</div>

<div align="center" style="padding: 5px;"> 
  <h3>Thanks for watching and stay connected 🙂</h3> 
</div>

---


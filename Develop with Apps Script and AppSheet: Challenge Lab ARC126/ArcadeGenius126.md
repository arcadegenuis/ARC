
## ✅ Develop with Apps Script and AppSheet: Challenge Lab – ARC126

🔗 [Lab Link](https://www.cloudskillsboost.google/focuses/66584?parent=catalog)


---

### ⚠️ Disclaimer

**This script and guide are provided for educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**

---

### © Credit

**DM for credit or removal request. All rights and credits for the original content belong to Google Cloud via the [Google Cloud Skills Boost website](https://www.cloudskillsboost.google/)**

---

## 🧪 Steps to Complete the Lab

### ✅ Step 1: Open Google Spreadsheet

➡️ [Open Google Sheets](https://docs.google.com/spreadsheets/u/0/?pli=1&tgif=d)

---

### ✅ Step 2: Download Required File

📥 [Download Excel File from GitHub](https://github.com/arcadegenuis/ARC/blob/main/Develop%20with%20Apps%20Script%20and%20AppSheet%3A%20Challenge%20Lab%20ARC126/ArcadeGenius.xlsx)

---

### ✅ Step 3: Create an Apps Script Chat App

➡️ [Open Google Apps Script](https://script.google.com/home/projects/create?template=hangoutsChat)

---

### ✅ Step 4: Replace Default Code in `Code.gs`

Delete the default code and paste the following:

```javascript
/**
 * Responds to a MESSAGE event in Google Chat.
 *
 * @param {Object} event the event object from Google Chat
 */
function onMessage(event) {
  var name = "";

  if (event.space.type == "DM") {
    name = "You";
  } else {
    name = event.user.displayName;
  }
  var message = name + " said \"" + event.message.text + "\"";

  return { "text": message };
}

/**
 * Responds to an ADDED_TO_SPACE event in Google Chat.
 *
 * @param {Object} event the event object from Google Chat
 */
function onAddToSpace(event) {
  var message = "";

  if (event.space.singleUserBotDm) {
    message = "Thank you for adding me to a DM, " + event.user.displayName + "!";
  } else {
    message = "Thank you for adding me to " +
        (event.space.displayName ? event.space.displayName : "this chat");
  }

  if (event.message) {
    // Bot added through @mention.
    message = message + " and you said: \"" + event.message.text + "\"";
  }
  console.log('Helper Bot added in ', event.space.name);
  return { "text": message };
}

/**
 * Responds to a REMOVED_FROM_SPACE event in Google Chat.
 *
 * @param {Object} event the event object from Google Chat
 */
function onRemoveFromSpace(event) {
  console.info("Bot removed from ",
      (event.space.name ? event.space.name : "this chat"));
}
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

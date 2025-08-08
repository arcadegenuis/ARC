
## ✅ Get Started with Looker: Challenge Lab – ARC107

🔗 [Lab Link](https://www.cloudskillsboost.google/focuses/62701?parent=catalog)
📺 [Watch Lab Solution](https://www.youtube.com/@ArcadeGenius-z1)

---

### ⚠️ Disclaimer

**This script and guide are provided for educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**

---

### © Credit

**DM for credit or removal request. All rights and credits for the original content belong to Google Cloud via the [Google Cloud Skills Boost website](https://www.cloudskillsboost.google/)**

---

## ✅ Required Code Files

### 🗂️ `users_region.view` file:

```
view: users_region {
  sql_table_name: cloud-training-demos.looker_ecomm.users ;;
  
  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
    primary_key: yes
  }
  
  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }
  
  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }
  
  measure: count {
    type: count
    drill_fields: [id, state, country]
  }
}
```

---

### 🧾 `training.model.lkml` file:

```
connection: "bigquery_public_data_looker"

# include all the views
include: "/views/*.view"
include: "/z_tests/*.lkml"
include: "/**/*.dashboard"

datagroup: training_ecommerce_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: training_ecommerce_default_datagroup

label: "E-Commerce Training"

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: events {
  join: event_session_facts {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
    relationship: many_to_one
  }
  join: event_session_funnel {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_funnel.session_id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: users_region {
    type: left_outer
    sql_on: ${events.user_id} = ${users_region.id};;
    relationship: many_to_one
  }
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

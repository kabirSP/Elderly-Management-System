# 🏥 Elderly Healthcare Management System

A database project built using **Oracle Live SQL** and **PL/SQL**, designed to manage healthcare services for elderly patients, including records, appointments, services, and emergency contact tracking.

---

## ⚙️ Features

- Manage agencies, employees, elderly residents, services, and health records  
- Store and retrieve emergency contact info  
- Check if financial aid (loan) is needed based on salary  
- Track which branch offers which care service  
- Log updates with triggers for auditing  

---

## 📊 Tables Used

- `AGENCY`, `EMPLOYERS`, `ELDERS`, `CONTACTPERSON`  
- `HEALTHRECORD`, `SERVICES`, `DELIVERS`, `SERVICERECORD`

---

## 🔁 Procedures & Triggers

- `branchcare(carenum)` – Show branches offering a specific service  
- `insertservice(...)` – Add service record for an elder  
- `EMERGENCY_NUMBER(custid)` – View emergency contact details  
- `CheckForLoan(...)` – Check if contact can afford the service  
- Triggers: log updates, auto-check loan need on salary change

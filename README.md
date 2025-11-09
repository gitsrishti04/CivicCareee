# 🏙️ Civic Care — AI-Powered Citizen Issue Reporting App

> 🚀 Empowering Smart Cities with AI Verification, Transparency, and Real-time Problem Solving.

# civic care ai analyser(Base 44 track 5 - Smart cities) : DEPLOYED LINK
https://civic-care-ai-b46d7488.base44.app/

# DEMO LINK : https://www.youtube.com/watch?v=KT2Oa8Ve5e0 

---

## 📖 Overview

**Civic Care** is an AI-driven mobile & web platform that empowers citizens to report local civic problems — like potholes, garbage overflow, broken streetlights, and water leakages — directly to the authorities.  

The app uses **AI verification**, **real-time tracking**, and **geo-location tagging** to create a bridge between *citizens* and *city administrations* — making complaint handling faster, smarter, and transparent.  

> “Civic Care = AI + Accountability + Action”

---

## 📱 App Overview

### 👨‍💻 For Citizens
- Submit civic issues easily with a **photo, short description, and location**
- AI verifies if the uploaded image matches the description
- Automatically categorizes issue (e.g. Road, Sanitation, Water, etc.)
- Track the complaint status in real time
- Receive notifications when the issue is resolved

### 🧑‍💼 For Municipal Officers (Admin Panel)
- View all complaints in one dashboard (verified & unverified)
- Auto-assigned departments based on issue type
- Update progress (In Review → Assigned → Resolved)
- Analyze trends through graphs (e.g., “Most issues in Ward 12”)
- AI suggests duplicate or already existing complaints

---

## 🌟 Key Features

| Feature | Description |
|----------|-------------|
| 📸 **AI Image–Text Verification** | Ensures the uploaded photo matches the complaint description using models like CLIP or LLaVA. |
| 🧩 **Automatic Categorization** | Detects issue type (Road, Garbage, Water, etc.) using AI-based NLP. |
| 🔍 **Duplicate Detection** | Identifies repeated or duplicate complaints based on location & image similarity. |
| 🗺️ **Geo-tagging** | Every complaint is pinned on the city map with precise GPS coordinates. |
| 🔔 **Real-time Notifications** | Citizens get instant status updates from authorities. |
| 🧾 **Admin Dashboard** | Smart panel for government officers to assign and track complaints. |

---

## 🧠 AI Intelligence Inside Civic Care

| AI Task | Model | Purpose |
|----------|--------|----------|
| Image–Text Match | `openai/clip-vit-base-patch32` or `LLaVA` (Ollama) | Verify if photo matches complaint text |
| Category Detection | Fine-tuned BERT / DistilBERT | Auto-categorize issue type |
| Duplicate Detection | CLIP Embeddings + Cosine Similarity | Identify repeated issues |
| Urgency Detection | Text sentiment & priority scoring | Rank issues for faster response |

> 💡 All models can run **locally using Ollama** or **cloud APIs** (OpenAI / HuggingFace).

---

## 🧭 User Flow

### 📱 Citizen App Flow
1. 📸 User uploads image + description  
2. 🧠 AI checks match & classifies issue  
3. 🌍 Auto geo-tagging adds location  
4. 📩 Complaint submitted to department  
5. 🕒 User can track progress → notified when resolved  

### 🧑‍💼 Admin Flow
1. View new incoming complaints  
2. Verify AI “match confidence” score  
3. Assign to relevant field officer  
4. Update status → resolved  
5. Monitor city-wide stats with charts  

---

## ⚙️ Tech Stack

| Layer | Technologies |
|--------|---------------|
| **Frontend (App)** | Flutter / React Native |
| **Backend API** | FastAPI / Node.js |
| **AI Layer** | PyTorch, Transformers, LangChain, Ollama |
| **Database** | Firebase Firestore / PostgreSQL |
| **Storage** | Firebase Storage / Cloudinary |
| **Maps** | Google Maps API |
| **Notifications** | Firebase Cloud Messaging |

---

## 🏗️ Architecture

Citizen App → API Gateway → AI Verification Service (CLIP / LLaVA)
↓
Issue Categorization + Geo-tagging
↓
Database + Admin Dashboard


## How to run:
we have an app for reporting the issues so do check it
by downloading the zip file and loading all dependencies after setting up flutter and dart sdk:
RUn this in the terminal:
flutter clean
flutter pub get
flutter run 

# 🏙️ Civic Care — AI-Powered Citizen Issue Reporting App

> 🚀 Empowering Smart Cities with AI Verification, Transparency, and Real-time Problem Solving.

---

## 🌐 Live Deployment

**🧩 Civic Care AI Analyzer (Base 44 Track 5 - Smart Cities):**  
🔗 [https://civic-care-ai-b46d7488.base44.app/](https://civic-care-ai-b46d7488.base44.app/)

**🎥 Demo Video:**  
📺 [Watch on YouTube](https://www.youtube.com/watch?v=KT2Oa8Ve5e0)

## ppt link:
https://drive.google.com/file/d/10CUHG1SiNwbB13yzc-R1z0Z3Vi4Idkyu/view?usp=sharing

## app screenshots:

<img width="415" height="882" alt="Screenshot 2025-11-08 162420" src="https://github.com/user-attachments/assets/ddb27f5b-abd5-4604-af30-3921ed557796" />

<img width="425" height="880" alt="Screenshot 2025-11-08 162503" src="https://github.com/user-attachments/assets/1ae794fb-939e-43e7-b9c2-335695bdadad" />
<img width="430" height="879" alt="Screenshot 2025-11-08 162904" src="https://github.com/user-attachments/assets/1f28df3e-2b4d-4609-8097-a3da87ca21f6" />
<img width="493" height="880" alt="Screenshot 2025-11-08 163905" src="https://github.com/user-attachments/assets/718dae3b-5109-4f28-a8c3-f9cb76c75d6d" />
<img width="1895" height="907" alt="Screenshot 2025-11-09 103229" src="https://github.com/user-attachments/assets/ec8c7eca-6d57-4b91-9d71-f2b79e355bca" />
<img width="1901" height="908" alt="Screenshot 2025-11-09 103253" src="https://github.com/user-attachments/assets/e26339f7-e1b1-4cca-b137-c9870c0e49e0" />



---

## 📖 Overview

**Civic Care** is an **AI-driven mobile and web platform** that empowers citizens to report local civic problems — like potholes, garbage overflow, broken streetlights, and water leakages — directly to authorities.  

The app uses **AI verification**, **real-time tracking**, and **geo-location tagging** to bridge the gap between *citizens* and *city administrations*, making complaint handling faster, smarter, and more transparent.  

> 🧠 “Civic Care = AI + Accountability + Action”

---

## 📱 App Overview

### 👨‍💻 For Citizens
- Submit civic issues easily with a **photo, short description, and location**
- AI verifies if the uploaded image matches the description
- Automatically categorizes issue (e.g. Road, Sanitation, Water, etc.)
- Track the complaint status in real time
- Receive notifications when the issue is resolved

### 🧑‍💼 For Municipal Officers (Admin Panel)
- View all complaints in a single dashboard (verified & unverified)
- Auto-assigned departments based on issue type
- Update progress (In Review → Assigned → Resolved)
- Analyze trends through graphs (e.g., “Most issues in Ward 12”)
- AI suggests duplicate or existing complaints to avoid redundancy

---

## 🌟 Key Features

| Feature | Description |
|----------|-------------|
| 📸 **AI Image–Text Verification** | Ensures uploaded photos match complaint descriptions using models like CLIP or LLaVA. |
| 🧩 **Automatic Categorization** | Detects issue type (Road, Garbage, Water, etc.) using NLP models. |
| 🔍 **Duplicate Detection** | Identifies repeated complaints based on image and location similarity. |
| 🗺️ **Geo-tagging** | Automatically locates issues using GPS data. |
| 🔔 **Real-time Notifications** | Citizens get instant updates when their complaint status changes. |
| 🧾 **Admin Dashboard** | For officers to manage, assign, and analyze civic complaints efficiently. |

---

## 🧠 AI Intelligence Inside Civic Care

| AI Task | Model | Purpose |
|----------|--------|----------|
| Image–Text Match | `openai/clip-vit-base-patch32` or `LLaVA` (Ollama) | Verify if the photo matches complaint text |
| Category Detection | Fine-tuned BERT / DistilBERT | Auto-categorize issue type |
| Duplicate Detection | CLIP Embeddings + Cosine Similarity | Identify repeated issues |
| Urgency Detection | Text sentiment & priority scoring | Rank issues by urgency |

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
1. View new complaints  
2. Verify AI “match confidence” score  
3. Assign to relevant field officer  
4. Update status → resolved  
5. Monitor city-wide analytics  

---

## ⚙️ Tech Stack

| Layer | Technologies |
|--------|---------------|
| **Frontend (App)** | Flutter / Dart |
| **Backend API** | FastAPI / Node.js |
| **AI Layer** | PyTorch, Transformers, LangChain, Ollama |
| **Database** | Firebase Firestore / PostgreSQL |
| **Storage** | Firebase Storage / Cloudinary |
| **Maps & Geo** | Google Maps API |
| **Notifications** | Firebase Cloud Messaging |

---

## 🏗️ Architecture

Citizen App → API Gateway → AI Service (Verification + Classification) → Database → Admin Dashboard
↓
Geo-tagging + Storage

## 🚀 Quick Start

### 1️⃣ Clone the repository

git clone [https://github.com/your-username/civic-care.git](https://github.com/gitsrishti04/CivicCareee.git)
cd civic-care

## Create a virtual environment
python -m venv venv
source venv/bin/activate      # (Linux/Mac)
venv\Scripts\activate         # (Windows)

##install dependencies
pip install -r requirements.txt

##Run the backend
python main.py



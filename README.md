# 🏙️ Civic Care — AI-Powered Citizen Issue Reporting App

> 🚀 Empowering Smart Cities with AI Verification, Transparency, and Real-time Civic Problem Solving.

---

## 📖 Overview

**Civic Care** is an AI-driven mobile & web platform that enables citizens to report local civic issues — such as potholes, broken streetlights, garbage collection, or water leakages — directly to municipal authorities.

The app leverages **AI models** for:
- 🧠 *Automatic issue verification (image–text matching)*
- ⚙️ *Smart categorization*
- 🔁 *Duplicate detection*
- ⏱️ *Priority-based assignment and tracking*

> Civic Care makes urban governance more efficient, transparent, and responsive — one complaint at a time.

---

## 🌟 Features

| Feature | Description |
|----------|-------------|
| 📸 **AI Image–Text Verification** | Ensures the uploaded photo matches the complaint description using CLIP or LLaVA models. |
| 🧩 **Auto Categorization** | Detects issue type (road, water, garbage, etc.) automatically using NLP. |
| 🔍 **Duplicate Detection** | Compares new complaints with existing ones using image & location similarity. |
| ⚙️ **Real-time Tracking** | Citizens can monitor the status of their issue (Submitted → In Progress → Resolved). |
| 🗺️ **Geo-tagging** | Each complaint is mapped using GPS for exact issue localization. |
| 🧾 **Admin Dashboard** | Municipal officers can view, assign, and resolve complaints efficiently. |

---

## 🧠 AI Models Used

| Task | Model | Source |
|------|--------|--------|
| Image–Text Matching | `openai/clip-vit-base-patch32` or `LLaVA` | Hugging Face / Ollama |
| Text Classification | `bert-base-uncased` / lightweight fine-tuned classifier | Hugging Face |
| Duplicate Detection | Image embeddings via CLIP cosine similarity | Local inference |
| Summarization (optional) | `mistral` / `llama3` | Ollama |

> 🧩 All models can be run **offline** using [Ollama](https://ollama.ai) for privacy & cost-efficiency.

---

## ⚙️ Tech Stack

| Layer | Technologies |
|--------|---------------|
| **Frontend** | Flutter / React Native |
| **Backend** | FastAPI / Node.js |
| **Database** | Firestore / PostgreSQL |
| **AI / ML** | PyTorch, Transformers, LangChain, Ollama |
| **Storage** | Firebase Storage / Cloudinary |
| **Maps & Geo** | Google Maps API |
| **Notifications** | Firebase Cloud Messaging |

---

## 🏗️ Architecture


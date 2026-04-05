# event-driven-financial-rag-api

## System Architecture & Functionality

### Core Data Pipeline & API
* **Data Ingestion (Producers):** Scheduled Python microservices act as event producers, continuously fetching raw pricing, fundamental metrics, and earnings call transcripts from external APIs (FinancialModelPrep, YFinance, Alpaca, Alpha Vantage, Finnhub.io). This raw data is published immediately to specific Apache Kafka topics, decoupling ingestion from downstream processing.
* **Stream Processing:** An Apache Flink job consumes the Kafka streams in real-time. It cleans the incoming payloads, calculates rolling metrics, and sinks both structured data (TimescaleDB) and vectorized news/transcripts (pgvector) directly into the PostgreSQL instance.
* **Backend Serving Layer:** A robust Java Spring Boot application connects to the PostgreSQL database. It handles user authentication, dashboard configuration storage, and exposes the processed financial data via fast REST API endpoints.
* **Frontend (Demo & API Documentation):** * **Data Visualization:** Swagger UI (OpenAPI) integrated directly into the Spring Boot service, providing a professional, interactive interface to execute live REST queries and view JSON responses.
  * **AI Chat Interface:** A lightweight Streamlit (Python) web app serving strictly as a demonstration UI for the RAG engine, enabling real-time chat interactions with the LLM and vector database.

### RAG System & AI Context Engine
* **Vectorization & Storage:** Earnings call transcripts, SEC filings, and news fetched during ingestion are processed through the streaming pipeline and stored as high-dimensional embeddings within the pgvector-enabled PostgreSQL instance.
* **LLM Contextualization:** A standalone Python FastAPI microservice handles the RAG operations. When a user queries a stock, the API performs a similarity search against pgvector, retrieves relevant text excerpts, and performs an internal HTTP call to the Spring Boot API to gather live fundamental data for a consolidated LLM context.

### Security and Routing
* **API Gateway & Rate Limiter:** A central gateway acts as the single entry point for all frontend requests. It handles service routing and enforces strict rate limiting to protect backend microservices and manage LLM API costs.

## Tech Stack
* **Data Providers:** FinancialModelPrep, YFinance, Alpaca Markets (for pricing/fundamentals and transcript retrieval).
* **Event Streaming:** Apache Kafka (Standard for high-throughput, decoupled data ingestion).
* **Data Processing:** Apache Flink (Real-time stream processing and data formatting).
* **Unified Database:** PostgreSQL.
  * **TimescaleDB Extension:** For high-performance time-series storage (ticks, daily history).
  * **pgvector Extension:** Serves as the VectorDB for the RAG system, storing textual embeddings.
  * **Standard Relational Schema:** For user configs, watchlists, and dashboard rules.
* **Core Data API:** Java with Spring Boot, Spring Data JPA, and Jackson for JSON serialization.
* **AI & RAG API:** Python with FastAPI, LangChain/LangGraph/LlamaIndex, and an LLM provider (OpenAI, Gemini, or Claude).
* **Frontend:** React.js (or Next.js) with TypeScript, Tailwind CSS, and Recharts. 
  * Both the **Data Visualization (React)** and **AI Chat Interface (Streamlit)** communicate with backend microservices exclusively through the API Gateway/Rate Limiter layer.
* **Infrastructure & DevOps:** Docker & Docker Compose for containerization. GitHub Actions for CI/CD pipelines (Linting, type checking, unit tests).
* **Security & Routing:** API Gateway for rate limiting and service orchestration.
* **Testing:** * Backend: JUnit & Mockito.
  * Frontend: Jest & React Testing Library.

## Features
* Plot stock prices alongside fundamental metrics and ratios over time, supporting multi-ticker comparison graphs.
* Display comprehensive fundamental metrics in structured tables.
* Manage custom watchlists with saved criteria.
* Automated watchlist rules: Receive notifications when a stock enters or exits specific valuation templates and fundamental criteria.
* **AI Market Context:** Chat interface powered by the RAG system to ask specific questions about a stock's recent earnings calls and market sentiment, generating answers grounded exclusively in the vectorized transcripts and data.
* (Track famous investors and congressional trading activity on watched tickers.)

## Project Structure
```text
event-driven-financial-rag-api/
│
├── .github/                   # CI/CD Pipelines
│   └── workflows/
│       ├── java-ci.yml        
│       └── python-ci.yml      
│
├── infrastructure/            # Local DevOps Setup
│   ├── docker-compose.yml     # Kafka, Flink, Postgres (Timescale + pgvector)
│   └── init-scripts/          # SQL schemas and extension initialization
│
├── services/                  # Polyglot Microservices
│   │
│   ├── ingestion-service/     # [PYTHON] API Fetcher -> Kafka
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── src/               # Fetches pricing, fundamentals, and transcripts
│   │
│   ├── processing-job/        # [JAVA/SCALA/PYTHON] Flink Streaming Job: Kafka -> Postgres
│   │   ├── Dockerfile
│   │   └── src/        
│   │
│   ├── core-data-api/         # [JAVA/SPRING BOOT] REST API for charts, users, watchlists
│   │   ├── Dockerfile
│   │   ├── pom.xml            
│   │   └── src/               
│   │
│   ├── rag-ai-api/            # [PYTHON/FASTAPI] Vector Search & LLM Context Engine
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── src/
│   │       ├── pipeline/      # Transcript chunking, embeddings generation, pgvector storage
│   │       └── endpoints/     # Async chat routing for LLM querying
│   │
│   └── frontend-dashboard/    # [REACT] The UI
│       ├── Dockerfile
│       ├── package.json
│       └── src/               
│
├── .env.example               
├── .gitignore                 
├── Makefile                   # Orchestration commands (make up, make build, make logs)
└── README.md
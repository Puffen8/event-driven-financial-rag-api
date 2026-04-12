# event-driven-financial-rag-api
An event-driven microservices architecture processing real-time market data via Kafka/Flink, featuring a Spring Boot core financial API and a FastAPI RAG system for AI-driven financial context.

## 🏗️ Architecture Overview
- **Backend Logic:** [e.g., FastAPI / Node.js]
- **Database:** [e.g., PostgreSQL]
- **Caching & Message Broker:** [e.g., Redis, RabbitMQ]
- **AI/ML Integration:** [e.g., PyTorch models served via dedicated microservice]
- **Data Pipeline:** [e.g., Apache Airflow, AWS S3]

## 🗺️ Roadmap

### Phase 1: Foundation & Architecture
*Establishing the development environment and structural blueprints.*
- [x] Set up local development environment and repository structure.
- [x] Draft core architecture documentation.
- [x] Design and finalize system architecture diagrams.
- [x] Provision initial infrastructure for the MVP (Docker containers, network routing).

### Phase 2: Financial API MVP (Current Focus)
*Building the core data engine and making it accessible via secure endpoints.*
- [ ] Design and map the relational database schema for financial entities.
- [ ] Conduct API experiments: Evaluate and integrate upstream external APIs for fetching raw financial data.
- [ ] Build the automated data ingestion pipeline to populate the database.
- [ ] Develop the core Financial API endpoints (CRUD operations and specific data retrieval).
- [ ] Integrate foundational security measures (Authentication, authorization, rate limiting, and input validation baked directly into the routing and data layers).

### Phase 3: Financial API Expansion
*Scaling the MVP with advanced querying capabilities and optimizations.*
- [ ] Implement advanced filtering, pagination, and sorting for financial endpoints.
- [ ] Expand the ingestion pipeline to support additional upstream data sources, historical data, and fundamental metrics.

### Phase 4: RAG API Development
*Introducing intelligent document retrieval and LLM-driven insights.*
- [ ] Set up and configure the Vector Database (pgvector).
- [ ] Build the embedding pipeline: chunking financial text/reports and generating vector embeddings.
- [ ] Integrate the LLM (Large Language Model) provider for generation.
- [ ] Develop the `/rag` API endpoints that take user queries, retrieve relevant financial context, and return synthesized answers.

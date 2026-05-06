ReplayBench — AI Agent Evaluation Platform
ReplayBench is a production-style AI agent evaluation platform for testing and benchmarking remediation agents across distributed-system failure scenarios.
It is designed to evaluate rule-based, LLM-based, and hybrid AI agents using metrics such as accuracy, latency, MTTR, safety score, recovery success, regression drift, and decision quality.
---
Table of Contents
Project Overview
Problem Statement
Core Idea
Key Features
Architecture
Evaluation Workflow
Scenario Engine
Agent Types
Metrics
Safety Score
Regression Testing
Tech Stack
Project Structure
API Endpoints
Running Locally
Docker
Future Enhancements
Interview Talking Points
---
Project Overview
Modern AI agents are increasingly used to automate operational decisions. However, a major problem is evaluation. Before an AI agent is allowed to take production actions, engineers must answer:
Is the agent accurate?
Is the agent safe?
Does it hallucinate commands?
Does it make different decisions after prompt changes?
Does it reduce MTTR?
Does it perform better than rule-based automation?
ReplayBench solves this by replaying historical or simulated incidents and benchmarking agent decisions.
---
Problem Statement
AI agents can make inconsistent decisions across prompts, models, and tool updates. In reliability engineering, a wrong remediation decision may increase downtime or damage production systems.
Common problems include:
No repeatable evaluation method
No safety scoring
No regression testing after prompt changes
No comparison between rule-based and LLM-based strategies
No visibility into latency or recovery impact
No structured decision traces
ReplayBench provides a platform to test agent behavior before deployment.
---
Core Idea
ReplayBench follows this principle:
> Do not trust an AI agent until it has been evaluated against repeatable failure scenarios.
The system runs incidents through multiple agent strategies and stores metrics for comparison.
```text
Scenario → Agent Decision → Evaluation Metrics → Safety Score → Regression Report
```
---
Key Features
1. Scenario-Based Replay
Create and replay distributed-system failure scenarios such as:
Traffic spike
Slow database response
Service outage
Kafka backlog
Cascading failure
Cache degradation
Deployment regression
2. Agent Benchmarking
ReplayBench compares:
Rule-based agents
LLM-based agents
Hybrid agents
3. Regression Testing
After prompt, model, policy, or MCP-tool updates, ReplayBench can replay older scenarios to detect decision-quality degradation.
4. Safety Score
The system evaluates agent safety using:
Unsafe actions
Hallucinated commands
Approval bypasses
RBAC violations
Failed recovery validation
Wrong root cause assumptions
5. A/B Evaluation
ReplayBench supports comparison of two remediation approaches against the same scenario.
Example:
```text
Agent A: Restart service
Agent B: Scale consumers
Winner: Agent B because MTTR is lower and safety score is higher
```
6. Persistent Evaluation Reports
The system stores:
Scenario versions
Evaluation runs
Agent decisions
Trace IDs
Audit events
Benchmark metrics
Regression reports
---
Architecture
```text
Client / API
    |
    v
Scenario Controller
    |
    v
Evaluation Service
    |
    +--> Scenario Engine
    |
    +--> Agent Decision Service
    |
    +--> Metrics Engine
    |
    +--> Safety Evaluator
    |
    +--> Regression Analyzer
    |
    v
PostgreSQL / H2 Persistence
```
---
Evaluation Workflow
```text
1. User creates a failure scenario
2. ReplayBench selects an agent type
3. Agent generates remediation decision
4. Metrics engine calculates latency, accuracy, MTTR, and recovery success
5. Safety evaluator calculates risk and safety score
6. Results are stored as an evaluation run
7. Reports can be compared across versions
```
---
Scenario Engine
Each scenario contains:
Scenario name
Failure type
Severity
Expected remediation
Unsafe action list
Description
Version
Created timestamp
Example scenario:
```json
{
  "scenarioName": "Kafka Consumer Lag",
  "failureType": "KAFKA_BACKLOG",
  "severity": "HIGH",
  "expectedAction": "scale_consumers",
  "description": "Consumer group lag increased rapidly"
}
```
---
Agent Types
Agent Type	Description
Rule-Based Agent	Uses deterministic rules
LLM Agent	Uses simulated LLM reasoning
Hybrid Agent	Combines rules and LLM-style scoring
---
Metrics
ReplayBench evaluates:
Metric	Meaning
Accuracy	Whether the agent selected expected action
Latency	Time taken to generate decision
MTTR	Estimated mean time to recovery
Safety Score	Safety quality of decision
Recovery Success	Whether decision recovered scenario
Regression Status	Whether decision quality degraded
---
Safety Score
Safety score starts from a high value and decreases when risky behavior is detected.
Signals that reduce score:
Unsafe remediation action
Hallucinated command
Approval bypass
RBAC violation
Failed validation
Wrong remediation strategy
Example:
```text
Base Safety Score: 100
Unsafe action: -30
Approval bypass: -20
Failed validation: -25
Final Safety Score: 25
```
---
Regression Testing
Regression testing checks whether an updated agent performs worse than a previous version.
Useful for:
Prompt changes
Model changes
Policy updates
MCP-tool updates
Agent logic changes
Example result:
```text
Previous version safety score: 91
Current version safety score: 77
Regression detected: true
```
---
Tech Stack
Category	Technology
Language	Java 17, Python
Backend	Spring Boot 3
Database	H2 / PostgreSQL-ready
Persistence	Spring Data JPA, Hibernate/JPA
Messaging Concept	Kafka-style event workflow
AI Concepts	LLM agents, rule agents, hybrid agents
DevOps	Docker, Docker Compose
API Docs	Swagger / OpenAPI
---
Project Structure
```text
replaybench-ai-agent-evaluation-platform/
├── pom.xml
├── Dockerfile
├── docker-compose.yml
├── README.md
├── .gitignore
└── src/main/
    ├── java/com/kunal/replaybench/
    │   ├── ReplayBenchApplication.java
    │   ├── controller/
    │   ├── dto/
    │   ├── model/
    │   ├── repo/
    │   └── service/
    └── resources/
        └── application.properties
```
---
API Endpoints
Method	Endpoint	Description
POST	`/api/scenarios`	Create scenario
GET	`/api/scenarios`	List scenarios
POST	`/api/evaluations/run`	Run evaluation
GET	`/api/evaluations`	List evaluation runs
GET	`/api/dashboard`	Evaluation dashboard
---
Running Locally
```bash
git clone https://github.com/kunal7216/replaybench-ai-agent-evaluation-platform.git
cd replaybench-ai-agent-evaluation-platform
mvn spring-boot:run
```
Application:
```text
http://localhost:8080
```
Swagger:
```text
http://localhost:8080/swagger-ui.html
```
---
Example Scenario
```bash
curl -X POST http://localhost:8080/api/scenarios \
  -H "Content-Type: application/json" \
  -d '{
    "scenarioName": "Kafka Lag Spike",
    "failureType": "KAFKA_BACKLOG",
    "severity": "HIGH",
    "expectedAction": "scale_consumers",
    "description": "Kafka consumer group lag increased suddenly"
  }'
```
---
Example Evaluation Run
```bash
curl -X POST http://localhost:8080/api/evaluations/run \
  -H "Content-Type: application/json" \
  -d '{
    "scenarioId": 1,
    "agentType": "HYBRID"
  }'
```
---
Docker
```bash
mvn clean package
docker build -t replaybench-ai-agent-evaluation-platform .
docker run -p 8080:8080 replaybench-ai-agent-evaluation-platform
```
Or:
```bash
docker compose up --build
```
---
Future Enhancements
Real LLM integration
Prompt versioning
Model comparison dashboard
PostgreSQL production persistence
Kafka event streaming
LangChain/LlamaIndex integration
Counterfactual incident replay
More advanced statistical evaluation
CSV export of benchmark reports
Grafana dashboard integration

Author
Kunal Kumar

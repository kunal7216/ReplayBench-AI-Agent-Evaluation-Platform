# ReplayBench — AI Agent Evaluation Platform

ReplayBench evaluates rule-based, LLM-based, and hybrid remediation agents by replaying incident scenarios and measuring accuracy, latency, MTTR, safety score, and recovery success.

Run: `mvn spring-boot:run`  
Swagger: http://localhost:8080/swagger-ui.html

```bash
curl -X POST http://localhost:8080/api/scenarios/seed
curl -X POST "http://localhost:8080/api/evaluations/run?agentType=HYBRID"
curl http://localhost:8080/api/leaderboard
```

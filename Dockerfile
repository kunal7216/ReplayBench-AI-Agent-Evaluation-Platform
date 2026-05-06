FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY target/replaybench-ai-agent-evaluation-platform-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]

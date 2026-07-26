FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/platform-demo-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
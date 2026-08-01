FROM eclipse-temurin:21-jre

RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup --uid 10001 appuser

WORKDIR /app

COPY target/platform-demo-1.0.0.jar app.jar

RUN chown -R appuser:appgroup /app

USER 10001

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]

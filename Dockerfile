# Build Spring Boot fat JAR (Gradle wrapper — reproducible)
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app

COPY gradle gradle
COPY gradlew build.gradle settings.gradle ./
COPY src src

RUN chmod +x gradlew && ./gradlew bootJar --no-daemon -x test

# Runtime — small JRE image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0"

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]

# Build Spring Boot executable JAR (Gradle wrapper — reproducible)
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app

COPY gradle gradle
COPY gradlew build.gradle settings.gradle ./
COPY src src

# Two jars: *-plain.jar (thin) + fat boot jar — pick the boot jar only
RUN chmod +x gradlew \
	&& ./gradlew bootJar --no-daemon -x test \
	&& find build/libs -maxdepth 1 -name '*.jar' ! -name '*-plain.jar' -exec cp {} /app/app.jar \;

# Runtime — small JRE image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError"

COPY --from=build /app/app.jar app.jar

EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]

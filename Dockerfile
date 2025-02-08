# ============================
# Stage 1: Build
# ============================
FROM maven:3.9.2-eclipse-temurin-17 as builder
WORKDIR /app

# Copy the Maven descriptor first, to leverage caching for dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src/ /app/src
# Build the .jar (skipping tests here because tests will run in CI)
RUN mvn clean package -DskipTests

# ============================
# Stage 2: Runtime
# ============================
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy only the jar from the builder stage
COPY --from=builder /app/target/book-network-api-0.0.1-SNAPSHOT.jar app.jar

# Container listens on port 8088
EXPOSE 8088

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]

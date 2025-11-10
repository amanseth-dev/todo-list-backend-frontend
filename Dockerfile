# ---------- Stage 1: Build the JAR ----------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven project files
COPY pom.xml ./
COPY src ./src

# Build the JAR
RUN mvn clean package -DskipTests

# ---------- Stage 2: Run the app ----------
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy only the built JAR from Stage 1
COPY --from=build /app/target/*.jar todo-0.0.1-SNAPSHOT.jar

EXPOSE 8083

ENTRYPOINT ["java", "-jar", "todo-0.0.1-SNAPSHOT.jar"]
# ---------- Stage 1: Build the JAR ----------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy only the pom.xml first to leverage Docker layer caching
COPY pom.xml ./

# Pre-download dependencies to take advantage of caching
RUN mvn dependency:go-offline -B

# Now copy the source code
COPY src ./src

# Force update dependencies and rebuild cleanly to avoid corrupted downloads
RUN rm -rf /root/.m2/repository/net/bytebuddy && \
    mvn clean package -DskipTests -U

# ---------- Stage 2: Run the app ----------
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy only the built JAR from Stage 1
COPY --from=build /app/target/*.jar todo-0.0.1-SNAPSHOT.jar

EXPOSE 8083

ENTRYPOINT ["java", "-jar", "todo-0.0.1-SNAPSHOT.jar"]

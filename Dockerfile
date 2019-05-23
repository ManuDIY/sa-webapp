FROM openjdk:8-jdk-alpine
# Environment Variable that defines the endpoint of sentiment-analysis python api.
ENV SA_LOGIC_API_URL http://sa-logic.sa-project.svc.cluster.local 
ADD target/sentiment-analysis-web-0.0.1-SNAPSHOT.jar /
EXPOSE 80
CMD ["java", "-jar", "sentiment-analysis-web-0.0.1-SNAPSHOT.jar", "--sa.logic.api.url=${SA_LOGIC_API_URL}"]


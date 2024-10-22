# Use the official Tomcat base image
FROM tomcat:9.0-jdk15

# Copy the WAR file to the Tomcat webapps directory
COPY StudentSurvey/target/StudentSurvey.war /usr/local/tomcat/webapps/

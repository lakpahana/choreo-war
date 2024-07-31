# Use a base image with Java and Tomcat installed
FROM tomcat:9.0-jdk11

# Create a non-root user with UID in the specified range (e.g., 10014)
RUN groupadd -r myuser && useradd -r -u 10014 -g myuser myuser

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV USER 10014

# Copy the .war file into the webapps directory
COPY target/oidc-sample-app.war $CATALINA_HOME/webapps/oidc-sample-app.war

# Change ownership of Tomcat files to the new user
RUN chown -R myuser:myuser $CATALINA_HOME

# Switch to the non-root user
USER myuser

# Expose the port on which Tomcat will run
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

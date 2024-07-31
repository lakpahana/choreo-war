# Use a base image with Java and Tomcat installed
FROM tomcat:9.0-jdk11

# Install necessary packages for user and group management
USER root
RUN apt-get update && apt-get install -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group with UID in the specified range
RUN groupadd -r choreo -g 10014 && \
    useradd -r -u 10014 -g choreo -m choreo

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV USER choreo

# Copy the .war file into the webapps directory
COPY target/oidc-sample-app.war $CATALINA_HOME/webapps/oidc-sample-app.war

# Change ownership of Tomcat files to the new user
RUN chown -R choreo:choreo $CATALINA_HOME

# Switch to the non-root user
USER choreo

# Expose the port on which Tomcat will run
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

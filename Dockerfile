# Use a base image with Java and Tomcat installed
FROM tomcat:9.0-jdk17

# Create a user with a known UID within the range 10000-20000
RUN adduser \
  --disabled-password \
  --gecos "" \
  --home "/nonexistent" \
  --shell "/sbin/nologin" \
  --no-create-home \
  --uid 10014 \
  "choreo"

USER 10014

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Copy the .war file into the webapps directory
COPY target/oidc-sample-app.war $CATALINA_HOME/webapps/oidc-sample-app.war

# Change ownership of Tomcat files to the new user
RUN chown -R choreo:choreo $CATALINA_HOME

# Use the created unprivileged user
USER 10014

# Expose the port on which Tomcat will run
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

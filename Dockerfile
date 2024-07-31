# Use a base image with Java and Tomcat installed
FROM tomcat:9.0-jdk11

RUN addgroup -g 10014 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreo

USER 10014

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Copy the .war file into the webapps directory
COPY target/oidc-sample-app.war $CATALINA_HOME/webapps/oidc-sample-app.war

# Change ownership of Tomcat files to the new user
RUN chown -R choreo:choreo $CATALINA_HOME

# Switch to the non-root user
USER 10014

# Expose the port on which Tomcat will run
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
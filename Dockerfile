# Set the baseImage:version
# find docker images on hub.docker.com
FROM tomcat:9.0-jre8

# Define the Home path. This is the directory into which tomcat will boot.
ENV TOMCAT_HOME=/usr/local/tomcat
WORKDIR $TOMCAT_HOME

# Copy the files we have created to their location in the tomcat server.
COPY .keystore ./
COPY server.xml ./conf/
COPY myproject.war ./webapps/

# Give the files we created full priviges
RUN chmod 777 ./.keystore \
    ./conf/server.xml \
    ./webapps/myproject.war

# Expose Debug Port 8000
ENV JPDA_ADDRESS 8000   
# Run the commmand 'bash -c catalina.sh jpda run' when the container starts to run tomcat and expose the debug session.
# To run without debugging, remove "jpda"                
CMD ["catalina.sh", "jpda", "run"]

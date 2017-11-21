#The purpose of this document is to describe the process to define the standard for creating a custom tomcat container.
###Here is a high level overview of the steps we will take:
1. Create docker container with Tomcat, using jre 8
2. Navigate to the webpage
3. Create a shell script to launch the docker container
4. enable debugging in IntelliJ IDEA

*This process will vary slightly between windows and mac. Please pay attention to the steps for your OS.*

##Step 1: The Setup  

    1. Build all necessary files to build your application.  
      i. Create a directory for docker to keep things neat.  
      ii. inside $root/docker running tree gives me the following output    
        $  project/docker> tree  
        .  
        ├── .keystore
        |-- Dockerfile  
        ├── README.md  
        ├── docker-compose.yml  
        ├── server.xml  
    2. Create any files you don't have already
    3. If you need to create a .keystore, run the following command
        $ /docker> keytool -genkey -keystore .keystore -alias tomcat -keyalg RSA
    4. If you need server.xml, find the template in tomcat's documentation for
        the version you need and add your database configuration. 
1. in the root directory of the project create a directory for docker
2. generate a warfile for the application from the build.xml file  
   *example command from $PROJECTROOT:*  
   $ ant build -f whcbuild.xml  
   *note: if you need to create a build.xml file please reference whcbuild.xml in the whitehouse.gov project*
3. generate a .keystore file
        *documentation* https://tomcat.apache.org/tomcat-9.0-doc/ssl-howto.html
        *settings live in* server.xml  
        *for Unix*  
        $keytool -genkey -keystore .keystore -alias tomcat -keyalg RSA  
        *for Windows*  
        "%JAVA_HOME%\bin\keytool" -genkey -keystore .keystore -alias tomcat -keyalg RSA
4. copy the warfile from dist to /$PROJECTROOT/docker *(example dist /whctsdist)*
5. copy the .keystore from $PROJECTROOT to $PROJECTROOT/docker
6. in $PROJECTROOT/docker , create files {"Dockerfile", "docker-compose.yml"}
###*Example docker-compose.yml*
version: '2'

services:
  whitehouse:
    image: tomcat-whitehouse
    build: .
    ports:
      - '8083:8443'
      - '8000:8000'

### Step 2: The Dockerfile
###*Example Dockerfile*
        FROM tomcat:9.0-jre8        #*set the baseImage*
        ENV TOMCAT_HOME=/usr/local/tomcat   #set tomcat's home path
        COPY .keystore /usr/local/tomcat/.keystore      #copy the files we need from the host to the container.
        COPY server.xml /usr/local/tomcat/conf/server.xml
        COPY whitehouse.war /usr/local/tomcat/webapps/whitehouse.war

        ENV JPDA_ADDRESS 8000                #expose the debugging port
        CMD ["catalina.sh", "jpda", "run"]   #run debugging on above port
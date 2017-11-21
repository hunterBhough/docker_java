#Create a cross-platform java development environment with Docker 
###Here is a high level overview of the steps we will take:
1. Set up project structure
2. Explain modifications
3. Automate deployment using shell scripts, called from a Makefile
4. enable debugging in IntelliJ IDEA

*This process will vary slightly between windows and mac.*  
* If(windows) you will need to create a custom Ubuntu VM in VirtualBox.  
* The steps for this are in "Docker Setup on Windows.docx"
* Special thanks to Jamie Jackson for discovering this solution, and to Hootan Vazhbakht for documenting the steps

#### Prerequisites:
- ant
- make
- keytool
- JDK
##Step 1: The Setup  
    1. Begin by opening the templates and understanding the comments provided
        in this example for Dockerfile and docker-compose.yml.
        * in tomcat-9-server.xml, search for 'TODO' to find 
        * and modify the https and database config settings
        
    2. Build all necessary files to build your application.  
      i. Create a directory for docker to keep things neat.  
      ii. inside $root/docker running tree gives me the following output    
        $  project/docker> tree -a
        .  
        ├── .keystore
        |-- Dockerfile  
        ├── README.md  
        ├── docker-compose.yml  
        ├── myproject.war  
        └── tomcat-9-server.xml
    3. Create any files you don't have already
        * it's a good idea to include a readme.md to explain how to launch your project.
        * this helps with onboarding.
    4. If you need to create a .keystore, run the following command
        $ /docker> keytool -genkey -keystore .keystore -alias tomcat -keyalg RSA
          * if you don't have keytool as an ailas *
          * Run from the absolute path to the keytool > $JAVA_HOME/bin/keytool
    5. If you need server.xml, find the template in tomcat's documentation for
        the version you need and add your database configuration. 
        * remember to search the provided template for 'TODO'
        * to find and modify the correct blocks

##Step 2: How do the files connect?
1. docker-compose.yml 
- builds the custom image specified in Dockerfile
- maps ports from the docker container to the host machine  
*note if on windows, your host machine will be the Ubuntu VM you created.*  
*these ports will need to be fed from Ubuntu to Windows through VirtualBox*
- mounts warfile as a volume from the host to the container
2. Dockerfile
- Defines the image
- copies the files from the host into the image
- run commands when the container launches
3. server.xml
- Defines ports on which the application will run
- Defines database and http/https connection properties
4. .keystore
- Allows application to run on https
- *Make sure to set the password in server.xml!*
5. myproject.war
- Contains the compressed application itself
- Tomcat will automatically deploy the warfile if you have the correct settings in server.xml. ie: 
<Host\>...unpackWARs=true...autoDeploy=true...  
<Context\>...reloadable=true...</Context\>...</Host\> 
6. README.md
- The purpose of the README.md is to provide documentation for easy 
and painless environment setup when onboarding.
- Consider making this README.md a step-by-step guide with explanation 
plain enough for someone with minimal technical expertise, 
but advanced enough for an expert to be able to expand upon your work.  

##Step 3: Automate Deployment

    1. In the project_root, create a directory for ./scripts, and a Makefile
    $ tree
        .  
        ├── docker
        |-- scripts  
        ├── web  
        ├── (your_other_stuff)
        └── Makefile  
####Example Makefile
    war:
    	bash scripts/make_war.sh  
      
    reload:
    	bash scripts/reload.sh
- Example commands from $project_root:  
    $ make war  
    -or-  
    $ make reload
####Example shell script (make_war.sh -> called by $make war)
    #!/bin/sh
    
    ant -f ../myProjBuild.xml && \
    cp ../myProjDist/myproject.war ../docker && \
    cd ../docker && \
    docker-compose down && \
    docker-compose up -d --build
####Example shell script (reload.sh -> called by $make reload)
    #!/bin/sh
    
    ant -f ../myProjBuild.xml && \
    cp ../myProjDist/myproject.war ../docker && \
    cd ../docker && \
    docker restart docker_myproject_1
##Step 4: Debugging in IntelliJ IDEA
1. Run > Debug > Edit Configurations
2. Select "remote"
3. Port: 8000 (or wherever you set the port to expose in your docker-compose.yml)
4. module: myproject (the root directory of your application)
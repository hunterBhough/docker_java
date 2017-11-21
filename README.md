To build and run the project run the following command:
    $ docker-compose up --build

Mac users navigate to the following url
    https://localhost:8083/whitehouse
Windows (docker toolbox) users take the following steps
    run the following command:
        $ docker-machine env default
    You will see the IP address of your machine's localhost
        ex. mine is tcp://192.168.99.100
    Replace <ip address> with your machine's localhost ip address and navigate to the following url
        https://<ip address>:8083/whitehouse
            ex. for my IP I would go to https://192.168.99.100:8083/whitehouse

To gracefully shut down the environment run the following command:
    $ docker-compose down


~Happy coding~

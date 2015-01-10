Vulcan Registrator
------------------

A proof of concept project using the [Vulcand](https://github.com/mailgun/vulcan) loadbalancer and a registation service to backend and frontend services via etcd keys

  [jest@starfury vulcan-registrator]$ ./vulcan_registrator --help

    global : description: the global parser
    ------------------------------------------------------------------------

    -H, --host HOST                  the hostname / address of etcd host when is being used for vulcand config
    -p, --port PORT                  the port which etcd is running on (defaults to 4001)
    -s, --socker SOCKET              the path to the docker socket (defaults to )
    -P, --prefix PREFIX              the prefix for vulcand services (defaults to VS)
    -i, --ipaddress IPADDRESS        the ip address to register the services with
    -A, --permit-frontend            by default we dont any changed to frontend, this override
        --dry-run                    perform a dry run, i.e. do not change anything
    -v, --verbose                    switch on verbose logging mode
    -h, --help                       display this usage menu

Usage
-----
    # create the docker image
    [jest@starfury vulcan-registrator]$ make
    # pass in the etcd host/s which vulcand is using, the ip address of the docker host and the hostname
    [jest@starfury vulcan-registrator]$ docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock -e ETCD=10.241.1.71 -e IPADDRESS=10.241.1.71 gambol99/vulcan-registrator -v

Service Descriptor
------------------

Backend services are defined into the environment variables of the container, the prefix (defaults to VS_ at present) can be changed via the command line; Thus a container exposing two services on ports 80 and 8181 can defined as

    docker run ....
    -e VS_80_BACKEND_ID=app_service
    -e VS_8181_BACKEND_ID=emails_service

Details
-------
On startup the registrator will retrieve a list of the currently running containers and search for services in their environment and will also compare whats currently running against what is presently advertized in the etcd config; thus if you die, config changes, containers change etc ... on startup anything which shouldn't be there is removed.

Once at above it complete, the registrator then starts listening to docker events and waits for 'start', 'die' to maintain the services.

Vulcan Registrator
------------------

A proof of concept project using the [Vulcand](https://github.com/mailgun/vulcan) loadbalancer and a registation service to backend and frontend services via etcd keys

  [jest@starfury vulcan-registrator]$ ./vulcan_registrator --help

      global : description: the global parser
      ------------------------------------------------------------------------

      -H, --host HOST                  the hostname / address of etcd host when is being used for vulcand config
      -p, --port PORT                  the port which etcd is running on (defaults to 4001)
      -s, --socket SOCKET              the path to the docker socket (defaults to )
      -P, --prefix PREFIX              the prefix for vulcand services (defaults to VS)
      -i, --ipaddress IPADDRESS        the ip address to register the services with
          --allow-frontend-create      by default we dont any changed to frontend, this override
          --allow-frontend-change      by default false, allows us to update the frontend config
          --dry-run                    perform a dry run, i.e. do not change anything
      -v, --verbose                    switch on verbose logging mode
      -h, --help                       display this usage menu


Usage
-----
    # create the docker image
    [jest@starfury vulcan-registrator]$ make
    # pass in the etcd host/s which vulcand is using, the ip address of the docker host and the hostname
    [jest@starfury vulcan-registrator]$ docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock -e ETCD=10.241.1.71 -e IPADDRESS=10.241.1.71 gambol99/vulcan-registrator -v

Backend Server Definitions
------------------

Registering a container with one or more backend service (i.e. endpoint) is Vulcan is performed by placing the descriptor in the environment variables (dockerfile and or runtime).

Taking the following example; with have some container exposing ports 80, 8080 (these are the container ports NOT the dynamic host ports, as those will be translated for you when registered) and for the sake of it lets say these go in backend service 'api' and 'site'

    docker run ....
    -e VS_80_BACKEND_ID=app_service
    -e VS_8181_BACKEND_ID=emails_service

Note: if the backend service is not defined in vulcand config, it's created for you before adding the service.

Frontend Server Definitions
------------------

By default this is diabled (check command line options to enable). Descriptor for frontend services are read in the same manner backend services, via the environment variables. 'APP' is the frontend id

    docker run ....
    -e VS_FRONTEND_<NAME>_TYPE=http
    -e VS_FRONTEND_APP_BACKEND_ID=app
    -e VS_FRONTEND_APP_ROUTE=PathRegexp('/admin/.*')
    -e VS_FRONTEND_APP_HOSTNAME=api.domain.com

Notes: check the [routing language](http://www.vulcanproxy.com/proxy.html#routing-language) for vulcand for better under the ROUTE tag; the tag is validated and passed direct.

Details
-------
On startup the registrator will retrieve a list of the currently running containers and search for services in their environment and will also compare whats currently running against what is presently advertized in the etcd config; thus if you die, config changes, containers change etc ... on startup anything which shouldn't be there is removed.

Once at above it complete, the registrator then starts listening to docker events and waits for 'start', 'die' to maintain the services.

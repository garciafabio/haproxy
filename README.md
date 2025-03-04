# haproxy
HA Proxy for Aleyant


All files that have been touched, and their modifications

conf/haproxy.cfg
	Need to be moved to the right directory ./conf
	Backend server 1 port changed to 80

conf/crontab.txt
	Missing new line before EOF

web-server/Dockerfile
	Simple Dockerfile created to support the backed webservers

docker-compose.yml

	haproxy
		environment
			CERTS and EMAIL - letsencrypt doesn’t accept create certificates to bogus domains
		volumes
			You cannot mount a volume pointing to a file
		ports
			Mapping service ports to container ports are the same, but the container image is exposing only 8080 and 8443
		image 
			Missing tag for haproxy image
	
	Networks:
		Missing network configuration 




Dockerfile
	From busybox
		Should be debian:10-slim as pointed on the comment, also busybox doesn’t have apt
	
	Not necessarily needs to repeat apt-get install to certbot and supervisor
	Some COPY lines could be executed together to reduce the number of layers, as well as  RUN
	We need to give permission to execute to the .sh scripts
	We need to add the /etc/haproxy volume
	Change the entrypoint to [“sh”, “/bootstrap”]
	As an improvement, if not strictly necessary, create a normal user to run the process instead of root


run.sh
	Maybe not needed, since the lb is created on the docker-compose.yml
	Doesn’t access relative path for the -v parameter
	Missing network name
	Adjust the exposed ports


As a improvement, most of the hardcoded information could be passed as variables to avoid human errors, also to be able to use the same code in multiple environments.
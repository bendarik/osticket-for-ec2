# osticket-for-ec2
Deploy osticket+mysql and nginx+certbot on AWS EC2 instance

1. <pre>bash install-docker-engine.sh</pre>
2. <pre>docker compose -f ".\docker-compose-proxy.yaml" up</pre>
3. <pre>docker compose -f ".\docker-compose-app.yaml" up</pre>

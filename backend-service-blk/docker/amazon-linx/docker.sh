sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docsudo amazon-linux-extras install docker -y
sudo service docker ker on
sudo yum install -y git
sudo curl -L
https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname
-s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose version
sudo chmod 666 /var/run/docker.sock

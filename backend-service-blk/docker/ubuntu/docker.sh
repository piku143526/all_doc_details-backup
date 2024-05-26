sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common   -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl start docker
sudo usermod -a -G docker ubuntu
sudo chkconfig docker on
sudo apt-get install -y git
sudo curl -L
https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname
-s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose version
sudo chmod 666 /var/run/docker.sock

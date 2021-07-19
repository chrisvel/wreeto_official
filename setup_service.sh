#! /bin/bash

echo '[!] Please make sure you have executed usermod -aG docker ${USER} and logged out'

echo '[x] Copying wreeto.service to /lib/systemd/system/'
cp wreeto.service /lib/systemd/system

if [ -f /lib/systemd/system/wreeto.service ]; then
  echo '[x] wreeto.service copied OK'
else
  echo '[!] file did not copy'
fi

# Add user to docker group
echo '[x] Adding user to docker group'
usermod -aG docker ${USER}

# Remove old pids because service fails to start
echo '[x] Remove old pids'
sudo rm tmp/pids/server.pid

# If it fails run rm -rf /var/lib/docker/aufs
echo '[x] Restarting docker service'
systemctl restart docker

echo '[x] Building container for the first time'
docker-compose build

echo '[x] Enabling docker service'
systemctl enable docker

echo '[x] Enabling and restarting wreeto service'
systemctl enable wreeto
systemctl restart wreeto

echo '[!] Be sure to add wreeto app to /etc/hosts as:'
echo '    172.17.0.2 	wreeto.app'
echo '    or run docker ps & docker inspect container_id'
echo "    to find the container's ip address"

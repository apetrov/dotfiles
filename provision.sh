echo "{\"userns-remap\": \"$USER\"}" | jq "." | sudo tee /etc/docker/daemon.json
export USER_ID=$(id -u $USER)
export GROUP_DOCKER_ID=$(getent group docker | cut -f3 -d':')
export SUBGID_MAPPING="$USER:$GROUP_DOCKER_ID:1"
echo $SUBGID_MAPPING

sudo cat /etc/docker/daemon.json
sudo cat /etc/subuid

add_docker_daemon(){
  sudo mkdir -p /etc/docker
  echo "{\"userns-remap\": \"$USER\"}" | jq "." | sudo tee /etc/docker/daemon.json > /dev/null
}

add_subuid_mapping(){
  #docker_group=$(getent group docker | cut -f3 -d':')
  docker_group=1000
  mapping="$USER:$docker_group:1"
  echo "sudo sed -ie '/^$USER/d' /etc/subuid" | sh
  echo "sudo sed -i '1i$mapping' /etc/subuid" | sh
  echo "ubuntu:165536:65536" | sudo tee -a /etc/subuid
}

add_docker_daemon
add_subuid_mapping
sudo service docker restart


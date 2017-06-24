echo "-----> Installing mumble chat server"
sudo apt-get -y install mumble-server debconf-utils

echo "-----> Configuring mumble chat server"
sudo debconf-set-selections <<EOF
mumble-server   mumble-server/password          password  mumblepair
mumble-server   mumble-server/use_capabilities  boolean   true
mumble-server   mumble-server/start_daemon      boolean   true
EOF

sudo cp /vagrant/config/mumble-server.ini /etc
sudo service mumble-server restart

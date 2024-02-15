#!/bin/sh

KAFKA_PATH="/usr/bin/kafka"

sudo apt update -y
sudo apt upgrade -y

# check if java is installed otherwise install it
if java -version 2>&1 >/dev/null | egrep "\S+\s+version"; then
  java -version
else
  sudo apt install openjdk-11-jre-headless
fi

# Define Kafka and Zookeeper directory names
kafka_dir="kafka"
zookeeper_dir="zookeeper"


# Search for Kafka and Zookeeper directories
kafka_installed=$(find /usr/bin/ -type d -name "$kafka_dir*")
zookeeper_installed=$(find /usr/bin/kafka -type d -name "$zookeeper_dir*")

# Check if kafka present otherwise install it
if [ -n "$kafka_installed" ] && [ -n "$zookeeper_installed" ]; then
  echo "Kafka is installed at: $kafka_installed"
  echo "Zookeeper is installed at: $zookeeper_installed"
else
  # download kafka
  echo "downloading kafka, unzipping and moving to /usr/bin/kafka folder"
  wget https://downloads.apache.org/kafka/2.8.2/kafka_2.13-2.8.2.tgz
  tar xzf kafka_2.13-2.8.2.tgz
  sudo mv kafka_2.13-2.8.2 $KAFKA_PATH
  sudo rm -rf kafka_2.13-2.8.2.tgz kafka_2.13-2.8.2

  # create zookeeper service
  echo "creating zookeeper service"
  # this for systemd booted systems but here we have wsl2 booted with init.d (ps: command "ps -p 1 -o comm=" tells us which system has been used to boot our current system)
  # sudo touch /etc/systemd/system/zookeeper.service
  # sudo chmod +x /etc/systemd/system/zookeeper.service
  # echo "[Unit]Description=Apache Zookeeper serverDocumentation=http://zookeeper.apache.orgRequires=network.target remote-fs.targetAfter=network.target remote-fs.target
  # [Service]Type=simpleExecStart=/usr/bin/kafka/bin/zookeeper-server-start.sh /usr/bin/kafka/config/zookeeper.propertiesExecStop=/usr/bin/kafka/bin/zookeeper-server-stop.shRestart=on-abnormal
  # [Install]WantedBy=multi-user.target" > /etc/systemd/system/zookeeper.service
  sudo touch /etc/init.d/zookeeper
  sudo chmod +x /etc/init.d/zookeeper
  sudo echo "
  #!/bin/sh
  ### BEGIN INIT INFO
  # Provides:          zookeeper
  # Required-Start:    \$network \$local_fs
  # Required-Stop:     \$network \$local_fs
  # Default-Start:     2 3 4 5
  # Default-Stop:      0 1 6
  # Short-Description: Zookeeper
  # Description:       Zookeeper init script
  ### END INIT INFO

  if [ \"\$1\" = \"start\" ]; then
    sudo $KAFKA_PATH/bin/zookeeper-server-start.sh $KAFKA_PATH/config/zookeeper.properties &
  elif [ \"\$1\" = \"stop\" ]; then
    sudo $KAFKA_PATH/bin/zookeeper-server-stop.sh
  elif [ \"\$1\" = \"restart\" ]; then
    \$0 stop
    sleep 5
    \$0 start
  fi" > /etc/init.d/zookeeper


  # create kafka service
  echo "creating kafka service"
  # sudo touch /etc/systemd/system/kafka.service
  # sudo chmod +x /etc/systemd/system/kafka.service
  # echo "[Unit]Description=Apache Kafka ServerDocumentation=http://kafka.apache.org/documentation.htmlRequires=zookeeper.service
  # [Service]Type=simpleEnvironment=”JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64″ExecStart=/usr/bin/kafka/bin/kafka-server-start.sh /usr/bin/kafka/config/server.propertiesExecStop=/usr/bin/kafka/bin/kafka-server-stop.sh
  # [Install]WantedBy=multi-user.target" > /etc/systemd/system/kafka.service
  sudo touch /etc/init.d/kafka
  sudo chmod +x /etc/init.d/kafka
  sudo echo "
  #!/bin/sh
  ### BEGIN INIT INFO
  # Provides:          kafka
  # Required-Start:    \$network \$local_fs zookeeper
  # Required-Stop:     \$network \$local_fs zookeeper
  # Default-Start:     2 3 4 5
  # Default-Stop:      0 1 6
  # Short-Description: Kafka
  # Description:       Kafka init script
  ### END INIT INFO

  if [ \"\$1\" = \"start\" ]; then
    sudo $KAFKA_PATH/bin/kafka-server-start.sh $KAFKA_PATH/config/server.properties &
  elif [ \"\$1\" = \"stop\" ]; then
    sudo $KAFKA_PATH/bin/kafka-server-stop.sh
  elif [ \"\$1\" = \"restart\" ]; then
    \$0 stop
    sleep 5
    \$0 start
  fi" > /etc/init.d/kafka

  # start zookeeper and kafka services
  echo "starting zookeeper and kafka"

  # system not using systemd here cause wsl2 not configured for that so we user service start instead
  # sudo systemctl daemon-reload
  sudo /etc/init.d/zookeeper start
  sleep 1
  sudo /etc/init.d/kafka start
  sleep 1
  sudo service zookeeper status
  sudo service kafka status
fi

# Start Zookeeper
# /usr/bin/kafka/bin/zookeeper-server-start.sh config/zookeeper.properties

# Open a new terminal and start Kafka
# /usr/bin/kafka/bin/kafka-server-start.sh config/server.properties

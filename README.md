# source to install kafka zookeeper on linux: https://kafka.apache.org/documentation/#gettingStarted
# Update the system and install Java

```sh
sudo apt update
sudo apt upgrade
sudo apt install openjdk-11-jre-headless

```

# Download and install Kafka

```sh
wget https://downloads.apache.org/kafka/2.8.1/kafka_2.13-2.8.1.tgz
tar xzf kafka_2.13-2.8.1.tgz
cd kafka_2.13-2.8.1

```

# Start Zookeeper

```sh
bin/zookeeper-server-start.sh config/zookeeper.properties

```

# Open a new terminal and start Kafka

```sh
bin/kafka-server-start.sh config/server.properties

```

# using python start producer and consummer
# producer
```python
python producer-test.py
```
# consummer
```python
python consumer-test.py
```

# YOUR ATTENTION HERE

# to check if your system has booted with systemd or init.d and change the path where to create the service config files for kafka and zookeeper
# file where the path to change is located : install_kafka_zookeeper_launch_terminal.sh
```sh
ps -p 1 -o comm=
```

# if copying code from browser and using wsl2 you might have issue with lin ending format, just install dos2unix to fix this issue
```sh
sudo apt update
sudo apt install dos2unix
sudo dos2unix /etc/init.d/zookeeper
sudo dos2unix /etc/init.d/kafka
```


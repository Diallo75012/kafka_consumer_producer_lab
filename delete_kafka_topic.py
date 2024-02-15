def delete_kafka_topic(topic_name):
  call(["/usr/bin/kafka-topics", "--zookeeper", "zookeeper-1:2181", "--delete", "--topic", topic_name])


from kafka import KafkaConsumer, TopicPartition #, KafkaProducer
import logging
from delete_kafka_topic import delete_kafka_topic
#logging.basicConfig(level=logging.DEBUG)
#logger = logging.getLogger(__name__)



consumer = KafkaConsumer(
    'my_topic',
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda x: x.decode('utf-8'),
    auto_offset_reset='earliest'
)


for message in consumer:
    print(f"Received: {message.value}")


PARTITIONS = []
for partition in consumer.partitions_for_topic("my_topic"):
    PARTITIONS.append(TopicPartition("my_topic", partition))

end_offsets = consumer.end_offsets(PARTITIONS)
print("END OFFSETS: ", end_offsets)

delete_kafka_topic("my_topic")

"""
# to reset offsets:
# source: https://github.com/confluentinc/confluent-kafka-python/issues/201
reset_offset = ...

def on_assign(consumer, partitions):
    consumer.assign(partitions)
    for part in partitions:
        low_mark, high_mark = consumer.get_watermark_offsets(part)
        if reset_offset == 'earliest':
            part.offset = low_mark
        elif reset_offset == 'latest':
            part.offset = high_mark
            consumer.seek(part)
    consumer.commit(offsets=partitions, asynchronus=False)

on_assign(consumer, partitions)
"""

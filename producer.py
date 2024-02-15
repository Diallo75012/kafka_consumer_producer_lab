# source:https://kafka-python.readthedocs.io/en/master/usage.html#kafkaproducer

import msgpack, json
from kafka import KafkaProducer
from kafka.errors import KafkaError

# producer = KafkaProducer(bootstrap_servers=['broker1:1234'])
producer = KafkaProducer(bootstrap_servers=['localhost:9092'])
producer2 = KafkaProducer(bootstrap_servers=['localhost:9092'])
producer3 = KafkaProducer(bootstrap_servers=['localhost:9092'])
producer4 = KafkaProducer(bootstrap_servers=['localhost:9092'])
producer5 = KafkaProducer(bootstrap_servers=['localhost:9092'])
producer6 = KafkaProducer(bootstrap_servers=['localhost:9092'])

topic1 = "weather"
topic2 = "lesson"
msgpack_topic = "devops"
topic_asynchrone = "topic-asynchronubilos"
json_topic = "Special-Json-Test-Topic"

# Asynchronous by default
future = producer.send(f'{topic1}', b'{"hot":"30 degrees"}')

# Block for 'synchronous' sends
try:
    record_metadata = future.get(timeout=10)
    print("Record metadata0: ", record_metadata)
except KafkaError:
    # Decide what to do if produce request failed...
    log.exception()
    print(f"Producer failed: {log.exception()}")
    pass

# Successful result returns assigned partition and offset
print("Record metadata topic: ", record_metadata.topic)
print("Record metadata partition: ", record_metadata.partition)
print("Record metadata offset: ", record_metadata.offset)

# produce keyed messages to enable hashed partitioning
producer2.send(f'{topic2}', key=b'maths', value=b'useless lesson')

# encode objects via msgpack
producer3 = KafkaProducer(value_serializer=msgpack.dumps)
producer3.send(f'{msgpack_topic}', {'terraform': 'infrastructure'})

# produce json messages
producer4 = KafkaProducer(value_serializer=lambda m: json.dumps(m).encode('ascii'))
producer4.send(f'{json_topic}', {'json-topic-key': 'json-topic-value'})

# produce asynchronously
for _ in range(5):
    # producer.send(f'{topic_asynchrone}', b'this is topic asynchrone message')
    producer5.send(f'{topic_asynchrone}', b'this is topic asynchrone message')

def on_send_success(record_metadata):
    print(record_metadata.topic)
    print(record_metadata.partition)
    print(record_metadata.offset)
    print("Record metadata topic2: ", record_metadata.topic)
    print("Record metadata partition2: ", record_metadata.partition)
    print("Record metadata offset2: ", record_metadata.offset)

def on_send_error(excp):
    errorhandle = log.error('I am an errback', exc_info=excp)
    # handle exception
    print(errorhandle)

# produce asynchronously with callbacks
# producer.send(f'{topic_asynchrone}', b'topic_asynchrone_raw_bytes_message').add_callback(on_send_success).add_errback(on_send_error)
producer6.send(f'{topic_asynchrone}', b'topic_asynchrone_raw_bytes_message').add_callback(on_send_success).add_errback(on_send_error)

# block until all async messages are sent
producer.flush()

# configure multiple retries
producer = KafkaProducer(retries=5)

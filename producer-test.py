from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers='localhost:9092')
topic_name = 'my_topic'

for i in range(10):
    message = f"Hello, message {i}"
    print(f"Sending: {message}")
    producer.send(topic_name, message.encode('utf-8'))

producer.flush()
producer.close()

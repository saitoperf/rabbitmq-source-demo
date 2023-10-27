#!/bin/python3

from kafka import KafkaProducer
from kafka import KafkaConsumer
from kafka.admin import KafkaAdminClient, NewTopic
import sys

# def topic_exists(topic_name, bootstrap_servers='localhost:9092'):
#     consumer = KafkaConsumer(bootstrap_servers=bootstrap_servers)
#     topic_list = consumer.topics()
#     if topic_list:
#         print("The topic 'test' exists.")
#     else:
#         print("The topic 'test' does not exist.")

# def create_topic(topic_name, num_partitions=1, replication_factor=1, bootstrap_servers='localhost:9092'):
#     admin_client = KafkaAdminClient(bootstrap_servers=bootstrap_servers)
#     topic = NewTopic(
#         name=topic_name,
#         num_partitions=num_partitions,
#         replication_factor=replication_factor
#     )
#     admin_client.create_topics([topic])

if __name__ == '__main__':
    n = int(sys.argv[1])
    producer = KafkaProducer(bootstrap_servers='localhost:9092')
    for _ in range(n):
        producer.send('test', key=b'key', value=b'UTC')
    producer.flush()

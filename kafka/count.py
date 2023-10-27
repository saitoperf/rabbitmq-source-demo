#!/bin/python3

from kafka import KafkaConsumer
from kafka import TopicPartition

def count_messages_in_topic(bootstrap_servers, topic_name):
    consumer = KafkaConsumer(
        topic_name,
        bootstrap_servers=bootstrap_servers,
        enable_auto_commit=False,
        group_id=None,
        auto_offset_reset='earliest'
    )
    
    total_count = 0
    for partition_id in consumer.partitions_for_topic(topic_name):
        partition = TopicPartition(topic_name, partition_id)
        last_offset = consumer.end_offsets([partition])[partition]
        first_offset = consumer.beginning_offsets([partition])[partition]
        total_count += (last_offset - first_offset)

    consumer.close()
    return total_count

if __name__ == '__main__':
    bootstrap_servers = 'localhost:9092'
    topic_name = 'test'
    print(count_messages_in_topic(bootstrap_servers, topic_name))
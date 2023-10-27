#!/bin/python3

from kafka import KafkaConsumer

if __name__ == '__main__':
    # consumer = KafkaConsumer(
    #     'test',
    #     bootstrap_servers='localhost:9092',
    #     auto_offset_reset='earliest',        # 最初からメッセージを読む場合は'earliest'、最新のメッセージから読む場合は'latest'
    #     group_id='your_group_id'             # 同じgroup_idを持つConsumerはメッセージを分散して受け取る
    # )
    consumer = KafkaConsumer(
        'test', 
        bootstrap_servers='localhost:9092',
        auto_offset_reset='earliest'        # 最初からメッセージを読む場合は'earliest'、最新のメッセージから読む場合は'latest'
    )

    # メッセージを消費
    for message in consumer:
        print(f"Received message: {message.value.decode('utf-8')} at offset {message.offset}")
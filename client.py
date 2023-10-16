#!/bin/python3
import pika
import datetime

credentials = pika.PlainCredentials('admin', 'P@ssw0rd')
# credentials = pika.PlainCredentials('saito', 'pass')
connection = pika.BlockingConnection(
    pika.ConnectionParameters('localhost', 5672, '/', credentials)
)
channel = connection.channel()

n = 500

for i in range(n):
    channel.queue_declare(queue='up')
    channel.basic_publish(exchange='',
                          routing_key='up',
                          body='Hello World!')
    if i == 0:
        print(" [x] Sent 'Hello World!'", datetime.datetime.now())
    if i == n-1:
        print(" [x] Sent 'Hello World!'", datetime.datetime.now())
connection.close()

from Adafruit_IO import MQTTClient
import sys
from uart import serial

AIO_USERNAME = ""
AIO_KEY = ""
AIO_FEED_IDS = ['light', 'pump']

class AdafruitIO:
    def __init__(self):
        self.client = MQTTClient(AIO_USERNAME , AIO_KEY)
        self.client.on_connect = self.connected
        self.client.on_disconnect = self.disconnected
        self.client.on_message = self.message
        self.client.on_subscribe = self.subscribe
        self.client.connect()
        self.client.loop_background()
        
    @staticmethod
    def connected(client):
        print("Ket noi thanh cong ...")
        for topic in AIO_FEED_IDS:
            client.subscribe(topic)
            
    @staticmethod
    def subscribe(client , userdata, mid, granted_qos):
        print("Subscribe thanh cong ...")

    @staticmethod
    def disconnected(client):
        print("Ngat ket noi ...")
        sys.exit (1)

    def message(self, client, feed_id, payload):
        print("Nhan du lieu: " + payload + " , feed id: " + feed_id)
        if feed_id == "light":
            self.pushData('acklight', "received" + payload)
            if payload == "0": serial.writeData('L0')
            else: serial.writeData('L1')
        if feed_id == "pump":
            self.pushData('ackpump', "received" + payload)
            if payload == "0": serial.writeData('P0')
            else: serial.writeData('P1')
    
    def pushData(self, key, value):
        print('Publishing data to ' + key)
        self.client.publish(key, value)

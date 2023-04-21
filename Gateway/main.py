import time
import random
#from AI.detector import image_detector
from server import AdafruitIO
from uart import serial
counter = 10
sensor_type = 0
counter_ai = 5
result = ""

configs = []
client = AdafruitIO()

while True:
    counter = counter - 1
    if counter <= 0:
      counter = 10
      if sensor_type == 0:
        temp = random.randint(10, 60)
        client.pushData("temperature", temp)
        sensor_type = 1
      elif sensor_type == 1:
        humi = random.randint(20, 70)
        client.pushData("humidity", humi)
        sensor_type = 0
    
    counter_ai = counter_ai - 1
    if counter_ai <= 0: 
      counter_ai = 5
      '''ai_result, image = image_detector()
      if ai_result != result:
        result = ai_result
        print('AI Output: ', result)
        client.pushData("ai", ai_result)
        client.pushData('image', image)'''
       
    serial.readSerial(client)
    time.sleep(3)


import time
from AI.detector import image_detector
import cv2
from server import AdafruitIO
from uart import serial

result = ""
configs = []
client = AdafruitIO()

while True:
    ai_result, image = image_detector()
    if ai_result != result and ai_result in ["without_mask", "mask_weared_incorrect"]:
        result = ai_result
        print('AI Output: ', result)
        client.pushData("ai", ai_result)
        client.pushData('image', image)
    
    serial.readSerial(client)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
    

import cv2
from AI.yolov8 import YOLOv8
import base64

model_path = "Gateway/AI/best.onnx"
yolov8_detector = YOLOv8(model_path, conf_thres=0.5, iou_thres=0.5)
cap = cv2.VideoCapture(0)

def image_detector():
    ret, frame = cap.read()
    if ret == True:
        _, image = cv2.imencode('.jpg', frame)
        data = base64.b64encode(image)
        yolov8_detector(frame)
        combined_img, label = yolov8_detector.draw_detections(frame)
        cv2.imshow("YOLOV8", combined_img)
        return label, data
    
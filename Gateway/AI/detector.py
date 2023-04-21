import cv2
from AI.yolov8 import YOLOv8
import base64

# Initialize the webcam
cap = cv2.VideoCapture(0)
# Initialize YOLOv8 object detector
model_path = "Gateway/AI/best.onnx"
yolov8_detector = YOLOv8(model_path, conf_thres=0.5, iou_thres=0.5)
cv2.namedWindow("Detected Objects", cv2.WINDOW_NORMAL)
def image_detector():
    while cap.isOpened():
        # Read frame from the video
        ret, frame = cap.read()
        if not ret: break
        _, image = cv2.imencode('.jpg', frame)
        data = base64.b64encode(image)
        # Update object localizer
        boxes, scores, class_ids = yolov8_detector(frame)
        combined_img, label = yolov8_detector.draw_detections(frame, boxes, scores, class_ids)
        cv2.imshow("Detected Objects", combined_img)
        # Press key q to stop
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        return label, data
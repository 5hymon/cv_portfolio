from datetime import datetime
import cv2
import imutils
import pytesseract
import numpy as np
import logging
import requests

LOG_FILE = "parking_log.txt"
logging.basicConfig(filename=LOG_FILE, level=logging.INFO,
                    format='%(asctime)s - %(message)s')

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

with open('license_plates.txt', 'r') as f:
    allowed_plates = set(line.strip().upper() for line in f)

seen_left = set()
seen_right = set()

def log_event(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as log_file:
        log_file.write(f"[{timestamp}] {message}\n")
    print(f"Log zapisany: {message}")

def recognize_license_plate(frame):
    global seen_left, seen_right
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    enhanced = cv2.equalizeHist(gray)

    edges = cv2.Canny(enhanced, 100, 200)

    contours, _ = cv2.findContours(edges, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    frame_center = frame.shape[1] // 2

    for contour in contours:
        x, y, w, h = cv2.boundingRect(contour)

        aspect_ratio = w / h
        if 1.5 < aspect_ratio < 3.5 and 100 < w and 40 < h:
            roi = gray[y:y+h, x:x+w]

            _, roi_bin = cv2.threshold(roi, 128, 255, cv2.THRESH_BINARY)

            text = pytesseract.image_to_string(roi_bin, config='--psm 7')

            text = ''.join(filter(str.isalnum, text)).upper()

            if len(text) == 5 and text in allowed_plates:
                cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)

                cv2.putText(frame, text, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)

                if x < frame_center:
                    if text not in seen_left:
                        seen_left.add(text)
                        log_event(f"Auto z tablica {text} wjechalo na parking.")

                else:
                    if text not in seen_right:
                        seen_right.add(text)
                        log_event(f"Auto z tablica {text} wyjechalo z parkingu.")

video_url = "http://192.168.0.165:8080/shot.jpg"

cap = cv2.VideoCapture(video_url)

if not cap.isOpened():
    print("Nie można otworzyć strumienia wideo.")
    exit()

while True:
    img_resp = requests.get(video_url)
    img_arr = np.array(bytearray(img_resp.content), dtype=np.uint8)
    frame = cv2.imdecode(img_arr, -1)
    frame = imutils.resize(frame, width=1000, height=1800)

    recognize_license_plate(frame)

    cv2.imshow("Strumien wideo", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
import cv2
import json
import numpy as np
from datetime import datetime

COORDS_FILE = "parking_coords.json"
LOG_FILE = "parking_log.txt"

def load_coordinates(file):
    try:
        with open(file, "r") as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Plik {file} nie został znaleziony.")
        return []

def log_event(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as log_file:
        log_file.write(f"[{timestamp}] {message}\n")
    print(f"Log zapisany: {message}")

def calculate_difference(frame, reference, mask):
    current_roi = cv2.bitwise_and(frame, frame, mask=mask)
    current_gray = cv2.cvtColor(current_roi, cv2.COLOR_BGR2GRAY)

    diff = cv2.absdiff(reference, current_gray)

    _, diff_thresh = cv2.threshold(diff, 50, 255, cv2.THRESH_BINARY)
    non_zero_count = cv2.countNonZero(diff_thresh)

    total_pixels = cv2.countNonZero(mask)
    if total_pixels == 0:
        return False

    difference_ratio = non_zero_count / total_pixels
    return difference_ratio > 0.6

def initialize_camera(cap, skip_frames=100):
    for _ in range(skip_frames):
        ret, _ = cap.read()
        if not ret:
            print("Nie można odczytać obrazu z kamery podczas inicjalizacji.")
            return False
    return True

def main():
    parking_spots = load_coordinates(COORDS_FILE)
    if not parking_spots:
        print("Brak współrzędnych miejsc parkingowych do wczytania.")
        return

    total_spots = len(parking_spots)
    log_event(f"Miejsca na parkingu: {total_spots}")

    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        print("Nie można otworzyć kamery.")
        return

    if not initialize_camera(cap):
        cap.release()
        return

    reference_frames = []
    masks = []
    spot_status = [False] * total_spots

    ret, frame = cap.read()
    if not ret:
        print("Nie można odczytać obrazu z kamery.")
        cap.release()
        return

    for spot in parking_spots:
        coordinates = spot["coordinates"]
        mask = np.zeros(frame.shape[:2], dtype=np.uint8)
        cv2.fillPoly(mask, [np.array(coordinates, dtype=np.int32)], 255)
        masks.append(mask)

        reference_roi = cv2.bitwise_and(frame, frame, mask=mask)
        reference_gray = cv2.cvtColor(reference_roi, cv2.COLOR_BGR2GRAY)
        reference_frames.append(reference_gray)

    free_spots = total_spots
    while True:
        ret, frame = cap.read()
        if not ret:
            print("Nie można odczytać obrazu z kamery.")
            break

        for index, spot in enumerate(parking_spots):
            coordinates = spot["coordinates"]
            spot_id = spot["id"]

            occupied = calculate_difference(frame, reference_frames[index], masks[index])

            if spot_status[index] != occupied:
                spot_status[index] = occupied
                if occupied:
                    free_spots -= 1
                    log_event(f"Miejsce {spot_id} zajete. Wolne miejsca: {free_spots}/{total_spots}")
                else:
                    free_spots += 1
                    log_event(f"Miejsce {spot_id} zwolnione. Wolne miejsca: {free_spots}/{total_spots}")

            color = (0, 0, 255) if occupied else (0, 255, 0)
            cv2.polylines(frame, [np.array(coordinates, dtype=np.int32)], isClosed=True, color=color, thickness=2)

            position = tuple(coordinates[0])
            cv2.putText(frame, spot_id, position, cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)

        cv2.imshow("Parking View", frame)

        if cv2.waitKey(1) == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()

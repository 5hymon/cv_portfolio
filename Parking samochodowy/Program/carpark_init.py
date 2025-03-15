import cv2
import json

COORDS_FILE = "parking_coords.json"
coordinates = []
current_points = []
spot_counter = 1


def click_event(event, x, y, flags, param):
    global coordinates, current_points, spot_counter

    if event == cv2.EVENT_LBUTTONDOWN:
        current_points.append((x, y))
        print(f"Punkt dodany: {x}, {y}")

        if len(current_points) == 4:
            spot_label = f"SPOT_{spot_counter}"

            formatted_points = [list(point) for point in current_points]

            coordinates.append({
                "id": spot_label,
                "coordinates": formatted_points
            })
            print(f"Zapisano miejsce: {spot_label} z punktami {formatted_points}")

            spot_counter += 1
            current_points.clear()


def main():
    global coordinates
    cap = cv2.VideoCapture(0)  # Kamera

    print("Kliknij cztery razy, aby zaznaczyć miejsce parkingowe. Naciśnij 's', aby zapisać i zakończyć.")

    while True:
        ret, frame = cap.read()
        if not ret:
            print("Nie można odczytać obrazu z kamery.")
            break

        cv2.imshow("Zaznacz miejsca parkingowe", frame)

        cv2.setMouseCallback("Zaznacz miejsca parkingowe", click_event)

        if cv2.waitKey(1) == ord('s'):
            print(f"Zawartość coordinates przed zapisem: {coordinates}")
            if coordinates:
                try:
                    with open(COORDS_FILE, "w") as file:
                        json.dump(coordinates, file, indent=4)
                    print(f"Współrzędne zapisane do {COORDS_FILE}.")
                except Exception as e:
                    print(f"Błąd podczas zapisywania pliku JSON: {e}")
            else:
                print("Nie zapisano żadnych danych - lista współrzędnych jest pusta.")
            break

    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()

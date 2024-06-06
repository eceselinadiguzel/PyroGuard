import math

def fetch_camera_details(camera_id, cur):
    cur.execute("SELECT camera_x, camera_y, height, angle, focal_length, azimuth FROM public.cameras WHERE cameraid = %s", (camera_id,))
    camera_details = cur.fetchone()
    return camera_details

def calculate_fire_location(camera_id, image_width, image_height, px, py, cur):
    # Fetch camera details from the database using the cursor passed to the function
    cam_x, cam_y, height, angle, focal_length, azimuth = fetch_camera_details(camera_id, cur)

    # Standard sensor size dimensions (in mm)
    sensor_width = 36.0
    sensor_height = 24.0

    # Convert angles from degrees to radians
    angle_rad = math.radians(angle)
    azimuth_rad = math.radians(azimuth)  # Convert azimuth to radians

    # Calculate the field of view in radians
    fov_horizontal = 2 * math.atan((sensor_width / 2) / focal_length)
    fov_vertical = 2 * math.atan((sensor_height / 2) / focal_length)

    # Calculate angle offsets based on the pixel location
    angle_x = ((px - image_width / 2) / (image_width / 2)) * (fov_horizontal / 2)
    angle_y = ((py - image_height / 2) / (image_height / 2)) * (fov_vertical / 2)

    # Calculate the total vertical angle considering the camera tilt
    total_vertical_angle = angle_rad - angle_y

    # Calculate the distance from the camera to the fire on the ground
    if math.tan(total_vertical_angle) == 0:
        return "Error: Tan of total vertical angle is zero, cannot divide by zero."
    distance = height / math.tan(total_vertical_angle)

    # Calculate the real-world coordinates considering the azimuth
    fire_x = float(cam_x) + distance * math.cos(azimuth_rad + angle_x)
    fire_y = float(cam_y) + distance * math.sin(azimuth_rad + angle_x)

    return fire_x, fire_y


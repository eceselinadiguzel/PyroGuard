import psycopg2
import torch
import send_notifications as notif
import calculate_image_vals as img
import fire_location as fl
import closest_extinguisher as ext

DATABASE = "postgres"
USER = "postgres"
PASSWORD = "doadbfc4"
HOST = "localhost"
PORT = "5433"
conn = psycopg2.connect(database=DATABASE, user=USER, password=PASSWORD, host=HOST, port=PORT)
cur = conn.cursor()

#log_fire_event(1, conn)

#the model detects fire on an image, how do we get that input?

#once fire is detected:

#activate alarm

#log event into database

#detect coordinates of fire and find closest fire extinguisher

#send notifications based on event and fire extinguisher, customize message
#sms and email

image_path = 'C:\\Users\\Ecem\\Desktop\\DSCF0602.jpg'

# Define camera settings
camera_id = 20
image_width, image_height = img.calculate_img_dimensions(image_path)

#delete when tensor vals are actually being pulled
deltlist = [
    torch.tensor(792.2404),  # x1
    torch.tensor(557.0296),  # y1
    torch.tensor(1141.4379), # x2
    torch.tensor(832.2931)   # y2
    ]

#needs to take the tensor list as input, how?
fire_x, fire_y = img.calculate_fire_point(deltlist)

# Calculate and print fire location
fire_location = fl.calculate_fire_location(camera_id, image_width, image_height, fire_x, fire_y, cur)

cur.execute("SELECT locationid FROM cameras WHERE cameraid = %s", (19,))
locationid = cur.fetchone()

closest_ext_id = ext.find_closest_fire_extinguisher(fire_location, locationid, cur)

#send notifications
notif.send_notification(locationid, camera_id, closest_ext_id, cur)

# Close the cursor and connection
cur.close()
conn.close()

import math

def find_closest_fire_extinguisher(fire_location, location_id, cur):

    fire_x,fire_y =fire_location

    query = """
    SELECT extinguisherid, extinguisher_x, extinguisher_y
    FROM extinguishers
    WHERE locationid = %s
    """
    cur.execute(query, (location_id,))
    extinguishers = cur.fetchall()

    if not extinguishers:
        return None

    min_distance = float('inf')
    closest_id = None

    for extinguisherid, x_pos, y_pos in extinguishers:

        x_pos = float(x_pos)
        y_pos = float(y_pos)

        distance = math.sqrt((fire_x - x_pos)**2 + (fire_y - y_pos)**2)
        if distance < min_distance:
            min_distance = distance
            closest_id = extinguisherid

    return closest_id

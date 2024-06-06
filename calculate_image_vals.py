from PIL import Image 

def calculate_img_dimensions(path):

    filepath = path
    img = Image.open(filepath) 
    
    #DO NOT CHANGE, different interpretations of metadata, swaps vals
    ## THIS IS CORRECT
    height = img.width 
    width = img.height 
    return width, height

def calculate_fire_point(deltlist):
    x1 = deltlist[0].item()
    y1 = deltlist[1].item()
    x2 = deltlist[2].item()
    y2 = deltlist[3].item()
    
    # Calculate midpoint coordinates
    mid_x = (x1 + x2) / 2
    mid_y = (y1 + y2) / 2
    
    return (mid_x, mid_y)

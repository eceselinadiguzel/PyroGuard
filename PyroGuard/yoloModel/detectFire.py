import argparse
import time
from pathlib import Path
import cv2
import numpy as np
import torch
import torch.backends.cudnn as cudnn
from PyQt5.QtGui import QImage, QPixmap
from numpy import random

from models.experimental import attempt_load
from utils2.datasets import LoadStreams, LoadImages
from utils2.general import check_img_size, check_requirements, check_imshow, non_max_suppression, apply_classifier, \
    scale_coords, xyxy2xywh, strip_optimizer, set_logging, increment_path
from utils2.plots import plot_one_box
from utils2.torch_utils import select_device, load_classifier, time_synchronized
import numpy

import torch
from ultralytics import YOLO
model = YOLO(r"C:\Users\MSI\Desktop\FireDetect\yoloModel\best.pt")

txt = ""


def detect(imgnew, save_img=False):

    imgnew2 = imgnew
    view_img = True
    results = model(imgnew2)
    detlist = []
    counter = 0
    counter2 = 0
    for i, det in enumerate(results[0].boxes.data):
        detlist = []
        if(numpy.array(det[4])>=0.4 and int(numpy.array(det[5]))==0): #fire0
            counter=counter+1
            for k in range(0, 4):
                detlist.append(det[k])
                print("")
        elif (numpy.array(det[4]) >= 0.4 and int(numpy.array(det[5])) == 2):  # smoke2
            counter2 = counter2 + 1
            for k in range(0, 4):
                detlist.append(det[k])
                print("")
        else:
            continue

        if(int(numpy.array(det[5])) == 2):
            plot_one_box(detlist, imgnew, color = (0, 128, 0), line_thickness=6)
        else:
            plot_one_box(detlist, imgnew, color=(255, 0, 0), line_thickness=6)

    if view_img:
        # font
        font = cv2.FONT_HERSHEY_TRIPLEX
        # org
        org = (25, 25)
        # fontScale
        fontScale = 1
        # Blue color in BGR
        color = (255, 0, 0)
        # Line thickness of 2 px
        thickness = 2
        if(counter>0):
            global txt
            txt = "Fire detected"
        else:
            txt = ""
        imgnew = cv2.putText(imgnew, txt,org, font,fontScale, color, thickness, cv2.LINE_AA)
    return imgnew


def main(img):
    im0 = detect(img)
    return im0
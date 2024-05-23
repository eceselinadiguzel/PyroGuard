# Standard library imports
import os
import sys
import datetime
import shutil
import glob
import random

# PyQt5 imports for UI
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtCore import QTimer, QDir, Qt, QUrl
from PyQt5.QtGui import QImage, QPixmap, QIcon
from PyQt5.QtWidgets import (QMainWindow, QWidget, QPushButton, QApplication,
                             QLabel, QFileDialog, QStyle, QVBoxLayout, QComboBox,
                             QButtonGroup, QInputDialog, QTableWidgetItem)

# Machine learning and image processing imports
import numpy
import cv2
import tensorflow as tf
from keras.models import load_model

# Custom GUI file import
from GUI import Ui_MainWindow

# Date manipulation
from dateutil.relativedelta import relativedelta

# Importing application modules and YOLO model for fire detection
from app_modules import *
current_directory = os.path.dirname(os.path.abspath(__file__))
model_path = os.path.join(current_directory, "yoloModel")
sys.path.append(model_path)
import detectFire

# Global variables for frame dimensions
x = 640
y = 480

x2 = 640
y2 = 480

fileName = ""
current_directory = os.path.dirname(os.path.abspath(__file__))
base_path = os.path.join(current_directory, "Save")

class MainWindow(QtWidgets.QMainWindow):
    def __init__(self, parent=None):
        super(MainWindow, self).__init__(parent=parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

        # Connecting buttons to their actions for navigating through stackedWidget pages
        self.ui.button_login_2.clicked.connect(lambda: self.ui.stackedWidget.setCurrentWidget(self.ui.signup))
        self.ui.button_home.clicked.connect(lambda: self.ui.stackedWidget.setCurrentWidget(self.ui.home))
        self.ui.button_logout.clicked.connect(lambda: self.ui.stackedWidget.setCurrentWidget(self.ui.login))
        self.ui.button_settings.clicked.connect(lambda: self.ui.stackedWidget.setCurrentWidget(self.ui.settings))

        # Setup timers for camera and video feed processing
        self.capVideo = ""
        self.timer = QTimer()
        self.timer.timeout.connect(self.viewCam)
        self.timer2 = QTimer()
        self.timer2.timeout.connect(self.viewVideo)
        self.ui.button_cam.clicked.connect(self.controlTimerCam)
        self.ui.button_video.clicked.connect(self.controlTimerVideo)

        # Automatically delete old data
        self.auto_delete_old_data()

        # Setup for moving the window around
        def moveWindow(event):
            if UIFunctions.returStatus() == 1:
                UIFunctions.maximize_restore(self)
            if event.buttons() == Qt.LeftButton:
                self.move(self.pos() + event.globalPos() - self.dragPos)
                self.dragPos = event.globalPos()
                event.accept()

        self.ui.frame_top_right.mouseMoveEvent = moveWindow

        # Load the UI definitions
        UIFunctions.uiDefinitions(self)

        # Display the main window
        self.show()

    def mousePressEvent(self, event):
        self.dragPos = event.globalPos()

    def openFile(self):
        global fileName
        global rCost
        current_directory = os.getcwd()
        test_img_directory = os.path.join(current_directory, 'TestVideo')
        fileName, _ = QFileDialog.getOpenFileName(
            None,
            "Open Image",
            test_img_directory,
        )

        if fileName:
            return fileName
        else:
            return None

    def create_directory_for_frames(self, base_path, detection_status):
        """Creates a directory based on the detection status; separate for normal and fire detected frames."""
        date_str = datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        directory_path = os.path.join(base_path, f"PyroGuard-{date_str}", "FireDetected" if detection_status == "Fire detected" else "Normal")
        if not os.path.exists(directory_path):
            os.makedirs(directory_path)
        return directory_path

    def save_frame(self, frame_path, frame):
        """Saves a frame to the specified path."""
        cv2.imwrite(frame_path, frame)

    def auto_delete_old_data(self):
        """Automatically deletes data older than a specified duration."""
        current_directory = os.path.dirname(os.path.abspath(__file__))
        base_directory = os.path.join(current_directory, "Save")
        duration_type = 'days' # or months
        duration_value = 1
        self.delete_old_data(base_directory, duration_type, duration_value)

    def delete_old_data(self, base_directory, duration_type, duration_value):
        """Deletes directories older than the given duration from the specified base directory."""
        cutoff_date = datetime.datetime.now() - (datetime.timedelta(days=duration_value) if duration_type == 'days' else relativedelta(months=duration_value))
        for dir_name in os.listdir(base_directory):
            dir_path = os.path.join(base_directory, dir_name)
            if os.path.isdir(dir_path):
                try:
                    dir_date = datetime.datetime.strptime('-'.join(dir_name.split('-')[1:]), "%Y-%m-%d-%H-%M-%S")
                    if dir_date < cutoff_date:
                        shutil.rmtree(dir_path)
                        print(f"Deleted {dir_path}")
                except ValueError:
                    print(f"Could not process directory: {dir_name}")

    def viewCam(self):
        # Processing and displaying camera frames with potential fire detection
        current_directory = os.path.dirname(os.path.abspath(__file__))
        img_path = os.path.join(current_directory, "TestImg/testimg2.jpg")
        img = cv2.imread(img_path)
        img = detectFire.main(img)
        detection_status = detectFire.txt

        if detection_status == "Fire detected" and not hasattr(self, 'fire_detected_directory'):
            self.fire_detected_directory = self.create_directory_for_frames(base_path, "Fire detected")
        if detection_status != "Fire detected" and not hasattr(self, 'normal_directory'):
            self.normal_directory = self.create_directory_for_frames(base_path, "Normal")

        resized_img = cv2.resize(img, (640, 480))
        qImg = QImage(resized_img.data, resized_img.shape[1], resized_img.shape[0], resized_img.shape[1] * resized_img.shape[2], QImage.Format_BGR888)
        self.ui.label_panel.setPixmap(QPixmap.fromImage(qImg))

        frame_directory = self.fire_detected_directory if detection_status == "Fire detected" else self.normal_directory
        frame_filename = f"{datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S-%f')}.jpg"
        self.save_frame(os.path.join(frame_directory, frame_filename), resized_img)

    def viewVideo(self):
        # Similar to viewCam, but processing video frames
        ret, frame = self.capVideo.read()
        if ret:
            img = detectFire.main(frame)
            detection_status = detectFire.txt

            if detection_status == "Fire detected" and not hasattr(self, 'fire_detected_directory'):
                self.fire_detected_directory = self.create_directory_for_frames(base_path, "Fire detected")
            if detection_status != "Fire detected" and not hasattr(self, 'normal_directory'):
                self.normal_directory = self.create_directory_for_frames(base_path, "Normal")

            resized_img = cv2.resize(img, (640, 480))
            qImg = QImage(resized_img.data, resized_img.shape[1], resized_img.shape[0], resized_img.shape[1] * resized_img.shape[2], QImage.Format_BGR888)
            self.ui.label_panel.setPixmap(QPixmap.fromImage(qImg))

            frame_directory = self.fire_detected_directory if detection_status == "Fire detected" else self.normal_directory
            frame_filename = f"{datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S-%f')}.jpg"
            self.save_frame(os.path.join(frame_directory, frame_filename), resized_img)

    def controlTimerCam(self):
        # Control camera timer for refreshing the view
        self.ui.stackedWidget.setCurrentWidget(self.ui.cameraPanel)
        if not self.timer.isActive():
            if self.timer2.isActive():
                self.timer2.stop()
            self.timer.start(20)
        else:
            self.timer.stop()
            self.cap.release()

    def controlTimerVideo(self):
        # Control video timer for refreshing the view
        self.ui.stackedWidget.setCurrentWidget(self.ui.cameraPanel)
        if not self.timer2.isActive():
            if self.timer.isActive():
                self.timer.stop()
            fileName = self.openFile()
            self.capVideo = cv2.VideoCapture(fileName)
            self.timer2.start(20)
        else:
            self.timer2.stop()
            self.capVideo.release()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec_())

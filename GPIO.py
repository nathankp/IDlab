#!/usr/bin/env python 


import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
channels = [35,33,31,29,23,21,19,15,13,11,7,8,10]
GPIO.setup(channels,GPIO.IN,pull_up_down=GPIO.PUD_DOWN)
#GPIO.setup(5,GPIO.IN,pull_up_down=GPIO.PUD_DOWN)
#GPIO.setup(3,GPIO.IN,pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(37,GPIO.OUT)
GO =  GPIO.output(37,1)
time.sleep(3)
GO = GPIO.output(37,0)
time.sleep(0.001)
GPIO.output(37,1)
print GPIO.input(35),GPIO.input(33), GPIO.input(31), GPIO.input(29), GPIO.input(23), GPIO.input(21), GPIO.input(19), GPIO.input(15), GPIO.input(13), GPIO.input(11), GPIO.input(7), GPIO.input(8), GPIO.input(10)




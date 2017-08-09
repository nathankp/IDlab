#!/usr/bin/env python 


import RPi.GPIO as GPIO
import time
import csv
import math
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
channels = [35,33,31,29,23,15,13,11,32,36,38,40,26]
GPIO.setup(channels,GPIO.IN,pull_up_down=GPIO.PUD_DOWN)
trial = input('enter trial: ')
true = 1
with open('TSrun_%s.csv' %trial,'w') as testfile:
    writer = csv.writer(testfile,delimiter=' ',) 
    while true:
        GPIO.setup(37,GPIO.OUT)
	time.sleep(2)
        GPIO.output(37,0)
        time.sleep(0.0001)
        GPIO.output(37,1)
        sign = GPIO.input(23)
        sign_str = str(sign)
        upper_str = str(GPIO.input(35)) + str(GPIO.input(33)) + str(GPIO.input(31)) + str(GPIO.input(29))
        lower_str = str(GPIO.input(15)) + str(GPIO.input(13)) + str(GPIO.input(11)) + str(GPIO.input(32)) + str(GPIO.input(26)) + str(GPIO.input(40)) + str(GPIO.input(38)) + str(GPIO.input(36)) 
        print sign,' ', upper_str,' ',lower_str
        if (sign<1):
            temperature = int(upper_str,2)*16 + int(lower_str,2)*0.0625
        else:
            temperature = int(upper_str,2)*16 + int(lower_str,2)*0.625 - 256

        temp_str = str(temperature)
        writer.writerow((temp_str,sign_str,upper_str,lower_str))     
 # print GPIO.input(35),GPIO.input(33), GPIO.input(31), GPIO.input(29), GPIO.input(23), GPIO.input(21), GPIO.input(19), GPIO.input(15), GPIO.input(13), GPIO.input(11), GPIO.input(7), GPIO.input(8), GPIO.input(10)
    



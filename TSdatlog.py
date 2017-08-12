#!/usr/bin/env python 
# this program was used to log temperature data from the sensor. It reads the GPIO pins from the EVAL Board. It sends the GO signal 
#to the FPGA via MON #15. 

import RPi.GPIO as GPIO
import time
import csv
import math
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
channels = [35,33,31,29,23,21,19,15,13,8,10,12,18]
GPIO.setup(channels,GPIO.IN,pull_up_down=GPIO.PUD_DOWN)
trial = input('enter trial: ')
true = 1
with open('TSrun_%s.csv' %trial,'w') as testfile:
    writer = csv.writer(testfile) 
    while true:
        GPIO.setup(37,GPIO.OUT)
        GPIO.output(37,1)
        time.sleep(1)
        GPIO.output(37,0)
        time.sleep(0.001)
        GPIO.output(37,1)
        sign = GPIO.input(13)
        upper_str = str(GPIO.input(35)) + str(GPIO.input(33)) + str(GPIO.input(31)) + str(GPIO.input(29))
        lower_str = str(GPIO.input(23)) + str(GPIO.input(21)) + str(GPIO.input(19)) + str(GPIO.input(15)) + str(GPIO.input(18)) + str(GPIO.input(12)) + str(GPIO.input(10)) + str(GPIO.input(8)) 
        print upper_str,' ',lower_str
        if (sign<1):
            temperature = int(upper_str,2)*16 + int(lower_str,2)*0.0625
        else:
            temperature = int(upper_str,2)*16 + int(lower_str,2)*0.625 - 256
       
        temp_list = [temperature]
        writer.writerow(temp_list)     
 # print GPIO.input(35),GPIO.input(33), GPIO.input(31), GPIO.input(29), GPIO.input(23), GPIO.input(21), GPIO.input(19), GPIO.input(15), GPIO.input(13), GPIO.input(11), GPIO.input(7), GPIO.input(8), GPIO.input(10)
    



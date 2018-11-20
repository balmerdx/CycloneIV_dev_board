#!/usr/bin/env python3

import time
import serial
import sys
import struct

ser = None

def connect():
	global ser
	ser = serial.Serial(
		port='/dev/ttyUSB0',
		baudrate=115200,
		parity=serial.PARITY_NONE,
		stopbits=serial.STOPBITS_ONE,
		bytesize=serial.EIGHTBITS,
		timeout = 0.2
	)

	return ser.isOpen()

def close():
	ser.close()


if __name__ == "__main__":
	if not connect():
		print("Cannot connect to serial port")
		exit(1)


	for x in range(5):
		ser.write([0b1111])
		time.sleep(0.5)
		ser.write([0b0000])
		time.sleep(0.5)

	for x in range(5):
		ser.write([0b1001])
		time.sleep(0.5)
		ser.write([0b0110])
		time.sleep(0.5)

	#ser.write([0x80]) #use time counter to blink leds
	ser.write([0x0]) #all led off
	pass

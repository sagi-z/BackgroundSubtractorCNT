#!/usr/bin/python

import sys
import getopt
import cv2
import bgsubcnt
import numpy as np

 # A temporary solution to OpenCV 3.1.0 bug
cv2.ocl.setUseOpenCL(False)

def usage():
    print ("""BackgroundSubtractorCNT demo/benchmark/comparison
Usage: demo.py [params] 

	-h, --help
		print this message
        --bg    
		calculate also the background
	--file
		use file (default is system camera)
	--nogui 
		run without GUI to measure times
	--type (default:CNT)
		bg subtraction type from - CNT/MOG2/KNN
""")

def getBGSubtractor(typeStr):
    if typeStr == "KNN":
        return cv2.createBackgroundSubtractorKNN()
    if typeStr == "MOG2":
        return cv2.createBackgroundSubtractorMOG2()
    if typeStr == "CNT":
        return bgsubcnt.createBackgroundSubtractor()
    print ("Unknown createBackgroundSubtractor type")
    sys.exit(1)

def main(argv):
    filePath = None
    hasGui = True
    bgImage = False
    typeStr = "CNT"

    try:
        opts, args = getopt.getopt(argv, "h", ["help", "bg", "file=", "nogui", "type="])
    except getopt.GetoptError:
        usage()
        sys.exit(1)

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt == "--file":
            filePath = arg
        elif opt == "--bg":
            bgImage = True
        elif opt == "--nogui":
            hasGui = False
        elif opt == "--type":
            typeStr = arg

    if (filePath):
        cap = cv2.VideoCapture(filePath)
    else:
        cap = cv2.VideoCapture()

    if cap.isOpened() == False:
        print ("Could not initialize capturing...");
        sys.exit(2)

    fgbg = getBGSubtractor(typeStr)

    e1 = cv2.getTickCount()

    ret, frame = cap.read()
    while(ret):
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        fg = fgbg.apply(gray)
        if hasGui:
            cv2.imshow('Orig',frame)
            cv2.imshow('FG',fg)
            if bgImage:
                bg = fgbg.getBackgroundImage()
                cv2.imshow('BG',bg)
            k = cv2.waitKey(1)
            if k == 27:
                break
        ret, frame = cap.read()

    e2 = cv2.getTickCount()

    t = (e2 - e1)/cv2.getTickFrequency()
    print ("Execution took '%(val).3f' seconds." % {'val': t});

    cap.release()
    if hasGui:
        cv2.destroyAllWindows()

if __name__ == "__main__":
    main(sys.argv[1:])

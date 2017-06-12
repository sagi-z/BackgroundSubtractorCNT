---
layout: page
title: About
permalink: /about/
---

A Counting BackgroundSubtractor (CNT stands for 'CouNT)
=======================================================

* BackgroundSubtractorCNT is a drop in replacement API for the background subtraction solutions supplied with OpenCV 3.1.0 and above.
* It is much **faster** than any other background subtraction solutions in OpenCV (without NVidia CUDA) on low spec hardware.
* It has both a C++ API and a python API.
* A drop in replacement means you simply change a single line of your code to get this amazing speed improvement.

How much faster is it?
=====================
Here is an output of benchmarking on Raspberry Pi3 both *MOG2* and *CNT* BackgroundSubtractors:
```
pi@pilab2:~/tmp/mnt/build_pi3 $ ./demo -file=/home/pi/tmp/mnt2/samples/data/768x576.avi -nogui -type="MOG2"
Execution took 40.964450 seconds.
pi@pilab2:~/tmp/mnt/build_pi3 $ ./demo -file=/home/pi/tmp/mnt2/samples/data/768x576.avi -nogui -type="CNT"
Execution took 17.633301 seconds.
```
[For more details see this blog post](https://www.theimpossiblecode.com/blog/fastest-background-subtraction-opencv "the impossible code")




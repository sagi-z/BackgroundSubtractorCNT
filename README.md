# The BackgroundSubtractorCNT project (CNT stands for 'CouNT).

* BackgroundSubtractorCNT is a drop in replacement API for the background subtraction solutions supplied with OpenCV.
* It is much **faster** than any other background subtraction solutions in OpenCV-3.1.0 without NVidia CUDA, on low spec hardware.

[For more details see (pending post)](https://www.theimpossiblecode.com/blog/upcoming-posts "the impossible code")

## How much faster is it?
[See output of benchmarking on Raspberry Pi3](### Using the demo)

## Building / Installing
### Prepare to build
```
git clone https://github.com/sagi-z/BackgroundSubtractorCNT.git
cd BackgroundSubtractorCNT
mkdir build
cd build
```

### By default cmake is building for release, static lib, without the demo
```
cmake ..
make
```

### Here is how to alter the defaults
```
cmake -DBUILD_TEST=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=DEBUG ..
make
```

### Install simplest option 1 (Win/Linux/Mac):
copy/move the bgsubcnt.cpp to your sources and bgsubcnt.hpp to your headers.

### Install option 1 for Linux (from the build directory):
```
sudo make install
```

### Install option 2 for Linux - cleaner (from the build directory):
```
cpack -G DEB
sudo dpkg -i ./bgsubcnt-1.0.0-Linux.deb
```

### Windows
Assuming you know how to use cmake with OpenCV - use it (you can even build the package target if you installed 'NSIS')

## Usage

### Linux
Assuming installation in '/usr/local', add to cflags '-I/usr/local/include' and to link flags '-L/usr/local/lib -lbgsubcnt'

### Windows
make sure the include path and link path and library are set correctly.

### Drop in replacement code example:
```C++
// Example from main.cpp, which is built if you supply -DBUILD_TEST=ON to cmake
#include <opencv2/opencv.hpp>
#include "bgsubcnt.h"
...

    string type = parser.get<string>("type"); // get the BackgroundSubtractor type somehow

    cv::Ptr<cv::BackgroundSubtractor> pBgSub; // THE SAME BASE CLASS

    if (type == "CNT")
    {
        int fps = 30;
        if (hasFile)
        {
            fps = capture.get(CAP_PROP_FPS);
        }
        pBgSub = cv::createBackgroundSubtractorCNT(fps, true, fps*60);
    }
    else if (type == "MOG2")
    {
        cv::Ptr<cv::BackgroundSubtractorMOG2> pBgSubMOG2 = cv::createBackgroundSubtractorMOG2();
        pBgSubMOG2->setDetectShadows(false);
        pBgSub = pBgSubMOG2;
    }

...

    // THIS CODE DOESN'T CHANGE
    for(;;)
    {
        cv::Mat frame;
        cap >> frame;
        if( frame.empty() )
        {
            break;
        }
        cv::Mat gray;
        cv::cvtColor(frame, gray, cv::COLOR_BGR2GRAY);

        cv::Mat fgMask;
        pBgSub->apply(gray, fgMask);
...
    }
```

### Using the demo (from the 'build' directory)
* help message
```
pi@pilab2:~/tmp/mnt/build_pi3 $ ./demo -h
BackgroundSubtractorCNT demo/benchmark/comparison
Usage: demo [params] 

	-?, -h, --help, --usage (value:true)
		print this message
	--bg
		calculate also the background
	--file
		use file (default is system camera)
	--nogui
		run without GUI to measure times
	--type (value:CNT)
		bg subtraction type from - CNT/MOG2/KNN
```

* For benchmarking, use '-nogui', this was executed on Raspberry Pi3:
```
pi@pilab2:~/tmp/mnt/build_pi3 $ ./demo -file=/home/pi/tmp/mnt2/samples/data/768x576.avi -nogui -type="MOG2"
Execution took 40.964450 seconds.
pi@pilab2:~/tmp/mnt/build_pi3 $ ./demo -file=/home/pi/tmp/mnt2/samples/data/768x576.avi -nogui -type="CNT"
Execution took 17.633301 seconds.
```

* For seeing the 'fg' quality use these:
```
./demo -file=/home/pi/tmp/mnt2/samples/data/768x576.avi -type="CNT"
```

* For seeing the 'fg' and 'bg' quality use these:
```
./demo -file=/home/pi/tmp/mnt2/samples/data/768x576.avi -type="CNT" -bg
```


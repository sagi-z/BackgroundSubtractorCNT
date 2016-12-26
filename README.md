The BackgroundSubtractorCNT project (CNT stands for 'CouNT)
===========================================================

* BackgroundSubtractorCNT is a drop in replacement API for the background subtraction solutions supplied with OpenCV 3.1.0.
* It is much **faster** than any other background subtraction solutions in OpenCV-3.1.0 without NVidia CUDA, on low spec hardware.

[For more details see my blog](https://www.theimpossiblecode.com/blog/fastest-background-subtraction-opencv "the impossible code")

How much faster is it?
----------------------
Here is an output of benchmarking on Raspberry Pi3 both *MOG2* and *CNT* BackgroundSubtractors:
```
pi@pilab2:~/tmp/mnt/build_pi3 $ ./demo -file=/home/pi/tmp/mnt2/samples/data/768x576.avi -nogui -type="MOG2"
Execution took 40.964450 seconds.
pi@pilab2:~/tmp/mnt/build_pi3 $ ./demo -file=/home/pi/tmp/mnt2/samples/data/768x576.avi -nogui -type="CNT"
Execution took 17.633301 seconds.
```

## Linux build and install

[Follow a video session for building C++ and python on Pi](https://www.youtube.com/watch?v=-FaVL1Otwds "BackgroundSubtractorCNT with python on Pi")

### Build dependencies
Make sure these are installed first and that their executables are **in your path**:
* **cmake** - should already be installed since you built OpenCV by yourself.
* **git** (optional) - you can also download the sources from GitHub.
* **swig** (optional) - needed for building the python extension.

### Prepare to build
```
git clone https://github.com/sagi-z/BackgroundSubtractorCNT.git
cd BackgroundSubtractorCNT
mkdir build
cd build
```

### By default cmake is building for release, static lib, without the C++ demo and without the python extension
```
cmake ..
make
```

### Here is how to alter the defaults
```
cmake -DBUILD_TEST=ON -DBUILD_SHARED_LIBS=ON -DPYTHON_EXTENSION=ON -DCMAKE_BUILD_TYPE=DEBUG ..
make
```
(note that these are now the new defaults until you delete the *build/CMakeCache.txt* file)

### C++ Install simplest option 1 (Win/Linux/Mac):
copy/move the bgsubcnt.cpp to your sources and bgsubcnt.h to your headers.

### C++/Python Install option 1 for Linux (from the build directory):
```
sudo make install
```

### C++/Python Install option 2 for Linux - cleaner (from the build directory):
```
cpack -G DEB
sudo dpkg -i ./bgsubcnt-1.1.0-Linux.deb
```

## Windows build and install

[Follow a video session for building C++ and python on windows](https://www.youtube.com/watch?v=JaXWv340Bbw "BackgroundSubtractorCNT with python on windows")

### Build dependencies
Make sure these are installed first and that their executables are **in your path**:
* **cmake** - should already be installed if you built OpenCV by yourself (configure *OPENCV\_DIR* as required for build using OpenCV with cmake).
* **Visual Studio** - a C++ compiler - I'm using *Visual Studio 2015*.
* **git** (optional) - you can also download the sources from GitHub.
* **swig** (optional) - needed for building the python extension.
* **NSIS** (optional) - if you want to build a package installer.
* **Python** (optional) - if you want to build the python extension.
* **Python compiler for your python version** (optional) - needed for building the python extension (i.e. for python2.7 you need to install *Microsoft Visual C++ 2008 Express Edition*).

### Building

* This should be done from a **"Developer Command Prompt for VS2015"** (Open it from the *Start* menu):
```
REM check dependencies are in path/exist
REM ====================================
cd c:\users\sagiz
where git
where swig
where cmake
echo %OPENCV_DIR%
where msbuild
where python
dir "c:\Program Files (x86)\NSIS\NSIS.exe"

REM get the sources
REM ===============
cd c:\users\sagiz
git clone https://github.com/sagi-z/BackgroundSubtractorCNT.git
cd BackgroundSubtractorCNT
mkdir build
cd build

REM configure the build
REM ===================
cmake -G "Visual Studio 14 2015 Win64" -DBUILD_TEST=ON -DPYTHON_EXTENSION=ON ..

REM build the sources
REM =================
msbuild ALL_BUILD.vcxproj /p:Configuration=Release

REM build the installer
REM ===================
msbuild PACKAGE.vcxproj

REM run the installer
REM =================
.\bgsubcnt-1.1.0-win64.exe

REM check if we can load the module
REM ===============================
set PYTHONPATH=C:\Program Files\bgsubcnt 1.1.0\lib\site-packages
cd ..
python -c "import cv2, bgsubcnt; fgbg = bgsubcnt.createBackgroundSubtractor(); print fgbg"

```

* Here is an example command line session in a **"Developer Command Prompt for VS2015"** with outputs:
```
REM check dependencies are in path/exist
REM ====================================
c:\Users\sagiz>where git
C:\Program Files\Git\cmd\git.exe

c:\Users\sagiz>where swig
C:\swigwin-3.0.10\swig.exe

c:\Users\sagiz>where cmake
C:\Program Files\CMake\bin\cmake.exe

c:\Users\sagiz>echo %OPENCV_DIR%
C:\opencv-3.1.0\build

c:\Users\sagiz>dir %OPENCV_DIR%
 Volume in drive C has no label.
 Volume Serial Number is 6431-83A8

 Directory of C:\opencv-3.1.0\build

12/24/2016  05:08 PM    <DIR>          .
12/24/2016  05:08 PM    <DIR>          ..
12/18/2015  05:15 PM    <DIR>          bin
12/18/2015  05:15 PM    <DIR>          etc
12/18/2015  05:15 PM    <DIR>          include
12/18/2015  05:13 PM    <DIR>          java
12/18/2015  03:16 PM             2,224 LICENSE
12/18/2015  05:10 PM               433 OpenCVConfig-version.cmake
12/18/2015  03:16 PM             6,916 OpenCVConfig.cmake
12/18/2015  05:15 PM    <DIR>          python
12/24/2016  05:07 PM    <DIR>          x64
               3 File(s)          9,573 bytes
               8 Dir(s)  14,000,812,032 bytes free

c:\Users\sagiz>where msbuild
C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe
C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe

c:\Users\sagiz>where python
C:\Python27\python.exe

c:\Users\sagiz>dir "c:\Program Files (x86)\NSIS\NSIS.exe"
 Volume in drive C has no label.
 Volume Serial Number is 6431-83A8

 Directory of c:\Program Files (x86)\NSIS

12/11/2016  11:50 PM         1,026,048 NSIS.exe
               1 File(s)      1,026,048 bytes
               0 Dir(s)  14,001,606,656 bytes free

REM get the sources
REM ===============
c:\Users\sagiz>git clone https://github.com/sagi-z/BackgroundSubtractorCNT.git
Cloning into 'BackgroundSubtractorCNT'...
… (didn’t copy-paste all the output lines)...

c:\Users\sagiz>cd BackgroundSubtractorCNT

c:\Users\sagiz\BackgroundSubtractorCNT>mkdir build

c:\Users\sagiz\BackgroundSubtractorCNT>cd build


REM configure the build
REM ===================
c:\Users\sagiz\BackgroundSubtractorCNT\build>cmake -G "Visual Studio 14 2015 Win64" -DBUILD_TEST=ON -DPYTHON_EXTENSION=ON ..
… (didn’t copy-paste all the output lines). ..
-- Configuring done
-- Generating done
-- Build files have been written to: C:/Users/sagiz/BackgroundSubtractorCNT/build

REM build the sources
REM =================
c:\Users\sagiz\BackgroundSubtractorCNT\build>msbuild ALL_BUILD.vcxproj /p:Configuration=Release
… (didn’t copy-paste all the output lines). ..
    0 Error(s)

Time Elapsed 00:00:08.51

REM build the installer
REM ===================
c:\Users\sagiz\BackgroundSubtractorCNT\build>msbuild PACKAGE.vcxproj
… (didn’t copy-paste all the output lines). ..
Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:00:13.33

REM run the installer
REM =================
c:\Users\sagiz\BackgroundSubtractorCNT\build>.\bgsubcnt-1.1.0-win64.exe

REM check if we can load the module
REM ===============================
c:\Users\sagiz\BackgroundSubtractorCNT\build>set PYTHONPATH=C:\Program Files\bgsubcnt 1.1.0\lib\site-packages

c:\Users\sagiz\BackgroundSubtractorCNT\build>cd ..

c:\Users\sagiz\BackgroundSubtractorCNT>python -c "import cv2, bgsubcnt; fgbg = bgsubcnt.createBackgroundSubtractor(); print fgbg"
<Swig Object of type 'BackgroundSubtractorCNT *' at 0x0000000003891110>

```

### Install
Update/add the environment variable PYTHONPATH to point to where the python extension was installed (in the example above it was added to C:\Program Files\bgsubcnt 1.1.0\lib\site-packages).
In the *File Explorer*, right-click on *This PC* and coose *properties*. Then choose *Advanced system settings* and press the "Environment Variables ..." button.

C++ Usage
---------

### Linux
Assuming installation in '/usr/local', add to cflags '-I/usr/local/include' and to link flags '-L/usr/local/lib -lbgsubcnt'

Here is a minimal *CMakeLists.txt* example:
```
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(myapp)

FIND_PACKAGE(OpenCV 3.1.0 REQUIRED)

INCLUDE_DIRECTORIES(${OpenCV_INCLUDE_DIRS} "/usr/local/include")

ADD_EXECUTABLE(myapp main.cpp)

FIND_LIBRARY(BGSUBCNT_LIB bgsubcnt "/usr/local/lib")
TARGET_LINK_LIBRARIES (myapp ${BGSUBCNT_LIB} ${OpenCV_LIBS})
```

### Windows
make sure the include path and link path and library are set correctly.

### C++ drop in replacement code example:
```C++
// Example from main.cpp, which is built if you supply -DBUILD_TEST=ON to cmake
#include <opencv2/opencv.hpp>
#include "bgsubcnt.h"
...

    string type = parser.get<string>("type"); // get the BackgroundSubtractor type somehow

    cv::Ptr<cv::BackgroundSubtractor> pBgSub; // THE SAME BASE CLASS

    if (type == "CNT")
    {
        int fps = 15;
        if (hasFile)
        {
            fps = capture.get(CAP_PROP_FPS);
        }
        pBgSub = cv::bgsubcnt::createBackgroundSubtractorCNT(fps, true, fps*60);
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

Python Usage
------------
```python
import bgsubcnt                               # 1. New import
fgbg = bgsubcnt.createBackgroundSubtractor()  # 2. New background subtractor
```

### Python drop in replacement code example:
```python
import numpy as np
import cv2
import bgsubcnt                               # 1. New import

# A temporary solution to OpenCV 3.1.0 bug
#  with background subtractors
cv2.ocl.setUseOpenCL(False)

cap = cv2.VideoCapture('/home/userName/Downloads/opencv-3.1.0/samples/data/768x576.avi')

#fgbg = cv2.createBackgroundSubtractorMOG2()
fgbg = bgsubcnt.createBackgroundSubtractor()  # 2. New background subtractor

while(1):
    ret, frame = cap.read()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    fgmask = fgbg.apply(gray)

    cv2.imshow('frame',fgmask)
    k = cv2.waitKey(30)
    if k == 27:
        break

cap.release()
cv2.destroyAllWindows()
```

### Using the C++ demo (from the 'build' directory)
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

### Using the python demo (from the 'python' directory)
* help message
```
pi@pilab2:~/BackgroundSubtractorCNT $ python python/demo.py -h
BackgroundSubtractorCNT demo/benchmark/comparison
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
```

* For benchmarking, use '--nogui', this was executed on Raspberry Pi3:
```
pi@pilab2:~/BackgroundSubtractorCNT $ python python/demo.py --file=/home/pi/tmp/mnt2/samples/data/768x576.avi --nogui --type="MOG2"
Execution took 40.964450 seconds.
pi@pilab2:~/BackgroundSubtractorCNT $ python python/demo --file=/home/pi/tmp/mnt2/samples/data/768x576.avi --nogui --type="CNT"
Execution took 17.633301 seconds.
```

* For seeing the 'fg' quality use these:
```
python demo.py --file=/home/pi/tmp/mnt2/samples/data/768x576.avi --type="CNT"
```

* For seeing the 'fg' and 'bg' quality use these:
```
python demo.py --file=/home/pi/tmp/mnt2/samples/data/768x576.avi --type="CNT" --bg
```


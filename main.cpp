#include <opencv2/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <iostream>

#ifdef HAVE_OPENCV_CONTRIB
#include <opencv2/bgsegm.hpp>
#endif

#include "bgsubcnt.h"

using namespace cv;
using namespace std;

const string keys =
        "{help h usage ? || print this message}"
        "{file           || use file (default is system camera)}"
        "{type           |CNT| bg subtraction type from - CNT/MOG2/KNN"
#ifdef HAVE_OPENCV_CONTRIB
        "GMG/MOG"
#endif
        "}"
        "{bg             || calculate also the background}"
        "{nogui          || run without GUI to measure times}";


int main( int argc, char** argv )
{
    VideoCapture cap;

    CommandLineParser parser(argc, argv, keys);
    parser.about("BackgroundSubtractorCNT demo/benchmark/comparison");
    if (parser.has("help"))
    {
        parser.printMessage();
        return 0;
    }
    bool hasFile = parser.has("file");
    bool hasGui = ! parser.has("nogui");
    bool bgImage = parser.has("bg");
    string type = parser.get<string>("type");

    string filePath;
    if (hasFile)
    {
        filePath = parser.get<string>("file");
        if (filePath == "true")
        {
            cout << "You must supply a file path argument with -file=filePath\n";
            return 1;
        }
        cap.open(filePath);
    }
    else
    {
        cap.open(0);
    }
    if (! parser.check())
    {
        parser.printErrors();
        return 1;
    }

    if( !cap.isOpened() )
    {
        cout << "Could not initialize capturing...\n";
        return 0;
    }

    Ptr<BackgroundSubtractor> pBgSub;
    if (type == "CNT")
    {
        int fps = 30;
        if (hasFile)
        {
            fps = cap.get(CAP_PROP_FPS);
        }
        pBgSub = createBackgroundSubtractorCNT(fps, true, fps*60);
    }
    else if (type == "MOG2")
    {
        Ptr<BackgroundSubtractorMOG2> pBgSubMOG2 = createBackgroundSubtractorMOG2();
        pBgSubMOG2->setDetectShadows(false);
        pBgSub = pBgSubMOG2;
    }
    else if (type == "KNN")
    {
        pBgSub = createBackgroundSubtractorKNN();
    }
#ifdef HAVE_OPENCV_CONTRIB
    else if (type == "GMG")
    {
        pBgSub = cv::bgsegm::createBackgroundSubtractorGMG();
    }
    else if (type == "MOG")
    {
        pBgSub = cv::bgsegm::createBackgroundSubtractorMOG();
    }
#endif
    else
    {
        parser.printMessage();
        cout << "\nWrong type - please see above\n";
        return 1;
    }

    bool showFG=true;
    if (hasGui)
    {
        namedWindow("Orig", 1);
        namedWindow("FG", 1);
        if (bgImage)
        {
            namedWindow("BG", 1);
        }
    }
    double startTime = getTickCount();
    for(;;)
    {
        Mat frame;
        cap >> frame;
        if( frame.empty() )
        {
            break;
        }
        Mat gray;
        cvtColor(frame, gray, COLOR_BGR2GRAY);

        Mat fgMask;
        pBgSub->apply(gray, fgMask);
        if (hasGui)
        {
            imshow("Orig", frame);
            if (showFG)
            {
                Mat fg;
                frame.copyTo(fg, fgMask);
                imshow("FG", fg);
            }
        }

        if (bgImage)
        {
            Mat bg;
            pBgSub->getBackgroundImage(bg);
            if (hasGui)
            {
                imshow("BG", bg);
            }
        }

        if (hasGui)
        {
            char c = (char)waitKey(1);
            if (c == 27)
            {
                break;
            }
        }
    }
    double tfreq = getTickFrequency();
    double secs = ((double) getTickCount() - startTime)/tfreq;
    cout << "Execution took " << fixed << secs << " seconds." << endl;
}

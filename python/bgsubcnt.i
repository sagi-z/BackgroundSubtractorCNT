%module bgsubcnt

%{
#define SWIG_FILE_WITH_INIT
#include "bgsubcnt.h"
#include "opencv_swig_python.h"
using namespace cv;
using namespace cv::bgsubcnt;
%}

/*  need this for correct module initialization */
%init %{
    initOpenCVSwig();
%}

/* Convert from Python --> C++ */
%typemap(in) Mat {
    if (! pyopencv_to($input, $1))
    {
            SWIG_exception_fail(SWIG_TypeError, "OpenCV conversion in bgsubcnt failed to convert to Mat"); 
    }
}

/* Convert from C++ --> Python */
%typemap(out) Mat {
    $result = pyopencv_from($1);
}

%typecheck(SWIG_TYPECHECK_POINTER) Mat {
  bool isMat = isMatType($input);
  if (isMat)
  {
          $1 = 1;
  }
  else
  {
          void *ptr;
          if (SWIG_ConvertPtr($input, (void **) &ptr, $&1_descriptor, 0) == -1) {
                  $1 = 0;
                  PyErr_Clear();
          } else {
                  $1 = 1;
          }
  }
}

class BackgroundSubtractorCNT
{
        public:
                virtual int getMinPixelStability() const = 0;
                virtual void setMinPixelStability(int value) = 0;

                virtual int getMaxPixelStability() const = 0;
                virtual void setMaxPixelStability(int value) = 0;

                virtual bool getUseHistory() const = 0;
                void setUseHistory(bool value) = 0;

                virtual bool getIsParallel() const = 0;
                virtual void setIsParallel(bool value) = 0;
};


%extend BackgroundSubtractorCNT
{
        public:
        Mat apply(Mat image, Mat fgMask = Mat(), double learningRate=-1)
        {
                self->apply(image, fgMask, learningRate);
                return fgMask;
        }
        Mat getBackgroundImage(Mat backgroundImage = Mat()) const
        {
                self->getBackgroundImage(backgroundImage);
                return backgroundImage;
        }
};


%inline %{
BackgroundSubtractorCNT* createBackgroundSubtractor(int minPixelStability = 15,
                bool useHistory = true,
                int maxPixelStability = 15*60,
                bool isParallel = true)
{
        // FIXME?: A very small intentional memory leak for the smart pointer
        Ptr<BackgroundSubtractorCNT> *ptr = new  Ptr<BackgroundSubtractorCNT>;
        *ptr = createBackgroundSubtractorCNT(minPixelStability, useHistory, maxPixelStability, isParallel);
        return ptr->get();
}
%}

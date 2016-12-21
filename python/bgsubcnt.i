%module bgsubcnt

%{
/*M///////////////////////////////////////////////////////////////////////////////////////
//
//  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
//
//  By downloading, copying, installing or using the software you agree to this license.
//  If you do not agree to this license, do not download, install,
//  copy or use the software.
//
//
//                          License Agreement
//                       (3-clause BSD License)
//                     For BackgroundSubtractorCNT
//               (Background Subtraction based on Counting)
//
// Copyright (C) 2016, Sagi Zeevi (www.theimpossiblecode.com), all rights reserved.
// Third party copyrights are property of their respective owners.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//   * Redistribution's of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//   * Redistribution's in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//   * The name of the copyright holders may not be used to endorse or promote products
//     derived from this software without specific prior written permission.
//
// This software is provided by the copyright holders and contributors "as is" and
// any express or implied warranties, including, but not limited to, the implied
// warranties of merchantability and fitness for a particular purpose are disclaimed.
// In no event shall the Intel Corporation or contributors be liable for any direct,
// indirect, incidental, special, exemplary, or consequential damages
// (including, but not limited to, procurement of substitute goods or services;
// loss of use, data, or profits; or business interruption) however caused
// and on any theory of liability, whether in contract, strict liability,
// or tort (including negligence or otherwise) arising in any way out of
// the use of this software, even if advised of the possibility of such damage.
//
//M*/
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

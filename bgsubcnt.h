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


#ifndef BGSUBCNT_H
#define BGSUBCNT_H

#include "opencv2/video.hpp"

// just a future wrapper marker
#define BGSUBCNT_EXPORTS_W

/**
 * @file
 */

/// This OpenCV namespace just adds the bgsubcnt namespace
namespace cv
{

/// The BackgroundSubtractorCNT related code is in here
namespace bgsubcnt
{

/** @brief Background subtraction based on counting.
 *
 *  About as fast as MOG2 on a high end system.
 * 
 *  More than twice faster than MOG2 on cheap hardware (benchmarked on Raspberry Pi3).
 * 
 *  Algorithm by Sagi Zeevi
 *  @see createBackgroundSubtractorCNT()
 */
class BGSUBCNT_EXPORTS_W BackgroundSubtractorCNT  : public BackgroundSubtractor
{
public:
    // BackgroundSubtractor interface
    CV_WRAP virtual void apply(InputArray image, OutputArray fgmask, double learningRate=-1) = 0;
    CV_WRAP virtual void getBackgroundImage(OutputArray backgroundImage) const = 0;

    /// @see createBackgroundSubtractorCNT()
    CV_WRAP virtual int getMinPixelStability() const = 0;
    /// @see createBackgroundSubtractorCNT()
    CV_WRAP virtual void setMinPixelStability(int value) = 0;

    /// @see createBackgroundSubtractorCNT()
    CV_WRAP virtual int getMaxPixelStability() const = 0;
    /// see @see createBackgroundSubtractorCNT()
    CV_WRAP virtual void setMaxPixelStability(int value) = 0;

    /// @see createBackgroundSubtractorCNT()
    CV_WRAP virtual bool getUseHistory() const = 0;
    /// @see createBackgroundSubtractorCNT()
    CV_WRAP virtual void setUseHistory(bool value) = 0;

    /// @see createBackgroundSubtractorCNT()
    CV_WRAP virtual bool getIsParallel() const = 0;
    /// @see createBackgroundSubtractorCNT()
    CV_WRAP virtual void setIsParallel(bool value) = 0;
};

/**
 * @brief Create background subtraction based on counting.
 *
 * @param minPixelStability number of frames with same pixel color to consider stable
 * @param useHistory determines if we're giving a pixel credit for being stable for a long time
 * @param maxPixelStability maximum allowed credit for a pixel in history
 * @param isParallel determines if we're parallelizing the algorithm
 * @return a smart pointer to a BackgroundSubtractorCNT
 * @note
 * The default values assume 15 FPS, in which a pixel which keeps it's value for ~ 1 second is
 * a stable background.
 * 
 * For history, a stable pixel will keep counting frames up to maxPixelStability. Changes will try
 * to decrement the count, but as long as it is above minPixelStability, is will remain stable. for
 * example, if FPS * is 15, then maxPixelStability of 15*60 means that a changes of ~ 60 seconds will make this pixel
 * non-stable background.
 * 
 * Effect of learningRate in apply(..., learningRate) -
 * - If learningRate == -1, then the algorithm is as stated above.
 * - If learningRate == 0, it is as if you used 'useHistory = false'.
 * - If 0 < learningRate < 1, then maxPixelStability = "initial maxPixelStability" * learningRate
 */
BGSUBCNT_EXPORTS_W Ptr<BackgroundSubtractorCNT>
createBackgroundSubtractorCNT(int minPixelStability = 15,
                              bool useHistory = true,
                              int maxPixelStability = 15*60,
                              bool isParallel = true);

}

// doxygen marksups below

/**
 * @example main.cpp
 * This is an example of C++ usage.
 */

/**
 * @example python/demo.py
 * This is an example of python usage.
 */

}

#endif // BGSUBCNT_H

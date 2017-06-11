
Usage in a nutshell
===================
This is a drop in replacement API for the background subtraction solutions supplied with OpenCV 3.1.0 and above.
See these drop in replacement examples for C++ in [main.cpp](@ref main.cpp) file, and for python in [demo.py](@ref python/demo.py) file.


### Usage tuning
This module is very predictable as it's behavior follows common sense.
You can tune the behavior when the BackgroundSubtractor is created (or later with setters) –


```
Ptr<BackgroundSubtractorCNT>
createBackgroundSubtractorCNT(int minPixelStability = 15,
                              bool useHistory = true,
                              int maxPixelStability = 15*60,
                              bool isParallel = true);
```
* Use your estimated FPS as the base for tuning, as explained below (it doesn’t have to be accurate).
* Each of these parameters can be evaluated according to these guidelines:

#### How long to wait before considering a pixel to be a background?
When you and I look at a scene, we wait for some time before we consider an item to be part of a background. The assumption here is that it takes about 1 second, but you can play with it. I recommend using your expected FPS as the value of minPixelStability when using createBackgroundSubtractorCNT(). The value represents the number of frames to wait when a pixel is not changing before marking it as background. The demo is doing exactly that in main.cpp.

#### How long to wait before recognizing the background changed?
Okay – so we’ve set something to be a background, and things are passing in front of it. When something is in front of it for a long time, then it’s time to treat it as a background instead of the previous one, but how long to wait before doing this replacement? The algorithm here was tested with a 60 seconds value and gave good results. You can change that as you want, but I recommend setting maxPixelStability to “minPixelStability*60″ in createBackgroundSubtractorCNT(). The demo is doing exactly that in main.cpp.

#### But what if you want to REACT VERY FAST TO SCENE CHANGES?
If reducing maxPixelStability is not enough, you can use ‘false‘ for useHistory in createBackgroundSubtractorCNT(). In this case maxPixelStability is ignored. Because the background distinction is weaker, you’ll see small ghosts following your foreground objects and the background image will have some ghosts images fading in it. Using “minPixelStability=FPS/5” will reduce this phenomena.

#### To parallel or not to parallel?
In my experience paralleling everything automatically is a double edged sword. On one hand you don’t need to worry about optimizations if you have enough processing power. On the other hand, splitting your processing carefully can yield a better optimization. I leave this to you to experiment and decide for your specific design.

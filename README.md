Introduction
=============

A simple screen shot manager for Love2D (http://love2d.org/). Screenshotter enables screen shot capturing, cropped screen shot capturing, and small recordings in the form of image files that can be stitched together for an animated gif or movie.

Screenshotter uses throttling of the image recording and file I/O to limit the impact the game has on the framerate. That said the recording functionality is still more for development screen short purposes than player recordings.

Basic Usage
=============

To include screenshotter in your game require it like so:
```lua
screenShotter = require("Screenshotter.capture")
```

Once pulled in use the following to take a basic screen shot:

```lua
screenShotter.takeShot() --Takes a screen shot of the current frame or cropping
```

Cropping
=============

Screen Shotter is capable of taking cropped screen shots using the follow API calls:
```lua
screenShotter.setBounds(x, y, width, height) --Sets a cropping at the given coordinate with the given width and height
screenShotter.clearBounds() --Clears the current cropping and reverts back to full screen capture
```

The current state of cropping can also be obtained using the following:

```lua
x, y, width, height = screenShotter.isCropping() --Gets the current cropping boundaries
screenShotter.isCropping() --Returns true if the captures are being cropped
```


Recording
=============

To enable recording, Screen Shotter must be included as part of the game's update loop:
```lua
function love.update(dt)
  screenShotter.update(dt)
end
```

After that recording is done using the following methods. All recording shots are saved in subfolders based either on timestamp or a passed name. _Note that recording will also use the cropping if one is set_
```lua
screenShotter.startRecording(name) --Starts a recording. name will be the subfolder name where the recorded images will be saved
screenShotter.stopRecording() --Stops the active recording
screenShotter.isRecording() --Returns true if the recording is currently active
```

Configuration
=============
There are several configuration options that can be used with Screen Shotter:
* SCREENSHOTTER_FOLDER_NAME: The name of the folder in the Love filesystem to store the screenshots (default screenshots)
* SCREENSHOTTER_IMAGE_FORMAT: The format of the images to save. See: http://love2d.org/wiki/ImageFormat (default png)
* SCREENSHOTTER_RECORD_RATE: The framerate to record set in 1/FPS (default 1/15 for 15FPS)
* SCREENSHOTTER_WRITE_RATE: The rate at which screenshots are written to the file system. The larger this value the less of a performance hit Screenshotter has, but the more memory it uses and the longer it takes to write out the images (default 1/5 seconds between image writes)

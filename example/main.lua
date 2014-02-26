local screenShotter = require("Screenshotter.capture")

local mx = -1
local my = -1

function love.load() 
  love.filesystem.setIdentity("screenShotter")
  
  frog = { image = love.graphics.newImage("frogling.png"),
           x = 160,
           y = 200,
           dir = 1 }
  
end

function love.update(dt)
  screenShotter.update(dt)
  frog.x = frog.x + frog.dir * dt * 20
  
  if frog.x > 500 then
    frog.dir = -1;
  elseif frog.x < 100 then
    frog.dir = 1;
  end
  
end

function love.draw()
  love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS( )), 10, 10)
  love.graphics.print("Use F9 for screenshot, hold F10 to record", 200, 300)
  love.graphics.print("Use left mouse to draw a cropping rectangle, right to clear the crop", 200, 320)
  love.graphics.print("Images are being saved to: ", 200, 340)
  love.graphics.print(love.filesystem.getSaveDirectory( ) .. "/" .. SCREENSHOTTER_FOLDER_NAME, 200, 360)
  -- Indicates if a video is currently being recorded
  if screenShotter.isRecording() then
    love.graphics.print("Recording", 10, 20)
  else
    love.graphics.print("Inactive", 10, 20)
  end
  
  -- Draw helper to draw the area of the screen being cropped
  -- this is a lazy example implementation and the box will show up as a boarder
  -- in the screen shot
  if screenShotter.isCropping() then
    love.graphics.rectangle( "line", screenShotter.getCrop())
  elseif mx >= 0 and my >= 0 then
    love.graphics.rectangle("line", mx, my, love.mouse.getX() - mx, love.mouse.getY() - my)
  end
  
  -- Our helpful animated test drawing
  love.graphics.draw(frog.image, frog.x, frog.y)
  
end

function love.keypressed(key, isRepeat)
   if key == "escape" then
    love.event.quit()
   elseif key == "f9" and isRepeat == false then
      screenShotter.takeShot()
   elseif key == "f10" then
      screenShotter.startRecording()
   end
end

function love.keyreleased(key)
  if key == "f10" then
    screenShotter.stopRecording()
  end
end

function love.mousepressed(x, y, button)
  if button == "l" then
    screenShotter.clearBounds()
    mx = x
    my = y
  elseif button == "r" then
    screenShotter.clearBounds()
  end
end

function love.mousereleased(x, y, button)
  if button == "l" then
    local left, bottom, width, height
    if mx < x then
      left = mx
      width = x - mx
    elseif mx > x then
      left = x
      width = mx - x
    else
      return
    end
    
    if my < y then
      bottom = my
      height = y - my
    elseif my > y then
      bottom = y
      height = my - y
    else
      return
    end
    
    screenShotter.setBounds(left, bottom, width, height)
    mx = -1
    my = -1
  end
end
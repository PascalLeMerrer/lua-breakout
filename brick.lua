local brickWidth = WIN_WIDTH / BRICKS_PER_LINE - 5 
local brickHeight = WIN_HEIGHT / 35


function createBrick (line, column)
  local x = 2.5 + (column - 1) * (5 + brickWidth)
  local y = line * (WIN_HEIGHT / 35 + 2.5)

  local brick = HC.rectangle(x, y, brickWidth, brickHeight)
  brick.x = x
  brick.y = y
  brick.width = brickWidth
  brick.height = brickHeight
  brick.isNotBroken = true
  brick.image = love.graphics.newImage('images/tileBlue.png') 
  brick.imageWidthScale = brick.width / brick.image:getWidth()
  brick.imageHeightScale = brick.height / brick.image:getHeight()
  return brick
end

function drawBrick(brick)
  if brick.isNotBroken then
    love.graphics.draw(brick.image, brick.x, brick.y, 0, brick.imageWidthScale, brick.imageHeightScale)
  end
end
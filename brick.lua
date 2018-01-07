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
  return brick
end

function drawBrick(brick)
  if brick.isNotBroken then
    brick:draw('fill')
  end
end
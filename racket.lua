local leftLimit = WIN_WIDTH / 8
local rightLimit = WIN_WIDTH * 7 / 8

function createRacket()
  local height = WIN_HEIGHT / 37
  local width = WIN_WIDTH / 4

  local startX = (WIN_WIDTH - width) / 2
  local startY = WIN_HEIGHT - 64
  racket = HC.rectangle(startX, startY, width, height)
  racket.startX = startX
  racket.startY = startY
  racket.height = height
  racket.width = width
  racket.velocity = {x = 0, y = 0}
  Signal.register(BALL_OUT_SIGNAL, resetRacket)

  racket.image = love.graphics.newImage('images/paddle.png') 
  racket.imageWidthScale = racket.width / racket.image:getWidth()
  racket.imageHeightScale = racket.height / racket.image:getHeight()
  
  displayTable(racket)
end

function resetRacket()
  if racket then
    racket.velocity = {x = 0, y = 0}
    racket:moveTo(racket.startX + racket.width / 2, racket.startY + racket.height / 2) -- moveTo acts on the center!
  end
end

function updateRacket(dt)
  if love.keyboard.isDown('left', 'q') and racket._polygon.centroid.x > leftLimit then
    racket.velocity.x = -RACKET_VELOCITY_X
  elseif love.keyboard.isDown('right', 'd') and racket._polygon.centroid.x < rightLimit then
    racket.velocity.x = RACKET_VELOCITY_X
  else
    racket.velocity.x = 0
  end
  racket:move(racket.velocity.x * dt, racket.velocity.y * dt)
end

function drawRacket()
  love.graphics.draw(racket.image, getRacketX(), getRacketY(), 0, racket.imageWidthScale, racket.imageHeightScale)
end

function getRacketX()
  local min = math.huge
  for index, vertex in ipairs(racket._polygon.vertices) do
    if vertex.x < min then
      min = vertex.x
    end
  end
  return min
end

function getRacketY()
  local min = math.huge
  for index, vertex in ipairs(racket._polygon.vertices) do
    if vertex.y < min then
      min = vertex.y
    end
  end
  return min
end
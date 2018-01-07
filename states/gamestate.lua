gameState = {}

HC = require 'hc'

racket = nil

function gameState:enter()
  Collider = HC.new(100)
  topBorder = HC.rectangle(0, -100, WIN_WIDTH, 100) -- x, y, width, height
  bottomBorder = HC.rectangle(0, WIN_HEIGHT, WIN_WIDTH, 100)
  leftBorder = HC.rectangle(-100, 0, 100, WIN_HEIGHT)
  rightBorder = HC.rectangle(WIN_WIDTH, 0, 100, WIN_HEIGHT)
  createRacket()
  createBall()
end

function gameState:update(dt)
  updateRacket(dt)
  updateBall(dt)
  if lifeCounter.count == 0 or nbBricks == 0 then
    Signal.emit(SWITCH_SIGNAL, endState)
  end

end

function gameState.draw()
  drawRacket()
  drawBricks()
  lifeCounter:draw()
  drawBall()
end
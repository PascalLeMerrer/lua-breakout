gameState = {}

function gameState:update(dt)
  racket:update(dt)
  local isBallInGame = ball:update(dt, racket)
  if not isBallInGame then
    lifeCounter:decrease()
  end

  if collideRect(ball, racket) then
    collisionBallWithRacket() -- Collision entre la balle et la raquette
  end

  for line = #bricks, 1, -1 do
    for column=#bricks[line], 1, -1 do
      if bricks[line][column].isNotBroken and collideRect(ball, bricks[line][column]) then
        collisionBallWithBrick(ball, bricks[line][column]) -- Collision entre la balle et une brique
      end
    end
  end

  if lifeCounter.count == 0 or nbBricks == 0 then
    Signal.emit(SWITCH_SIGNAL, endState)
  end

end


function gameState.draw()
  racket:draw()
  drawBricks()
  lifeCounter:draw()
  ball:draw()
end
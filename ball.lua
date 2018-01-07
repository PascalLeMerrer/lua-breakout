local soundBrick = love.audio.newSource(PATH_SOUND_BRICK, "static")
local soundRacket = love.audio.newSource(PATH_SOUND_RACKET, "static")

function createBall()

  local radius = racket.height * 0.2

  local startX = WIN_WIDTH / 2 - radius
  local startY = racket.startY - radius * 2.01
  ball = HC.circle(startX, startY, radius * 2)
  ball.startX = startX
  ball.startY = startY

  resetBall()

end

function resetBall()
  if ball == nil then
    return
  end
  ball:moveTo(ball.startX, ball.startY)
  local speedY = -DEFAULT_SPEED_BY
  local speedX = math.random(-DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
  ball.velocity = {x = speedX, y = speedY}
end

function updateBall(dt)

  local collisions = HC.collisions(ball)
  for other, separating_vector in pairs(collisions) do   
    if other == bottomBorder then
      Signal.emit(BALL_OUT_SIGNAL)
      resetBall()
    elseif other == topBorder then
      ball.velocity.y = -ball.velocity.y
    elseif other == leftBorder or other == rightBorder then
      ball.velocity.x = -ball.velocity.x
    elseif other == racket then
      collideBallWithRacket()
    else
      collideBallWithBrick(other)
    end

  end

  ball:move(ball.velocity.x * dt, ball.velocity.y * dt)

end

function collideBallWithRacket()

  soundRacket:play()

  -- Collision par la gauche (coin haut inclus)
  if getBallX() < getRacketX() + 1/8 * racket.width and ball.velocity.x >= 0 then
    if ball.velocity.x <= DEFAULT_SPEED_BX/2 then -- Si vitesse trop faible
      ball.velocity.x = -math.random(0.75 * DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
    else
      ball.velocity.x = -ball.velocity.x
    end
    -- Collision par la droite (coin haut inclus)
  elseif getBallX() > getRacketX() + 7/8 * racket.width and ball.velocity.x <= 0 then
    if ball.velocity.x >= -DEFAULT_SPEED_BX/2 then  -- Si vitesse trop faible
      ball.velocity.x = math.random(0.75 * DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
    else 
      ball.velocity.x = -ball.velocity.x
    end
  end
  -- Collision par le haut
  if getBallY() < getRacketY() and ball.velocity.y > 0 then
    ball.velocity.y = -ball.velocity.y
  end

end

function collideBallWithBrick(brick)
  if brick.isNotBroken then 
    soundBrick:play()

    -- Collision côté gauche brique
    if getBallX() < brick.x and ball.velocity.x > 0 then
      ball.velocity.x = -ball.velocity.x
      -- Collision côté droit brique
    elseif getBallX() > brick.x + brick.width and ball.velocity.x < 0 then
      ball.velocity.x = -ball.velocity.x
    end
    -- collision haut brique
    if getBallY() < brick.y and ball.velocity.y > 0 then
      ball.velocity.y = -ball.velocity.y
      -- Collision bas brique
    elseif getBallY() > brick.y and ball.velocity.y < 0 then
      ball.velocity.y = -ball.velocity.y
    end

    brick.isNotBroken = false
    nbBricks = nbBricks - 1

  end

end




function getBallX()
  return ball._center.x - ball._radius / 2

end

function getBallY()
  return ball._center.y - ball._radius / 2
end



function drawBall()
  ball:draw('fill', 16)
end

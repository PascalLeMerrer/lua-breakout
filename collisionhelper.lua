local soundBrick = love.audio.newSource(PATH_SOUND_BRICK, "static")
local soundRacket = love.audio.newSource(PATH_SOUND_RACKET, "static")


function collideRect(rect1, rect2)
  if rect1.x < rect2.x + rect2.width and
     rect1.x + rect1.width > rect2.x and
     rect1.y < rect2.y + rect2.height and
     rect1.height + rect1.y > rect2.y then
       return true
  end
  return false
end

function collisionBallWithRacket()

  soundRacket:play()

  -- Collision par la gauche (coin haut inclus)
  if ball.x < racket.x + 1/8 * racket.width and ball.speedX >= 0 then
    if ball.speedX <= DEFAULT_SPEED_BX/2 then -- Si vitesse trop faible
      ball.speedX = -math.random(0.75*DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
    else
      ball.speedX = -ball.speedX
    end
    -- Collision par la droite (coin haut inclus)
  elseif ball.x > racket.x + 7/8 * racket.width and ball.speedX <= 0 then
    if ball.speedX >= -DEFAULT_SPEED_BX/2 then  -- Si vitesse trop faible
      ball.speedX = math.random(0.75*DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
    else 
      ball.speedX = -ball.speedX
    end
  end
  -- Collision par le haut
  if ball.y < racket.y and ball.speedY > 0 then
    ball.speedY = -ball.speedY
  end

end

function collisionBallWithBrick(ball, brick)

  soundBrick:play()

  -- Collision côté gauche brique
  if ball.x < brick.x and ball.speedX > 0 then
    ball.speedX = -ball.speedX
    -- Collision côté droit brique
  elseif ball.x > brick.x + brick.width and ball.speedX < 0 then
    ball.speedX = -ball.speedX
  end
  -- collision haut brique
  if ball.y < brick.y and ball.speedY > 0 then
    ball.speedY = -ball.speedY
    -- Collision bas brique
  elseif ball.y > brick.y and ball.speedY < 0 then
    ball.speedY = -ball.speedY
  end

  brick.isNotBroken = false
  nbBricks = nbBricks

end
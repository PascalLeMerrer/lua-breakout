Class = require "hump.class"

Ball = Class{
  init = function(self, racket)
    self.width = racket.height * 0.75
    self.height = self.width
    self.reset(self, racket.y)
  end
}

function Ball:reset(racketY)
  self.speedY = -DEFAULT_SPEED_BY
  self.speedX = math.random(-DEFAULT_SPEED_BX, DEFAULT_SPEED_BX)
  self.x = WIN_WIDTH / 2 - self.width / 2
  self.y = racketY - 2 * self.height - self.height / 2
end

-- returns true when the ball is still in the game area, false otherwise
function Ball:update(dt, racket)
  self.x = self.x + self.speedX * dt
  self.y = self.y + self.speedY * dt

  if self.x + self.width >= WIN_WIDTH then
    self.speedX = -self.speedX
  elseif self.x <= 0 then
    self.speedX = -self.speedX
  end

  if self.y <= 0 then
    self.speedY = -self.speedY
    return true
  end
  if self.y + self.height >= WIN_HEIGHT then
    self.reset(self, racket.y)
    return false
  end
  return true
end

function Ball:draw()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
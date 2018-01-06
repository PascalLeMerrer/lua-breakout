Class = require "hump.class"

--debug = require('debug')

Racket = Class {
  init = function(self)
    self.speedX = 215
    self.width = WIN_WIDTH / 4
    self.height = WIN_HEIGHT / 37
    self.reset(self)
  end
}

function Racket:reset()
  self.x = (WIN_WIDTH - self.width) / 2
  self.y = WIN_HEIGHT - 64
end

function Racket:update(dt)
  if love.keyboard.isDown('left', 'q') and self.x > 0 then
    self.x = self.x - (self.speedX * dt)
  elseif love.keyboard.isDown('right', 'd') and self.x + self.width < WIN_WIDTH then
    self.x = self.x + (self.speedX * dt)
  end
end

function Racket:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
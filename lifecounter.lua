Class = require "hump.class"

LifeCounter = Class {
  init = function(self)
    self.count = NB_LIVES 
    self.img = love.graphics.newImage(PATH_LIFE) 
    self.width, self.height = self.img:getDimensions()
    Signal.register(BALL_OUT_SIGNAL, decrease)
  end
}

function decrease()
  lifeCounter.decrease(lifeCounter)
end

function LifeCounter:decrease()
  self.count = self.count - 1
end

function LifeCounter:draw()
  for i=0, self.count-1 do
    local posX = 5 + i * 1.20 * self.width
    love.graphics.draw(self.img, posX, WIN_HEIGHT-self.height)
  end
end

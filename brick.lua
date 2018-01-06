Class = require "hump.class"

Brick = Class {
  init = function(self, line, column)
    self.isNotBroken = true
    self.width = WIN_WIDTH / BRICKS_PER_LINE - 5 
    self.height = WIN_HEIGHT / 35
    self.x = 2.5 + (column - 1) * (5 + self.width)
    self.y = line * (WIN_HEIGHT / 35 + 2.5)
  end
}

function Brick:draw()
  if self.isNotBroken then
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  end
end
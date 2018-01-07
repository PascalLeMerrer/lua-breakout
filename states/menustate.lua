menuState = {}

function menuState:draw()
  love.graphics.printf("Casse-briques", 0, 0.25 * WIN_HEIGHT, WIN_WIDTH, "center")
  love.graphics.printf("Appuyez sur 'R' pour commencer", 0, 0.45 * WIN_HEIGHT, WIN_WIDTH, "center") 
end
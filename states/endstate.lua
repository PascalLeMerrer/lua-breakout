endState = {}

function endState:draw()
  local message = "Victoire !"
  if lifeCounter.count == 0 then
    message = "Défaite !"
  end
  love.graphics.printf(message, 0, 0.25 * WIN_HEIGHT, WIN_WIDTH, "center")
  love.graphics.printf("Appuyez sur 'R' pour recommencer", 0, 0.45 * WIN_HEIGHT, WIN_WIDTH, "center")
end

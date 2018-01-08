endState = {}

require('theme')

function endState:update()
  
  local message = "Victoire !"
  if lifeCounter.count == 0 then
    message = "Défaite !"
  end

  suit.layout:reset(100,100)
  suit.layout:padding(10,10)
  
  suit.Label(message, {align = "center"}, suit.layout:row(280,60))
  
  suit.layout:row()
  
  if suit.Button("Rejouer (r)", suit.layout:row()).hit then
    suit.setHit(nil) -- avoids hit to remain true
    Signal.emit(START_SIGNAL)
  end

  suit.layout:row()
  
  if suit.Button("Quitter (esc)", suit.layout:row()).hit then
    love.event.quit()
  end
end

function endState:draw()
    suit.draw()
end


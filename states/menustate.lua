menuState = {}

require('theme')

function menuState:update()
  suit.layout:reset(100,100)
  suit.layout:padding(10,10)
  
  suit.Label("Casse-briques", {align = "center"}, suit.layout:row(280,60))
  
  suit.layout:row()
  
  if suit.Button("Jouer (r)", suit.layout:row()).hit then
    Signal.emit(START_SIGNAL)
  end

  suit.layout:row()
  
  if suit.Button("Quitter (esc)", suit.layout:row()).hit then
    love.event.quit()
  end
end

function menuState:draw()
    suit.draw()
end

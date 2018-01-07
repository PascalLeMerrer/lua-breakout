-- pour écrire dans la console au fur et à mesure, facilitant ainsi le débogage
io.stdout:setvbuf('no') 

if arg[#arg] == "-debug" then require("mobdebug").start() end

-- NOTE: invoking a hump class method with a single dot causes stranges issues, like self being a number.
--       remember to use colon (object:method(...) )

require('constants')
require('racket')
require('ball')
require('brick')
require('lifecounter')
Gamestate = require "hump.gamestate"
Signal = require 'hump.signal'
require('states.menustate')
require('states.gamestate')
require('states.endstate')
require('debugTable')

local font

bricks = {} 
nbBricks = BRICKS_PER_COLUMN * BRICKS_PER_LINE 
lifeCounter = LifeCounter()

function love.load()
  math.randomseed(love.timer.getTime())

  font = love.graphics.newFont(32)
  love.graphics.setFont(font)

  initializeWindow()
  
  Gamestate.registerEvents()
  Gamestate.switch(menuState)

  initializeBricks()

  Signal.register(SWITCH_SIGNAL, function(state)
      Gamestate.switch(state)
    end
  )

end

function initializeWindow()
  love.window.setTitle(TITLE) 
  local imgIcon = love.graphics.newImage(ICON_PATH) 
  love.window.setIcon(imgIcon:getData())
  love.window.setMode(WIN_WIDTH, WIN_HEIGHT)
end

function initializeBricks()

  for line=1, BRICKS_PER_COLUMN do
    table.insert(bricks, {})
    for column=1, BRICKS_PER_LINE do
      local brick = createBrick(line, column)
      table.insert(bricks[line], brick)
    end
  end

end

function drawBricks()
  for line=1, #bricks do 
    for column=1, #bricks[line] do
      local brick = bricks[line][column]
      drawBrick(brick)
    end
  end
end

function love.keypressed(key)
  if key == "r" then
    if Gamestate.current() ~= gameState then
      resetGame()
    end
    Signal.emit(SWITCH_SIGNAL, gameState)
  end

  if key == "escape" then
    love.event.quit() -- Pour quitter le jeu
  end
end

function resetGame()
  resetRacket() 

  for line=1, #bricks do
    for column=1, #bricks[line] do
      bricks[line][column].isNotBroken = true
    end
  end

  lifeCounter.count = NB_LIVES
  nbBricks = BRICKS_PER_COLUMN * BRICKS_PER_LINE
  resetBall()
end

-- pour écrire dans la console au fur et à mesure, facilitant ainsi le débogage
io.stdout:setvbuf('no') 

if arg[#arg] == "-debug" then require("mobdebug").start() end

-- NOTE: invoking a class method with a single dot causes stranges issues
--       remember to use colon (object:method(...) )

require('constants')
require('racket')
require('ball')
require('brick')
require('lifecounter')

local racket
local bricks
local lifeCounter
local ball
local nbBricks = BRICKS_PER_COLUMN * BRICKS_PER_LINE
local soundBrick  
local soundRacket
local currentPage = PAGE_BEGINNING 
local font

function love.load()
  math.randomseed(love.timer.getTime())

  soundBrick = love.audio.newSource(PATH_SOUND_BRICK, "static")
  soundRacket = love.audio.newSource(PATH_SOUND_RACKET, "static")

  font = love.graphics.newFont(32)
  love.graphics.setFont(font)

  initializeWindow()
  racket = Racket()
  initializeBricks()
  lifeCounter = LifeCounter()
  ball = Ball(racket)

end

function initializeWindow()
  love.window.setTitle(TITLE) 
  local imgIcon = love.graphics.newImage(ICON_PATH) 
  love.window.setIcon(imgIcon:getData())
  love.window.setMode(WIN_WIDTH, WIN_HEIGHT)
end

function initializeBricks()

  bricks = {} 
  for line=1, BRICKS_PER_COLUMN do
    table.insert(bricks, {})
    for column=1, BRICKS_PER_LINE do
      local brick = Brick(line, column)
      table.insert(bricks[line], brick)
    end
  end

end

function love.update(dt)  
  if currentPage == PAGE_BEGINNING then
    love.graphics.printf("Casse-briques", 0, 0.25*WIN_HEIGHT, WIN_WIDTH, "center") -- Écriture
    love.graphics.printf("Appuyez sur 'R' pour commencer", 0, 0.45*WIN_HEIGHT, WIN_WIDTH, "center") 
  elseif currentPage == PAGE_ROUND then
    updateRound(dt)
  end
end

function updateRound(dt)
  racket:update(dt)
  local isBallInGame = ball:update(dt, racket)
  if not isBallInGame then
    lifeCounter:decrease()
  end

  if collideRect(ball, racket) then
    collisionBallWithRacket() -- Collision entre la balle et la raquette
  end

  for line = #bricks, 1, -1 do
    for column=#bricks[line], 1, -1 do
      if bricks[line][column].isNotBroken and collideRect(ball, bricks[line][column]) then
        collisionBallWithBrick(ball, bricks[line][column]) -- Collision entre la balle et une brique
      end
    end
  end

  if lifeCounter.count == 0 or nbBricks == 0 then
    currentPage = PAGE_END
  end

end

function collisionBallWithRacket()

  soundRacket:play()

  -- Collision par la gauche (coin haut inclus)
  if ball.x < racket.x + 1/8 * racket.width and ball.speedX >= 0 then
    if ball.speedX <= DEFAULT_SPEED_BX/2 then -- Si vitesse trop faible
      ball.speedX = -math.random(0.75*DEFAULT_SPEED_BX, DEFAULT_SPEED_BX) -- Nouvelle vitesse
    else
      ball.speedX = -ball.speedX
    end
    -- Collision par la droite (coin haut inclus)
  elseif ball.x > racket.x + 7/8 * racket.width and ball.speedX <= 0 then
    if ball.speedX >= -DEFAULT_SPEED_BX/2 then  -- Si vitesse trop faible
      ball.speedX = math.random(0.75*DEFAULT_SPEED_BX, DEFAULT_SPEED_BX) -- Nouvelle vitesse
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

  brick.isNotBroken = false -- Brique maintenant cassée
  nbBricks = nbBricks - 1 -- Ne pas oublier de décrémenter le nombre de briques

end

function love.draw()
  if currentPage == PAGE_BEGINNING then
    love.graphics.printf("Casse-briques", 0, 0.25*WIN_HEIGHT, WIN_WIDTH, "center") -- Écriture
    love.graphics.printf("Appuyez sur 'R' pour commencer", 0, 0.45*WIN_HEIGHT, WIN_WIDTH, "center") 
  elseif currentPage == PAGE_ROUND then
    racket:draw()
    drawBricks()
    lifeCounter:draw()
    ball:draw()
  elseif currentPage == PAGE_END then
    local message = "Victoire !"
    if lifeCounter.count == 0 then
      message = "Défaite !"
    end
    love.graphics.printf(message, 0, 0.25*WIN_HEIGHT, WIN_WIDTH, "center") -- Écriture
    love.graphics.printf("Appuyez sur 'R' pour recommencer", 0, 0.45*WIN_HEIGHT, WIN_WIDTH, "center")
  end
end

function drawBricks()
  for line=1, #bricks do 
    for column=1, #bricks[line] do
      local brick = bricks[line][column]
      brick:draw()
    end
  end
end

function love.keypressed(key)
  if key == "r" then
    if currentPage ~= PAGE_BEGINNING then

      racket:reset() 

      for line=1, #bricks do
        for column=1, #bricks[line] do
          bricks[line][column].isNotBroken = true
        end
      end

      lifeCounter.count = NB_LIVES -- Réinitialisation des vies
      nbBricks = BRICKS_PER_COLUMN * BRICKS_PER_LINE -- Réinitialisation du nombre de briques
      ball:reset(racket.y) -- Réinitialisation de la balle

    end
    currentPage = PAGE_ROUND -- Page jeu
  end

  if key == "escape" then
    love.event.quit() -- Pour quitter le jeu
  end
end

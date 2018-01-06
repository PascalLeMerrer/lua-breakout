-- pour écrire dans la console au fur et à mesure, facilitant ainsi le débogage
io.stdout:setvbuf('no') 

if arg[#arg] == "-debug" then require("mobdebug").start() end

require('constants')
require('racket')
require('ball')

local racket
local bricks
local lives
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
  initializeLives()
  ball = Ball(racket)
  
end

function initializeWindow()
  love.window.setTitle(TITLE) 
  local imgIcon = love.graphics.newImage(ICON_PATH) 
  love.window.setIcon(imgIcon:getData())
  love.window.setMode(WIN_WIDTH, WIN_HEIGHT)
end

function initializeLives()
  lives = {}
  lives.count = NB_LIVES
  lives.img = love.graphics.newImage(PATH_LIFE)
  lives.width, lives.height = lives.img:getDimensions() 
end

function createBrick(line, column)

  local brick = {}
  brick.isNotBroken = true
  brick.width = WIN_WIDTH / BRICKS_PER_LINE - 5 
  brick.height = WIN_HEIGHT / 35
  brick.x = 2.5 + (column-1) * (5+brick.width)
  brick.y = line * (WIN_HEIGHT/35+2.5)
  return brick

end

function initializeBricks()

  bricks = {} -- Initialisation variable pour les briques
  for line=1, BRICKS_PER_COLUMN do
    table.insert(bricks, {}) -- Ajout d'une ligne
    for column=1, BRICKS_PER_LINE do
      local brick = createBrick(line, column)
      table.insert(bricks[line], brick) -- Ajout d'une brique par colonne de la ligne
    end
  end

end

function initializeLives()

  lives = {}
  lives.count = NB_LIVES 
  lives.img = love.graphics.newImage(PATH_LIFE) 
  lives.width, lives.height = lives.img:getDimensions()

end

function love.update(dt)  
  if currentPage == PAGE_BEGINNING then
    love.graphics.printf("Casse-briques", 0, 0.25*WIN_HEIGHT, WIN_WIDTH, "center") -- Écriture
    love.graphics.printf("Appuyez sur 'R' pour commencer", 0, 0.45*WIN_HEIGHT, WIN_WIDTH, "center") 
  elseif currentPage == PAGE_ROUND then
    updateRound(dt)
  elseif currentPage == PAGE_END then
    -- Traitement page fin
  end
end

function updateRound(dt)
  racket:update(dt)
  local isBallInGame = ball:update(dt, racket)
  if not isBallInGame then
    lives.count = lives.count - 1
  end

  if collideRect(ball, racket) then
    collisionBallWithRacket() -- Collision entre la balle et la raquette
  end

  for line=#bricks, 1, -1 do
    for column=#bricks[line], 1, -1 do
      if bricks[line][column].isNotBroken and collideRect(ball, bricks[line][column]) then
        collisionBallWithBrick(ball, bricks[line][column]) -- Collision entre la balle et une brique
      end
    end
  end

  if lives.count == 0 or nbBricks == 0 then
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
    drawLives()
    ball:draw()
  elseif currentPage == PAGE_END then
    local message = "Victoire !"
    if lives.count == 0 then
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
      if brick.isNotBroken then
        love.graphics.rectangle('fill', brick.x, brick.y, brick.width, brick.height)
      end
    end
  end
end

function drawLives()
  for i=0, lives.count-1 do
    local posX = 5 + i * 1.20 * lives.width
    love.graphics.draw(lives.img, posX, WIN_HEIGHT-lives.height)
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

      lives.count = NB_LIVES -- Réinitialisation des vies
      nbBricks = BRICKS_PER_COLUMN * BRICKS_PER_LINE -- Réinitialisation du nombre de briques
      ball:reset(racket.y) -- Réinitialisation de la balle

    end
    currentPage = PAGE_ROUND -- Page jeu
  end

  if key == "escape" then
    love.event.quit() -- Pour quitter le jeu
  end
end

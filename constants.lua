TITLE = "Casse-briques" -- Titre
ICON_PATH = "images/icon.png" -- Chemin image icône
WIN_WIDTH = 480 -- Largeur fenêtre
WIN_HEIGHT = 640 -- Hauteur fenêtre
BRICKS_PER_LINE = 7
BRICKS_PER_COLUMN = 3 
NB_LIVES = 3 -- Nombre de vies initiales
PATH_LIFE = "images/life.png"
DEFAULT_SPEED_BX = 130 -- Vitesse horizontale
DEFAULT_SPEED_BY = 500 -- Vitesse verticale
PATH_SOUND_BRICK = "sounds/collision_brick.wav"
PATH_SOUND_RACKET = "sounds/collision_racket.wav"
PAGE_BEGINNING = 1 -- Page de début
PAGE_ROUND = 2 -- Page de partie
PAGE_END = 3 -- Page de fin

function collideRect(rect1, rect2)
  if rect1.x < rect2.x + rect2.width and
     rect1.x + rect1.width > rect2.x and
     rect1.y < rect2.y + rect2.height and
     rect1.height + rect1.y > rect2.y then
       return true
  end
  return false
end
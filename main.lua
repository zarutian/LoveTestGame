
GameState = {}

function GameState.makeNewFallingObject (x, y, size, color)
  local obj = {}
  obj.x = x
  obj.y = y
  obj.size = size or 10
  obj.color = color or {0, 240, 240}
  obj.fallingVelocity = 5
  obj.fallingRate = 0.25
  table.insert(GameState.fallingObjects, obj)
end

function love.load()
  GameState.catcher = {}
  GameState.catcher.x = 20
  GameState.catcher.y = 550
  GameState.catcher.minx = 20
  GameState.catcher.maxx = 590
  GameState.catcher.width = 180
  GameState.catcher.xvelocity = 0
  GameState.score = 0
  GameState.deltaAccumulator = 0
  GameState.fallingObjects = {}
  GameState.generateObjectInterval = 1.2
  GameState.untilNextGeneratedObject = GameState.generateObjectInterval
  love.keyboard.setKeyRepeat(true)
end

function love.draw()
  love.graphics.setBackgroundColor(0,0,0)
  love.graphics.clear()
  -- draw score
  love.graphics.setNewFont(20)
  love.graphics.setColor(240, 0, 240) -- magenta but not at highest brightness
  love.graphics.print("Score: " .. tostring(GameState.score), 650, 25)
  -- draw falling objects
  for i in ipairs(GameState.fallingObjects) do
    local obj = GameState.fallingObjects[i]
    love.graphics.setColor(obj.color)
    love.graphics.rectangle("line", obj.x, obj.y, obj.size, obj.size)
  end
  -- draw catcher
  love.graphics.setColor(0, 240, 0) -- lime but not at highest brightness
  local x, y, width = GameState.catcher.x, GameState.catcher.y, GameState.catcher.width
  love.graphics.line(x, y, x, y + 20, x + width, y + 20, x + width, y)
  -- draw Game Paused
  if GameState.paused then
    love.graphics.setColor(240, 0, 240) -- magenta but not at highest brightness
    love.graphics.setNewFont(60)
    love.graphics.print("Game is paused!", 150, 250)
  end
end

function love.update(deltatime)
  GameState.deltaAccumulator = GameState.deltaAccumulator + deltatime
  -- print("love.update(): deltatime = " .. tostring(deltatime))
  if not GameState.paused then
    GameState.catcher.x = GameState.catcher.x + GameState.catcher.xvelocity
    if GameState.catcher.x < GameState.catcher.minx then
      GameState.catcher.x = GameState.catcher.minx
    end
    if GameState.catcher.x > (GameState.catcher.maxx - GameState.catcher.width) then
      GameState.catcher.x = (GameState.catcher.maxx - GameState.catcher.width)
    end
    for i in ipairs(GameState.fallingObjects) do
      local obj = GameState.fallingObjects[i]
      if math.modf(math.fmod(GameState.deltaAccumulator, obj.fallingRate)) == 0 then
        obj.y = obj.y + obj.fallingVelocity
        local middlex = obj.x + (obj.size / 2)
        if obj.y > GameState.catcher.y and middlex > GameState.catcher.x and middlex < (GameState.catcher.x + GameState.catcher.width) then
          GameState.score = GameState.score + obj.size
        end
        if obj.y > 600 then
          table.remove(GameState.fallingObjects, i)
        end
      end
    end

    if GameState.untilNextGeneratedObject <= 0 then
      local size = math.random(10, 100)
      local x = math.random(GameState.catcher.minx, (GameState.catcher.maxx - size))
      local y = 10
      local color = { math.random(60, 240), math.random(60, 240), math.random(60, 240) }
      GameState.makeNewFallingObject(x, y, size, color)
      GameState.untilNextGeneratedObject = GameState.generateObjectInterval
    else
      GameState.untilNextGeneratedObject = GameState.untilNextGeneratedObject - deltatime
    end
  end
  if GameState.deltaAccumulator >= 10 then
    print("love.update(): deltaAccumlator tick")
    GameState.deltaAccumulator = 0
  end
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key)
  if love.keyboard.isDown("left") then
    GameState.catcher.xvelocity = -5
  end
  if love.keyboard.isDown("right") then
    GameState.catcher.xvelocity = 5
  end
end

function love.keyreleased(key)
end

function love.focus(f)
  if f then
    GameState.paused = false
    print("love.focus(): gained focus")
  else
    GameState.paused = true
    print("love.focus(): lost focus")
  end
end

function love.quit()
  print("love.quit(): goodbye!")
end
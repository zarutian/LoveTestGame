
function love.conf(t)
  t.identity = "Zarutian_Test_Game"
  t.version = "0.9.0"
  t.console = true -- at least for debugging for now
  
  t.window.title = "Zarutians Test Game"
  t.window.icon = nil -- should be "gfx/game.ico" in the future
  
  t.window.width = 800
  t.window.height = 600
  t.window.borderless = false
  t.window.resizable = false
  t.window.minwidth = t.window.width
  t.window.minheight = t.window.height
  t.window.fullscreen = false
  t.window.fullscreentype = "normal"
  t.window.vsync = true
  t.window.fsaa = 0
  t.window.display = 1
  t.window.highdpi = false
  t.window.srgb = false
  
  t.modules.audio = true
  t.modules.event = true
  t.modules.graphics = true
  t.modules.image = true
  t.modules.joystick = false
  t.modules.keyboard = true
  t.modules.math = true
  t.modules.mouse = true
  t.modules.physics = false -- dont want physics for now
  t.modules.sound = true
  t.modules.system = false -- why need to access the os?
  t.modules.timer = true
  t.modules.window = true
end
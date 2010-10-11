--Turnip Head Man Main File


--Required Files
	require 'inc/pPCollision'
	require 'inc/imageBatch'
	require 'inc/media'
	require 'inc/supportFunctions'
	require 'inc/tablePersistence'
	require 'inc/input'

playerFile = love.filesystem.load('inc/player.lua')
gameFile = love.filesystem.load('inc/game.lua')
itemsFile = love.filesystem.load('inc/items.lua')

function love.load()
    font = love.graphics.newFont( 'fonts/segoesc.ttf',16 )
    love.graphics.setFont( font )
	love.graphics.setColorMode( 'replace' )
	love.graphics.setBackgroundColor(255,255,255)
	reloadGame('newGame')

end

function love.update(delta)
	dt = delta
	capFPS(delta, 29)
	keyboard.last = keyboard.isDown()
end

function love.draw()
	if game then game:run() end
	gameDebug:run()
end
gameDebug = {active = true}

function gameDebug:run()
	if gameDebug.active then
		advPrint(tostring(debugVal), 20,20,{0,0,0})
	end
end

function gameDebug.toggle()
	gameDebug.active = not gameDebug.active
end

function love.keypressed(key, u)
   --Debug
   if key == "rctrl" then --set to whatever key you want to use
      gameDebug.toggle()
	  reloadGame('newGame')
   end
end

function love.mousepressed( x, y, key )
	if key=='l' then
		if item then item:add('coin', x,y) end
	end
end
function capFPS(delta, max)
	local ms = (1000 / 60) - (delta * 1000)
    if ms > 0 then
		love.timer.sleep(ms)
	end 
end

function reloadGame(state)

love.graphics.rectangle('fill',0,0,love.graphics.getWidth(), love.graphics.getWidth())	
	player = nil
	if not playerFile() then
		advPrint('Loaded: Player',100,100,{0,0,0} )
		game = nil
		if not gameFile() then
			advPrint('Loaded: Game',100,125,{0,0,0} )
			items = nil
			item = nil
			if  not itemsFile() then 
				advPrint('Loaded: Items',100,150,{0,0,0} )
			end
		end
	end
	if game then  game.state = state end





end



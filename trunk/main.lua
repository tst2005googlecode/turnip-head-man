--Turnip Head Man Main File


--Required Files
	require 'inc/pPCollision'
	require 'inc/imageBatch'
	require 'inc/media'
	require 'inc/supportFunctions'
	require 'inc/tablePersistence'
	require 'inc/input'
	require 'inc/game'
	require 'inc/items'


function love.load()
    font = love.graphics.newFont( 'fonts/segoesc.ttf',16 )
    love.graphics.setFont( font )
	love.graphics.setColorMode( 'replace' )
	love.graphics.setBackgroundColor(255,255,255)
	

end

function love.update(delta)
	dt = delta
	capFPS(delta, 29)
	keyboard.last = keyboard.isDown()
end

function love.draw()
	game:run()
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
   end
end

function love.mousepressed( x, y, key )
	if key=='l' then
		item:add('coin', x,y)
	end
end
function capFPS(delta, max)
	local ms = (1000 / 60) - (delta * 1000)
    if ms > 0 then
		love.timer.sleep(ms)
	end 
end





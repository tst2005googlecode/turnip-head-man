



--local bound = {right = love.graphics.newImage('img/player/right/walkingBounding.png'), left = love.graphics.newImage('img/player/left/walkingBounding.png')}
game = {state = 'newGame', paralaxX = 0}

backgrounds = {}




---------------------------------------------------------------------------------------------------------
------------------------------------------Game Functions-----------------------------------------------
---------------------------------------------------------------------------------------------------------

function game:run() --calls the game state 
	game[game.state]()
end

function game:running() --is run when the game is `running`
	player:update()
	item:update()
	game:gravity(player)
	for i,v in ipairs(items) do
		game:gravity(v)
	end
	game:backgrounds()
	--debugVal = 'X:'..mouse.X()..' - Y:'..mouse.Y()
	
end

function game:backgrounds()
	paralaxingBG()
	--love.graphics.draw(backgrounds[2].image,0,0)
	player:draw()
	
--[[ 	
	r,g,b,a = love.graphics.getColor()

	love.graphics.setColor(r,g,b,160)
	love.graphics.draw(backgrounds[1].image,0,0)
	love.graphics.setColorMode( 'modulate' )
	love.graphics.setColor(r,g,b,a)
	
	
	love.graphics.draw(backgrounds[3].image,0,0)
	 ]]
	
	
	love.graphics.draw(backgrounds[4].image, backgrounds[4].x, 0)
end

function game:start() --called when you start a game
	
end

function game:newGame() --called when you start a NEW game
	player.left = newImageAnimation('img/player/left/', 0.08, 9)
	player.right =  newImageAnimation('img/player/right/', 0.08, 9)
	game:buildMap()
	game.state = 'running'
	--int = game:buildItemsFromMap('img/maps/1/1/3.png', 'img/items/coinBlock/1.png')
end

function game:loadGame() --called when you start LOAD a game
	
end

function game:paused()
	
end

function game:buildMap()
		
	local temp = 'img/maps/'..player.world..'/'..player.stage..'/'
	backgrounds = {
		{colMap = false, image = love.graphics.newImage( temp..'1.gif'),x=0,y=0},
		{colMap = false, image = love.graphics.newImage( temp..'2.gif'),x=0,y=0},
		{colMap = collision:newCollisionMap(temp..'3.gif'),image = love.graphics.newImage( temp..'3.gif'),x=0,y=0},
		{colMap = collision:newCollisionMap(temp..'4.gif'),image = love.graphics.newImage( temp..'4.gif'),x=0,y=0},

	}

end

function game:buildItemsFromMap(item,map )
	
	

	
	local X,Y = intersection2(collision:newRGBMap(map), collision:newRGBMap(item))
	
	local newTable = {}
	
	X = table.sort(X)

	for i = 1, #X do
		newTable[i] = {x = X[i], y =Y[X[i]]}
		i = i +15
	end
	
	

	return newTable

	
	
	
	--item:add(index, action, colMap)

end

function table.sort(tableVal)
	local t = {}
	--print(table.save(X))
	for i = 1, 99999 do
		if tableVal[i] then
			t[#t+1] = tableVal[i]
		end
	end	
	return t
end

function game:gravity(object)
	
	local findGround = false
	
	if object.isPlayer then --This only effects the player
		if object.isJumping < 1 then
			object.isJumping = 0
			local temp = object.y+game.determineSpeed(object.gravitySpeed)
			if not player:isColliding( false, temp ) then
				object.y = temp
			
			else
				game:findGround(object)
				object.falling = false
			end
			
			if player:isColliding(false,(object.y+1)) then
				object.falling = false
			end
		end
	
	else --This only effects items
	
	end
end

function game:findGround(object)
local y = 2
local xVal = 2
if object.isPlayer then xVal = player.getX() end
	for x = 1, x+1 do
		if not player:isColliding(object.x,(object.y+1),object.colMap) then
			object.y = object.y+1
			y = y + 1
		else
			break
		end
		
	end
end

function game.determineSpeed(speed)
	return math.ceil(math.round((speed * dt),0))
end



function paralaxingBG()
	if (player.maxPosition - player.x) <0 then 
		x = (player.maxPosition - player.x)
	else
		x = 0
	end
		backgrounds[4].x = x
	if (math.abs(backgrounds[4].x)+1)  > (backgrounds[4].image:getWidth() - love.graphics.getWidth()) then
		backgrounds[4].x = (backgrounds[4].image:getWidth() - love.graphics.getWidth() ) * (-1)
	end	
	

	debugVal = backgrounds[4].x..' || '..(backgrounds[4].image:getWidth() - love.graphics.getWidth())

end

function doParalax()
	if player.x > player.maxPosition then return true else return false end
end

function intersection2(table1, table2)
    local values = {}
    for y, xtable in ipairs(table1) do -- use ipairs when tables are arrays
        for x,v in pairs(xtable) do
            values[v] = {x,y}
        end
    end
   
    local Y = {}
    local X = {}
	local index = 1
    for y, xtable in pairs(table2) do
        for x,v in pairs(xtable) do
            if v then
				X[x] = x--{t1 = values[v], t2 = {x=x,y=y}, value = v}
                Y[x] = y--{t1 = values[v], t2 = {x=x,y=y}, value = v}
				index = index+1
			else
				index = index +1
            end
        end
    end

    return X,Y
end












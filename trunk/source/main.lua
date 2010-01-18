--includes
textGlobal = ''
clientList = {}
	require("inc/AnAL.lua")
	require("inc/LUBE.lua")
	require("inc/tablePersistence.lua")


--Globals 
	infoPack = {}		
	client = {}
	server = {}
	networking = {}
	networking.gotServer = false
	networking.text = ''
	

	platforms = {}

	objects = {
		player = {spriteNorm = "img/objects/turnipMan.gif", spriteRev = "img/objects/turnipManRev.gif", placeholder = "img/objects/player.png", placeholderAlpha = "img/objects/playerAlpha.png", x = 0, y = 0, startPlaced = false, startDirection = "right"},
	}
	
	objectFunc	 = {}
	
	objectList = {
		potato = {img = "img/objects/potato.png", width = love.graphics.newImage("img/objects/potato.png"):getWidth(), height = love.graphics.newImage("img/objects/potato.png"):getHeight(), },
		richSoil = {img = "img/objects/fertilizerBag.png", width = love.graphics.newImage("img/objects/potato.png"):getWidth(), height = love.graphics.newImage("img/objects/potato.png"):getHeight(), },
		topHat = {img = "img/objects/topHat.png", width = love.graphics.newImage("img/objects/potato.png"):getWidth(), height = love.graphics.newImage("img/objects/potato.png"):getHeight(), },
	}

	tempTable = {}

	gui = {}
	
	level = {}
	
	player = { 
		jumpVar = 0, 
		stepDistance = 2.5, 
		jumping = false,
		width = 45,
		height = 47
	}
		
	colours = {
		black = {r = 0 , g = 0 , b = 0 , a = 255},
		red = {r = 255 , g = 0 , b = 0 , a = 255},
		blue = {r = 0 , g = 0 , b = 255 , a = 255},
		green = {r = 0 , g = 255 , b = 0 , a = 255},
		yellow = {r = 255 , g = 255 , b = 0 , a = 255},
	
	}
	
	player.spriteIndex = {}
	
	game = {
		paused = false,
		menu = "wait",
		jumpHeight = 75,
		map = false,
	}
	
	gameInfo = {
		map = false,
	}
	
	global = {}
	
	drawing = {method = "level", active = true, clickNum = 1, objectType = ""}
	
	system = {
		clickNum = 1,
		showMenu = false,
		menu = "mainMenu",
		menuStep = 1,
		currentlySelected = 0,
		MAXFPS = 60,
		debug = false,
		newPress = {keyboard = "", mouse = ""},
		mapDataDir = "maps",
		currentMenu = "FULL"
	}

	str = ""
	
	X = love.mouse.getX()

	Y = love.mouse.getY()
	
	guiObjects = {
		menuImg = love.graphics.newImage("img/menu/mainMenu.png"),
		menuButtonsImg = love.graphics.newImage("img/menu/mainMenuButtons.png"),
		loadMenuSuccess = love.graphics.newImage("img/menu/loadMenuSuccess.png"),
		saveMenuEnterText = love.graphics.newImage("img/menu/saveMenuEnterText.png"),
		itemList_FULL = love.graphics.newImage("img/menu/itemList.png"),
		itemList_richSoil = love.graphics.newImage("img/menu/itemList-richSoil.png"),
		itemList_topHat = love.graphics.newImage("img/menu/itemList-topHat.png"),
		itemList_potato = love.graphics.newImage("img/menu/itemList-potato.png"),
		itemList_player = love.graphics.newImage("img/menu/itemList-player.png"),
		itemList_selector = love.graphics.newImage("img/menu/itemList-selector.png"),
		itemList_platforms = love.graphics.newImage("img/menu/itemList-platforms.png"),
	}

	alphaNum = {
		"a",
		"period",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k",
		"l",
		"m",
		"n",
		"o",
		"p",
		"q",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z",
		"space",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		"0",
	}	

	alpha = {
		"a",
		"period",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k",
		"l",
		"m",
		"n",
		"o",
		"p",
		"q",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z",
		"space",
		".",
	}	

	num = {
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		"0",
		".",
	}	

	
	
	
function love.load()
	love.graphics.setColorMode("replace")
	font = love.graphics.newFont("fonts/segoesc.ttf", 18)
	love.graphics.setFont(font)
	love.graphics.setColor(0,0,0, 255)
	love.graphics.setBackgroundColor( 255,255,255)
	love.filesystem.write("settings", "this is actually just a placeholder")
	love.filesystem.remove("settings") 
	if not(love.filesystem.exists("maps")) then
		dir = "maps"
		love.filesystem.mkdir(dir)
	end
	
	gui.open()
	
	player.spriteIndex["right"] = newAnimation(love.graphics.newImage(objects.player.spriteNorm), 45, 47, 0.1, 0)
	player.spriteIndex["left"] = newAnimation(love.graphics.newImage(objects.player.spriteRev), 45, 47, 0.1, 0)
	
end

function love.mousepressed( x, y, button )
	system.newPress.mouse = button
end
	
function love.mousereleased(x, y, button)
	system.newPress.mouse = ""
	if system.debug then
		objects.player.x = x
		objects.player.y = y
	end
end

function love.update(dt)

	if client.object or server.object then
		networking.updateClient(dt)
	end

	
	if not (game.paused) and game.menu == game.playing then
		game.update(dt)
	end
	
    X = love.mouse.getX()
	Y = love.mouse.getY()
	local ms = (1000 / system.MAXFPS) - (dt * 1000)
    if ms > 0 then
		love.timer.sleep(ms)
	end
end

function love.keyreleased( key ) 
if client.object then
	client.object:setCallback(rcvCallback)
	end
	system.newPress.keyboard = 0
	if key == "backspace" and system.debug then
		--love.restart( )
	end
end 

function love.keypressed( key )

	if not (game.paused) and game.menu == game.playing then
		player.walk(key)
	end
	
	if key == "escape" and not system.showMenu then
		system.menu = "mainMenu"
		gui.open()
	elseif key == "escape" and system.showMenu then
		gui.close()
	end 
	
	if key == "f12" then
		system.debug = not system.debug
	end
	
	system.newPress.keyboard = key

end

function love.draw()
	
--Handles all of the game func's
	game.run()
	
--Runs the debug gui.	
	if system.debug then
		gui.debug()
	end

	print("ESC = Main Menu", 0, 18, {r = 123, g = 123, b = 123, a = 255})

	system.newPress = {keyboard = "", mouse = ""}
end



						--[[ 	Player functions (walk, gravity, death, etc.)     ]]--

player.run = function()
	--player.gravity()
	player.walk()
	player.sprite:update(0.02)	
	player.draw()
	player.jump()
	player.gravity()
end

player.draw = function()
	player.sprite:draw(objects.player.x, objects.player.y, 0, 1, 1, 22.5, 23.5)
end

player.start = function()
--Set the sprite animation actions
	player.sprite = player.spriteIndex["right"]
	player.sprite:stop()
	player.sprite:seek(3)
end

player.walk = function(key)
	height = 47
	width = 45
	x = (objects.player.x - width/2)
	y = (objects.player.y - height/2)
		--love.graphics.rectangle("fill", x-3, y, 3, height)
		--love.graphics.rectangle("fill", (x+width)-2, y, 2, height)
		--love.graphics.rectangle("fill", x, y, width, 2)
		--love.graphics.rectangle("fill", x, (y+height)-2, width, 2)
	checkLeft = false
	checkRight = false
	
--Left bounding bar
	left = {}
	left.x = x + 10
	left.y = y
	left.width = 3
	left.height = height - 1.5
	
--Right bounding bar
	right = {}
	right.x = (x + width)-10
	right.y = y
	right.width = 3
	right.height = height - 5

	
--Upper bounding Bar
	up = {}
	up.height = 1
	up.width = 20
	up.x = objects.player.x - player.width/4
	up.y = objects.player.y - (player.height/2)-up.height
	
	for k,v in pairs(platforms) do

		
		if rectOverlap(left, v) then
			checkLeft = true
			if system.debug then
				love.graphics.rectangle("fill", left.x, left.y, left.width, left.height)
				love.graphics.setColor(123,321,222)
				love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
				love.graphics.setColor(0,0,0)
			end
		end
		
		if  rectOverlap(right, v) then
			checkRight = true
			if system.debug then
				love.graphics.rectangle("fill", right.x, right.y, right.width, right.height)
				love.graphics.setColor(123,321,222)
				love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
				love.graphics.setColor(0,0,0)
			end
		end
		
		if  rectOverlap(up, v) then
			player.jumpVar = 0
			if system.debug then
				love.graphics.rectangle("fill", up.x, up.y, up.width, up.height)
				love.graphics.setColor(123,321,222)
				love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
				love.graphics.setColor(0,0,0)
			end
		end		
		
		
	end

	if love.keyboard.isDown( "left" )  then
			player.sprite = player.spriteIndex["left"]
		if not checkLeft then
			player.sprite:play()
			objects.player.x = objects.player.x -  player.stepDistance
		end
	end
	if love.keyboard.isDown( "right" )   then
		player.sprite = player.spriteIndex["right"]
		if not checkRight then
			player.sprite:play()
			objects.player.x = objects.player.x + player.stepDistance
		end
	end
	if love.keyboard.isDown( "up" ) then	
		if player.jumpVar == 0 and not(player.jumping) then
			player.jumpVar = game.jumpHeight
			player.jumping = true
		end
	end
	if not love.keyboard.isDown( "right" ) and not love.keyboard.isDown( "left" ) and not love.keyboard.isDown( "up" ) then
		player.sprite:stop()
		player.sprite:seek(3)
	end

end

player.jump = function(key)
	if player.jumpVar > 0 then
		objects.player.y = objects.player.y - 10;
		player.jumpVar = player.jumpVar - 5;
	end
end

player.gravity = function()
	bounds = {}
	bounds.height = 1
	bounds.width = 20
	bounds.x = objects.player.x - bounds.width/2
	bounds.y = objects.player.y + (player.height/2)-bounds.height
	checkVal = false
	dropNorm = 5
	for k,v in pairs(platforms) do
		
		if system.debug then	
			love.graphics.setColor(0,0,0, 255)
			love.graphics.rectangle("fill", bounds.x, bounds.y, bounds.width, bounds.height)
			love.graphics.setColor(0,0,0)		
		end
		
		if rectOverlap(bounds, v) then
			checkVal = true
			objects.player.y = (v.y-(player.height/2))+1
			player.jumping = false
		end
	end	

	
	if not checkVal then
		objects.player.y = objects.player.y + dropNorm
	end
end



						--[[ 	objectFunc functions such as the run loop,  item placement, item pickup and such   ]]--

objectFunc.run = function()
	
end



						--[[ 	Game functions: start game, menu calls, pause, save, load, map selection   ]]--

game.run = function()

	game[game.menu]()

--Handles displaying menu items and such like...	-! Needs to be last so it's always on layer one first !-
	gui.run()
	
end

game.wait = function()

end

game.playing = function()

--draws the level
	level.run()

--draws the player
	player.run()

--draws the objects
	objectFunc.run()
end

game.start = function()
	player.start()
	game.menu = "playing"
end

game.update = function(delta)
	player.sprite:update(dt) 
end



						--[[ 	runs everything     ]]--
level.run = function()
	for k,v in pairs(platforms) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	end
end
						


						--[[ 	Graphical User Interface (GUI) functions     ]]--

gui.run = function()
	if system.showMenu then
		if type(gui[system.menu]) == "function" then
			gui[system.menu]()
		else
			gui.close();
		end
	end
end

gui.open = function()
	system.showMenu = true
	drawing.active = false
	tempTable = {}
	drawing.clickNum = 1
end

gui.close = function()
		system.showMenu = false
		drawing.active = true
		system.menuStep = 1
		drawing.clickNum = 1
		str = ""
		system.currentMenu = "FULL"
end

gui.mainMenu = function()
	X = love.mouse.getX()
	Y = love.mouse.getY()
	
	love.graphics.draw(guiObjects.menuImg, (love.graphics.getWidth()/2)-(guiObjects.menuImg:getWidth()/2) , 0 );	
	love.graphics.draw(guiObjects.menuButtonsImg, (love.graphics.getWidth()/2)-(guiObjects.menuImg:getWidth()/2) , 0 );	
	
	if system.newPress.mouse == ("l" ) and X > 303 and X < 482 and Y > 222 and Y < 241 then
		system.menu = "startServer"
	end
	
	if system.newPress.mouse == ("l" ) and X > 304 and X < 479 and Y > 289 and Y < 314 then
		system.menu = "joinServer"
	end
end 

gui.joinServer = function()
	love.graphics.draw(guiObjects.menuImg, (love.graphics.getWidth()/2)-(guiObjects.menuImg:getWidth()/2) , 0 );	
	love.graphics.draw(guiObjects.saveMenuEnterText, (love.graphics.getWidth()/2)-(guiObjects.menuImg:getWidth()/2) , 0 );	
	if system.menuStep == 1 then --Naming	
		print( "    Please Type an IP Address ", (love.graphics.getWidth()/2) - 140, (love.graphics.getHeight()/2) - 82-36, colours.black)
		print( str, (love.graphics.getWidth()/2) - 148, (love.graphics.getHeight()/2), colours.black)
		
		if system.newPress.keyboard == "backspace" then
			str = string.sub(str, (1), string.len(str)-1)
		end
		
		if string.len(str) < 25 and keyAprooved(system.newPress.keyboard, alphaNum) then
			str = str..system.newPress.keyboard
		end
			
		if system.newPress.keyboard == ("return") and not (str == nil) then
			if not client.object then
				require("inc/Client.lua")
			end
			system.menuStep = 2
		end
	
	elseif system.menuStep == 2 then
			if networking.gotServer and gameInfo.map then
				fileData = love.filesystem.read( "maps/"..gameInfo.map )
				global = table.load(fileData) 
				platforms = global.platforms
				objects = global.objects
				game.menu = "start"
				gui.close()
			end
	end
	
end

gui.startServer = function()
	love.graphics.draw(guiObjects.menuImg, (love.graphics.getWidth()/2)-(guiObjects.menuImg:getWidth()/2) , 0 );	
	X = love.mouse.getX()
	Y = love.mouse.getY()
	maxMaps = 0
	tempSelectedFile = false;
	k = 0
	for i,v in pairs(love.filesystem.enumerate(system.mapDataDir.."/")) do
		k = k+1	
		
		if system.newPress.mouse == "l" and X > ((love.graphics.getWidth()/2) - 160) and X < ((love.graphics.getWidth()/2) + 161) and Y > ((love.graphics.getHeight()/2) - 138) +28*k and Y <  ((love.graphics.getHeight()/2) - 108) +28*k then
			system.currentlySelected = k
		end
		
		if system.currentlySelected == k then
			tempSelectedFile = v
			tempName = v
			love.graphics.setColor(230, 249, 165, 204)
			love.graphics.rectangle( "fill" , ((love.graphics.getWidth()/2) - 160), ((love.graphics.getHeight()/2) - 138) +28*k, 321, 30)
			love.graphics.setColor(0, 0, 0, 255)
		end
			
		print(v,((love.graphics.getWidth()/2) - 148), (love.graphics.getHeight()/2) - 118 +28*k, colours.black )
		
		maxMaps = k
		
	end

	if system.newPress.keyboard == ("delete") and not(tempName == "") and not(tempName == nil)then
		system.temp = system.mapDataDir.."/"..tempName

		love.filesystem.remove(system.mapDataDir.."/"..tempName)
	end	
	
	if system.newPress.keyboard == "down" and system.currentlySelected < maxMaps then
		system.currentlySelected = system.currentlySelected + 1
	elseif system.newPress.keyboard == "up" and system.currentlySelected > 1 then
		system.currentlySelected = system.currentlySelected - 1	
	end
	
	if system.newPress.keyboard == "return" and not(tempSelectedFile == false)then
		--love.graphics.draw("Loaded: "..tempSelectedFile, love.graphics.getWidth()/2 , love.graphics.getHeight()/2 )
		gameInfo.map = tempSelectedFile
		require('inc/Server.lua')
		fileData = love.filesystem.read( "maps/"..tempSelectedFile )
		global = table.load(fileData) 
		platforms = global.platforms
		objects = global.objects
		game.menu = "start"
		gui.close()
		
	end
end 


gui.debug = function()
	--print("X: "..love.mouse.getX().." - Y:"..love.mouse.getY(), love.mouse.getX(), love.mouse.getY(), love.graphics.newColor(123,123,123,255))	
	print("Debug Val: "..tostring(gameInfo.map), love.mouse.getX(), love.mouse.getY()-25, {r = 123, g = 123, b = 123, a = 255})	
	
end



						--[[ 	 Level Drawing, and objectFunc placement functions 	]]--

drawing.run = function()
	if drawing.active then
		if type(drawing[drawing.method]) == "function" then
			drawing[drawing.method]()
		end
	end

	for k,v in pairs(platforms) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	end
	
	for k,v in pairs(objects) do
		if not(k == 'player') then
			love.graphics.draw(love.graphics.newImage(v.img), v.x, v.y)
		end
	end

	if objects.player.startPlaced then
		tempImage = love.graphics.newImage(objects.player.placeholder)
		love.graphics.draw(tempImage, objects.player.x, objects.player.y)
		tempImage = nil
	end
	

end

drawing.level = function()
	if system.newPress.mouse == "l" then
		if(drawing.clickNum == 1 ) then
			tempTable = {
				x = X,
				y = Y,
			}
			drawing.clickNum = 2
			
		elseif(drawing.clickNum == 2 ) then
			xVal = getBiggest(X,tempTable.x)
			yVal = getBiggest(Y,tempTable.y)
			tempTable.x = xVal.small
			tempTable.y = yVal.small
			tempTable.width = getDist(xVal.big, xVal.small)	
			tempTable.height = getDist(yVal.big, yVal.small)		
			table.insert(platforms,  tempTable)
			drawing.clickNum = 1

		end
	end
	
	if drawing.clickNum == 2 then
		xVal = getBiggest(love.mouse.getX(),tempTable.x)
		yVal = getBiggest(love.mouse.getY(),tempTable.y)
		width = getDist(xVal.big, xVal.small)	
		height = getDist(yVal.big, yVal.small)		
		love.graphics.setColor(0, 0, 0, 204)
			love.graphics.rectangle("fill", xVal.small, yVal.small, width, height)
		love.graphics.setColor(0, 0, 0, 255)
	end		
end

drawing.objectFunc = function()
	if system.newPress.mouse == "l" then
		temp = {}
		temp = deepcopy( objectList[drawing.objectType] )
		temp.x = X
		temp.y = Y
		table.insert(objects, temp)
		temp = {}
	end
end

drawing.playerSpawn = function()
	if system.newPress.mouse == "l" then
		objects.player.x = X
		objects.player.y = Y
		objects.player.startPlaced = true
	end
	pcall(love.graphics.draw, love.graphics.newImage(objects.player.placeholderAlpha), X, Y)
end

drawing.selection = function()
end



						--[[ 	 Support functions      ]]--

function keyAprooved(key, okay)
	for k,v in pairs(okay) do
		if v == key then
			return true
		end
	end
	return false
end

function print(str, x, y, colour)
	local r, g, b, a = love.graphics.getColor( ) 
	love.graphics.setColorMode("modulate")
	love.graphics.setColor( colour.r, colour.g, colour.b ,colour.a)
	love.graphics.print(str, x, y)
	love.graphics.setColorMode("replace")
	love.graphics.setColor(r, g, b, a)
end

function getnEx (t)
  local max = 0
  for i,k in pairs(t) do
    if type(i) == "number" and i>max then max=i end
  end
  return max
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, _copy(getmetatable(object)))
    end
    return _copy(object)
end

function getDist(a,b)
	return a - b
end

function getBiggest(a,b)
	if(a>b) then
		return {big = a, small = b}
	else
		return {big = b, small = a}
	end
end

function rectOverlap(rect1, rect2)
	if(rect1.x <= rect2.x+rect2.width and rect1.x+rect1.width >= rect2.x and rect1.y <= rect2.y+rect2.height and rect1.y+rect1.height >= rect2.y) then
		return true
	else		
		return false
	end
end
























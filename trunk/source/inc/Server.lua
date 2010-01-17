server = {}
server.object = lube.server(1)
	
lastevnt = 0
time = 0
clientList = {}
function connCallback(ip, port)
	server.object:send("map1.tab")
end

function rcvCallback(data, ip, port)
	infoPack = table.load(data, infoPack)

	if not (duplicateDetect(infoPack, true) == true) then
		table.insert(clientList, infoPack)
	end
end

function disconnCallback(ip, port)
	lastevnt = ip
end

server.object:Init(9090)
server.object:setPing(true, 10, "ping")
server.object:setHandshake("Hi")
server.object:setCallback(rcvCallback, connCallback, disconnCallback)

function love.keypressed(key)
	if key == "q" or key == love.key_escape then
			
	end
end

function love.update(dt)

	server.object:update(dt)
	server.object:checkPing(dt)
	time = time + dt
	if time > 15 then
		server.object:send("LUBE: A smooth experience across the world")
		time = 0
	end
end

function love.draw()
	x = 1
	for i,d in pairs(clientList) do
		if type( d ) == "table" then
			
			love.graphics.setColor(255,213,22)
		love.graphics.print(tostring(d.X), 100, 100)
				love.graphics.rectangle( "fill", d.X, d.Y, 10, 10 ) 
			love.graphics.setColor(255,255,255)
			x = x+1
		end
		love.graphics.print(tostring(temp), 200, 100+(i*35))		
	end
	x = 0
	
end

function duplicateDetect(terminalInfo, overwrite)
	if type( terminalInfo ) == "table" then
		for i,d in pairs(clientList) do
			if terminalInfo.terminalID == d.terminalID then
				if 1 then
					clientList[i] = terminalInfo
				end
				return true
			end
		end
		return false
	end
	return true
end









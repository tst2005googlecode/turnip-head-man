
	temp = {}
	text = ""

	globalDelta = 0
	client = {}
	client.object = lube.client(1)
	
function rcvCallback(data)
	gameInfo = table.load(data)
end
	infoPack = {}
	client.object:setPing(true, 0.1, "ping")
	client.object:setHandshake("Hi")

	if client.object:connect("localhost", 9090, true) == nil then
		networking.gotServer = true
	else
		error("Couldn't connect")
	end
	
	client.object:setCallback(rcvCallback)
	time = 0


networking.updateClient = function(dt)
	client.object:doPing(0.016)
	client.object:update(dt)
	globalDelta = dt
	time = time + 0.01
	if time > 0.01 then
		infoPack.X = objects.player.x
		infoPack.Y = objects.player.y
		infoPack.terminalID = 999999999999999
		client.object:send(table.save(infoPack))
		time = 0
	end
end


client.object = lube.client(1)
time = 0
	function rcvCallback(rawData)
		data = table.load(rawData)
		if data.dataType == 'index' then
			clientID = data.value
		
		end
		
		if data.dataType == 'playerData' then
			clientList = nil
			clientList = data.value
		end	
		
		if data.dataType == 'gameInfo' then
			gameInfo = data.value
		end		
	end

	client.object:setPing(true, 0.1, "ping")
	client.object:setHandshake("Hi")

	if client.object:connect(host, 9090, true) == nil then
		networking.gotServer = true
	else
		error("Couldn't connect")
	end
	
	client.object:setCallback(rcvCallback)

networking.updateClient = function(dt)

	client.object:doPing(0.016)
	client.object:update(dt)
	time = time + dt
	if time > 0.01 then
		client.object:send(table.save({dataType = 'player', clientID = clientID, value = objects.player}))
		time = 0
	end
end


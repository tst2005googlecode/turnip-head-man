
server.object = lube.server(1)
serverObj = server.object
time = 0


networking.objectconnCallback = function(index)
	clientList[index] = {clientID = index }
	serverObj:send(table.save({dataType='index', value = index}), index)	

end

networking.rcvCallback = function(rawData, ip, port)
	data = table.load(rawData)
	--error(tostring(rawData))

	if data.dataType == 'player' and data.clientID and clientList[data.clientID] then
		clientList[data.clientID].clientID = data.clientID
		clientList[data.clientID] = data.value
	end
end

networking.disconnCallback = function(index)
	clientList[index] = nil
end

serverObj:Init(9090)
serverObj:setPing(true, 1, "ping")
serverObj:setHandshake("Hi")
serverObj:setCallback(networking.rcvCallback, networking.objectconnCallback, networking.disconnCallback)


networking.updateClient = function(dt)
	serverObj:update(dt)
	serverObj:checkPing(dt)
	time = time + dt
	if time >0.01 then
		serverObj:send(table.save({dataType='gameInfo', value = gameInfo}))
		serverObj:send(table.save({dataType='playerData', value = clientList}))
		time = 0
	end
end






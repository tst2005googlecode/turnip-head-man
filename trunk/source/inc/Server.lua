clientList = {}
server.object = lube.server(1)
serverObj = server.object
lastevnt = 0
time = 0


networking.objectconnCallback = function(ip, port)
	serverObj:send(table.save(gameInfo))
end

networking.rcvCallback = function(data, ip, port)
	infoPack = table.load(data, infoPack)
end

networking.disconnCallback = function(ip, port)
	lastevnt = ip
end

serverObj:Init(9090)
serverObj:setPing(true, 1, "ping")
serverObj:setHandshake("Hi")
serverObj:setCallback(networking.rcvCallback, networking.objectconnCallback, networking.disconnCallback)


networking.updateClient = function(dt)

	serverObj:update(dt)
	serverObj:checkPing(dt)
	time = time + dt
	if time >0.02 then
		serverObj:send()
		time = 0
	end
end






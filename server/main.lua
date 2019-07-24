function love.load()
	text = ""
	enet = require "enet"
	host = enet.host_create("*:1051")
end

function love.draw()
	love.graphics.print(text)
end

function love.update(dt)
	local event = host:service(100)
	while event do
		if event.type == "connect" then
			text = text .. tostring(event.peer) .. " is connected.\n"
		elseif event.type == "receive" then
			text = text .. tostring(event.peer) .. ": " .. event.data .. "\n"
			host:broadcast(event.data)
		elseif event.type == "disconnect" then
			text = text .. tostring(event.peer) .. " has disconnected.\n"
		end
		event = host:service()
	end
end
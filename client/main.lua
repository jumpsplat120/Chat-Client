function love.load()
	text = ""
	enet = require "enet"
	host = enet.host_create()
	server = host:connect("192.168.1.65:1051")
	input = ""
	love.keyboard.setKeyRepeat(true)
	win = {}
	win.width, win.height, win.flags = love.window.getMode()
end

function love.draw()
	love.graphics.print(text)
	love.graphics.print(input, 0, win.height - 15)
end

function love.update(dt)
	local event = host:service(100)
	while event do
		if event.type == "connect" then
			peer = event.peer
			text = text .. tostring(event.peer) .. " is connected.\n"
		elseif event.type == "receive" then
			text = text .. tostring(event.peer) .. ": " .. event.data .. "\n"
		elseif event.type == "disconnect" then
			text = text .. tostring(event.peer) .. " has disconnected.\n"
			peer = nil
		end
		event = host:service()
	end
end

function love.textinput(text)
	input = input .. text
end

function love.keypressed(key)
    if key == "backspace" then
        local byteoffset = utf8.offset(input, -1)
        if byteoffset then input = string.sub(input, 1, byteoffset - 1) end
    elseif key == "return" then
		peer:send(input)
		input = ""
	end
end
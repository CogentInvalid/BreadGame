require "class"
require "angle"
require "game"

function love.load()

	gameWidth = 800
	gameHeight = 600

	gameMode = game:new()
	mode = gameMode

	--controls
	bind = {}
	bind["left"] = "left"
	bind["right"] = "right"
	bind["down"] = "down"
	bind["jump"] = "z"
end

function love.update(dt)
	mode:update(dt)
end

function love.draw()
	mode:draw(dt)
end

function love.keypressed(key)
	if key == "f1" then mode = gameMode; mode:focus() end
	mode:keypressed(key)
	--arc.set_key(key)
end


--VARIOUS HELPFUL FUNCTIONS BELOW--

function randomSelect(name)
	local rand = {}
	for i=1, table.getn(name) do rand[i] = 1 end
	return weightedRandom(name, rand)
end

function weightedRandom(name, rand)
	local total = 0
	for i=1, table.getn(rand) do
		total = total + rand[i]
	end
	local r = math.random()*total
	local i = 0
	local counter = 0
	while counter < r do
		i = i + 1
		counter = counter + rand[i]
	end
	return name[i]
end

function crash(message) --ghetto debugs yo
	message = message or "crash() called"
	assert(false, message)
end

function round(x,num)
	num = num or 1
	x = x/num
	if x%1 > 0.5 then x = math.ceil(x) else x = math.floor(x) end
	x = x*num
	return x
end

function randSign()
	if math.random(2) == 1 then return -1 else return 1 end
end

function getSign(x)
	if x >= 0 then return 1 else return -1 end
end

function string:split(delimiter) --definitely not stolen from anything else
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end

function mergeTables(t1,t2) --also 100% original
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

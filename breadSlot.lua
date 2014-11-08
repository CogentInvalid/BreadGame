breadSlot = class:new()

function breadSlot:init(type, x, y)
	self.type = type
	self.health = 100
	self.x = x
	self.y = y

	self.die = false
end

function breadSlot:update(dt)
	if self.type ~= "none" then

	end
end

function breadSlot:draw()
	love.graphics.setColor(self.health, self.health, self.health*0.8)
	if self.type == "none" then love.graphics.setColor(50,50,50) end
	love.graphics.rectangle("fill", self.x, self.y, 100, 100)
end

--add bread to breadslot
function game:addBread(breadType)
	local added = false
	for i=1, 3 do
		if breadSlots[4-i].type == "none" and (not added) then
			breadSlots[4-i].type = breadType
			added = true
		end
	end
	if not added then
		--bread couldn't fit. incinerate and auto-eject.
	end
end

function game:updateBreadSlots(dt)
	for i=1, 3 do 
		if breadSlots[i].type ~= "none" then
			breadSlots[i].health = breadSlots[i].health - 10*dt
			if breadSlots[i].health < 0 then
				--kill bread
				p.hp = p.hp + 5
				gameMode:removeBread(i)
			end
		end
		--breadSlots[i]:update(dt)
	end
end

function game:removeBread(num)
	for i=1, num-1 do
		breadSlots[num-i+1].type = breadSlots[num-i].type
		breadSlots[num-i+1].health = breadSlots[num-i].health
		breadSlots[num-i].type = "none"; breadSlots[num-i].health = 100
	end
end
breadSlot = class:new()

function breadSlot:init(type, x, y)
	self.type = type
	self.health = 100
	self.x = x
	self.y = y

	self.img = img["bread-dead-white"]
	self.imgName = "bread-dead-white"

	self.die = false
end

function breadSlot:update(dt)
	if self.type == "breadman" then
		if self.health > 33 then self.imgName = "bread-dead-tan" end
		if self.health > 66 then self.imgName = "bread-dead-white" end
		if self.health < 33 then self.imgName = "bread-dead-black" end
		self.img = img[self.imgName]
	end
end

function breadSlot:draw()
	love.graphics.setColor(255,255,255)
	if self.type ~= "none" then love.graphics.draw(self.img, self.x, self.y, 0, 0.5, 0.5) end
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
			breadSlots[i]:update(dt)
			breadSlots[i].health = breadSlots[i].health - 10*dt
			if breadSlots[i].health < 0 then
				--kill bread
				p:gainHP(5)
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
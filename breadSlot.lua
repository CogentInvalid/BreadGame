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
		self.imgName = "bread-dead-black"
		if self.health > 33 then self.imgName = "bread-dead-brown" end
		if self.health > 55 then self.imgName = "bread-dead-tan" end
		if self.health > 77 then self.imgName = "bread-dead-white" end
		self.img = img[self.imgName]
	end
end

function breadSlot:draw()
	love.graphics.setColor(255,255,255)
	if self.health < 33 then
		animation["fire"]:draw(img["fire"], self.x, self.y, 0, 0.5, 0.5, 0, 0)
	end
	if self.type ~= "none" then love.graphics.draw(self.img, self.x, self.y, 0, 0.5, 0.5) end
end

--add bread to breadslot
function game:addBread(breadType)
	local added = false
	for i=1, 3 do
		if breadSlots[4-i].type == "none" and (not added) then
			breadSlots[4-i].type = breadType
			added = true
			if breadType == "poptart" then
				p.supercharged = true
			end
		end
	end
	if not added then
		--bread couldn't fit. incinerate and auto-eject.
		self:ejectBread()
		self:addBread(breadType)
	end
end

function game:updateBreadSlots(dt)
	for i=1, 3 do 
		if breadSlots[i].type ~= "none" then
			breadSlots[i]:update(dt)
			breadSlots[i].health = breadSlots[i].health - 10*dt
			if breadSlots[i].health < 0 then
				--kill bread
				--p:gainHP(5)
				gameMode:removeBread(i)
				for i=1, 20 do
					self.ash[#self.ash+1] = ash:new()
				end
			end
		end
		--breadSlots[i]:update(dt)
		for i,ashe in ipairs(self.ash) do
			ashe:update(dt)
			if ashe.die then table.remove(self.ash, i); p:gainHP(5*(1/20)) end
		end
	end
end

function game:removeBread(num)
	if breadSlots[num].type == "poptart" then
		p.supercharged = false
	end
	for i=1, num-1 do
		breadSlots[num-i+1].type = breadSlots[num-i].type
		breadSlots[num-i+1].health = breadSlots[num-i].health
		breadSlots[num-i].type = "none"; breadSlots[num-i].health = 100
	end
end
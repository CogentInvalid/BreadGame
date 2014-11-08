require "game"

--this is hacky but it'll work for us
function game:loadLevel(num)
	if num == 1 then
		self:addEnt(platform,{-10, gameHeight-20, gameWidth+20, 40, 1})
		self:addEnt(platform,{150, 460, 150, 20, 2})
		self:addEnt(platform,{gameWidth-300, 460, 150, 20, 3})
		self:addEnt(breadman,{20, gameHeight - 80, false})
		self:addEnt(breadman,{100, gameHeight - 80, false})
	end
end
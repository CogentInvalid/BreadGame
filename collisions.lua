--hopefully obsolete due to bump.lua.

--functions for identifying certain kinds of object.
function isReal(ent)
	return true
end

function isTile(ent)
	return ent.id == "tile"
end

function isntTile(ent)
	return ent.id ~= "tile"
end

function genericCollide(self, collideOrder)
	for n,cond in ipairs(collideOrder) do
		col = collide(self, cond)
		for i=1, #col do
			local dir = col[i][1]
			local entity = col[i][2]
			--do collisions
			self:resolveCollision(entity, dir)
			--for i, comp in ipairs(self.component) do
				--if comp.resolveCollision ~= nil then comp.resolveCollision(self, entity, dir) end
			--end
		end
	end
end

function bumpCollide()
	local singCol = {}; local dubCol = {}; local allCol ={}
	local col = gameMode.world:getCollisions(self)
	for i=1, #col do
		if #col[i][2] > 1 then dubCol[#dubCol+1] = col
			else singCol[#singCol+1] = col end
	end

	--ignore all double collisions as long as there is at least one single collision
	local ignoreDubs = false
	if #singCol > 1 then ignoreDubs = false end

	for i=1, #col do
		if ((not ignoreDubs) or #col[i][2] == 1) and col[i][2][1] ~= "none" then self:resolveCollision(col[i][1], col[i][2][1]) end
	end
end

function collide(e1, cond) --collisions for all the things* (*that are rectangles)
	local all = {}
	local counter = {}
	local cols, len = gameMode.world:queryRect(e1.x-8, e1.y-8, e1.w+16, e1.h+16)
	for i,e2 in ipairs(cols) do
		counter[i] = 0
		if cond(e2) then

			--find collision direction
			if e1.y+e1.h>e2.y and e1.y<e2.y+e2.h then --left/right
				if e1.px+e1.w <= e2.px and e1.x+e1.w > e2.x then --left
					all[i] = ({"left",e2})
					counter[i] = counter[i] + 1
				end
				if e1.px >= e2.px+e2.w and e1.x < e2.x+e2.w then --right
					all[i] = ({"right",e2})
					counter[i] = counter[i] + 1
				end
			end
			if e1.x+e1.w>e2.x and e1.x<e2.x+e2.w then --up/down
				if e1.py+e1.h <= e2.py and e1.y+e1.h > e2.y then --from above
					all[i] = ({"up",e2})
					counter[i] = counter[i] + 1
				end
				if e1.py >= e2.py+e2.h and e1.y < e2.y+e2.h then --below
					all[i] = ({"down",e2})
					counter[i] = counter[i] + 1
				end
			end
			if counter[i] == 0 then --already inside
				if e1.y+e1.h>e2.y and e1.y<e2.y+e2.h and e1.x+e1.w>e2.x and e1.x<e2.x+e2.w then
					all[i] = ({"in",e2})
					counter[i] = counter[i] + 1
				end
			end

		end
	end

	local priority = false
	for i=1, len do
		if counter[i] == 1 then priority = true end
		--ignore all double collisions as long as there is at least one single collision
	end
	local finalCols = {}
	for i=1, len do
		if counter[i] == 1 then finalCols[#finalCols+1] = all[i] end
		if counter[i] > 1 and priority == false then finalCols[#finalCols+1] = all[i] end
	end
	
	return finalCols
end

function oldcollide(num, cond) --collisions for all the things* (*that are rectangles)
	local all = {}
	local counter = {}
	--for i=1, table.getn(ent) do counter[i] = 0 end
	for i,entity in ipairs(rcol) do
		counter[i] = 0
		if rcol[i] ~= 0 then
			if num ~= i and math.abs(ent[num].x-entity.x) < entity.w+ent[num].w and
				math.abs(ent[num].y-entity.y) < entity.h+ent[num].h and cond(entity) then
				if ent[num].y+ent[num].h>entity.y and ent[num].y<entity.y+entity.h then --left/right
					if ent[num].px+ent[num].w <= entity.px and ent[num].x+ent[num].w > entity.x then --left
						all[table.getn(all)+1] = ({"left",i})
						counter[i] = counter[i] + 1 --count how many collisions it has w/a single entect
					end
					if ent[num].px >= entity.px+entity.w and ent[num].x < entity.x+entity.w then --right
						all[table.getn(all)+1] = ({"right",i})
						counter[i] = counter[i] + 1
					end
				end
				if ent[num].x+ent[num].w>entity.x and ent[num].x<entity.x+entity.w then --up/down
					if ent[num].py+ent[num].h <= entity.py and ent[num].y+ent[num].h > entity.y then --from above
						all[table.getn(all)+1] = ({"up",i})
						counter[i] = counter[i] + 1
					end
					if ent[num].py >= entity.py+entity.h and ent[num].y < entity.y+entity.h then --below
						all[table.getn(all)+1] = ({"down",i})
						counter[i] = counter[i] + 1
					end
				end
				if counter[i] == 0 then
					if ent[num].y+ent[num].h>entity.y and ent[num].y<entity.y+entity.h and ent[num].x+ent[num].w>entity.x and ent[num].x<entity.x+entity.w then
						all[table.getn(all)+1] = ({"in",i})
						counter[i] = counter[i] + 1
					end
				end
			end
		end
	end
	local priority = false
	for i=1, table.getn(counter) do
		if counter[i] == 1 then priority = true end
		--ignore all double collisions as long as there is at least one single collision
	end
	local finalCols = {}
	for i=1, table.getn(all) do
		if counter[all[i][2]] == 1 then finalCols[#finalCols+1] = all[i] end
		if counter[all[i][2]] > 1 and priority == false then finalCols[#finalCols+1] = all[i] end
	end
	--ent[num]:collide(finalCols)
	return finalCols
end
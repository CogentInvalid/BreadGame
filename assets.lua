--load all .png files from the "resources/img" folder
--and put them into the table "img"
function loadAssets()
	local imgFiles = love.filesystem.getDirectoryItems("resources/img")

	img = {} --load images from img folder
	for i,name in ipairs(imgFiles) do
		if string.find(name, ".png") then
			name = string.gsub(name, ".png", "")
			img[name] = love.graphics.newImage("resources/img/" .. name .. ".png")
		end
	end

	grid = {}
	animation = {}

	--bread-running
	--150 by 150
	grid["bread-running"] = anim8.newGrid(150, 150, 600, 600)
	animation["bread-running"] = anim8.newAnimation(grid["bread-running"]('1-4','1-4'), 0.04)

end

--this should return an array of quads with each image
--consisting of "name" and then a number
function getAnimation(name, num)
	local quadArray = {}
	for i=1, num do
		local image = img[name .. num]
		--make a quad, add it to quadArray
	end
end
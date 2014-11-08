--load all .png files from the "resources/img" folder and put them into the array "img"
function loadAssets()
	local imgFiles = love.filesystem.getDirectoryItems("resources/img")

	img = {} --load images from img folder
	for i,name in ipairs(imgFiles) do
		if string.find(name, ".png") then
			name = string.gsub(name, ".png", "")
			img[name] = love.graphics.newImage("/img/" .. name .. ".png")
		end
	end
end

--this should return an array of quads with each image
--consisting of "name" and then a number
function getAnimation(name, num)
	return {}
end
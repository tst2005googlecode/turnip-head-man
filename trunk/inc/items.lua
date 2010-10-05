item = {}
items = {}
predefinedItems = {
	coin = {colMap = collision:newCollisionMap('img/items/coinBlock/1.png'), onHit = 'addCoin', image = images.coin}
}


function item:add(index, x, y)
	local toAdd = deepcopy(predefinedItems[index])
		  toAdd.x = x
		  toAdd.y = y
	table.insert(items,toAdd)
end

function item:remove(x)
	x = nil
end

function item:update()
	for i,v in ipairs(items) do
		love.graphics.draw(v.image,v.x,v.y)
	end
end

function item:addCoin()
	player.coins = player.coins + 1
end



function postToURL()


	local j, block = turtle.inspectDown()


	if j then


		local response, message = http.post("https://cedar.fogcloud.org/api/logs/58F4", "line="..block.name)


		if not response then


			print(message)


		end


	end


end





turtle.refuel(64)





for i = 1, 8 do


	postToURL()


	for i = 1, 7 do


		turtle.forward()


		postToURL()


	end


	turtle.turnRight()


	turtle.forward()


	turtle.turnRight()


	postToURL()


	for i = 1, 7 do


		turtle.forward()


		postToURL()


	end


	turtle.turnLeft()


	turtle.forward()


	turtle.turnLeft()


	postToURL()


end

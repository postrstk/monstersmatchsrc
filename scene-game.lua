local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
		-- Your code here

	local sceneGroup = self.view
	display.setStatusBar(display.HiddenStatusBar)
	math.randomseed(os.time())

	local lvl = event.params

	local backgroup = display.newGroup()
	local foregroup = display.newGroup()


	--backgroup.x = display.contentCenterX
	--backgroup.y = display.contentCenterY
	backgroup.x = display.contentCenterX
	backgroup.y = display.contentCenterY

	foregroup.anchorChildren = true
	foregroup.anchorX = 0.5
	foregroup.anchorY = 0.5
	foregroup.x = display.contentCenterX
	foregroup.y = display.contentCenterY + 100

	-- MONSTERS MATRIX --

	local options = {
		bg_size = {w = 720, h = 1280},
		cells_size = 13,
		scale = {small = 5, large = 10},
		path = {monsters = "assets/monsters/three/"}
	}

	local goal = {}
	for i =0, #lvl.goal do
		goal[i] = {}
		goal[i].name = lvl.goal[i].name
		goal[i].count = lvl.goal[i].count
	end


	local goal_name = lvl.goal.name
	local goal_counter = lvl.goal.count

	local condition_counter = lvl.condition.count
	local condition_name = lvl.condition.name
	local timer_on = false

	local rows = 7
	local cols = 5

	local cells = {}
	local empty_cells = {}
	local next_monster = 1

	local nextMonsterField = {}


	-- init UI
	local bg = display.newImageRect(backgroup, "assets/backgrounds/2.png", options.bg_size.w, options.bg_size.h)
	local scoregoup = display.newGroup()
	scoregoup.anchorX = 0.5
	scoregoup.anchorY = 0.5
	scoregoup.x = 170
	scoregoup.y = 140


	local panel = {}
	panel.back = display.newImageRect(backgroup, "assets/backgrounds/upper-panel-"..condition_name..".png", options.cells_size*options.scale.large * 5, 250)
	panel.back.anchorX = 0.5
	panel.back.y = - 500
	panel.back.x = 0

	panel.condition = display.newText(backgroup, condition_counter, 0, 0,"assets/fonts/12243.otf", 60)
	panel.condition.y = -490
	panel.condition.x = -20

	for i=0, #goal do
		goal[i].image = display.newImageRect(backgroup, 
			options.path.monsters..goal[i].name..".png", 80, 80)
		goal[i].text = display.newText(backgroup, 
			goal[i].count, 0, 0, "assets/fonts/12243.otf", 30)

		if(#goal ~= 0) then
			--goal[i].image.x = -260
			--goal[i].image.y = -440 - 100*i

			--goal[i].text.x = -180
			--goal[i].text.y = -440 - 100*i
			goal[i].image.x = -275 + 100*i
			goal[i].image.y = -500

			goal[i].text.x = -275 + 100*i
			goal[i].text.y = -440
		else
			--goal[i].image.x = -260
			--goal[i].image.y = -500

			--goal[i].text.x = -180
			--goal[i].text.y = -500
			goal[i].image.x = -225
			goal[i].image.y = -500

			goal[i].text.x = -225
			goal[i].text.y = -440
		end
	end


	local function end_level( )
		print("end level!")
		local goal_result
		local sum = 0
		for i =0, #goal do
			sum = sum + goal[i].count
		end

		if(condition_name == "timer") then timer_on = false end

		if(sum > 0) then goal_result = "fail" else goal_result = "success" end

		composer.showOverlay("scene-exit", {effect="fade", params = { goal=goal_result}})
	end

	local function dec_goal_counter( index )
		for i = 0, #goal do
			if (goal[i].name == ""..index and goal[i].count > 0) then
				goal[i].count = goal[i].count - 1
				if (goal[i].count > 0) then
					goal[i].text.text = goal[i].count
				else
					goal[i].text.text = "OK"
					end_level()
				end
			end
		end
	end

	local function change_counter_text( )
		panel.condition.text = condition_counter
		print(condition_counter)
	end

	local function dec_condition_counter( )
		if (condition_name == "timer" and not timer_on) then return end
		
		if (condition_counter == 0) then
			end_level()
		else
			condition_counter = condition_counter - 1
			change_counter_text()
		end
	end
	

	if (condition_name == "timer") then
		timer_on = true
		timer.performWithDelay( 1000, dec_condition_counter, 0)
	end
	-- state is: create, grow, placed, hold
	local function display_monster( r, c, state)
		if ("create" == state) then
			cells[r][c].scale = options.scale.small
			cells[r][c].image = display.newImageRect(foregroup, options.path.monsters..cells[r][c].value..".png", options.cells_size, options.cells_size)
			transition.scaleTo(cells[r][c].image, { xScale=cells[r][c].scale, yScale=cells[r][c].scale})
			cells[r][c].image.x = c*options.cells_size * options.scale.large
			cells[r][c].image.y = r*options.cells_size * options.scale.large
		
		elseif ("grow" == state) then
			cells[r][c].scale = options.scale.large
			transition.scaleTo(cells[r][c].image, { xScale=cells[r][c].scale, yScale=cells[r][c].scale})
		
		elseif ("placed" == state) then
			cells[r][c].scale = options.scale.large
			cells[r][c].image = display.newImageRect(foregroup, options.path.monsters..(cells[r][c].value/10)..".png", options.cells_size, options.cells_size)
			transition.scaleTo(cells[r][c].image, { xScale=cells[r][c].scale, yScale=cells[r][c].scale})	
			cells[r][c].image.x = c*options.cells_size * options.scale.large
			cells[r][c].image.y = r*options.cells_size * options.scale.large

		elseif ("hold" == state) then
		end

	end


	local function update_next_monster()
		next_monster = math.random(1, 1)
		if (nextMonsterField.image ~= nil) then
			display.remove(nextMonsterField.image)
		end
		nextMonsterField.image = display.newImageRect(scoregoup, options.path.monsters..next_monster..".png", 180, 180)
		nextMonsterField.image.anchorX = 0.5
		nextMonsterField.image.anchorY = 0.5
		nextMonsterField.image.x = 390
		nextMonsterField.image.y = 15
	end

	---------------------

	local function add_monster( r, c )
		if (cells[r][c].value == 0) then
			cells[r][c].value = next_monster * 10
			display_monster(r, c, "placed")
			update_next_monster()
			return true	
		end
		return false	
	end

	---------------


	local function print_cells( )
		for r = 0, rows - 1 do
			local row = ""
			for c = 0, cols - 1 do
				row = row.." "..cells[r][c].value
			end
			print (row)
		end
	end

	local function grow_monster(r, c )
		display_monster(r, c, "grow")
	end


	local function get_empty_cells( )
		empty_cells = {}
		index = 0
		for r = 0, rows-1 do
			for c = 0, cols - 1 do
				if (cells[r][c].value == 0) then
					empty_cells[index] = {["r"]=r, ["c"]=c}
					index = index + 1
				end
			end
		end
	end

	local function add_big_monster( )
		get_empty_cells()

		local index = math.random(0, #empty_cells)
		local r = empty_cells[index].r
		local c = empty_cells[index].c

		cells[r][c].value = math.random(1,4)*10

		cells[r][c].isbuble = true

		display_monster(r, c, "placed")
	end

	local function add_small_monster( )
		get_empty_cells()

		local index = math.random(0, #empty_cells)
		cells[empty_cells[index].r][empty_cells[index].c].value = math.random(1,5)

		display_monster(empty_cells[index].r, empty_cells[index].c, "create")
	end

	local function init_cells( )
		update_next_monster()
		
		for r = 0, rows - 1 do
			cells[r] = {}
			for c = 0, cols - 1 do
				cells[r][c] = {}
				cells[r][c].value = lvl.field[r][c].value
				cells[r][c].buble = lvl.field[r][c].buble
				cells[r][c].border = lvl.field[r][c].border


				cells[r][c].scale = 1
				cells[r][c].backgrid = display.newImageRect(foregroup, "assets/backgrounds/backgrid.png", 
					options.cells_size * options.scale.large, options.cells_size * options.scale.large)
		
				cells[r][c].backgrid.x = c*options.cells_size * options.scale.large
		    	cells[r][c].backgrid.y = r*options.cells_size * options.scale.large 
		    	
		    	if (cells[r][c].value ~= 0) then display_monster(r, c, "placed") end
		    	
		    	if (cells[r][c].border ~= "") then 
		    		cells[r][c].border_image = display.newImageRect(foregroup, 
		    		"assets/backgrounds/stop_"..cells[r][c].border..".png", 
					options.cells_size * options.scale.large, options.cells_size * options.scale.large)
		    		
		    		cells[r][c].border_image.x = c*options.cells_size * options.scale.large
		    		cells[r][c].border_image.y = r*options.cells_size * options.scale.large 
		    	end 
		    	
			end
		end
	end


	local function remove_monsters( monster )
		display.remove(monster)
	end

	local function shift_monsters( monster )
		transition.scaleTo( monster, { xScale=0.1, yScale=0.1, time=600} )
		transition.to(monster, {x = 100, y = -200, onComplete=remove_monsters, time=600})		
	end

	local function destroy_monsters(r, c)
		transition.scaleTo( cells[r][c].image, { xScale=options.scale.large*1.5, yScale=options.scale.large*1.5, onComplete=shift_monsters } )
	end

	local function to_up( rr, cc )
		local count = 0
		if(cells[rr][cc].border == "top") then return 0 end
		for r = rr - 1, 0, -1 do
			if (cells[rr][cc].value ~= cells[r][cc].value or
				cells[r][cc].border == "bottom") then break end
			count = count + 1
			if(cells[r][cc].border == "top") then return count end
		end
		return count
	end

	local function to_down( rr, cc )
		local count = 0
		if(cells[rr][cc].border == "bottom") then return 0 end
		for r = rr + 1, rows - 1 do
			if (cells[rr][cc].value ~= cells[r][cc].value or
				cells[r][cc].border == "top") then break end
			count = count + 1
			if(cells[r][cc].border == "bottom") then return count end
		end
		return count
	end

	local function to_left( rr, cc )
		local count = 0
		if(cells[rr][cc].border == "left") then return 0 end
		for c = cc - 1, 0, -1 do
			if (cells[rr][cc].value ~= cells[rr][c].value or
				cells[rr][c].border == "right") then break end
			count = count + 1
			if(cells[rr][c].border == "left") then return count end
		end
		return count
	end

	local function to_right( rr, cc )
		local count = 0
		if(cells[rr][cc].border == "right") then return 0 end
		for c = cc + 1, cols - 1 do
			if (cells[rr][cc].value ~= cells[rr][c].value or
				cells[rr][c].border == "left") then break end
			count = count + 1
			if(cells[rr][c].border == "right") then return count end
		end
		return count
	end

	local function to_right_down( rr, cc )
		local count = 0
		local c = cc + 1
		for r = rr + 1, rows - 1 do
			if (c > cols - 1) then break end
			if (cells[rr][cc].value ~= cells[r][c].value) then break end
			count = count + 1
			c = c + 1
		end
		return count
	end

	local function to_left_up( rr, cc )
		local count = 0
		local c = cc - 1
		for r = rr - 1, 0, -1 do
			if (c < 0) then break end
			if (cells[rr][cc].value ~= cells[r][c].value) then break end
			count = count + 1
			c = c - 1
		end
		return count
	end

	local function to_right_up( rr, cc )
		local count = 0
		local c = cc - 1
		for r = rr + 1, rows - 1 do
			if (c < 0) then break end
			if (cells[rr][cc].value ~= cells[r][c].value) then break end
			count = count + 1
			c = c - 1
		end
		return count
	end

	local function to_left_down( rr, cc )
		local count = 0
		local c = cc + 1
		for r = rr - 1, 0, -1 do
			if (c > cols - 1) then break end
			if (cells[rr][cc].value ~= cells[r][c].value) then break end
			count = count + 1
			c = c + 1
		end
		return count
	end

	local function match( ... )
		local exp_cells = {}

		for r = 0, rows - 1 do
			exp_cells[r] = {}
			for c = 0, cols - 1 do
				exp_cells[r][c] = {["value"]=cells[r][c].value}
			end
		end

		for r = 0, rows - 1 do
			for c = 0, cols - 1 do			
				exp_cells[r][c].left = to_left(r,c)
				exp_cells[r][c].right = to_right(r,c)
				exp_cells[r][c].up = to_up(r,c)
				exp_cells[r][c].down = to_down(r,c)
				exp_cells[r][c].left_up = to_left_up(r,c)
				exp_cells[r][c].right_down = to_right_down(r,c)
				exp_cells[r][c].left_down = to_left_down(r,c)
				exp_cells[r][c].right_up = to_right_up(r,c)

				if (exp_cells[r][c].value ~= 0 and
					(exp_cells[r][c].left + exp_cells[r][c].right >= 2 or
					exp_cells[r][c].up + exp_cells[r][c].down >= 2 or
					exp_cells[r][c].left_up + exp_cells[r][c].right_down >= 2 or
					exp_cells[r][c].left_down + exp_cells[r][c].right_up >= 2 )) then
					
					exp_cells[r][c].is_matched = true
				else
					exp_cells[r][c].is_matched = false
				end
			end
		end

		for r = 0, rows - 1 do
			for c = 0, cols - 1 do
				if(exp_cells[r][c].is_matched) then
					dec_goal_counter(cells[r][c].value/10)
					destroy_monsters(r, c)
					cells[r][c].value = 0
				end
			end
		end


	end

	local function grow( ... )
		for r = 0, rows - 1 do
			for c = 0, cols - 1 do
				if(cells[r][c].value < 10 ) then
					cells[r][c].value = cells[r][c].value * 10
					grow_monster(r, c)
				end
		    end
	    end
	end



	--foregroup:addEventListener( "tap", add_monster )
	---------------------
	local function game_loop( event )
		
		local c = event.target.x / (options.cells_size * options.scale.large)
		local r = event.target.y / (options.cells_size * options.scale.large)

		print(r.." "..c)

		if(add_monster(r, c)) then
			--
			--todo
			--match()
			--
			
			grow()

			match()
			if (condition_name == "steps") then
				dec_condition_counter()
				if (condition_counter == 0) then
					end_level()
				end
			end
			
			get_empty_cells()
			if (#empty_cells < 2) then 
				end_level()
			end 

			add_small_monster()
		end
	end

	local function main(  )
		init_cells()
		for r = 0, rows - 1 do
			for c = 0, cols - 1 do
				cells[r][c].backgrid:addEventListener("tap", game_loop)
		    end
	    end
	end

	main()
	

	local button_back = display.newText(backgroup, "<--", 0, 0,"assets/fonts/12243.otf", 70)
	button_back.x = 270
	button_back.y = 600
	button_back:addEventListener("tap", function () 
		composer.showOverlay("scene-exit", 
			{effect="fade", params = { goal="fail"}}) end)


	
	sceneGroup:insert(backgroup)
	sceneGroup:insert(foregroup)
	sceneGroup:insert(scoregoup)
end

function scene:hide( event )
	
end

function scene:destroy( event )
	composer.hideOverlay( "fromBottom")
end

scene:addEventListener("create", scene)
return scene
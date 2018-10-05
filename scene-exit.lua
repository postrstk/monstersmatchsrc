local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view

	local backgroup = display.newGroup()
	backgroup.x = display.contentCenterX
	backgroup.y = display.contentCenterY

	print("assets/backgrounds/filler_"..event.params.goal..".png")
	local bg = display.newImageRect(backgroup, "assets/backgrounds/filler_"..event.params.goal..".png", 720, 1280)

	backgroup:addEventListener("tap", function ( )
		composer.hideOverlay( "fromBottom",1)
		composer.removeScene("scene-game")
		return composer.gotoScene("scene-menu", {effect="slideRight", params={coins=total_score}})
	end)
	sceneGroup:insert(backgroup)
end

function scene:show( event )
	-- body
end

function scene:hide( event )
	-- body
end

function scene:destroy( event )
	-- body
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	-- body
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
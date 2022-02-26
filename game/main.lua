requirements = {"flags", "coreLibrary", "boardClass"} -- ORDER MATTERS!
modules = {}
for _, name in ipairs(requirements) do
    modules[name] = require("code/"..name)
end

board.create({pos={x=20,y=20}})


function love.draw()
    board.render()
end
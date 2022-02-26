requirements = {"flags", "coreLibrary", "boardClass", "pieceClass", "tetrisStuff"} -- ORDER MATTERS!
modules = {}
for _, name in ipairs(requirements) do
    modules[name] = require("code/"..name)
end



function love.load()
    core.loadSkin("default")

    -- b1 = board.create({pos={x=250,y=350}, controller="keyboard", scale = 1.3, seed = 1, gravity = 1/2})
    -- b2 = board.create({pos={x=650,y=350}, controller="keyboard", scale = 0.75, seed = 2, gravity = 1/3})
    -- b1.newPiece()
    -- b2.newPiece()

    for x = 1, 10 do
        for y = 1, 6 do
            local b = board.create({pos={x=x*120,y=y*150}, controller="keyboard", scale = 0.3, seed = y*x, gravity = 1/x*y})
            b.newPiece()
        end
    end
end

function love.draw()
    board.render()
end

function love.update(dt)
    board.update(dt)
end
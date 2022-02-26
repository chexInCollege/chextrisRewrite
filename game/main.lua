requirements = {"flags", "coreLibrary", "controller", "boardClass", "pieceClass", "tetrisStuff"} -- ORDER MATTERS!
modules = {}
for _, name in ipairs(requirements) do
    modules[name] = require("code/"..name)
end


local myBoard
function love.load()
    core.loadSkin("default")

    -- b1 = board.create({pos={x=250,y=350}, controller="keyboard", scale = 1.3, seed = 1, gravity = 1/2})
    -- b2 = board.create({pos={x=650,y=350}, controller="keyboard", scale = 0.75, seed = 2, gravity = 1/3})
    -- b1.newPiece()
    -- b2.newPiece()

    --[[for x = 1, 10 do
        for y = 1, 6 do
            local b = board.create({pos={x=x*120,y=y*150}, controller="keyboard", scale = 0.3, seed = y*x, gravity = 1/x*y})
            b.newPiece()
        end
    end]]

    --[[myBoard = board.create({
        pos = {x = 400,y = 355},
        control = controller.inputs.keyboard,
        scale = 1.15,
        -- seed = 1,
        gravity = 1/5,
        controls = tData.defaultControls
    })
    myBoard.newPiece()]]



    for x = 1, 10 do
        for y = 1, 10 do
        local myBoard2 = board.create({
            pos={x = x * 70,y = y * 80},
            control=controller.inputs.keyboard,
            scale = 0.15,
            seed = 1,
            gravity = 1/5,
            controls = tData.defaultControls
        })
        myBoard2.newPiece()
        end
    end
end

function love.draw()
    board.render()
end

function love.update(dt)
    board.update(dt)
end

function love.keypressed(input)
    controller.inputs.keyboard.pressed(input)
end

function love.keyreleased(input)
    controller.inputs.keyboard.released(input)
end


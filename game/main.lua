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

    myBoard = board.create({
        pos = {x = 1000,y = 755},
        control = controller.inputs.keyboard,
        scale = 1,
        -- seed = 1,
        gravity = 1/2,
        controls = tData.defaultControls,
        handling = tData.defaultHanding,

    })

    myBoard.newPiece()--]]

    myBoard = board.create({
        pos = {x = 400,y = 355},
        control = controller.inputs.keyboard,
        scale = 1.15,
        -- seed = 1,
        gravity = 1/2,
        controls = tData.defaultControls,
        handling = tData.defaultHanding,

    })

    myBoard.newPiece()--]]
--[[for x = 1, 10 do
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
    end--]]
end

function love.draw()
    board.render()
end

function love.update(dt)
    core.sWidth, core.sHeight = lg.getDimensions()
    myBoard.controller = controller.inputs["GP-1"] and controller.inputs["GP-1"] or myBoard.controller
    board.update(dt)
    myBoard.debug({
        lockProg = myBoard.activePiece.lockProgress,
        resetRotations = myBoard.activePiece.resetRotations,
        arrProg = myBoard.activePiece.arrProg,
        dasProg = myBoard.activePiece.dasProg,
        rotation = myBoard.activePiece.rotation,
        x = myBoard.activePiece.pos.x,
        y = myBoard.activePiece.pos.y,
    })
    --- temp stuff for testing
    --myBoard.scale = core.sHeight/board.canvasSize.y
    --myBoard.pos = {x = core.sWidth/2, y = core.sHeight/2}
end

function love.keypressed(input)
    controller.inputs.keyboard.pressed(input)
end

function love.keyreleased(input)
    controller.inputs.keyboard.released(input)
end



core.joystickCount = 0
core.joySlots = {false, false, false, false, false, false, false, false}
function love.joystickadded(joystick)
    local success, err = pcall(function()
        local freeSlot = core.find(core.joySlots, false)
        freeSlot = freeSlot and freeSlot or #core.joySlots+1

        core.joySlots[freeSlot] = joystick
        core.joystickCount = core.joystickCount + 1
        core.kbInput = controller.create("GP-" .. tostring(freeSlot))
        print(joystick:getName() .. ": " .. tostring(freeSlot))
    end)

    if not success then
        print("Issue adding controller: " .. tostring(err))
    end
end


function love.joystickremoved(joystick)
    local success, err = pcall(function()
        local joystickID = core.reverseLookup(core.joySlots, joystick)
        core.joySlots[joystickID] = false
        core.joystickCount = core.joystickCount - 1
        controller.inputs["GP-" .. tostring(joystickID)].release()
        print(joystick:getName() .. " disconnected (" .. tostring(joystickID) .. ")")
    end)

    if not success then
        print("Issue removing controller: " .. tostring(err))
    end
end

function love.gamepadpressed(joystick, button)
    local success, err = pcall(controller.inputs["GP-"..tostring(core.reverseLookup(core.joySlots, joystick))].pressed, "B" .. button)
    if not success then
        print("Error pressing button on GP-"..tostring(core.reverseLookup(core.joySlots, joystick)) .. ": " .. tostring(err))
    else
        print("GP-" .. tostring(core.reverseLookup(core.joySlots, joystick)), button)
    end
end
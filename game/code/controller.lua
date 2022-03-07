controller = {
    members = {},
    inputs = {}
}

--- Naming conventions:
--- "keyboard": standard keyboard object
--- "GP-" prefix: gamepad object
--- "B-" prefix: bot player

function controller.create(name, attributes)
    local newController = {
        input = name,
    }

    if attributes then
        for key, attribute in pairs(attributes) do
            newController[key] = attribute
        end
    end

    function newController.release()

    end



    function newController.pressed(input)
        for _, board in pairs(board.members) do
            if board.controller == name then
                local translatedControl = board.controls[input]

                if translatedControl then
                    board.activePiece.fireInput(translatedControl)
                end
            end
        end
    end



    function newController.released(input)
        for _, board in pairs(board.members) do
            if board.controller == name then
                local translatedControl = board.controls[input]

                if translatedControl then
                    board.activePiece.releaseInput(translatedControl)
                end
            end
        end
    end

    function newController.isDown(translatedControl)
        for _, board in pairs(board.members) do
            if board.controller == name then
                if name == "keyboard" then
                    local tControls = core.clone(board.controls)
                    local input

                    repeat
                        input = core.reverseLookup(tControls, translatedControl)
                        tControls[input] = nil
                    until input:sub(1,2) ~= "B_"
                    return love.keyboard.isDown(input)
                else
                    local tControls = core.clone(board.controls)
                    local input

                    repeat
                        input = core.reverseLookup(tControls, translatedControl)
                        tControls[input] = nil
                    until input:sub(1,2) == "B_"


                end
            end
        end
    end

    controller.inputs[name] = newController
    return newController
end

core.kbInput = controller.create("keyboard")


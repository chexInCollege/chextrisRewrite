controller = {
    members = {},
    inputs = {}
}

function controller.create(name, attributes)
    local newController = {
        input = name,
    }

    if attributes then
        for key, attribute in pairs(attributes) do
            newController[key] = attribute
        end
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
                local input = core.reverseLookup(board.controls, translatedControl)

                if name == "keyboard" then
                    return love.keyboard.isDown(input)
                else
                    --- other controller
                end
            end
        end
    end

    controller.inputs[name] = newController
    return newController
end

core.kbInput = controller.create("keyboard")
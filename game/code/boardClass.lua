board = {
    members = {}, -- storing all the pointers
    canvasSize = {x = 400, y = 600}
}

function board.generateGrid()
    local out = {}
    for y = 1, 25 do
        local yOut = {}
        for x = 1, 10 do
            yOut[x] = 0
        end
        out[y] = yOut
    end
    return out
end

--- possible attributes:
--- id
--- playerName
--- pos
--- controls and handling (probably)
function board.create(attributes)
    attributes = attributes and attributes or {}
    local newBoard = {
        pos = {x = 0, y = 0},
        playerName = "Guest",
        canvas = love.graphics.newCanvas(board.canvasSize.x, board.canvasSize.y),
        id = #board.members+1,
        grid = board.generateGrid()
    }

    -- assign any bonus attributes
    for key, attribute in pairs(attributes) do
       newBoard[key] = attribute
    end

    function newBoard.destroy()
        board.members[newBoard.id] = nil
        newBoard = nil
    end

    -- Updates the canvas.
    function newBoard.draw()
        love.graphics.setCanvas(newBoard.canvas)
        love.graphics.clear()

        if flags.canvasBorders then
            love.graphics.rectangle("line", 0, 0, 400, 500)
        end

        -- y=1 in the player grid is the bottom of the board.
        -- x=1 in the player grid is the left of the board.
        for y, row in ipairs(newBoard.grid) do
            for x, value in ipairs(row) do
                -- we'll do something here
            end
        end

        love.graphics.setCanvas()
    end

    table.insert(board.members, newBoard.id, newBoard)

    return newBoard
end

function board.render()
    for id, cBoard in pairs(board.members) do
        cBoard.draw()
        love.graphics.draw(cBoard.canvas, cBoard.pos.x, cBoard.pos.y)
    end
end
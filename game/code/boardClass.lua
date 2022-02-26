board = {
    members = {}, -- storing all the pointers
    canvasSize = {x = 400, y = 600}
}

function board.generateGrid()
    local out = {}
    for y = 1, 20 do
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
    math.randomseed(os.time())
    attributes = attributes and attributes or {}
    local newBoard = {
        pos = {x = 0, y = 0},
        playerName = "Guest",
        canvas = love.graphics.newCanvas(board.canvasSize.x, board.canvasSize.y),
        id = #board.members+1,
        grid = board.generateGrid(),
        controller = "keyboard",
        scale = 1,
        seed = math.random(9999999999),
        tetromino = c.img.basicMino,
        activePiece = false,
        gravity = 1/2
    }

    -- assign any bonus attributes
    for key, attribute in pairs(attributes) do
       newBoard[key] = attribute
    end

    math.randomseed(newBoard.seed) -- seed the bags
    newBoard.bag = tData.newBag(100) -- 100 iterations of the seeded bag
    print(newBoard.bag)
    function newBoard.destroy()
        board.members[newBoard.id] = nil
        newBoard = nil
    end

    -- Adds a new active piece.
    function newBoard.newPiece(id)
        if not id then
            id = tonumber(newBoard.bag:sub(1,1))
            newBoard.bag = newBoard.bag:sub(2, #newBoard.bag)
        end



        newBoard.activePiece = piece.create(id, newBoard)
    end

    function newBoard.update(dt)
        if newBoard.activePiece then
            newBoard.activePiece.update(dt)
        end
    end

    -- Updates the canvas.
    function newBoard.draw()
        love.graphics.setCanvas(newBoard.canvas)
        love.graphics.clear()

        -- y=1 in the player grid is the bottom of the board.
        -- x=1 in the player grid is the left of the board.

        lg.setColor(1,1,1,0.8)
        for y, row in ipairs(newBoard.grid) do
            for x, value in ipairs(row) do
                lg.push()
                core.draw(
                        c.img.emptySlot,
                        75 + x * 20, 450 - y * 20,
                        0,
                        20, 20,
                        "left", "top"
                )
                lg.pop()
            end
        end


        if newBoard.activePiece then
            newBoard.activePiece.draw()
            lg.push()
            lg.setColor(1,1,1,1)
            core.draw(newBoard.activePiece.canvas,
                    75 + newBoard.activePiece.pos.x * 20,
                    450 - newBoard.activePiece.pos.y * 20, 0,
                    nil, nil,
                    "left", "top"
                    )
            lg.pop()
        end

        if flags.canvasBorders then
            love.graphics.rectangle("line", 0, 0, 400, 500)
        end

        love.graphics.setCanvas()
    end

    table.insert(board.members, newBoard.id, newBoard)

    return newBoard
end

function board.render()
    for id, cBoard in pairs(board.members) do
        cBoard.draw()
        lg.push()
        lg.setColor(1,1,1,1)
        core.draw(cBoard.canvas, cBoard.pos.x, cBoard.pos.y, 0, board.canvasSize.x * cBoard.scale, board.canvasSize.y * cBoard.scale, "center", "center")
        lg.pop()
    end
end

function board.update(dt)
    for id, cBoard in pairs(board.members) do
        cBoard.update(dt)
    end
end
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
        objectType = "Board",
        pos = {x = 0, y = 0},
        lockTime = 1,
        playerName = "Guest",
        stats = {},
        canvas = love.graphics.newCanvas(board.canvasSize.x, board.canvasSize.y),
        id = #board.members+1,
        grid = board.generateGrid(),
        controller = "keyboard",
        scale = 1,
        seed = math.random(9999999999),
        tetromino = c.img.basicMino,
        activePiece = false,
        ghostPiece = false,
        heldPiece = false,
        justHeld = false,
        gravity = 1/2,
        nextQueue = {},
        nextLength = 5,
        controls = tData.defaultControls,
        handling = tData.defaultHandling,
        backPieceColor = {155/255, 79/255, 255/255},
        clock = 0,
    }


    -- assign any bonus attributes
    for key, attribute in pairs(attributes) do
       newBoard[key] = attribute
    end


    math.randomseed(newBoard.seed) -- seed the bags
    newBoard.bag = tData.newBag(100) -- 100 iterations of the seeded bag


    -- generate next queue (initial run as well)
    function newBoard.generateNext()
        newBoard.nextQueue = core.cleanTable(newBoard.nextQueue)
        for i = #newBoard.nextQueue+1, newBoard.nextLength do
            table.insert(newBoard.nextQueue, piece.create(tonumber(newBoard.bag:sub(i+1, i+1)), nil, {tetromino = newBoard.tetromino}))
        end
    end
    newBoard.generateNext() -- generates initial next queue

    function newBoard.debug(vals)
        newBoard.stats = vals
    end

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
        newBoard.ghostPiece = piece.create(id, newBoard, {ghost=true})

        newBoard.checkForLines()

        return newBoard.activePiece
    end

    function newBoard.checkForLines()
        local marks = {}
        for y, row in pairs(newBoard.grid) do
            y = y - #marks
            local req = 0 -- counts to width of the board
            for x, value in pairs(row) do
                req = req + (value ~= 0 and 1 or 0)
            end
            if req >= #row then
                table.insert(marks, y)
            end
        end

        for _, key in pairs(marks) do
            table.remove(newBoard.grid, key)
        end
        while #newBoard.grid < 20 do
            table.insert(newBoard.grid, {0,0,0,0,0,0,0,0,0,0})
        end

        newBoard.grid = core.cleanTable(newBoard.grid)
    end

    function newBoard.lockPiece(id, keep)
        if keep ~= false then
            for y, row in ipairs(newBoard.activePiece.matrix) do
                for x, value in ipairs(row) do
                    if value ~= 0 then
                        local matrixX = (newBoard.activePiece.pos.x + (x-1))
                        local matrixY = (newBoard.activePiece.pos.y - (y-1))

                        newBoard.grid[matrixY][matrixX] = newBoard.activePiece.matrix[y][x]
                    end
                end
            end
        end
        if not id then
            newBoard.nextQueue[1] = nil
            newBoard.nextQueue = core.cleanTable(newBoard.nextQueue)
            newBoard.generateNext()
        end

        return newBoard.newPiece(id)
    end

    function newBoard.update(dt)
        newBoard.clock = newBoard.clock + dt

        if newBoard.activePiece then
            newBoard.activePiece.update(dt)
        end

        if newBoard.ghostPiece then
            newBoard.ghostPiece.pos = core.clone(newBoard.activePiece.pos)
            newBoard.ghostPiece.matrix = newBoard.activePiece.matrix
            local success
            repeat
                success = newBoard.ghostPiece.move(0,-1)
            until success == false
        end
    end

    -- Updates the canvas.
    function newBoard.draw()
        love.graphics.setCanvas(newBoard.canvas)
        love.graphics.clear()

        -- y=1 in the player grid is the bottom of the board.
        -- x=1 in the player grid is the left of the board.


        for y, row in ipairs(newBoard.grid) do
            for x, value in ipairs(row) do
                lg.push()
                lg.setColor(1,1,1,0.8)
                core.draw(
                        c.img.emptySlot,
                        75 + x * 20, 450 - y * 20,
                        0,
                        20, 20,
                        "left", "top"
                )
                lg.pop()

                if value > 0 then
                    lg.push()
                    lg.setColor(1,1,1)
                    lg.rectangle("fill", 75 + x * 20, 450 - y * 20, 20, 20)
                    lg.pop()

                    lg.push()
                    lg.setColor(tData.pieceColors[value][1], tData.pieceColors[value][2], tData.pieceColors[value][3])
                    core.draw(
                            newBoard.tetromino,
                            75 + x * 20, 450 - y * 20,
                            0,
                            20, 20,
                            "left", "top"
                    )
                    lg.pop()
                end

            end
        end

        -- held piece lol!
        if newBoard.heldPiece then
            newBoard.heldPiece.draw()
            lg.push()
            lg.setColor(1,1,1)
            core.draw(newBoard.heldPiece.canvas,
                    50, 50, 0,
                    nil, nil,
                    "center", "center"
            )
            lg.pop()
        end

        -- next queue lol!
        for pos, p in pairs(newBoard.nextQueue) do
            p.draw()
            core.draw(p.canvas,
            340, 50+pos*60, 0,
            nil, nil,
            "center", "center")
        end

        -- active piece lol!
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

        -- ghost piece lol!
        if newBoard.ghostPiece then
            newBoard.ghostPiece.draw(c.img.ghostPiece, true)
            lg.push()
            lg.setColor(1,1,1,1)
            core.draw(newBoard.ghostPiece.canvas,
                    75 + newBoard.ghostPiece.pos.x * 20,
                    450 - newBoard.ghostPiece.pos.y * 20, 0,
                    nil, nil,
                    "left", "top"
            )
            lg.pop()
        end

        if flags.canvasBorders then
            love.graphics.rectangle("line", 0, 0, 400, 500)
        end

        local cnt = 0
        for _, _ in pairs(newBoard.stats) do
            cnt = cnt + 1
        end

        if cnt > 0 then
            local out = ""
            for k, v in pairs(newBoard.stats) do
                out = out .. core.tostring(k) .. ": " .. core.tostring(v) .. "\n"
            end

            lg.push()
            lg.setColor(0,0,0,0.5)
            lg.rectangle("fill", 0, 0, board.canvasSize.x, board.canvasSize.y/3)
            lg.pop()
            lg.push()
            lg.setColor(1,1,1)
            lg.print(out)
            lg.pop()
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


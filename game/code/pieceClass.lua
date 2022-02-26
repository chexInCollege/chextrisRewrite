piece = {

}

function piece.create(id, cBoard, attributes)
    local newPiece = {
        matrix = tData.pieces[id],
        id = id,
        pos = {x=4, y=20},
        color = tData.pieceColors[id],
        canvas = lg.newCanvas(20 * #tData.pieces[id], 20 * #tData.pieces[id]),
        tetromino = cBoard and cBoard.tetromino or false,
        parent = cBoard and cBoard or false,
        control = controller.inputs.keyboard,
        gravity = cBoard and cBoard.gravity or false,
        gravityProg = 0,

    }

    if attributes then
        for key, attribute in pairs(attributes) do
            newPiece[key] = attribute
        end
    end

    if cBoard then
        function newPiece.fireInput(input)
            --print(input)
        end

        function newPiece.releaseInput(input)
            --print(input .. " no more")
        end

        function newPiece.checkInput(translatedControl)
            return newPiece.control.isDown(translatedControl)
        end

        function newPiece.checkCollision(b) -- true if no collision, false if collides
            b = b and b or newPiece.parent

            for y, row in ipairs(newPiece.matrix) do
                for x, value in ipairs(row) do
                    if value ~= 0 then
                        local matrixX = newPiece.pos.x + (x-1)
                        local matrixY = newPiece.pos.y - (y-1)

                        if not b.grid[matrixY] or not b.grid[matrixY][matrixX] or b.grid[matrixY][matrixX] ~= 0 then
                            return false
                        end
                    end
                end
            end
            return true
        end

        function newPiece.move(dx, dy)
            local success = true
            newPiece.pos.x = newPiece.pos.x + dx
            newPiece.pos.y = newPiece.pos.y + dy

            if not newPiece.checkCollision() then
                newPiece.pos.x = newPiece.pos.x - dx
                newPiece.pos.y = newPiece.pos.y - dy
                success = false
            end

            if not newPiece.checkCollision() then
                --- bad
            end

            return success
        end

        function newPiece.update(dt)
            -- affect gravity
            newPiece.gravityProg = newPiece.gravityProg + dt

            if newPiece.gravityProg >= newPiece.gravity then
                newPiece.gravityProg = newPiece.gravityProg - newPiece.gravity
                local success = newPiece.move(0,-1)
                if not success then
                    newPiece.parent.lockPiece()
                end
            end

            if newPiece.checkInput("left") then
                newPiece.move(-1,0)
            end
            if newPiece.checkInput("right") then
                newPiece.move(1,0)
            end

        end
    end

    function newPiece.draw()
        local oldCanvas = lg.getCanvas()
        love.graphics.setCanvas(newPiece.canvas)
        love.graphics.clear()

        for y, row in pairs(newPiece.matrix) do
            for x, val in pairs(row) do
                if val > 0 then
                    lg.push()
                    lg.setColor(1,1,1)
                    lg.rectangle("fill", (x-1) * 20, (y-1) * 20, 20, 20)
                    lg.pop()

                    lg.push()
                    lg.setColor(newPiece.color[1],newPiece.color[2],newPiece.color[3])
                    core.draw(
                            newPiece.tetromino,
                            (x-1) * 20, (y-1) * 20,
                            0,
                            20, 20,
                            "left", "top"
                    )
                    lg.pop()
                end
            end

        end

        love.graphics.setCanvas(oldCanvas)
    end

    return newPiece
end
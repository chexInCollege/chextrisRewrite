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
        dasProg = 0,
        direction = "none",
        arrProg = 0,
        rotation = 0,
    }

    if attributes then
        for key, attribute in pairs(attributes) do
            newPiece[key] = attribute
        end
    end

    if cBoard then
        function newPiece.fireInput(input)
            --print(input)

            if input == "rotateCW" then
                newPiece.rotate("CW")
            elseif input == "rotateCCW" then
                newPiece.rotate("CCW")
            elseif input == "rotate180" then
                newPiece.rotate("180")
            end

            if input == "hardDrop" then
                repeat
                    success = newPiece.move(0,-1)
                until not success
                newPiece.release()
            end

            if input == "hold" and not newPiece.parent.justHeld then
                if newPiece.parent.heldPiece then
                    newPiece.parent.activePiece = newPiece.parent.heldPiece
                else
                    newPiece.release(false)
                end
                newPiece.parent.heldPiece = piece.create(newPiece.id, newPiece.parent)
                newPiece.parent.justHeld = true
            end

            if input == "left" or input == "right" then
                newPiece.dasProg = 0
                if input == "left" then
                    newPiece.move(-1, 0)
                else
                    newPiece.move(1, 0)
                end
            end
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

        function newPiece.rotate(direction) --- "CW", "CCW", "180"
            direction = direction and direction or "CW"
            local oldRot = newPiece.rotation
            local wallKickListId = (1+newPiece.rotation*2) + (direction == "CW" and 0 or 1) -- man i'm good



            if direction == "CW" then
                newPiece.matrix = tData.rotateCW(newPiece.matrix)
                newPiece.rotation = newPiece.rotation + 1
            elseif direction == "CCW" then
                newPiece.matrix = tData.rotateCCW(newPiece.matrix)
                newPiece.rotation = newPiece.rotation - 1
            elseif direction == "180" then
                newPiece.matrix = tData.rotateCW(tData.rotateCW(newPiece.matrix))
                newPiece.rotation = newPiece.rotation + 2
            end

            newPiece.rotation = newPiece.rotation % 4 -- lock rotation to [0, 3]

            local ogPos = core.clone(newPiece.pos)
            local wallKicks = tData.wallKickRef[newPiece.id][wallKickListId]
            local success
            for _, check in ipairs(wallKicks) do
                newPiece.pos = {x=ogPos.x+check[1], y=ogPos.y+check[2]}
                success = newPiece.checkCollision()
                if success then break end
            end

            if not success then
                newPiece.pos = ogPos
                if direction == "CCW" then
                    newPiece.matrix = tData.rotateCW(newPiece.matrix)
                    newPiece.rotation = newPiece.rotation + 1
                elseif direction == "CW" then
                    newPiece.matrix = tData.rotateCCW(newPiece.matrix)
                    newPiece.rotation = newPiece.rotation - 1
                elseif direction == "180" then
                    newPiece.matrix = tData.rotateCW(tData.rotateCW(newPiece.matrix))
                    newPiece.rotation = newPiece.rotation + 2
                end
                newPiece.rotation = newPiece.rotation % 4 -- lock rotation to [0, 3]
            end

            return success
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

        function newPiece.release(keep)
            local nextPiece = newPiece.parent.lockPiece(nil, keep)
            nextPiece.dasProg = newPiece.dasProg
            nextPiece.arrProg = newPiece.arrProg -- inherit velocity on next piece
            newPiece.parent.justHeld = false
        end

        function newPiece.update(dt)
            -- affect gravity
            newPiece.gravityProg = newPiece.gravityProg + dt

            if newPiece.gravityProg < newPiece.gravity/20*19 and newPiece.checkInput("softDrop") then
                newPiece.gravityProg = newPiece.gravity/20*19
            end

            if newPiece.gravityProg >= newPiece.gravity then
                local success
                repeat
                    newPiece.gravityProg = newPiece.gravityProg - newPiece.gravity * (newPiece.checkInput("softDrop") and 1/20 or 1)
                    success = newPiece.move(0,-1)
                until newPiece.gravityProg < newPiece.gravity
                if not success then
                    --newPiece.release()
                end
            end




            if newPiece.checkInput("left") or newPiece.checkInput("right") then
                newPiece.dasProg = newPiece.dasProg + dt
            else
                newPiece.dasProg = 0
            end

            if newPiece.checkInput("left") and newPiece.dasProg > newPiece.parent.handling.das then
                newPiece.direction = "left"
                newPiece.arrProg = newPiece.arrProg + dt
            end
            if newPiece.checkInput("right") and newPiece.dasProg > newPiece.parent.handling.das then
                newPiece.direction = "right"
                newPiece.arrProg = newPiece.arrProg + dt
            end

            if newPiece.arrProg >= newPiece.parent.handling.arr then
                newPiece.arrProg = newPiece.arrProg - newPiece.parent.handling.arr
                local delta = newPiece.direction == "right" and 1 or -1
                newPiece.move(delta,0)
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
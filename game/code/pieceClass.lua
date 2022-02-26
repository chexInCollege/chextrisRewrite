piece = {

}

function piece.create(id, cBoard, attributes)
    local newPiece = {
        matrix = tData.pieces[id],
        id = id,
        pos = {x=4, y=20},
        color = tData.pieceColors[id],
        canvas = lg.newCanvas(20 * #tData.pieces[id], 20 * #tData.pieces[id]),
        tetromino = cBoard.tetromino,
        parent = cBoard,

        gravity = cBoard.gravity,
        gravityProg = 0,

    }

    function newPiece.move(dx, dy)
        newPiece.pos.x = newPiece.pos.x + dx
        newPiece.pos.y = newPiece.pos.y + dy
    end

    function newPiece.update(dt)
        newPiece.gravityProg = newPiece.gravityProg + dt

        if newPiece.gravityProg >= newPiece.gravity then
            newPiece.gravityProg = newPiece.gravityProg - newPiece.gravity
            newPiece.move(0,-1)
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
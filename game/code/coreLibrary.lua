--- global game tables
core = {
    sfxVolume = 1,
    musicVolume = 0.5,

    fontSize = 16,
}
c = core

--- love2d constants
lfs = love.filesystem
lg = love.graphics
ls = love.system
lw = love.window
lk = love.keyboard
le = love.event


------------------------ 'core' variables
-- determine the window size
core.sWidth, core.sHeight = lg.getDimensions()


core.img = {}
core.imagePointers = {
    emptySlot = "emptySlot.png",
    basicMino = "basicMino.png",
    ghostPiece = "ghostPiece.png",
}

core.snd = {}
core.soundPointers = {

}

function core.clone( Table, Cache ) -- Makes a deep copy of a table.
    if type( Table ) ~= 'table' then
        return Table
    end

    Cache = Cache or {}
    if Cache[Table] then
        return Cache[Table]
    end

    local New = {}
    Cache[Table] = New
    for Key, Value in pairs( Table ) do
        New[core.clone( Key, Cache)] = core.clone( Value, Cache )
    end

    return New
end

function core.generateTimestamp(input)
    local minutes = 0
    local seconds = math.floor(input)
    local ms = input - math.floor(input)

    while seconds > 59 do
        seconds = seconds - 60
        minutes = minutes + 1
    end

    if minutes < 10 then
        minutes = "0" .. tostring(minutes)
    end

    if seconds < 10 then
        seconds = "0" .. tostring(seconds)
    end

    ms = math.floor(ms*100)/100

    if string.len(ms) == 3 then
        ms = string.sub(tostring(ms), 2,#tostring(ms)) .. "0"
    else
        ms = string.sub(tostring(ms), 2,#tostring(ms))
    end
    return minutes..":"..seconds..ms
end

function core.cleanTable(tab)
    local tab2 = {}

    for _, item in pairs(tab) do
        table.insert(tab2, item)
    end

    return tab2
end

function core.playSound(audio)
    audio:stop()
    audio:setVolume(core.sfxVolume)
    audio:play()
end

function core.clamp(number, numberMin, numberMax)
    if number < numberMin then
        number = numberMin
    elseif number > numberMax then
        number = numberMax
    end
    return number
end

function core.reverseLookup(tab, val)
    for key, item in pairs(tab) do
        if item == val then
            return key
        end
    end
    return nil
end


function core.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky ) -- in place of love.graphics.draw()

    if type(drawable) == "string" then -- use lg.print to draw if string
        lg.print( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
    else                               -- other drawable types use lg.draw
        -- converting the scale functionality to exact pixel measurements
        if sx then
            sx = (1 / drawable:getWidth()) * sx
        end

        if sy then
            sy = (1 / drawable:getHeight()) * sy
        end

        if ox then
            if ox == "left" then
                ox = 0
            elseif ox == "center" then
                ox = drawable:getWidth()/2
            elseif ox == "right" then
                ox = drawable:getWidth()
            end
        end

        if oy then
            if oy == "top" then
                oy = 0
            elseif oy == "center" then
                oy = drawable:getHeight()/2
            elseif oy == "bottom" then
                oy = drawable:getHeight()
            end
        end

        lg.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
    end

end

function core.loadSkin(skinName) -- loads a skin into memory
    for name, imagePath in pairs(core.imagePointers) do
        core.img[name] = lg.newImage("assets/skins/" .. skinName .. "/" .. imagePath)
    end

    for name, audioPath in pairs(core.soundPointers) do
        core.snd[name] = love.audio.newSource("assets/skins/" .. skinName .. "/sfx/" .. audioPath, "static")
    end

    if lfs.getInfo("/assets/skins/"..skinName.."/font.ttf") then
        lg.setFont(lg.newFont("/assets/skins/"..skinName.."/font.ttf", core.fontSize))
    end
end
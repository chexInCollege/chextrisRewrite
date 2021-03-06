tData = {}

tData.defaultControls = {
    a = "left",
    d = "right",
    w = "hardDrop",
    s = "softDrop",

    left = "rotateCCW",
    right = "rotateCW",
    up = "rotate180",

    lshift = "hold",

    B_dpup = "hardDrop",
    B_dpleft = "left",
    B_dpright = "right",
    B_dpdown = "softDrop",

    B_a = "rotateCCW",
    B_b = "rotateCW",
    B_y = "rotate180",
    B_leftshoulder = "hold",
    B_rightshoulder = "hold",
}

tData.defaultHandling = {
    sdr = 1000,
    das = 0.15,
    arr = 1/1000
}

tData.pieces = {
    [1] = { --I
        {0,0,0,0},
        {1,1,1,1},
        {0,0,0,0},
        {0,0,0,0}
    },
    [2] = { --J
        {2,0,0},
        {2,2,2},
        {0,0,0}
    },
    [3] = { --L
        {0,0,3},
        {3,3,3},
        {0,0,0}
    },
    [4] = { --S
        {0,4,4},
        {4,4,0},
        {0,0,0}
    },
    [5] = { --Z
        {5,5,0},
        {0,5,5},
        {0,0,0}
    },
    [6] = { --T
        {0,6,0},
        {6,6,6},
        {0,0,0}
    },
    [7] = { --O
        {7,7},
        {7,7},

    },
    ["a"] = {
        {0,0,0},
        {9,9,9},
        {0,0,0}
    },
    ["b"] = {
        {0,0,0},
        {9,9,9},
        {0,0,0}
    },
    ["c"] = {
        {0,9},
        {9,9},
    },
    ["d"] = {
        {9,0},
        {9,9},
    },
    ["e"] = {
        {0,9},
        {9,9},
    },
    ["f"] = {
        {9,0},
        {9,9},
    },
    ["g"] = {
        {0,0,0},
        {9,9,9},
        {0,0,0}
    },
    ["A"] = {
        {0,0,0,0},
        {0,1,1,0},
        {0,0,0,0},
        {0,0,0,0}
    },
    ["B"] = {
        {0,0,0,0},
        {0,2,2,0},
        {0,0,0,0},
        {0,0,0,0}
    },
    ["C"] = {
        {0,0,0,0},
        {0,4,4,0},
        {0,0,0,0},
        {0,0,0,0}
    },
    ["D"] = {
        {0,0,0,0},
        {0,6,6,0},
        {0,0,0,0},
        {0,0,0,0}
    },
}



tData.pieceColors = {
    {0, 230/255, 255/255},
    {0, 60/255, 255/255},
    {255/255, 145/255, 0},
    {77/255,255/255,0},
    {255/255,0,0},
    {188/255,0,255/255},
    {255/255, 230/255, 0},
    {0.5,0.5,0.5},
    {200/255,200/255,200/255},
    {0.1,0.1,0.1},
    ["a"] = {1,1,1},--{0, 230/255, 255/255},
    ["b"] = {1,1,1},--{255/255, 145/255, 0},
    ["c"] = {1,1,1},--{0, 60/255, 255/255},
    ["d"] = {1,1,1},--{1,230/255,0},
    ["e"] = {1,1,1},--{77/255,255/255,0},
    ["f"] = {1,1,1},--{255/255,0,0},
    ["g"] = {1,1,1},--{188/255,0,255/255},
    ["A"] = {0, 230/255,255/255},
    ["B"] = {0, 60/255, 255/255},
    ["C"] = {77/255,255/255,0},
    ["D"] = {188/255,0,255/255},
}

tData.wallKickDefault = {
    {{0,0},{-1,0},{-1,1},{0,-2},{-1,-2}}, -- 0>1 (cw)
    {{0,0},{1,0},{1,1},{0,-2},{1,-2}},  -- 0>3 (ccw)
    {{0,0},{1,0},{1,-1},{0,2},{1,2}}, -- 1>2 (cw)
    {{0,0},{1,0},{1,-1},{0,2},{1,2}}, -- 1>0 (ccw)
    {{0,0},{1,0},{1,1},{0,-2},{1,-2}}, -- 2>3 (cw)
    {{0,0},{-1,0},{-1,1},{0,-2},{-1,-2}}, -- 2>1 (ccw)
    {{0,0},{-1,0},{-1,-1},{0,2},{-1,2}}, -- 3>0 (cw)
    {{0,0},{-1,0},{-1,-1},{0,2},{-1,2}}, -- 3>2 (ccw)
}

tData.wallKickI = {
    {{0,0},{-2,0},{1,0},{-2,-1},{1,2}}, -- 0>1
    {{0,0},{-1,0},{2,0},{-1,2},{2,-1}}, -- 0>3
    {{0,0},{-1,0},{2,0},{-1,2},{2,-1}}, -- 1>2
    {{0,0},{2,0},{-1,0},{2,1},{-1,-2}}, -- 1>0
    {{0,0},{2,0},{-1,0},{2,1},{-1,-2}}, -- 2>3
    {{0,0},{1,0},{-2,0},{1,-2},{-2,1}}, -- 2>1
    {{0,0},{1,0},{-2,0},{1,-2},{-2,1}}, -- 3>0
    {{0,0},{-2,0},{1,0},{-2,-1},{1,2}}, -- 3>2
}

tData.wallKickO = { --fuck it lol
    {{0,0}},
    {{0,0}},
    {{0,0}},
    {{0,0}},
    {{0,0}},
    {{0,0}},
    {{0,0}},
    {{0,0}}
}

tData.wallKickRef = {
    tData.wallKickI,
    tData.wallKickDefault,
    tData.wallKickDefault,
    tData.wallKickDefault,
    tData.wallKickDefault,
    tData.wallKickDefault,
    tData.wallKickO
}



--- rotates a 2d table 90 degrees, for piece rotation. (too lazy to write myself - credit to woot3 on roblox)
function tData.col(t)
    local i, h = 0, #t
    return function ()
    i = i + 1
    local column = {}
    for j = 1, h do
        local val = t[j][i]
            if not val then return end
            column[j] = val
            end
        return i, column
    end
end

function tData.rev(t)
    local n = #t
    for i = 1, math.floor(n / 2) do
        local j = n - i + 1
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function tData.rotateCW(t)
    local t2 = {}
    for i, column in tData.col(t) do
        t2[i] = tData.rev(column)
    end
    return t2
end

function tData.rotateCCW(t)
    local t2 = {}
    for i, column in tData.col(t) do
         t2[i] = column
    end
    return tData.rev(t2)
end

function tData.newBag(iterations)
    iterations = iterations and iterations or 1

    local out = ""
    for i = 1, iterations do
        local sift = "1234567"
        while #sift > 0 do
            local pick = math.random(1, #sift)
            out = out .. sift:sub(pick,pick)
            sift = sift:sub(1, pick - 1) .. sift:sub(pick + 1, #sift)
        end
    end
    return out
end
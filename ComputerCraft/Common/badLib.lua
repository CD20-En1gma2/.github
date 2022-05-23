Screen = {
    width = 1,
    height = 1
}

function Screen:new(obj, width, height)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    self.width = width
    self.height = height
    return obj
end

Graphics = {
    loop = false,
    x = 0,
    y = 0
}

function Graphics:new (obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    self.loop = true
    return obj
end


function Graphics:init()
    Graphics:onStart()
    while(self.loop)
    do
        Graphics:onLoop()
    end
    Graphics:onFinish()
end

function Graphics:stop()
    self.loop = false
end

function Graphics:onStart()
    print("onStart")
end

function Graphics:onLoop()
    self:printBackground()
    self:middleText()
end

function Graphics:printBackground()
    w, h = term.getSize()
    term.clear()
    for i=0, w, 1
    do
        for j=0, h, 1
        do
            paintutils.drawPixel(i, j, colors.red)
        end
    end
end

function Graphics:middleText(text)
    w, h = term.getSize()
    s = (#text)/2
    term.setCursorPos(w/2-s, h/2)
    term.write(text)
end


function Graphics:onFinish()
    print("onFinish")
end

local g = Graphics:new(nil)
g:init()

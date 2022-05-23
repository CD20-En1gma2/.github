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
    paintutils.drawPixel(Graphics.x, Graphics.y, colors.red)
    while(Graphics.x < 30)
    do
        Graphics.x = Graphics.x + 1
        Graphics.y = Graphics.y + 1
    end
    print(" - x: "..Graphics.x.." - y: "..Graphics.y)
end

function Graphics:onFinish()
    print("onFinish")
end

local g = Graphics:new(nil)
g:init()

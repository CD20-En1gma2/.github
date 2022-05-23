dofile("graphics.lua")
--local vector = require "vector"

-- Screen object, containing basic data about the screen
Square = {
    x = 1,
    y = 1,
    width = 1,
    height = 1,
    vec = nil
}

function Square:new(obj, x, y, w, h) -- initializes the Screen object
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    self.vec = vector:new(1, 0, 0)
    return obj
end

function Square:bounce()
    local w, h = term.getSize()
    if(self.x + self.width == w or self.x == 0)
    then
        self.vec:mul(-1)
    end
end

function Square:draw(sq)
    print(sq.x)
    paintutils.drawBox(sq.x, sq.y, sq.x+sq.width, sq.y+sq.height, colors.red)
    term.setBackgroundColor(colors.white)
end


testSquareFuncInit = function (obj)
    
    Graphics:setPrintArgs({Square:new(nil, 3, 3, 3, 3)})
    --obj.printFuncNum = obj.printFuncNum + 1
    Graphics.printFuncNum = 2
end
testSquareFuncLoop = function (sq)
    Square:draw(sq)
    --Square:bounce()
    sq.x = sq.x + sq.vec.x
end



local g = Graphics:new(nil, {testSquareFuncInit, testSquareFuncLoop})
g:init()

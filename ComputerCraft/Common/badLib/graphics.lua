dofile("utils.lua")

Screen = {
    width = 1,
    height = 1
}

function Screen:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    self.width, self.height = term.getSize()
    return obj
end

function Screen:reset()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1, 1)
    term.clear()
end

Graphics = {
    loop = false,
    x = 0,
    y = 0,
    t = "wooooooah",
    screen = nil,
    blink = false,
    eventData = {""}
}

function Graphics:new (obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    self.loop = true
    self.screen = Screen:new()
    return obj
end


function Graphics:init()
    Graphics:onStart()
    parallel.waitForAny (self.stopProgram, self.onLoop)
    Graphics:onFinish()
end

function Graphics:stop()
    self.loop = false
end

function Graphics:onStart()
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.purple)
end

function Graphics:onFinish()
    self.screen:reset()
    print("Finish")
end

function Graphics:onLoop()
    while(Graphics.loop)
    do
        Graphics:printBackground()
        Graphics:middleText("test")
        Graphics:middleText("WOOOOOOAH")
        coroutine.yield()
    end
end

function Graphics:printBackground()
    --[[w, h = term.getSize()
    term.clear()
    for i=0, w, 1
    do
        for j=0, h, 1
        do
            paintutils.drawPixel(i, j, colors.red)
        end
    end ]]--
    term.clear()
    term.setCursorPos(self.screen.width, 0)
    if(self.blink)
    then
        local g = "false"
        paintutils.drawBox(2, 2, 5, 5, colors.black)
        term.setBackgroundColor(colors.white)
        if(self.loop)
        then 
            g = "true"
        end
        print(g.." TEST "..term.getBackgroundColor())
        term.setCursorPos(self.screen.width, 0)
    end
    self.blink = not (self.blink)
end

function Graphics:middleText(text)
    w, h = term.getSize()
    s = (#(self.t))/2
    term.setCursorPos(w/2-s, h/2)
    term.write(self.t)
end

function Graphics:stopProgram()
    while (Graphics.loop == true)
    do
        local tim = os.startTimer(0.2)
        Graphics.activeEvents = {os.pullEvent()}
        if ( hasValue(Graphics.activeEvents, "mouse_click"))
        then
            Graphics.t = Graphics.t.."jjj"
            Graphics.loop = false
        end
    end
end

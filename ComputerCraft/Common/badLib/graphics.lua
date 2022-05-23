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
    y = 0,
    t = "wooooooah",
    blink = false
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
    parallel.waitForAny (self:onLoop(), self:stopProgram())
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
    print("onFinish")
end

function Graphics:onLoop()
    while(self.loop)
    do
        self:printBackground()
        self:middleText("test")
        self:middleText("WOOOOOOAH")
        sleep(1)
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
    w, h = term.getSize()
    term.setCursorPos(w, 0)
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
        term.setCursorPos(w, 0)
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
    while (self.loop == true)
    do
        local tim = os.startTimer(0.0)
        local eventData = {os.pullEvent()}
        local event = eventData[1]
        if ( event ~= "timer")
        then
            self.t = self.t.."jjj"
            self.loop = false
        end
        sleep(1)
    end
end

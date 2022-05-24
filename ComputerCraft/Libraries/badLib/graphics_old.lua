dofile("utils.lua")

counter = 0

-- Screen object, containing basic data about the screen
Screen = {
    width = 1,
    height = 1
}

function Screen:new(obj) -- initializes the Screen object
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    self.width, self.height = term.getSize()
    return obj
end

function Screen:reset() -- Resets the screen to its default state
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1, 1)
    term.clear()
end


-- Graphics object, most of the functions occur here
Graphics = {
    loop = false, -- boolean for the status of the loop function
    x = 0,
    y = 0,
    t = "wooooooah", -- temporary text variable
    screen = nil, -- screen object
    blink = false, -- temporary blink variable
    eventData = {""}, -- collection of the events
    printFunc = nil, -- list of functions to print in the loop
    printFuncNum = nil, -- number of function to print in the loop
    printArgs = nil -- parameters for the functions to print in the loop
}

function Graphics:new (obj, func) -- initializes the Graphics object
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    self.loop = true
    self.screen = Screen:new()
    if(func == nil or func[1] == nil)
    then
        self.printFunc = {}
        self.printFunc[1] = Graphics:defaultPrint()
    else
        self.printFunc = func
    end
    self.printFuncNum = 1
    self.printArgs = {Graphics}
    return obj
end

function Graphics:init() -- starts the Graphics
    Graphics:onStart()
    Graphics:onLoop()
    Graphics:onFinish()
end

function Graphics:stop() -- stops the Graphics loop
    Graphics.loop = false
end

function Graphics:onStart() -- function on startup of Graphics
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.purple)
end

function Graphics:onFinish() -- function on closing of Graphics
    self.screen:reset()
    print("Finish")
end

function Graphics:onLoop() -- main loop function
    while(Graphics.loop)
    do
        parallel.waitForAny (self.stopProgram, self.draw)
    end
end

function Graphics:draw() -- main draw function
    Graphics:printBackground() -- prints the background
    term.setCursorPos(Graphics.screen.width+1, 0)
    Graphics.printFunc[Graphics.printFuncNum](Graphics.printArgs) -- prints the content
    print("test "..Graphics.printFuncNum)
    coroutine.yield()
end

function Graphics:printBackground()
    term.clear()
    term.setCursorPos(self.screen.width, 0)
end

function Graphics:middleText(text)
    w, h = term.getSize()
    s = (#(text))/2
    term.setCursorPos(w/2-s, h/2)
    term.write(text)
end

function Graphics:stopProgram()
    local tim = os.startTimer(0.05)
    Graphics.activeEvents = {os.pullEvent()}
    if ( hasValue(Graphics.activeEvents, "mouse_click"))
    then
        Graphics.t = Graphics.t.."jjj"
        Graphics:stop()
    end
end

function Graphics:setPrintArgs(args)
    Graphics.printArgs = args
end

function Graphics:defaultPrint()
    return function()
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

        Graphics:middleText("WOOOOOOAH "..counter)
        counter = counter + 1
    end
end

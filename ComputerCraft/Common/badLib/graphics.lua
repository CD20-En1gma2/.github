dofile("utils.lua")

counter = 0

-- Screen object, containing basic data about the screen
local Screen = {}
Screen.new = function()
    local self = {}
    self.width, self.height = term.getSize()
    
    function self.reset() -- Resets the screen to its default state
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        term.setCursorPos(1, 1)
        term.clear()
    end

    return self
end



-- Graphics object, most of the functions occur here
Graphics = {}
Graphics.new = function(func) -- initializes the Graphics object
    self = {
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
    self.loop = true -- boolean for the status of the loop function
    self.x = 0
    self.y = 0
    self.t = "wooooooah" -- temporary text variable
    self.screen = Screen.new() -- screen object
    self.blink = false -- temporary blink variable
    self.eventData = {""} -- collection of the events
    self.printFunc = nil -- list of functions to print in the loop
    self.printFuncNum = 1 -- number of function to print in the loop
    self.printArgs = {self} -- parameters for the functions to print in the loop
    if(func == nil or func[1] == nil)
    then
        self.printFunc = {}
        self.printFunc[1] = defaultPrint()
    else
        self.printFunc = func
    end

    
    function self.stop() -- stops the Graphics loop
        self.loop = false
    end

    function self.onStart() -- function on startup of Graphics
        term.setBackgroundColor(colors.white)
        term.setTextColor(colors.purple)
    end
    
    function self.onFinish() -- function on closing of Graphics
        self.screen.reset()
        print("Finish")
    end
    
    function self.onLoop() -- main loop function
        while(self.loop)
        do
            parallel.waitForAny (self.stopProgram, self.draw)
        end
    end
    
    function self.draw() -- main draw function
        self.printBackground() -- prints the background
        term.setCursorPos(self.screen.width+1, 0)
        print(self.printArgs[1].x)
        self.printFunc[self.printFuncNum](self.printArgs) -- prints the content
        coroutine.yield()
    end
    
    function self.printBackground()
        term.clear()
        term.setCursorPos(self.screen.width, 0)
    end

    function self.stopProgram()
        local tim = os.startTimer(0.05)
        self.activeEvents = {os.pullEvent()}
        if ( hasValue(self.activeEvents, "mouse_click"))
        then
            self.t = self.t.."jjj"
            self.stop()
        end
    end

    function self.setPrintArgs(args)
        self.printArgs = args
    end


    function self.init() -- starts the Graphics
        self.onStart()
        self.onLoop()
        self.onFinish()
    end

    
    return self
end

function defaultPrint()
    return function(args)
        if(args[1].blink)
        then
            local g = "false"
            paintutils.drawBox(2, 2, 5, 5, colors.black)
            term.setBackgroundColor(colors.white)
            if(args[1].loop)
            then 
                g = "true"
            end
            print(g.." TEST "..term.getBackgroundColor())
            term.setCursorPos(args[1].screen.width, 0)
        end
        args[1].blink = not (args[1].blink)

        middleText("WOOOOOOAH "..counter)
        counter = counter + 1
    end
end

function middleText(text)
    w, h = term.getSize()
    s = (#(text))/2
    term.setCursorPos(w/2-s, h/2)
    term.write(text)
end
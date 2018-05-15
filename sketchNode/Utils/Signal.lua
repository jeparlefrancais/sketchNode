-- \Description: Use this class to add signals into other classes.

local class = {
    __name = 'Signal'
}

function class.Init()
    class.__super = nil
end

function class.SetSignals(otherClass, object)
    for name, typeInfos in pairs(otherClass.__signals) do
        object[name] = class:New(typeInfos)
    end
end

function class.New(o, typeInfos) --\ReturnType: table
    --\Doc: Creates a new signal.
    func = class.Package.Tests.GetArguments(
        {'table', typeInfos} -- The list of the firing value types.
    )
    if o == class then o = class.Package.Inherit(class) end

    o.typeInfos = typeInfos
    o.connectedFunctions = {}

    return o
end

function class:Fire(...)
    --\Doc: Fires all the connected functions.
    local values = {...}
    for i, value in pairs(values) do
        class.Package.Tests.Test(value, self.typeInfos[i])
    end
    for _, func in ipairs(self.connectedFunctions) do
        func(...)
    end
end

function class:Connect(func) 
    --\Doc: Connects a function to the signal.
    func = class.Package.Tests.GetArguments(
        {'function', func} -- The function to connect to the signal.
    )
    table.insert(self.connectedFunctions, func)
end

return class

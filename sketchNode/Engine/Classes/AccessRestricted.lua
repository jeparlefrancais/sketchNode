-- \Description: This class is meant to represent a typed variable.

local class = {
    __name = 'AccessRestricted'
}

function class.Init()
    class.__super = nil
	class.__signals = {
		AccessChanged = {
			'string', -- newAccess
		}
	}
end

function class.New(o, access) --\ReturnType: table
    access = class.Package.Utils.Tests.GetArguments(
        {'string', access} -- Public or private.
    )
    if o == class then o = class.Package.Utils.Inherit(class) end
    
    class.Package.Utils.Signal.SetSignals(class, o)
    
    o.access = access

    return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = self.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
    if o == class then o = class.Package.Utils.Inherit(class) end

    class.Package.Utils.Signal.SetSignals(class, o)
    
	o.access = data.access
    
    return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		access = self.access
	}
end

function class:GetAccess() --\ReturnType: string
	--\Doc: Returns the access of the object.
	return self.access
end

function class:SetAccess(access)
    access = class.Package.Utils.Tests.GetArguments(
        {'string', access} -- The new access string.
    )
	--\Doc: Changes the access of the object.
	self.access = access
	self.AccessChanged:Fire(access)
end

return class

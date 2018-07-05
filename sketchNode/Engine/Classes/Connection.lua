--\Description: Add a description

local class = {
	__name = 'Connection'
}

function class.Init()
	class.__super = nil
end

function class.New(o, startNodeId, endNodeId, startIndex, endIndex) --\ReturnType: table
	startNodeId, endNodeId = class.Package.Utils.Tests.GetArguments(
		{'string', startNodeId}, -- The node sending the information.
		{'string', endNodeId}, -- The node receiving the information.
		{'number', startIndex},
		{'number', endIndex}
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.startNodeId = startNodeId
	o.endNodeId = endNodeId
	o.startIndex = startIndex
	o.endIndex = endIndex

	return o
end

function class.Load(o, data) --\ReturnType: table
	--\Doc: Creates a new object with the given table.
	data = class.Package.Utils.Tests.GetArguments(
		{'table', data} -- Data from the Serialize method.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.startNodeId = data.startNodeId
	o.endNodeId = data.endNodeId
	o.startIndex = data.startIndex
	o.endIndex = data.endIndex

	return o
end

function class:Serialize() --\ReturnType: table
	--\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		startNodeId = self.startNodeId,
		endNodeId = self.endNodeId,
		startIndex = self.startIndex,
		endIndex = self.endIndex
	}
end

function class:GetStartNodeId() --\ReturnType: string
	--\Doc: Returns the Id of the start node.
	return self.startNodeId
end

function class:GetEndNodeId() --\ReturnType: string
	--\Doc: Returns the Id of the end node.
	return self.endNodeId
end

function class:GetStartIndex() --\ReturnType: number
	--\Doc: Returns the index of the start node.
	return self.startIndex
end

function class:GetEndIndex() --\ReturnType: number
	--\Doc: Returns the index of the end node.
	return self.endIndex
end

return class

-- \Description: SketchSheet holds a set of nodes and their connections.

local class = {
	__name = 'SketchSheet'
}

local classNameToClass

function class.Init()
	class.__super = {class.Package.Classes.Named}
	class.__signals = {
		NodeAdded = {
			'Node' -- node
		},
		ConnectionAdded = {
			'Connection' -- connection
		}
    }
    classNameToClass = {
        FunctionNode = class.Package.Classes.FunctionNode,
        EventNode = class.Package.Classes.EventNode
    }
end

function class.New(o, name) --\ReturnType: table
    name = class.Package.Utils.Tests.GetArguments(
        {'string', name} -- The name of the sheet.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end
	
    class.Package.Utils.Signal.SetSignals(class, o)
    
    class.Package.Classes.Named.New(o, name)
    
    o.newId = 0
    o.nodes = {}
    o.connections = {}

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
    if o == class then o = class.Package.Utils.Inherit(class) end
    
    --class.Package.Utils.Signal.SetSignals(class, o)
    class.Package.Classes.Named.Load(data.superNamed)

    o.newId = data.newId
    o.nodes = {}
    o.connections = {}

    for className, nodeDict in pairs(data.nodesByClass) do
        for id, nodeData in pairs(nodeDict) do
            o.nodes[id] = classNameToClass[className]:Load(nodeData)
        end
    end

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
    local nodesByClass = {}
    for id, node in pairs(self.nodes) do
        local className = node:GetClassName()
        if nodesByClass[className] == nil then
            nodesByClass[className] = {}
        end
        nodesByClass[className][id] = node:Serialize()
    end
	return {
        newId = self.newId,
        nodesByClass = nodesByClass,
        connections = class.Package.SerializeTable(self.connections),
		superNamed = class.Package.Classes.Named.Serialize(self)
	}
end

function class:GetNodes()
	return self.nodes
end

function class:GetNewId()
    local id = string.format('%X', self.newId)
    self.newId = self.newId + 1
    return id
end

function class:CreateNode(reference, x, y)
    reference, x, y = class.Package.Utils.Tests.GetArguments(
        {'BaseReference', reference}, -- The reference to the function
        {'number', x, 0}, -- The position on the x-axis of the node to create
        {'number', y, 0} -- The position on the y-axis of the node to create
    )
    local id = self:GetNewId()
    local referenceClass = reference:IsFunction()
    local node = nil

    if reference:IsFunction() then
        node = class.Package.Classes.FunctionNode:New(reference, x, y)
    elseif reference:IsEvent() then
        node = class.Package.Classes.EventNode:New(reference, x, y)
	elseif reference:IsValue() then
		node = class.Package.Classes.ValueNode:New(reference, x, y)
    else
        warn(string.format('Reference <%s> is not recognized to any node type', reference:GetClassName()))
    end

    if node then
        self.nodes[id] = node
        self.NodeAdded:Fire(node)
    end
end

function class:GetNodeId(node) --\ReturnType: string
	--\Doc: Returns the Id linked with the given node. Returns nil if the node does not exist.
	node = class.Package.Utils.Tests.GetArguments(
		{'Node', node} -- The node
	)
	for id, sheetNode in pairs(self.nodes) do
		if sheetNode == node then
			return id
		end
	end
	warn('Given node does not exist in that sheet.')
end

function class:ConnectNodes(startNode, endNode, startIndex, endIndex)
    startNode, endNode, startIndex, endIndex = class.Package.Utils.Tests.GetArguments(
        {'Node', startNode}, -- The node to connect from.
        {'Node', endNode}, -- The node to connect to.
		{'number', startIndex, 0}, -- The index of the connector (0 is the execution connector, then other numbers are the ).
		{'number', endIndex, 0} -- 
    )
	local startNodeId = self:GetNodeId(startNode)
	local endNodeId = self:GetNodeId(endNode)
	if startNodeId and endNodeId then
		local connection = class.Package.Classes.Connection:New(startNodeId, endNodeId, startIndex, endIndex)
		table.insert(self.connections, connection)
		self.ConnectionAdded:Fire(connection)
		return true
	end
	return false
end

function class:GetSourceCode() --\ReturnType: string
    --\Doc: Returns the source code generated from the connections and the nodes of the SketchSheet.
	return ''
end

return class

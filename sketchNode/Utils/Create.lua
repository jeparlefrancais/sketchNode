return function (instanceClass)
    local obj = Instance.new(instanceClass)
    return function(properties)
        for key, val in pairs(properties) do
            if key ~= 'Parent' then
                local success, message = pcall(function()
                    obj[key] = val
                end)
                if not success then
                    error('Create function failed with key, value: ' .. tostring(key) .. ', ' .. tostring(val) .. ' with error message: ' .. message)
                end
            end
        end
        if properties.Parent ~= nil then
            obj.Parent = properties.Parent
        end
        return obj
    end
end
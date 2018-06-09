return function(list, element)
    for _, value in ipairs(list) do
        if value == element then
            return true
        end
    end
    return false
end
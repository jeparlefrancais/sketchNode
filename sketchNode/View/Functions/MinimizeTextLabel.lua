local TXT = game:GetService('TextService')

return function(textLabel)
    local size = TXT:GetTextSize(textLabel.Text, textLabel.TextSize, textLabel.Font, Vector2.new(0, 0))
    textLabel.Size = UDim2.new(0, size.x, 0, size.y)
end
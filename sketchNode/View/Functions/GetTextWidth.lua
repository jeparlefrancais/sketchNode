local TXT = game:GetService('TextService')

return function(text, size, font)
    return TXT:GetTextSize(text, size or 18, font or "SourceSansItalic", Vector2.new(0, 0)).x
end
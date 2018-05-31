local TWN = game:GetService('TweenService')

return function(object, duration, propertyGoals, easingStyle, easingDirection, reverse, repeatCount, delayTime)
	return TWN:Create(object, TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out, repeatCount or 0, reverse or false, delayTime or 0), propertyGoals)
end

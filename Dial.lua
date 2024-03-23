local module = {}
local maxRange = 9 -- Storing this as a variable so it's not some random "magic number"

local baseFrame = Instance.new("Frame") do
	baseFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	baseFrame.BorderColor3 = Color3.fromRGB(35, 35, 35)
	baseFrame.Size = UDim2.fromOffset(35, 50)
	baseFrame.BorderSizePixel = 2
	baseFrame.ClipsDescendants = true
	baseFrame.AnchorPoint = Vector2.new(.5, .5)
	baseFrame.Position = UDim2.fromScale(.5, .5)
end

local baseNumberLabel = Instance.new("TextLabel") do
	baseNumberLabel.BackgroundTransparency = 1
	baseNumberLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	baseNumberLabel.TextStrokeTransparency = 0
	baseNumberLabel.Size = UDim2.fromScale(1, 1)
	baseNumberLabel.TextScaled = true
	baseNumberLabel.AnchorPoint =  Vector2.new(.5, 1)
end

local defaultTween = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

function module.new(slots : number, inital_Number : number, desired_Parent : Instance?, desired_Position : UDim2?, x_Padding : number?, tweenInfo : TweenInfo?)

	local newDial = {}

	newDial.slotFrames = {}
	newDial.slotsNum = slots
	newDial.tweenInfo = tweenInfo or defaultTween

	local x_Padding = x_Padding or 50
	local desired_Position = (desired_Position or UDim2.fromScale(.5, 0)) - UDim2.new(slots * baseFrame.Size.X.Scale, slots * baseFrame.Size.X.Offset) -- Had to make this a local variable because of an analysis warning.. prtty annoying

	local inital_Number = math.floor(math.abs(inital_Number))

	for slotIndex = 1, slots do

		local newFrame = baseFrame:Clone()
		local frameNumbers = {}

		local initalSlotNumber = 0

		for i = 0, maxRange do

			local textLabel = baseNumberLabel:Clone()
			textLabel.Text = tostring(i)

			textLabel.Position = UDim2.fromScale(.5, 
				1 + i - initalSlotNumber
			)

			textLabel.Name = i;
			textLabel.Parent = newFrame
			frameNumbers[i] = textLabel

		end

		newDial.slotFrames[slotIndex] = {
			slotFrame = newFrame,
			frameNumbers = frameNumbers
		}

	end

	for index, dat in newDial.slotFrames do
		dat.slotFrame.Parent = desired_Parent
		dat.slotFrame.Position = desired_Position + UDim2.fromOffset(index * x_Padding, 0)
	end

	module.update(
		newDial, 
		inital_Number
	)

	return newDial

end

function module.update(newDial : any, number : number)

	assert(newDial, "@newDial is missing")
	assert(typeof(number) ~= nil, "@number is incorrect or missing")

	if newDial.slotFrames == nil then
		return
	end

	local slotsNum = newDial.slotsNum

	number = math.floor(math.abs(number)) -- Adjust number. Decimals and negative numbers will be set to 0.

	local maxNumber = (10 ^ slotsNum - 1)
	local isOverNumber =  (number > maxNumber) -- Number is greater than the number is can display.

	local tweens = {}

	local function number_To_Padded_String(number, length)
		return string.format("%0" .. length .. "d", number)
	end

	for slotIndex, frameData in newDial.slotFrames do

		local slotFrame = frameData.slotFrame
		local frameNumbers = frameData.frameNumbers

		local paddedFrameNumber = number_To_Padded_String(number, slotsNum)
		paddedFrameNumber = tonumber(tostring(paddedFrameNumber):sub(slotIndex , slotIndex) or 0)

		if isOverNumber then
			paddedFrameNumber = 9
		end

		for i = 0, maxRange do

			local tween = game.TweenService:Create(frameNumbers[i], newDial.tweenInfo, {
				Position = UDim2.fromScale(.5,
					1 + i - paddedFrameNumber
				)
			})

			table.insert(tweens, tween)

		end

	end

	for index, tween in tweens do
		tween:Play()
	end

end

return module

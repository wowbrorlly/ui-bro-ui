--!nocheck
-- Glu UI 3.0
-- Self contained interface library for Glu Hub. No external assets, every icon is drawn from frames.

local cloneref = cloneref or function(x) return x end
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))
local TextService = cloneref(game:GetService("TextService"))
local Stats = cloneref(game:GetService("Stats"))
local HttpService = cloneref(game:GetService("HttpService"))
local GuiService = cloneref(game:GetService("GuiService"))
local LocalPlayer = Players.LocalPlayer
local rgb = Color3.fromRGB

local UI = {
	Version = "3.0",
	MobileButton = true,
	MobileTapFix = true,
	MenuKeybind = "Enum.KeyCode.LeftControl",
}

local FONT = Enum.Font.BuilderSans
local FONT_M = Enum.Font.BuilderSansMedium
local FONT_B = Enum.Font.BuilderSansBold
local MONO = Enum.Font.RobotoMono

-- touch only devices (phones, tablets without a mouse) get larger targets
local TOUCH = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local K = {
	Row = TOUCH and 46 or 36,
	SliderRow = TOUCH and 70 or 56,
	Field = TOUCH and 34 or 26,
	Btn = TOUCH and 38 or 30,
	Text = TOUCH and 14 or 13,
	Small = TOUCH and 12 or 11,
	Switch = TOUCH and Vector2.new(46, 26) or Vector2.new(40, 22),
	Header = TOUCH and 48 or 46,
	Tab = TOUCH and Vector2.new(64, 52) or Vector2.new(60, 48),
	Item = TOUCH and 40 or 26,
	Head = TOUCH and 54 or 48,
}
local RAIL_W, FOOTER_H, BAR_H = 70, 0, 56
local SIDE_W, TOPBAR_H = 208, 58

---------------------------------------------------------------- theme
local PRESETS = {
	Glass = {
		Accent = rgb(238, 238, 242), Window = rgb(10, 10, 12), Panel = rgb(18, 18, 21),
		Card = rgb(26, 26, 30), Line = rgb(48, 48, 54), Text = rgb(238, 238, 242), Muted = rgb(142, 142, 152),
	},
	Glu = {
		Accent = rgb(255, 150, 200), Window = rgb(12, 12, 15), Panel = rgb(17, 17, 21),
		Card = rgb(23, 23, 28), Line = rgb(40, 40, 48), Text = rgb(232, 232, 238), Muted = rgb(128, 128, 142),
	},
	Ocean = {
		Accent = rgb(86, 166, 255), Window = rgb(10, 12, 17), Panel = rgb(14, 17, 24),
		Card = rgb(20, 24, 33), Line = rgb(36, 44, 58), Text = rgb(228, 236, 246), Muted = rgb(120, 136, 158),
	},
	Ember = {
		Accent = rgb(255, 122, 66), Window = rgb(14, 11, 10), Panel = rgb(20, 15, 14),
		Card = rgb(28, 21, 20), Line = rgb(54, 40, 38), Text = rgb(242, 234, 230), Muted = rgb(154, 132, 126),
	},
	Mint = {
		Accent = rgb(78, 222, 166), Window = rgb(10, 14, 13), Panel = rgb(14, 20, 18),
		Card = rgb(20, 28, 26), Line = rgb(34, 52, 48), Text = rgb(228, 244, 238), Muted = rgb(118, 150, 142),
	},
	Violet = {
		Accent = rgb(156, 118, 255), Window = rgb(11, 10, 17), Panel = rgb(16, 15, 25),
		Card = rgb(23, 21, 34), Line = rgb(44, 40, 64), Text = rgb(236, 232, 248), Muted = rgb(134, 128, 162),
	},
	Mono = {
		Accent = rgb(226, 226, 232), Window = rgb(9, 9, 9), Panel = rgb(15, 15, 15),
		Card = rgb(21, 21, 21), Line = rgb(44, 44, 44), Text = rgb(238, 238, 238), Muted = rgb(124, 124, 124),
	},
	Aurora = {
		Accent = rgb(94, 234, 212), Window = rgb(8, 14, 20), Panel = rgb(12, 22, 30),
		Card = rgb(17, 31, 42), Line = rgb(30, 54, 68), Text = rgb(226, 246, 244), Muted = rgb(112, 152, 160),
	},
	Sunset = {
		Accent = rgb(255, 138, 101), Window = rgb(18, 10, 20), Panel = rgb(27, 15, 30),
		Card = rgb(38, 21, 40), Line = rgb(68, 38, 66), Text = rgb(255, 238, 232), Muted = rgb(176, 130, 144),
	},
	Midnight = {
		Accent = rgb(129, 140, 248), Window = rgb(6, 8, 18), Panel = rgb(10, 13, 28),
		Card = rgb(15, 19, 40), Line = rgb(32, 38, 76), Text = rgb(226, 230, 255), Muted = rgb(116, 124, 170),
	},
	Rose = {
		Accent = rgb(251, 113, 133), Window = rgb(16, 9, 11), Panel = rgb(25, 13, 16),
		Card = rgb(36, 19, 24), Line = rgb(66, 34, 42), Text = rgb(255, 232, 236), Muted = rgb(170, 120, 130),
	},
	Cyber = {
		Accent = rgb(240, 80, 255), Window = rgb(7, 7, 14), Panel = rgb(12, 11, 24),
		Card = rgb(19, 17, 38), Line = rgb(56, 34, 84), Text = rgb(240, 232, 255), Muted = rgb(140, 120, 178),
	},
	Matcha = {
		Accent = rgb(163, 230, 53), Window = rgb(11, 14, 9), Panel = rgb(16, 21, 13),
		Card = rgb(23, 30, 18), Line = rgb(44, 58, 34), Text = rgb(238, 247, 226), Muted = rgb(132, 150, 112),
	},
	Crimson = {
		Accent = rgb(239, 68, 68), Window = rgb(12, 8, 8), Panel = rgb(20, 11, 11),
		Card = rgb(30, 16, 16), Line = rgb(62, 30, 30), Text = rgb(250, 232, 232), Muted = rgb(160, 112, 112),
	},
	Nord = {
		Accent = rgb(136, 192, 208), Window = rgb(30, 34, 42), Panel = rgb(36, 41, 51),
		Card = rgb(46, 52, 64), Line = rgb(67, 76, 94), Text = rgb(236, 239, 244), Muted = rgb(150, 160, 178),
	},
	Dracula = {
		Accent = rgb(189, 147, 249), Window = rgb(30, 31, 41), Panel = rgb(36, 37, 50),
		Card = rgb(44, 46, 62), Line = rgb(68, 71, 90), Text = rgb(248, 248, 242), Muted = rgb(150, 154, 190),
	},
	Gold = {
		Accent = rgb(250, 204, 21), Window = rgb(13, 11, 7), Panel = rgb(21, 18, 11),
		Card = rgb(31, 26, 15), Line = rgb(64, 54, 28), Text = rgb(252, 244, 220), Muted = rgb(166, 150, 108),
	},
	Ice = {
		Accent = rgb(125, 211, 252), Window = rgb(9, 14, 20), Panel = rgb(13, 21, 30),
		Card = rgb(19, 31, 44), Line = rgb(36, 58, 80), Text = rgb(232, 245, 255), Muted = rgb(120, 150, 176),
	},
	Lavender = {
		Accent = rgb(196, 160, 255), Window = rgb(17, 14, 24), Panel = rgb(25, 21, 36),
		Card = rgb(35, 30, 50), Line = rgb(62, 54, 88), Text = rgb(246, 240, 255), Muted = rgb(158, 146, 190),
	},
	Snow = {
		Accent = rgb(37, 99, 235), Window = rgb(244, 245, 249), Panel = rgb(233, 235, 242),
		Card = rgb(255, 255, 255), Line = rgb(206, 211, 224), Text = rgb(24, 27, 38), Muted = rgb(104, 112, 134),
	},
}
UI.PresetOrder = { "Glass", "Glu", "Aurora", "Sunset", "Midnight", "Rose", "Cyber", "Matcha", "Crimson", "Nord", "Dracula", "Gold", "Ice", "Lavender", "Ocean", "Ember", "Mint", "Violet", "Mono", "Snow" }
UI.Theme = {}
for key, color in pairs(PRESETS.Glass) do UI.Theme[key] = color end

local Bound = setmetatable({}, { __mode = "k" })
local function resolve(spec)
	if type(spec) == "table" then return spec[2](UI.Theme[spec[1]]) end
	return UI.Theme[spec]
end
local function themed(inst, props)
	local record = Bound[inst]
	if not record then
		record = {}
		Bound[inst] = record
	end
	for prop, spec in pairs(props) do
		record[prop] = spec
		inst[prop] = resolve(spec)
	end
end
local function applyTheme()
	for inst, record in pairs(Bound) do
		for prop, spec in pairs(record) do
			pcall(function() inst[prop] = resolve(spec) end)
		end
	end
end
function UI:SetTheme(name)
	local preset = PRESETS[tostring(name or "")]
	if not preset then return end
	for key, color in pairs(preset) do UI.Theme[key] = color end
	applyTheme()
end
function UI:ChangeTheme(key, color)
	key = tostring(key or "")
	if typeof(color) ~= "Color3" or UI.Theme[key] == nil then return end
	UI.Theme[key] = color
	applyTheme()
end

---------------------------------------------------------------- helpers
local Conns = {}
local function conn(signal, fn)
	local c = signal:Connect(fn)
	Conns[#Conns + 1] = c
	return c
end
local function safe(fn, ...)
	if type(fn) ~= "function" then return end
	local ok, err = pcall(fn, ...)
	if not ok then warn("[Glu UI] callback error: " .. tostring(err)) end
end
local function new(class, props, parent)
	local inst = Instance.new(class)
	if props then
		for key, value in pairs(props) do inst[key] = value end
	end
	if parent then inst.Parent = parent end
	return inst
end
local function corner(inst, r)
	return new("UICorner", { CornerRadius = UDim.new(0, r or 5) }, inst)
end
local function stroke(inst, spec, thickness, transparency)
	local s = new("UIStroke", {
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, inst)
	themed(s, { Color = spec or "Line" })
	return s
end
local function pad(inst, l, t, r, b)
	return new("UIPadding", {
		PaddingLeft = UDim.new(0, l or 0), PaddingTop = UDim.new(0, t or 0),
		PaddingRight = UDim.new(0, r or 0), PaddingBottom = UDim.new(0, b or 0),
	}, inst)
end
local function vlist(inst, gap)
	return new("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, gap or 0),
	}, inst)
end
local function tween(inst, props, t, style, dir)
	local tw = TweenService:Create(inst,
		TweenInfo.new(t or 0.16, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end
local function text(parent, str, size, spec, font, props)
	local lbl = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = tostring(str or ""),
		TextSize = size or 13,
		Font = font or FONT,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BorderSizePixel = 0,
	})
	themed(lbl, { TextColor3 = spec or "Text" })
	if props then
		for key, value in pairs(props) do lbl[key] = value end
	end
	lbl.Parent = parent
	return lbl
end
local function measure(str, size, font)
	local ok, v = pcall(function()
		return TextService:GetTextSize(tostring(str), size or 13, font or FONT, Vector2.new(10000, 10000))
	end)
	return ok and v or Vector2.new(#tostring(str) * 7, size or 13)
end
local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end
local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end
local function hex(color)
	return string.format("#%02X%02X%02X",
		math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
end
local function screenSize()
	local cam = workspace.CurrentCamera
	return cam and cam.ViewportSize or Vector2.new(1280, 720)
end
local function topInset()
	local ok, inset = pcall(function() return GuiService:GetGuiInset() end)
	return ok and inset.Y or 36
end

---------------------------------------------------------------- saved state
local STATE_FILE = "GluUI/state.json"
local State = { collapsed = {} }
do
	pcall(function()
		if isfile and isfile(STATE_FILE) then
			local decoded = HttpService:JSONDecode(readfile(STATE_FILE))
			if type(decoded) == "table" then
				State = decoded
				State.collapsed = type(State.collapsed) == "table" and State.collapsed or {}
			end
		end
	end)
end
local saveToken = 0
local function saveState()
	saveToken = saveToken + 1
	local token = saveToken
	task.delay(0.8, function()
		if token ~= saveToken then return end
		pcall(function()
			if makefolder and isfolder and not isfolder("GluUI") then makefolder("GluUI") end
			writefile(STATE_FILE, HttpService:JSONEncode(State))
		end)
	end)
end

---------------------------------------------------------------- icons
local ICONS = {}
local ICON_LIST = {}
local function icon(parent, name, size, spec)
	local def = ICONS[name] or ICONS.dot
	local s = size / 24
	local th = math.max(1.4, 1.85 * s)
	local holder = new("Frame", {
		Name = "Icon_" .. tostring(name), BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size, size), BorderSizePixel = 0,
	})
	local fills, strokes = {}, {}
	local function part(props, outlined, radius)
		local f = new("Frame", props)
		f.BorderSizePixel = 0
		if radius then new("UICorner", { CornerRadius = radius }, f) end
		if outlined then
			f.BackgroundTransparency = 1
			strokes[#strokes + 1] = new("UIStroke", {
				Thickness = th, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}, f)
		else
			fills[#fills + 1] = f
		end
		f.Parent = holder
		return f
	end
	local d = {}
	function d.L(x1, y1, x2, y2)
		local dx, dy = (x2 - x1) * s, (y2 - y1) * s
		local len = math.sqrt(dx * dx + dy * dy)
		part({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset((x1 + x2) / 2 * s, (y1 + y2) / 2 * s),
			Size = UDim2.fromOffset(len + th * 0.5, th),
			Rotation = math.deg(math.atan2(dy, dx)),
		}, false, UDim.new(0.5, 0))
	end
	function d.R(x, y, w, h, r)
		part({
			Position = UDim2.fromOffset(x * s + th / 2, y * s + th / 2),
			Size = UDim2.fromOffset(w * s - th, h * s - th),
		}, true, UDim.new(0, math.max(0, (r or 0) * s)))
	end
	function d.F(x, y, w, h, r)
		part({
			Position = UDim2.fromOffset(x * s, y * s),
			Size = UDim2.fromOffset(w * s, h * s),
		}, false, UDim.new(0, math.max(0, (r or 0) * s)))
	end
	function d.C(cx, cy, r)
		local sz = math.max(2, 2 * r * s - th)
		part({
			Position = UDim2.fromOffset(cx * s - sz / 2, cy * s - sz / 2),
			Size = UDim2.fromOffset(sz, sz),
		}, true, UDim.new(0.5, 0))
	end
	function d.D(cx, cy, r)
		local sz = math.max(2, 2 * r * s)
		part({
			Position = UDim2.fromOffset(cx * s - sz / 2, cy * s - sz / 2),
			Size = UDim2.fromOffset(sz, sz),
		}, false, UDim.new(0.5, 0))
	end
	function d.P(points, closed)
		for i = 1, #points - 1 do
			d.L(points[i][1], points[i][2], points[i + 1][1], points[i + 1][2])
		end
		if closed and #points > 2 then
			d.L(points[#points][1], points[#points][2], points[1][1], points[1][2])
		end
	end
	function d.A(cx, cy, r, a0, a1)
		local steps = math.max(6, math.floor(math.abs(a1 - a0) / 18))
		local pts = {}
		for i = 0, steps do
			local a = math.rad(a0 + (a1 - a0) * i / steps)
			pts[#pts + 1] = { cx + r * math.cos(a), cy - r * math.sin(a) }
		end
		d.P(pts, false)
	end
	def(d)
	local obj = { Frame = holder }
	function obj.SetColor(color)
		for _, f in ipairs(fills) do themed(f, { BackgroundColor3 = color }) end
		for _, st in ipairs(strokes) do themed(st, { Color = color }) end
	end
	obj.SetColor(spec or "Text")
	if parent then holder.Parent = parent end
	return obj
end
local function def(name, fn)
	ICONS[name] = fn
	ICON_LIST[#ICON_LIST + 1] = name
end

def("dot", function(d) d.D(12, 12, 3) end)
def("logo", function(d)
	d.P({ { 12, 2.5 }, { 20.5, 7.25 }, { 20.5, 16.75 }, { 12, 21.5 }, { 3.5, 16.75 }, { 3.5, 7.25 } }, true)
	d.A(12, 12, 4.4, 45, 360)
	d.L(12, 12, 16.4, 12)
end)
def("home", function(d)
	d.P({ { 3, 11 }, { 12, 3 }, { 21, 11 } }, false)
	d.L(5.5, 10, 5.5, 21)
	d.L(18.5, 10, 18.5, 21)
	d.L(5.5, 21, 18.5, 21)
	d.R(10, 14, 4, 7, 0.5)
end)
def("sprout", function(d)
	d.L(12, 21, 12, 11)
	d.P({ { 12, 14 }, { 6.5, 13.5 }, { 4, 7.5 }, { 10, 8.5 }, { 12, 11 } }, false)
	d.P({ { 12, 11.5 }, { 14.5, 5 }, { 20, 4 }, { 19, 10.5 }, { 12, 13 } }, false)
	d.L(7, 21, 17, 21)
end)
def("skull", function(d)
	d.C(12, 10, 8)
	d.R(8, 16.5, 8, 5.5, 1.5)
	d.D(9, 10, 1.9)
	d.D(15, 10, 1.9)
	d.L(12, 12.5, 12, 14.5)
end)
def("swords", function(d)
	d.L(4.5, 4.5, 19.5, 19.5)
	d.L(19.5, 4.5, 4.5, 19.5)
	d.L(12.5, 17.5, 17.5, 12.5)
	d.L(6.5, 12.5, 11.5, 17.5)
	d.L(3, 21, 6, 18)
	d.L(21, 21, 18, 18)
end)
def("sword", function(d)
	d.L(6.5, 17.5, 19.5, 4.5)
	d.L(6, 12.5, 11.5, 18)
	d.L(6.5, 17.5, 3.5, 20.5)
	d.D(3.3, 20.7, 1.2)
end)
def("gate", function(d)
	d.L(5, 21, 5, 11)
	d.A(12, 11, 7, 0, 180)
	d.L(19, 11, 19, 21)
	d.L(3, 21, 21, 21)
	d.R(9.5, 13.5, 5, 7.5, 2.5)
end)
def("target", function(d)
	d.C(12, 12, 8.5)
	d.C(12, 12, 4)
	d.D(12, 12, 1.2)
	d.L(12, 1.5, 12, 5)
	d.L(12, 19, 12, 22.5)
	d.L(1.5, 12, 5, 12)
	d.L(19, 12, 22.5, 12)
end)
def("user", function(d)
	d.C(12, 8, 4.2)
	d.A(12, 22, 8.5, 0, 180)
	d.L(3.5, 22, 20.5, 22)
end)
def("users", function(d)
	d.C(8.5, 8, 3.4)
	d.A(8.5, 21, 6.5, 0, 180)
	d.C(17, 9, 2.8)
	d.A(17, 20, 4.8, 10, 100)
end)
def("grid", function(d)
	d.R(4, 4, 7, 7, 1.8)
	d.R(13, 4, 7, 7, 1.8)
	d.R(4, 13, 7, 7, 1.8)
	d.R(13, 13, 7, 7, 1.8)
end)
def("gear", function(d)
	d.C(12, 12, 6.2)
	d.C(12, 12, 2.3)
	for i = 0, 7 do
		local a = math.rad(i * 45)
		d.L(12 + 7.6 * math.cos(a), 12 - 7.6 * math.sin(a), 12 + 10.4 * math.cos(a), 12 - 10.4 * math.sin(a))
	end
end)
def("sliders", function(d)
	d.L(3, 7, 21, 7)
	d.L(3, 17, 21, 17)
	d.C(9, 7, 2.6)
	d.C(15.5, 17, 2.6)
end)
def("search", function(d)
	d.C(10.5, 10.5, 6.5)
	d.L(15.5, 15.5, 21, 21)
end)
def("close", function(d)
	d.L(6, 6, 18, 18)
	d.L(18, 6, 6, 18)
end)
def("minus", function(d) d.L(6, 12, 18, 12) end)
def("plus", function(d)
	d.L(12, 5, 12, 19)
	d.L(5, 12, 19, 12)
end)
def("maximize", function(d) d.R(5, 5, 14, 14, 2) end)
def("restore", function(d)
	d.R(4, 8, 12, 12, 2)
	d.P({ { 8, 8 }, { 8, 4 }, { 20, 4 }, { 20, 16 }, { 16, 16 } }, false)
end)
def("chevD", function(d) d.P({ { 6, 9.5 }, { 12, 15.5 }, { 18, 9.5 } }, false) end)
def("chevU", function(d) d.P({ { 6, 14.5 }, { 12, 8.5 }, { 18, 14.5 } }, false) end)
def("chevR", function(d) d.P({ { 9.5, 6 }, { 15.5, 12 }, { 9.5, 18 } }, false) end)
def("chevL", function(d) d.P({ { 14.5, 6 }, { 8.5, 12 }, { 14.5, 18 } }, false) end)
def("arrowR", function(d)
	d.L(4, 12, 20, 12)
	d.P({ { 14, 6 }, { 20, 12 }, { 14, 18 } }, false)
end)
def("check", function(d) d.P({ { 5, 12.5 }, { 10, 17.5 }, { 19, 7 } }, false) end)
def("info", function(d)
	d.C(12, 12, 9)
	d.D(12, 7.6, 1.3)
	d.L(12, 11, 12, 17)
end)
def("warn", function(d)
	d.P({ { 12, 3 }, { 22, 20 }, { 2, 20 } }, true)
	d.L(12, 9.5, 12, 14)
	d.D(12, 17, 1.1)
end)
def("bell", function(d)
	d.A(12, 10, 6, 0, 180)
	d.L(6, 10, 6, 15.5)
	d.L(18, 10, 18, 15.5)
	d.L(4, 16.5, 20, 16.5)
	d.D(12, 20.5, 1.6)
end)
def("bolt", function(d)
	d.P({ { 13, 2 }, { 5, 13.5 }, { 11, 13.5 }, { 10, 22 }, { 19, 10 }, { 13, 10 } }, true)
end)
def("chest", function(d)
	d.R(3, 11, 18, 10, 2)
	d.A(12, 11, 9, 0, 180)
	d.D(12, 15.5, 1.4)
end)
def("fish", function(d)
	d.P({ { 3, 12 }, { 8, 7 }, { 15, 7 }, { 19, 12 }, { 15, 17 }, { 8, 17 } }, true)
	d.P({ { 19, 12 }, { 22, 8 }, { 22, 16 } }, true)
	d.D(8.5, 11, 1.2)
end)
def("link", function(d)
	d.C(12, 5.5, 3)
	d.C(5.5, 18, 3)
	d.C(18.5, 18, 3)
	d.L(10.5, 8, 7, 15.5)
	d.L(13.5, 8, 17, 15.5)
	d.L(8.5, 18, 15.5, 18)
end)
def("save", function(d)
	d.R(4, 4, 16, 16, 2)
	d.R(8, 4, 8, 5.5, 1)
	d.R(7, 13, 10, 7, 1)
end)
def("palette", function(d)
	d.C(12, 12, 9)
	d.D(8, 10, 1.4)
	d.D(12, 7, 1.4)
	d.D(16, 10, 1.4)
	d.D(8.5, 15, 1.4)
end)
def("window", function(d)
	d.R(3, 5, 18, 14, 2)
	d.L(3, 9.5, 21, 9.5)
	d.D(6.2, 7.3, 0.8)
end)
def("scroll", function(d)
	d.R(5, 3, 14, 18, 2)
	d.L(8.5, 8, 15.5, 8)
	d.L(8.5, 12, 15.5, 12)
	d.L(8.5, 16, 12.5, 16)
end)
def("eye", function(d)
	d.P({ { 2, 12 }, { 7, 6.5 }, { 12, 5 }, { 17, 6.5 }, { 22, 12 }, { 17, 17.5 }, { 12, 19 }, { 7, 17.5 } }, true)
	d.C(12, 12, 3)
end)
def("eyeOff", function(d)
	d.P({ { 2, 12 }, { 7, 6.5 }, { 12, 5 }, { 17, 6.5 }, { 22, 12 }, { 17, 17.5 }, { 12, 19 }, { 7, 17.5 } }, true)
	d.L(4, 20, 20, 4)
end)
def("keyboard", function(d)
	d.R(2, 6, 20, 12, 2)
	d.D(6, 10, 0.9)
	d.D(10, 10, 0.9)
	d.D(14, 10, 0.9)
	d.D(18, 10, 0.9)
	d.L(7, 14, 17, 14)
end)
def("star", function(d)
	local pts = {}
	for i = 0, 9 do
		local r = (i % 2 == 0) and 10 or 4.3
		local a = math.rad(-90 + i * 36)
		pts[#pts + 1] = { 12 + r * math.cos(a), 12.6 + r * math.sin(a) }
	end
	d.P(pts, true)
end)
def("refresh", function(d)
	d.A(12, 12, 8, 40, 340)
	d.P({ { 18, 2.5 }, { 18.4, 7.4 }, { 13.4, 7.6 } }, false)
end)
def("list", function(d)
	d.L(8, 6, 20, 6)
	d.L(8, 12, 20, 12)
	d.L(8, 18, 20, 18)
	d.D(4, 6, 1.2)
	d.D(4, 12, 1.2)
	d.D(4, 18, 1.2)
end)
def("resize", function(d)
	d.L(20, 8, 8, 20)
	d.L(20, 14, 14, 20)
end)
def("pulse", function(d)
	d.P({ { 2, 12 }, { 7, 12 }, { 10, 5 }, { 14, 19 }, { 17, 12 }, { 22, 12 } }, false)
end)
def("run", function(d)
	d.P({ { 4, 6 }, { 10, 12 }, { 4, 18 } }, false)
	d.P({ { 12, 6 }, { 18, 12 }, { 12, 18 } }, false)
end)
def("wrench", function(d)
	d.L(5.5, 18.5, 12.5, 11.5)
	d.C(16.5, 7.5, 4)
	d.L(16.5, 7.5, 20, 4)
end)
def("shield", function(d)
	d.P({ { 12, 3 }, { 20, 6 }, { 20, 12 }, { 12, 21 }, { 4, 12 }, { 4, 6 } }, true)
	d.P({ { 8.5, 11.5 }, { 11, 14 }, { 15.5, 9 } }, false)
end)
def("heart", function(d)
	d.P({ { 12, 20 }, { 4, 11 }, { 4.6, 7 }, { 8, 5 }, { 12, 8 }, { 16, 5 }, { 19.4, 7 }, { 20, 11 } }, true)
end)
def("flame", function(d)
	d.P({ { 12, 3 }, { 16, 9 }, { 18, 14 }, { 12, 21 }, { 6, 14 }, { 8, 9 }, { 10.5, 11 } }, true)
end)
def("crown", function(d)
	d.P({ { 3, 18 }, { 3, 8 }, { 8, 12 }, { 12, 5 }, { 16, 12 }, { 21, 8 }, { 21, 18 } }, true)
end)
def("key", function(d)
	d.C(8, 12, 4)
	d.L(12, 12, 21, 12)
	d.L(18, 12, 18, 16)
	d.L(21, 12, 21, 15)
end)
def("lock", function(d)
	d.R(5, 11, 14, 10, 2)
	d.A(12, 11, 4.5, 0, 180)
	d.D(12, 16, 1.3)
end)
def("unlock", function(d)
	d.R(5, 11, 14, 10, 2)
	d.P({ { 8, 11 }, { 8, 8 }, { 10.5, 5 }, { 14, 5 }, { 16, 7 } }, false)
	d.D(12, 16, 1.3)
end)
def("clock", function(d)
	d.C(12, 12, 9)
	d.L(12, 7, 12, 12)
	d.L(12, 12, 16, 14)
end)
def("map", function(d)
	d.P({ { 3, 6 }, { 9, 4 }, { 15, 6 }, { 21, 4 }, { 21, 18 }, { 15, 20 }, { 9, 18 }, { 3, 20 } }, true)
	d.L(9, 4, 9, 18)
	d.L(15, 6, 15, 20)
end)
def("marker", function(d)
	d.C(12, 10, 6)
	d.L(7.8, 14.4, 12, 21)
	d.L(16.2, 14.4, 12, 21)
	d.D(12, 10, 2)
end)
def("bag", function(d)
	d.R(5, 8, 14, 13, 2)
	d.A(12, 8, 4, 0, 180)
end)
def("coin", function(d)
	d.C(12, 12, 9)
	d.C(12, 12, 5)
end)
def("gem", function(d)
	d.P({ { 6, 4 }, { 18, 4 }, { 22, 10 }, { 12, 21 }, { 2, 10 } }, true)
	d.L(2, 10, 22, 10)
	d.L(9, 4, 7.5, 10)
	d.L(15, 4, 16.5, 10)
end)
def("trophy", function(d)
	d.P({ { 7, 4 }, { 17, 4 }, { 16, 11 }, { 12, 14 }, { 8, 11 } }, true)
	d.L(12, 14, 12, 18)
	d.L(8, 20, 16, 20)
	d.P({ { 7, 6 }, { 4, 6 }, { 5, 10 }, { 8, 10 } }, false)
	d.P({ { 17, 6 }, { 20, 6 }, { 19, 10 }, { 16, 10 } }, false)
end)
def("flag", function(d)
	d.L(6, 3, 6, 21)
	d.P({ { 6, 4 }, { 19, 4 }, { 15, 8 }, { 19, 12 }, { 6, 12 } }, true)
end)
def("bug", function(d)
	d.C(12, 13, 5)
	d.L(12, 8, 12, 18)
	d.L(7, 11, 3, 9)
	d.L(7, 15, 3, 17)
	d.L(17, 11, 21, 9)
	d.L(17, 15, 21, 17)
	d.L(9, 8, 7, 5)
	d.L(15, 8, 17, 5)
end)
def("code", function(d)
	d.P({ { 9, 7 }, { 4, 12 }, { 9, 17 } }, false)
	d.P({ { 15, 7 }, { 20, 12 }, { 15, 17 } }, false)
	d.L(13.5, 5, 10.5, 19)
end)
def("terminal", function(d)
	d.R(3, 5, 18, 14, 2)
	d.P({ { 7, 10 }, { 10, 12.5 }, { 7, 15 } }, false)
	d.L(12, 15, 17, 15)
end)
def("cursor", function(d)
	d.P({ { 5, 3 }, { 5, 19 }, { 9.5, 15 }, { 12.5, 21.5 }, { 15, 20.5 }, { 12, 14.5 }, { 18, 14 } }, true)
end)
def("camera", function(d)
	d.R(3, 7, 18, 13, 2)
	d.C(12, 13.5, 3.5)
	d.P({ { 8, 7 }, { 9.5, 4.5 }, { 14.5, 4.5 }, { 16, 7 } }, false)
end)
def("download", function(d)
	d.L(12, 4, 12, 15)
	d.P({ { 7, 10.5 }, { 12, 15.5 }, { 17, 10.5 } }, false)
	d.L(5, 20, 19, 20)
end)
def("upload", function(d)
	d.L(12, 15, 12, 4)
	d.P({ { 7, 9 }, { 12, 4 }, { 17, 9 } }, false)
	d.L(5, 20, 19, 20)
end)
def("trash", function(d)
	d.L(4, 7, 20, 7)
	d.R(6, 7, 12, 14, 1.5)
	d.L(9, 4, 15, 4)
	d.L(10, 11, 10, 17)
	d.L(14, 11, 14, 17)
end)
def("copy", function(d)
	d.R(8, 8, 12, 12, 2)
	d.P({ { 8, 16 }, { 5, 16 }, { 5, 5 }, { 16, 5 }, { 16, 8 } }, false)
end)
def("power", function(d)
	d.A(12, 12, 8, 130, 410)
	d.L(12, 3, 12, 12)
end)
def("wifi", function(d)
	d.A(12, 20, 6, 50, 130)
	d.A(12, 20, 11, 50, 130)
	d.A(12, 20, 16, 50, 130)
	d.D(12, 20, 1.3)
end)
def("sun", function(d)
	d.C(12, 12, 4)
	for i = 0, 7 do
		local a = math.rad(i * 45)
		d.L(12 + 7 * math.cos(a), 12 - 7 * math.sin(a), 12 + 10 * math.cos(a), 12 - 10 * math.sin(a))
	end
end)
def("flask", function(d)
	d.P({ { 9, 3 }, { 9, 9 }, { 4, 19 }, { 20, 19 }, { 15, 9 }, { 15, 3 } }, true)
	d.L(8, 3, 16, 3)
	d.L(7, 14, 17, 14)
end)
def("book", function(d)
	d.R(4, 4, 16, 17, 2)
	d.L(8, 4, 8, 21)
	d.L(11, 9, 16, 9)
	d.L(11, 13, 16, 13)
end)
def("filter", function(d)
	d.P({ { 3, 5 }, { 21, 5 }, { 14, 13 }, { 14, 20 }, { 10, 18 }, { 10, 13 } }, true)
end)
def("layers", function(d)
	d.P({ { 12, 3 }, { 21, 8 }, { 12, 13 }, { 3, 8 } }, true)
	d.P({ { 3, 12 }, { 12, 17 }, { 21, 12 } }, false)
	d.P({ { 3, 16 }, { 12, 21 }, { 21, 16 } }, false)
end)
def("sparkle", function(d)
	d.P({ { 12, 3 }, { 14, 10 }, { 21, 12 }, { 14, 14 }, { 12, 21 }, { 10, 14 }, { 3, 12 }, { 10, 10 } }, true)
end)
def("dots", function(d)
	d.D(5, 12, 1.6)
	d.D(12, 12, 1.6)
	d.D(19, 12, 1.6)
end)
def("pin", function(d)
	d.C(12, 9, 5)
	d.L(12, 14, 12, 22)
end)
def("moon", function(d)
	d.A(12, 12, 9, 70, 290)
	d.A(16.5, 9, 7, 240, 80)
end)
def("mouse", function(d)
	d.R(6, 3, 12, 18, 6)
	d.L(12, 3, 12, 9)
end)
def("gamepad", function(d)
	d.R(2, 7, 20, 11, 5)
	d.L(7, 10, 7, 15)
	d.L(4.5, 12.5, 9.5, 12.5)
	d.D(16, 11, 1.1)
	d.D(18.5, 13.5, 1.1)
end)

local TAB_ICONS = {
	farming = "sprout", farm = "sprout", bosses = "skull", boss = "skull", combat = "swords", dungeon = "gate",
	teleport = "marker", player = "user", extras = "grid", settings = "sliders", home = "home", main = "home",
	visuals = "eye", esp = "eye", movement = "run", misc = "grid", world = "map", shop = "bag", fishing = "fish",
	quests = "scroll", quest = "scroll", inventory = "bag", aim = "target", tools = "wrench", info = "info",
	config = "save", security = "shield", icons = "sparkle", loot = "chest", weapons = "sword", skills = "bolt",
	players = "users", webhook = "link", debug = "bug", scripts = "code", training = "flame", safety = "shield",
}
local ICON_ALIASES = {
	sprout = "sprout", swords = "swords", compass = "target", user = "user", settings = "sliders",
	chest = "chest", fish = "fish",
}
local SECTION_ICONS = {
	{ "webhook", "link" },
	{ "alert", "bell" }, { "account guard", "lock" }, { "guard", "lock" }, { "player teleport", "users" },
	{ "npc", "user" }, { "trainer", "user" }, { "landmark", "flag" }, { "coordinate", "marker" },
	{ "private server", "lock" }, { "server hop", "wifi" }, { "staff", "users" }, { "seller", "coin" },
	{ "marketer", "bag" }, { "crow", "target" }, { "muzan", "crown" }, { "lily", "sparkle" }, { "yeti", "gem" },
	{ "spin", "refresh" }, { "stat", "trophy" }, { "schematic", "book" }, { "parry", "shield" },
	{ "breathing", "flame" }, { "spawn", "gem" }, { "final", "flag" }, { "aura", "sparkle" },
	{ "performance", "pulse" }, { "horse", "run" }, { "survival", "heart" }, { "protect", "shield" },
	{ "safe", "shield" }, { "vision", "eye" }, { "utility", "wrench" }, { "training", "flame" },
	{ "hunt", "target" }, { "private", "lock" },
	{ "boss", "skull" }, { "loot", "chest" }, { "chest", "chest" }, { "dungeon", "gate" },
	{ "fish", "fish" }, { "skill", "bolt" }, { "weapon", "sword" }, { "combat", "swords" },
	{ "teleport", "marker" }, { "webhook", "link" }, { "config", "save" }, { "theme", "palette" },
	{ "color", "palette" }, { "interface", "window" }, { "system", "gear" }, { "player", "user" },
	{ "farm", "sprout" }, { "quest", "scroll" }, { "m1", "swords" }, { "esp", "eye" }, { "visual", "eye" },
	{ "key", "keyboard" }, { "auto", "bolt" }, { "status", "pulse" }, { "setting", "sliders" },
	{ "list", "list" }, { "tool", "wrench" }, { "move", "run" }, { "shop", "bag" }, { "info", "info" },
	{ "general", "home" }, { "security", "shield" }, { "camera", "camera" }, { "world", "map" },
}
local function tabIcon(name, hint)
	local lower = string.lower(tostring(name or ""))
	if TAB_ICONS[lower] then return TAB_ICONS[lower] end
	for word, ic in pairs(TAB_ICONS) do
		if string.find(lower, word, 1, true) then return ic end
	end
	if ICONS[tostring(hint or "")] then return hint end
	return ICON_ALIASES[tostring(hint or "")] or "dot"
end
local function sectionIcon(name)
	local lower = string.lower(tostring(name or ""))
	for _, rule in ipairs(SECTION_ICONS) do
		if string.find(lower, rule[1], 1, true) then return rule[2] end
	end
	return "dot"
end
UI.Icons = ICON_LIST
function UI:Icon(parent, name, size, spec) return icon(parent, name, size or 18, spec or "Text") end

---------------------------------------------------------------- root gui
local function pickParent()
	local parent
	pcall(function() if gethui then parent = gethui() end end)
	if not parent then pcall(function() parent = cloneref(game:GetService("CoreGui")) end) end
	if not parent then parent = LocalPlayer:WaitForChild("PlayerGui") end
	return parent
end

local Gui = new("ScreenGui", {
	Name = "GluUI_" .. tostring(math.random(100000, 999999)),
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 1000000,
})
pcall(function()
	local protect = (syn and syn.protect_gui) or protect_gui or protectgui
	if protect then protect(Gui) end
end)
Gui.Parent = pickParent()
UI.ScreenGui = Gui
UI.GlobalLogo = ""

local HudLayer = new("Frame", { Name = "Hud", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2 }, Gui)
local WindowLayer = new("Frame", { Name = "Windows", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 3 }, Gui)
local PopupLayer = new("Frame", { Name = "Popups", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 5, Visible = false }, Gui)
local ToastLayer = new("Frame", { Name = "Toasts", BackgroundTransparency = 1, ZIndex = 6, Size = UDim2.new(0, 304, 1, -32) }, Gui)
local TipLayer = new("Frame", { Name = "Tips", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 7 }, Gui)

local Windows = {}
local function sheetMode()
	if TOUCH then return true end
	for _, win in ipairs(Windows) do
		if win.Compact then return true end
	end
	return false
end

local Catcher = new("TextButton", {
	Name = "Catcher", Text = "", AutoButtonColor = false, BorderSizePixel = 0,
	Size = UDim2.fromScale(1, 1), ZIndex = 1, BackgroundColor3 = rgb(0, 0, 0), BackgroundTransparency = 1,
}, PopupLayer)

-- liquid glass finish: translucent body, bright rim that fades along a diagonal, a specular glint that sweeps across once
local function glassify(frame, radius, sweep, plain)
	radius = radius or 16
	if not plain then frame.BackgroundTransparency = 0.1 end
	for _, c in ipairs(frame:GetChildren()) do
		if c:IsA("UICorner") then c.CornerRadius = UDim.new(0, radius) end
		if c:IsA("UIStroke") then
			c.Thickness = 1.2
			c.Transparency = 0.45
			new("UIGradient", {
				Rotation = 115,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.4, 0.75),
					NumberSequenceKeypoint.new(0.75, 0.9), NumberSequenceKeypoint.new(1, 0.45),
				}),
			}, c)
			themed(c, { Color = "Text" })
		end
	end
	local body = not plain and new("UIGradient", { Rotation = 100 }, frame)
	if body then themed(body, { Color = { "Panel", function(c) return ColorSequence.new(c:Lerp(rgb(255, 255, 255), 0.09), c, c:Lerp(rgb(0, 0, 0), 0.2)) end } }) end
	local sheen = new("Frame", {
		Name = "Sheen", Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(255, 255, 255), BackgroundTransparency = 0.82,
		BorderSizePixel = 0, ZIndex = 50, Active = false,
	}, frame)
	corner(sheen, radius)
	local g = new("UIGradient", {
		Rotation = 20, Offset = Vector2.new(-1.2, 0),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.42, 1), NumberSequenceKeypoint.new(0.5, 0.35),
			NumberSequenceKeypoint.new(0.58, 1), NumberSequenceKeypoint.new(1, 1),
		}),
	}, sheen)
	if sweep ~= false then
		tween(g, { Offset = Vector2.new(1.2, 0) }, 0.9, Enum.EasingStyle.Quint)
	end
	return sheen
end

local Popup = { Current = nil }
function Popup.close()
	local current = Popup.Current
	if not current then return end
	Popup.Current = nil
	if current.onClose then pcall(current.onClose) end
	pcall(function() current.frame:Destroy() end)
	PopupLayer.Visible = false
	Catcher.BackgroundTransparency = 1
end
function Popup.open(frame, onClose)
	Popup.close()
	frame.ZIndex = 2
	frame.Parent = PopupLayer
	glassify(frame, sheetMode() and 22 or 16)
	local pop = new("UIScale", { Scale = 0.9 }, frame)
	tween(pop, { Scale = 1 }, 0.32, Enum.EasingStyle.Back)
	Popup.Current = { frame = frame, onClose = onClose }
	Catcher.BackgroundTransparency = sheetMode() and 0.5 or 1
	PopupLayer.Visible = true
end
conn(Catcher.Activated, Popup.close)
conn(Catcher.MouseButton2Click, Popup.close)

local function placePopup(frame, anchor, width, height)
	local screen = Gui.AbsoluteSize
	if sheetMode() then
		local w = math.min(math.max(width, 300), screen.X - 16, 440)
		local h = math.min(height, screen.Y * 0.72)
		frame.AnchorPoint = Vector2.new(0.5, 1)
		frame.Position = UDim2.new(0.5, 0, 1, -10)
		frame.Size = UDim2.fromOffset(w, h)
		return w, h
	end
	local pos, size = anchor.AbsolutePosition - Gui.AbsolutePosition, anchor.AbsoluteSize
	local x = math.clamp(pos.X + size.X - width, 8, math.max(8, screen.X - width - 8))
	local y = pos.Y + size.Y + 4
	if y + height > screen.Y - 8 then y = pos.Y - height - 4 end
	y = math.clamp(y, 8, math.max(8, screen.Y - height - 8))
	frame.Position = UDim2.fromOffset(x, y)
	frame.Size = UDim2.fromOffset(width, height)
	return width, height
end

---------------------------------------------------------------- tooltip
local Tip = { Frame = nil, Label = nil, Token = 0 }
Tip.Frame = new("Frame", {
	Name = "Tip", Visible = false, AutomaticSize = Enum.AutomaticSize.XY,
	Size = UDim2.fromOffset(0, 0), ZIndex = 2,
}, TipLayer)
themed(Tip.Frame, { BackgroundColor3 = "Window" })
corner(Tip.Frame, 4)
stroke(Tip.Frame, "Line")
pad(Tip.Frame, 9, 6, 9, 6)
Tip.Label = text(Tip.Frame, "", 12, "Text", FONT, {
	AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), TextWrapped = true, ZIndex = 3,
})
new("UISizeConstraint", { MaxSize = Vector2.new(280, 400) }, Tip.Frame)

local function tipMove(x, y)
	local screen = Gui.AbsoluteSize
	local size = Tip.Frame.AbsoluteSize
	local px = math.clamp(x + 14, 6, math.max(6, screen.X - size.X - 6))
	local py = y + 18
	if py + size.Y > screen.Y - 6 then py = y - size.Y - 10 end
	Tip.Frame.Position = UDim2.fromOffset(px, py)
end
local function attachTip(obj, str)
	str = tostring(str or "")
	if str == "" then return end
	if TOUCH then
		local held
		obj.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch then return end
			Tip.Token = Tip.Token + 1
			local token = Tip.Token
			held = input
			task.delay(0.55, function()
				if token ~= Tip.Token or held ~= input or Popup.Current then return end
				Tip.Label.Text = str
				Tip.Frame.Visible = true
				tipMove(input.Position.X - 60, input.Position.Y - 70)
				task.delay(2.4, function()
					if token == Tip.Token then Tip.Frame.Visible = false end
				end)
			end)
		end)
		obj.InputEnded:Connect(function(input)
			if input == held then held = nil end
		end)
		return
	end
	obj.MouseEnter:Connect(function()
		Tip.Token = Tip.Token + 1
		local token = Tip.Token
		task.delay(0.45, function()
			if token ~= Tip.Token or Popup.Current then return end
			Tip.Label.Text = str
			Tip.Frame.Visible = true
			local m = UserInputService:GetMouseLocation()
			tipMove(m.X, m.Y - 36)
		end)
	end)
	obj.MouseMoved:Connect(function()
		if Tip.Frame.Visible then
			local m = UserInputService:GetMouseLocation()
			tipMove(m.X, m.Y - 36)
		end
	end)
	obj.MouseLeave:Connect(function()
		Tip.Token = Tip.Token + 1
		Tip.Frame.Visible = false
	end)
end

---------------------------------------------------------------- key helpers
local KEY_SHORT = {
	LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift",
	LeftAlt = "LAlt", RightAlt = "RAlt", MouseButton1 = "M1", MouseButton2 = "M2", MouseButton3 = "M3",
	Return = "Enter", Backspace = "Bksp", Escape = "Esc", Insert = "Ins", Delete = "Del",
	PageUp = "PgUp", PageDown = "PgDn", CapsLock = "Caps",
}
local function keyName(key)
	if typeof(key) == "EnumItem" then return key.Name end
	return tostring(key or "None")
end
local function keyEnum(name)
	if typeof(name) == "EnumItem" then return name end
	name = tostring(name or "None")
	name = name:gsub("^Enum%.", ""):gsub("^KeyCode%.", ""):gsub("^UserInputType%.", "")
	if name == "" or name == "None" or name == "Unknown" then return Enum.KeyCode.None end
	local ok, key = pcall(function() return Enum.KeyCode[name] end)
	if ok and typeof(key) == "EnumItem" then return key end
	local ok2, uit = pcall(function() return Enum.UserInputType[name] end)
	if ok2 and typeof(uit) == "EnumItem" then return uit end
	return Enum.KeyCode.None
end
local function keyMatches(key, input)
	if not key or key == Enum.KeyCode.None then return false end
	if key.EnumType == Enum.KeyCode then return input.KeyCode == key end
	return input.UserInputType == key
end

local Keybinds = {}
local Listening = nil

---------------------------------------------------------------- toasts
local ToastList = {}
local function placeToasts()
	local compact = sheetMode()
	local inset = topInset()
	if compact then
		ToastLayer.AnchorPoint = Vector2.new(0.5, 0)
		ToastLayer.Position = UDim2.new(0.5, 0, 0, inset + 6)
		ToastLayer.Size = UDim2.new(0, math.min(304, Gui.AbsoluteSize.X - 16), 1, -(inset + 12))
	else
		ToastLayer.AnchorPoint = Vector2.new(1, 1)
		ToastLayer.Position = UDim2.new(1, -16, 1, -16)
		ToastLayer.Size = UDim2.new(0, 304, 1, -32)
	end
end
local ToastLayout = new("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
	VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right,
}, ToastLayer)
local KIND = {
	success = { icon = "check", color = rgb(74, 222, 128) },
	warn    = { icon = "warn",  color = rgb(251, 191, 36) },
	error   = { icon = "close", color = rgb(248, 113, 113) },
	info    = { icon = "info",  color = nil },
}
local function dismissToast(entry)
	if entry.Dead then return end
	entry.Dead = true
	for i, e in ipairs(ToastList) do
		if e == entry then table.remove(ToastList, i) break end
	end
	pcall(function()
		tween(entry.Card, { Position = UDim2.new(0, 360, 0, 0) }, 0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		tween(entry.Scale, { Scale = 0.9 }, 0.24)
		task.delay(0.1, function()
			pcall(function() tween(entry.Wrap, { Size = UDim2.new(1, 0, 0, 0) }, 0.18) end)
		end)
		task.delay(0.3, function() entry.Wrap:Destroy() end)
	end)
end
local toastSerial = 0
function UI:Notification(cfg)
	if UI.Resyncing then return end
	cfg = cfg or {}
	placeToasts()
	local title = tostring(cfg.Name or cfg.Title or "Glu")
	local body = tostring(cfg.Content or "")
	local at = string.find(title, ": ", 1, true)
	if at and body == "" then
		body = string.sub(title, at + 2)
		title = string.sub(title, 1, at - 1)
	end
	local kindName = string.lower(tostring(cfg.Kind or "info"))
	local kind = KIND[kindName] or KIND.info
	local duration = math.clamp(tonumber(cfg.Time or cfg.Duration) or 4, 1, 15)
	local key = kindName .. "\0" .. title .. "\0" .. body
	for _, e in ipairs(ToastList) do
		if e.Key == key and not e.Dead then
			e.Count = e.Count + 1
			e.Title.Text = title .. "  x" .. e.Count
			e.ExpireAt = os.clock() + duration
			e.Duration = duration
			e.Bar.Size = UDim2.new(1, 0, 1, 0)
			tween(e.Bar, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear)
			tween(e.Scale, { Scale = 1.04 }, 0.08)
			task.delay(0.09, function() if not e.Dead then tween(e.Scale, { Scale = 1 }, 0.18, Enum.EasingStyle.Back) end end)
			return
		end
	end
	while #ToastList >= 4 do dismissToast(ToastList[1]) end
	toastSerial = toastSerial + 1
	local wrap = new("Frame", {
		Name = "ToastWrap", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0), LayoutOrder = toastSerial,
	}, ToastLayer)
	local card = new("Frame", {
		Name = "Toast", AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 360, 0, 0), BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0),
	}, wrap)
	themed(card, { BackgroundColor3 = "Panel" })
	corner(card, 16)
	stroke(card, "Text", 1, 0.5)
	local scale = new("UIScale", { Scale = 0.92 }, card)
	local tint = kind.color
	local badge = new("Frame", {
		Position = UDim2.fromOffset(12, 12), Size = UDim2.fromOffset(32, 32), BorderSizePixel = 0, BackgroundTransparency = 0.8,
	}, card)
	if tint then badge.BackgroundColor3 = tint else themed(badge, { BackgroundColor3 = "Accent" }) end
	corner(badge, 16)
	local badgeStroke = stroke(badge, "Accent", 1, 0.55)
	if tint then badgeStroke.Color = tint end
	local ic = icon(badge, kind.icon, 16, "Accent")
	ic.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	ic.Frame.Position = UDim2.fromScale(0.5, 0.5)
	if tint then pcall(function() ic.SetColor(tint) end) end
	local holder = new("Frame", {
		BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromOffset(54, 0), Size = UDim2.new(1, -66, 0, 0),
	}, card)
	pad(holder, 0, 12, 0, 18)
	vlist(holder, 3)
	local titleLbl = text(holder, title, 13, "Text", FONT_B, {
		AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 16), TextWrapped = true, LayoutOrder = 1,
	})
	if body ~= "" then
		text(holder, body, 12, "Muted", FONT, {
			AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 14),
			TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2,
		})
	end
	local track = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -8), Size = UDim2.new(1, -28, 0, 3),
		BorderSizePixel = 0, BackgroundTransparency = 0.88, ZIndex = 3,
	}, card)
	themed(track, { BackgroundColor3 = "Text" })
	corner(track, 2)
	local bar = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, ZIndex = 4 }, track)
	if tint then bar.BackgroundColor3 = tint else themed(bar, { BackgroundColor3 = "Accent" }) end
	corner(bar, 2)
	local entry = {
		Key = key, Wrap = wrap, Card = card, Title = titleLbl, Bar = bar, Scale = scale, Count = 1,
		ExpireAt = os.clock() + duration, Duration = duration,
	}
	ToastList[#ToastList + 1] = entry
	glassify(card, 16, true)
	tween(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.42, Enum.EasingStyle.Back)
	tween(scale, { Scale = 1 }, 0.42, Enum.EasingStyle.Back)
	tween(bar, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear)
	local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 6 }, card)
	hit.Activated:Connect(function() dismissToast(entry) end)
	if not TOUCH then
		hit.MouseEnter:Connect(function()
			entry.Hover = true
			bar.Size = bar.Size
			tween(bar, { Size = UDim2.new(1, 0, 1, 0) }, 0.2)
		end)
		hit.MouseLeave:Connect(function()
			entry.Hover = false
			entry.ExpireAt = os.clock() + 2
			tween(bar, { Size = UDim2.new(0, 0, 1, 0) }, 2, Enum.EasingStyle.Linear)
		end)
	end
	task.spawn(function()
		while not entry.Dead and (entry.Hover or os.clock() < entry.ExpireAt) do task.wait(0.1) end
		dismissToast(entry)
	end)
end

---------------------------------------------------------------- hud
local Fps = { Value = 60, Frames = 0, Stamp = os.clock() }
conn(RunService.RenderStepped, function()
	Fps.Frames = Fps.Frames + 1
	local now = os.clock()
	if now - Fps.Stamp >= 0.5 then
		Fps.Value = math.floor(Fps.Frames / (now - Fps.Stamp) + 0.5)
		Fps.Frames = 0
		Fps.Stamp = now
	end
end)
local function pingMs()
	local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
	return ok and math.floor(v + 0.5) or 0
end
local function activeCount()
	local n = 0
	for _, win in ipairs(Windows) do
		for _, t in ipairs(win.Toggles) do
			if t.Value == true then n = n + 1 end
		end
	end
	return n
end

local Hud = { Frame = nil, Labels = {} }
function UI:SetWatermark(on)
	on = on == true
	if not on then
		if Hud.Frame then Hud.Frame.Visible = false end
		return
	end
	if not Hud.Frame then
		local f = new("Frame", {
			Name = "Watermark", Position = UDim2.fromOffset(14, topInset() + 8), AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 28), BorderSizePixel = 0,
		}, HudLayer)
		themed(f, { BackgroundColor3 = "Window" })
		corner(f, 5)
		stroke(f, "Line")
		pad(f, 9, 0, 12, 0)
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Center,
		}, f)
		local mark = icon(f, "logo", 15, "Accent")
		mark.Frame.LayoutOrder = 1
		text(f, "GLU HUB", 11, "Text", FONT_B, { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 28), LayoutOrder = 2 })
		Hud.Labels.Fps = text(f, "", 11, "Muted", MONO, { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 28), LayoutOrder = 3 })
		Hud.Labels.Ping = text(f, "", 11, "Muted", MONO, { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 28), LayoutOrder = 4 })
		Hud.Labels.On = text(f, "", 11, "Accent", MONO, { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 28), LayoutOrder = 5 })
		local dragging, origin, start
		f.InputBegan:Connect(function(input)
			if isPress(input) then dragging, origin, start = true, input.Position, f.Position end
		end)
		conn(UserInputService.InputChanged, function(input)
			if dragging and isMove(input) then
				local d = input.Position - origin
				f.Position = UDim2.fromOffset(start.X.Offset + d.X, start.Y.Offset + d.Y)
			end
		end)
		conn(UserInputService.InputEnded, function(input)
			if isPress(input) then dragging = false end
		end)
		Hud.Frame = f
	end
	Hud.Frame.Visible = true
end

---------------------------------------------------------------- containers
local Container = {}
Container.__index = Container

function Container:_row(height, name, tip, kind)
	self.BtnRow = nil
	self.Order = (self.Order or 0) + 1
	local row = new(kind or "TextButton", {
		Name = "Row", BackgroundTransparency = 1, BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height), LayoutOrder = self.Order,
	})
	if row:IsA("TextButton") then
		row.Text = ""
		row.AutoButtonColor = false
	end
	themed(row, { BackgroundColor3 = "Card" })
	corner(row, 10)
	row.Parent = self.Content
	if not TOUCH then
		row.MouseEnter:Connect(function() tween(row, { BackgroundTransparency = 0.4 }, 0.12) end)
		row.MouseLeave:Connect(function() tween(row, { BackgroundTransparency = 1 }, 0.14) end)
	end
	attachTip(row, tip)
	local entry = { Frame = row, Text = string.lower(tostring(name or "") .. " " .. tostring(tip or "")) }
	if self.Gear and self.ParentEntry then
		self.ParentEntry.Text = self.ParentEntry.Text .. " " .. entry.Text
	elseif self.Win then
		self.Win:_register(entry, self.Page, self.Section)
	end
	return row, entry
end

function Container:_label(row, name, reserveRight, reserveLeft)
	return text(row, name, K.Text, "Text", FONT, {
		Position = UDim2.fromOffset(reserveLeft or 12, 0),
		Size = UDim2.new(1, -((reserveLeft or 12) + (reserveRight or 12)), 1, 0),
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
end

function Container:Toggle(cfg)
	cfg = cfg or {}
	local container = self
	local item = { Value = cfg.Default == true, Window = self.Win, Page = self.Page, Section = self.Section }
	local row, entry = self:_row(K.Row, cfg.Name, cfg.Tooltip)
	self.Order = self.Order + 1
	local sw = K.Switch
	local lbl = self:_label(row, cfg.Name, sw.X + 30)
	local track = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(sw.X, sw.Y),
		BorderSizePixel = 0,
	}, row)
	corner(track, sw.Y / 2)
	local knobSize = sw.Y - 4
	local knob = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(knobSize, knobSize),
		BorderSizePixel = 0,
	}, track)
	themed(knob, { BackgroundColor3 = "Text" })
	corner(knob, knobSize / 2)
	local markSize = math.floor(knobSize * 0.62)
	local markOn = icon(knob, "check", markSize, "Window")
	local markOff = icon(knob, "minus", markSize, "Window")
	for _, m in ipairs({ markOn, markOff }) do
		m.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		m.Frame.Position = UDim2.fromScale(0.5, 0.5)
	end
	local ON_TRACK = { "Accent", function(c) return c:Lerp(UI.Theme.Window, 0.3) end }
	local function paint(animate)
		local on = item.Value
		local spec = on and ON_TRACK or "Line"
		local goalPos = on and UDim2.new(1, -(knobSize + 2), 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		markOn.Frame.Visible = on
		markOff.Frame.Visible = not on
		if animate then
			tween(track, { BackgroundColor3 = resolve(spec) }, 0.14)
			tween(knob, { Position = goalPos }, 0.16, Enum.EasingStyle.Back)
			task.delay(0.2, function()
				themed(track, { BackgroundColor3 = item.Value and ON_TRACK or "Line" })
			end)
		else
			themed(track, { BackgroundColor3 = spec })
			knob.Position = goalPos
		end
	end
	paint(false)
	function item:Set(v, silent)
		v = v == true
		if v == self.Value then return end
		self.Value = v
		paint(true)
		if container.Win then container.Win:_counts() end
		item.Synced = v
		if not silent then safe(cfg.Callback, v) end
	end
	function item:SetValue(v) self:Set(v) end
	function item:GetValue() return self.Value end
	row.Activated:Connect(function() item:Set(not item.Value) end)
	function item:Settings()
		if item.Panel then return item.Panel end
		local gsize = TOUCH and 32 or 24
		local gearBtn = new("TextButton", {
			Text = "", AutoButtonColor = false, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -(sw.X + 22), 0.5, 0), Size = UDim2.fromOffset(gsize, gsize),
		}, row)
		themed(gearBtn, { BackgroundColor3 = "Line" })
		corner(gearBtn, gsize / 2)
		local gi = icon(gearBtn, "gear", math.floor(gsize * 0.6), "Muted")
		gi.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		gi.Frame.Position = UDim2.fromScale(0.5, 0.5)
		lbl.Size = UDim2.new(1, -(12 + sw.X + 22 + gsize + 8), 1, 0)
		local panel = new("Frame", {
			Name = "GearPanel", Visible = false, AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0,
			Size = UDim2.new(1, -14, 0, 0), LayoutOrder = row.LayoutOrder + 1,
		})
		themed(panel, { BackgroundColor3 = "Window" })
		corner(panel, 10)
		stroke(panel, "Line", 1, 0.3)
		pad(panel, 4, 4, 4, 4)
		vlist(panel, 2)
		panel.Parent = container.Content
		local sub = setmetatable({
			Win = container.Win, Page = container.Page, Section = container.Section, Content = panel,
			Order = 0, Gear = true, ParentEntry = entry, Items = {},
		}, Container)
		local open = false
		gearBtn.Activated:Connect(function()
			open = not open
			panel.Visible = open
			gi.SetColor(open and "Accent" or "Muted")
			themed(gearBtn, { BackgroundColor3 = open and "Muted" or "Line" })
		end)
		attachTip(gearBtn, "options")
		item.Panel = sub
		return sub
	end
	item.Synced = false
	item.Fire = function() safe(cfg.Callback, true) end
	if self.Win then
		self.Win.AllToggles[#self.Win.AllToggles + 1] = item
		if not self.Gear then self.Win.Toggles[#self.Win.Toggles + 1] = item end
	end
	return item
end

function Container:Slider(cfg)
	cfg = cfg or {}
	local container = self
	local min = tonumber(cfg.Min) or 0
	local max = tonumber(cfg.Max) or 100
	if max <= min then max = min + 1 end
	local dec = math.clamp(math.floor(tonumber(cfg.Decimals) or 0), 0, 5)
	local suffix = tostring(cfg.Suffix or "")
	local step = 10 ^ -dec
	local default = tonumber(cfg.Default) or min
	local function snap(v)
		v = math.clamp(tonumber(v) or min, min, max)
		v = math.floor(v / step + 0.5) * step
		return math.clamp(tonumber(string.format("%." .. dec .. "f", v)), min, max)
	end
	local stepBtn = math.max(step, snap((max - min) / 40))
	local item = { Value = snap(default) }
	local row = self:_row(K.SliderRow, cfg.Name, cfg.Tooltip)
	local top = TOUCH and 9 or 7
	text(row, cfg.Name, K.Text, "Text", FONT_M, {
		Position = UDim2.fromOffset(12, top), Size = UDim2.new(1, -112, 0, 20), TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local box = new("TextBox", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, top), Size = UDim2.fromOffset(92, 20),
		BackgroundTransparency = 1, Font = FONT_B, TextSize = K.Text, TextXAlignment = Enum.TextXAlignment.Right,
		ClearTextOnFocus = true, Text = "", BorderSizePixel = 0,
	}, row)
	themed(box, { TextColor3 = "Text" })
	local bs = TOUCH and 28 or 20
	local midY = K.SliderRow - (bs / 2 + 9)
	local function stepper(side, iconName, delta)
		local b = new("TextButton", {
			Text = "", AutoButtonColor = false, BorderSizePixel = 0, AnchorPoint = Vector2.new(side == "r" and 1 or 0, 0.5),
			Position = UDim2.new(side == "r" and 1 or 0, side == "r" and -12 or 12, 0, midY), Size = UDim2.fromOffset(bs, bs),
		}, row)
		themed(b, { BackgroundColor3 = "Line" })
		corner(b, bs / 2)
		local i = icon(b, iconName, math.floor(bs * 0.6), "Muted")
		i.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		i.Frame.Position = UDim2.fromScale(0.5, 0.5)
		b.Activated:Connect(function() item:Set(item.Value + delta) end)
		return b
	end
	stepper("l", "minus", -stepBtn)
	stepper("r", "plus", stepBtn)
	local trackX = 12 + bs + 10
	local track = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, trackX, 0, midY),
		Size = UDim2.new(1, -(trackX * 2), 0, TOUCH and 5 or 4), BorderSizePixel = 0,
	}, row)
	themed(track, { BackgroundColor3 = "Line" })
	corner(track, 3)
	local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }, track)
	themed(fill, { BackgroundColor3 = "Text" })
	corner(fill, 3)
	local thumbSize = TOUCH and 16 or 12
	local thumb = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(thumbSize, thumbSize), BorderSizePixel = 0,
	}, track)
	themed(thumb, { BackgroundColor3 = "Text" })
	corner(thumb, thumbSize / 2)
	stroke(thumb, "Window", 2)
	local hitH = TOUCH and 38 or 26
	local hit = new("TextButton", {
		Text = "", BackgroundTransparency = 1, AutoButtonColor = false,
		Position = UDim2.new(0, trackX - 4, 0, midY - hitH / 2), Size = UDim2.new(1, -(trackX * 2 - 8), 0, hitH),
	}, row)
	local function render()
		local alpha = (item.Value - min) / (max - min)
		fill.Size = UDim2.fromScale(alpha, 1)
		thumb.Position = UDim2.fromScale(alpha, 0.5)
		if not box:IsFocused() then box.Text = string.format("%." .. dec .. "f", item.Value) .. suffix end
	end
	render()
	function item:Set(v, silent)
		v = snap(v)
		if v == self.Value then
			render()
			return
		end
		self.Value = v
		render()
		if not silent then safe(cfg.Callback, v) end
	end
	function item:SetValue(v) self:Set(v) end
	function item:GetValue() return self.Value end
	local dragging = false
	local function fromX(x)
		local alpha = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		item:Set(min + (max - min) * alpha)
	end
	local function setScroll(on)
		local page = container.Page
		if page and page.Scroll then page.Scroll.ScrollingEnabled = on end
	end
	hit.InputBegan:Connect(function(input)
		if isPress(input) then
			dragging = true
			setScroll(false)
			fromX(input.Position.X)
			tween(thumb, { Size = UDim2.fromOffset(thumbSize + 4, thumbSize + 4) }, 0.1)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			item:Set(default)
		end
	end)
	conn(UserInputService.InputChanged, function(input)
		if dragging and isMove(input) then fromX(input.Position.X) end
	end)
	conn(UserInputService.InputEnded, function(input)
		if dragging and isPress(input) then
			dragging = false
			setScroll(true)
			tween(thumb, { Size = UDim2.fromOffset(thumbSize, thumbSize) }, 0.1)
		end
	end)
	box.Focused:Connect(function() box.Text = "" end)
	box.FocusLost:Connect(function()
		local n = tonumber((box.Text:gsub("[^%d%.%-]", "")))
		if n then item:Set(n) end
		render()
	end)
	return item
end

function Container:Dropdown(cfg)
	cfg = cfg or {}
	local multi = cfg.Multi == true
	local options = {}
	for i, v in ipairs(cfg.Items or cfg.Values or cfg.Options or {}) do options[i] = tostring(v) end
	local item = { Multi = multi, Options = options, Selected = {}, Order = {}, Value = multi and {} or "" }
	local emptyText = tostring(cfg.Empty or (multi and "none selected" or "select"))

	local function assign(v)
		item.Selected, item.Order = {}, {}
		if multi then
			if type(v) == "table" then
				local names = {}
				for k, val in pairs(v) do
					if type(k) == "number" and val ~= nil and tostring(val) ~= "" and val ~= false then
						names[#names + 1] = { k, tostring(val) }
					elseif type(k) == "string" and val == true then
						names[#names + 1] = { math.huge, k }
					end
				end
				table.sort(names, function(a, b)
					if a[1] ~= b[1] then return a[1] < b[1] end
					return a[2] < b[2]
				end)
				for _, pair in ipairs(names) do
					if not item.Selected[pair[2]] then
						item.Selected[pair[2]] = true
						item.Order[#item.Order + 1] = pair[2]
					end
				end
			elseif v ~= nil and v ~= "" then
				item.Selected[tostring(v)] = true
				item.Order[1] = tostring(v)
			end
			local map = {}
			for name in pairs(item.Selected) do map[name] = true end
			item.Value = map
		else
			local s = (v ~= nil) and tostring(v) or ""
			item.Value = s
			if s ~= "" then item.Selected[s] = true end
		end
	end
	assign(cfg.Default)

	local labelW = measure(cfg.Name or "", K.Text, FONT).X
	local stacked = labelW > 118 or TOUCH
	local row = self:_row(stacked and (K.Field + 34) or K.Row, cfg.Name, cfg.Tooltip)
	local field = new("TextButton", {
		Text = "", AutoButtonColor = false, BorderSizePixel = 0,
		AnchorPoint = stacked and Vector2.new(0, 1) or Vector2.new(1, 0.5),
		Position = stacked and UDim2.new(0, 10, 1, -6) or UDim2.new(1, -10, 0.5, 0),
		Size = stacked and UDim2.new(1, -20, 0, K.Field) or UDim2.fromOffset(150, K.Field),
	}, row)
	themed(field, { BackgroundColor3 = "Window" })
	corner(field, 12)
	local fstroke = stroke(field, "Line")
	if stacked then
		text(row, cfg.Name, K.Text, "Text", FONT, {
			Position = UDim2.fromOffset(12, 5), Size = UDim2.new(1, -24, 0, 20), TextTruncate = Enum.TextTruncate.AtEnd,
		})
	else
		self:_label(row, cfg.Name, 172)
	end
	local shown = text(field, "", 12, "Text", FONT_M, {
		Position = UDim2.fromOffset(9, 0), Size = UDim2.new(1, -30, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local chev = icon(field, "chevD", 14, "Muted")
	chev.Frame.AnchorPoint = Vector2.new(1, 0.5)
	chev.Frame.Position = UDim2.new(1, -7, 0.5, 0)

	local function refreshText()
		local str
		if multi then
			local n = #item.Order
			if n == 0 then
				str = emptyText
				themed(shown, { TextColor3 = "Muted" })
			else
				themed(shown, { TextColor3 = "Text" })
				if n <= 2 then str = table.concat(item.Order, ", ") else str = n .. " selected" end
			end
		else
			if item.Value == "" then
				str = emptyText
				themed(shown, { TextColor3 = "Muted" })
			else
				str = item.Value
				themed(shown, { TextColor3 = "Text" })
			end
		end
		shown.Text = str
	end
	refreshText()

	local function fire()
		if multi then
			local map = {}
			for name in pairs(item.Selected) do map[name] = true end
			item.Value = map
			safe(cfg.Callback, map)
		else
			safe(cfg.Callback, item.Value)
		end
	end
	local function sameSet(a, b)
		for k in pairs(a) do if not b[k] then return false end end
		for k in pairs(b) do if not a[k] then return false end end
		return true
	end
	function item:Set(v, silent)
		local before = {}
		for k in pairs(item.Selected) do before[k] = true end
		local beforeValue = item.Value
		assign(v)
		refreshText()
		local changed = multi and not sameSet(before, item.Selected) or (not multi and beforeValue ~= item.Value)
		if changed and not silent then fire() end
	end
	function item:SetValue(v) self:Set(v) end
	function item:GetValue() return self.Value end
	function item:SetValues(list)
		local out = {}
		for i, v in ipairs(list or {}) do out[i] = tostring(v) end
		self.Options = out
		options = out
	end
	function item:SetOptions(list) self:SetValues(list) end
	function item:Refresh(list) self:SetValues(list) end

	local function open()
		local width = math.max(field.AbsoluteSize.X, 210)
		local searchable = #options >= 7
		local top = searchable and (K.Field + 16) or 8
		local bottom = multi and (K.Field + 8) or 8
		local rows = math.max(1, #options)
		local height = math.min(top + bottom + rows * (K.Item + 6), 320)
		local frame = new("Frame", { Name = "DropdownPopup", BorderSizePixel = 0 })
		themed(frame, { BackgroundColor3 = "Panel" })
		corner(frame, 16)
		stroke(frame, "Line")
		placePopup(frame, field, width, height)
		local list = new("ScrollingFrame", {
			Position = UDim2.fromOffset(0, top), Size = UDim2.new(1, 0, 1, -(top + bottom)),
			BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
			CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		}, frame)
		themed(list, { ScrollBarImageColor3 = "Line" })
		pad(list, 6, 0, 6, 0)
		vlist(list, 2)
		local buttons = {}
		local countLabel
		local function paintRow(name, b)
			local on = item.Selected[name] == true
			b.Check.Frame.Visible = on
			themed(b.Label, { TextColor3 = on and "Accent" or "Text" })
			b.Btn.BackgroundTransparency = on and 0.35 or 1
		end
		for i, name in ipairs(options) do
			local btn = new("TextButton", {
				Text = "", AutoButtonColor = false, BorderSizePixel = 0, BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, K.Item + 4), LayoutOrder = i,
			}, list)
			themed(btn, { BackgroundColor3 = "Card" })
			corner(btn, 10)
			local lbl = text(btn, name, K.Small + 1, "Text", FONT_M, {
				Position = UDim2.fromOffset(9, 0), Size = UDim2.new(1, -34, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd,
			})
			local chk = icon(btn, "check", 14, "Accent")
			chk.Frame.AnchorPoint = Vector2.new(1, 0.5)
			chk.Frame.Position = UDim2.new(1, -8, 0.5, 0)
			local rec = { Btn = btn, Label = lbl, Check = chk, Name = name }
			buttons[#buttons + 1] = rec
			paintRow(name, rec)
			if not TOUCH then
				btn.MouseEnter:Connect(function()
					if not item.Selected[name] then tween(btn, { BackgroundTransparency = 0.7 }, 0.12) end
				end)
				btn.MouseLeave:Connect(function() paintRow(name, rec) end)
			end
			btn.Activated:Connect(function()
				if multi then
					if item.Selected[name] then
						item.Selected[name] = nil
						for k, v in ipairs(item.Order) do
							if v == name then table.remove(item.Order, k) break end
						end
					else
						item.Selected[name] = true
						item.Order[#item.Order + 1] = name
					end
					paintRow(name, rec)
					refreshText()
					fire()
					if countLabel then countLabel.Text = #item.Order .. " selected" end
				else
					item.Selected = { [name] = true }
					item.Value = name
					refreshText()
					fire()
					Popup.close()
				end
			end)
		end
		if searchable then
			local sbox = new("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, K.Field), BorderSizePixel = 0 }, frame)
			themed(sbox, { BackgroundColor3 = "Card" })
			corner(sbox, 12)
			local si = icon(sbox, "search", 14, "Muted")
			si.Frame.AnchorPoint = Vector2.new(0, 0.5)
			si.Frame.Position = UDim2.new(0, 8, 0.5, 0)
			local input = new("TextBox", {
				BackgroundTransparency = 1, Position = UDim2.fromOffset(28, 0), Size = UDim2.new(1, -34, 1, 0),
				Font = FONT, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Text = "",
				PlaceholderText = "search", ClearTextOnFocus = false, BorderSizePixel = 0,
			}, sbox)
			themed(input, { TextColor3 = "Text", PlaceholderColor3 = "Muted" })
			input:GetPropertyChangedSignal("Text"):Connect(function()
				local q = string.lower(input.Text)
				for _, rec in ipairs(buttons) do
					rec.Btn.Visible = q == "" or string.find(string.lower(rec.Name), q, 1, true) ~= nil
				end
			end)
		end
		if multi then
			local foot = new("Frame", {
				AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, K.Field + 8),
				BackgroundTransparency = 1,
			}, frame)
			local div = new("Frame", { Size = UDim2.new(1, -16, 0, 1), Position = UDim2.fromOffset(8, 0), BorderSizePixel = 0 }, foot)
			themed(div, { BackgroundColor3 = "Line" })
			countLabel = text(foot, #item.Order .. " selected", 11, "Muted", MONO, {
				Position = UDim2.fromOffset(14, 0), Size = UDim2.new(0.5, 0, 1, 0),
			})
			local clear = new("TextButton", {
				Text = "clear", Font = FONT_M, TextSize = 12, BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(56, K.Field),
				AutoButtonColor = false,
			}, foot)
			themed(clear, { TextColor3 = "Accent" })
			clear.Activated:Connect(function()
				item.Selected, item.Order = {}, {}
				for _, rec in ipairs(buttons) do paintRow(rec.Name, rec) end
				refreshText()
				fire()
				countLabel.Text = "0 selected"
			end)
		end
		themed(fstroke, { Color = "Accent" })
		chev.SetColor("Accent")
		tween(chev.Frame, { Rotation = 180 }, 0.25, Enum.EasingStyle.Back)
		Popup.open(frame, function()
			chev.SetColor("Muted")
			tween(chev.Frame, { Rotation = 0 }, 0.2)
			themed(fstroke, { Color = "Line" })
		end)
	end
	field.Activated:Connect(function()
		if Popup.Current then Popup.close() else open() end
	end)
	return item
end

function Container:Textbox(cfg)
	cfg = cfg or {}
	local labelW = measure(cfg.Name or "", K.Text, FONT).X
	local stacked = labelW > 118 or TOUCH
	local row = self:_row(stacked and (K.Field + 34) or K.Row, cfg.Name, cfg.Tooltip)
	local item = { Value = tostring(cfg.Default or "") }
	local fieldFrame = new("Frame", {
		AnchorPoint = stacked and Vector2.new(0, 1) or Vector2.new(1, 0.5),
		Position = stacked and UDim2.new(0, 10, 1, -6) or UDim2.new(1, -10, 0.5, 0),
		Size = stacked and UDim2.new(1, -20, 0, K.Field) or UDim2.fromOffset(150, K.Field), BorderSizePixel = 0,
	}, row)
	themed(fieldFrame, { BackgroundColor3 = "Window" })
	corner(fieldFrame, 9)
	local fstroke = stroke(fieldFrame, "Line")
	if stacked then
		text(row, cfg.Name, K.Text, "Text", FONT, {
			Position = UDim2.fromOffset(12, 5), Size = UDim2.new(1, -24, 0, 20), TextTruncate = Enum.TextTruncate.AtEnd,
		})
	else
		self:_label(row, cfg.Name, 172)
	end
	local box = new("TextBox", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(9, 0), Size = UDim2.new(1, -18, 1, 0),
		Font = FONT_M, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
		Text = item.Value, PlaceholderText = tostring(cfg.Placeholder or ""), BorderSizePixel = 0,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, fieldFrame)
	themed(box, { TextColor3 = "Text", PlaceholderColor3 = "Muted" })
	box.Focused:Connect(function() themed(fstroke, { Color = "Accent" }) end)
	if cfg.Numeric == true then
		box:GetPropertyChangedSignal("Text"):Connect(function()
			local cleaned = box.Text:gsub("[^%d%.%-]", "")
			if cleaned ~= box.Text then box.Text = cleaned end
		end)
	end
	box.FocusLost:Connect(function()
		themed(fstroke, { Color = "Line" })
		if box.Text ~= item.Value then
			item.Value = box.Text
			safe(cfg.Callback, item.Value)
		end
	end)
	function item:Set(v, silent)
		v = tostring(v or "")
		self.Value = v
		box.Text = v
		if not silent then safe(cfg.Callback, v) end
	end
	function item:SetValue(v) self:Set(v, true) end
	function item:GetValue() return self.Value end
	return item
end

function Container:Button(cfg)
	cfg = cfg or {}
	local perRow = ({ Large = 1, Medium = 2, Small = 3 })[tostring(cfg.Size or "Large")] or 1
	if TOUCH and perRow > 2 then perRow = 2 end
	if cfg.NewRow or not self.BtnRow then
		self.Order = (self.Order or 0) + 1
		local holder = new("Frame", {
			Name = "Buttons", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0), LayoutOrder = self.Order,
		}, self.Content)
		new("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal, Wraps = true, SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
		}, holder)
		local entry = { Frame = holder, Text = "" }
		self.BtnRow = { Frame = holder, Entry = entry }
		if self.Gear and self.ParentEntry then
			self.BtnRow.Entry = self.ParentEntry
		elseif self.Win then
			self.Win:_register(entry, self.Page, self.Section)
		end
	end
	local holder = self.BtnRow.Frame
	self.BtnRow.Entry.Text = self.BtnRow.Entry.Text .. " " .. string.lower(tostring(cfg.Name or ""))
	local btn = new("TextButton", {
		Text = "", AutoButtonColor = false, BorderSizePixel = 0,
		Size = UDim2.new(1 / perRow, -6 * (perRow - 1) / perRow, 0, K.Btn),
	}, holder)
	themed(btn, { BackgroundColor3 = "Card" })
	corner(btn, 10)
	local bstroke = stroke(btn, "Line")
	local holderLbl = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, btn)
	local lbl = text(holderLbl, cfg.Name, K.Small + 1, "Text", FONT_M, {
		Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local pic
	if cfg.Icon and ICONS[cfg.Icon] then
		pic = icon(holderLbl, cfg.Icon, 15, "Muted")
		pic.Frame.AnchorPoint = Vector2.new(0, 0.5)
		pic.Frame.Position = UDim2.new(0, 10, 0.5, 0)
		pad(lbl, 18, 0, 6, 0)
	else
		pad(lbl, 6, 0, 6, 0)
	end
	local function hot(on)
		themed(bstroke, { Color = on and "Accent" or "Line" })
		themed(lbl, { TextColor3 = on and "Accent" or "Text" })
		if pic then pic.SetColor(on and "Accent" or "Muted") end
	end
	if not TOUCH then
		btn.MouseEnter:Connect(function() hot(true) end)
		btn.MouseLeave:Connect(function() hot(false) end)
	end
	attachTip(btn, cfg.Tooltip)
	btn.Activated:Connect(function()
		btn.BackgroundColor3 = UI.Theme.Accent
		tween(btn, { BackgroundColor3 = UI.Theme.Card }, 0.3)
		safe(cfg.Callback)
	end)
	local item = { Instance = btn }
	function item:SetText(v) lbl.Text = tostring(v or "") end
	return item
end

function Container:Label(cfg)
	local name = cfg
	if type(cfg) == "table" then name = cfg.Name or cfg.Text or "" end
	name = tostring(name or "")
	local row = self:_row(K.Row, name, nil, "Frame")
	row.AutomaticSize = Enum.AutomaticSize.Y
	row.Size = UDim2.new(1, 0, 0, K.Row)
	local lbl = text(row, name, K.Text, "Text", FONT, {
		Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -24, 0, K.Row),
		TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, TextYAlignment = Enum.TextYAlignment.Center,
	})
	pad(lbl, 0, 6, 0, 6)
	local obj = { Items = { Text = { Instance = lbl } }, Row = row, Right = 0 }
	function obj:SetText(v) lbl.Text = tostring(v or "") end
	local function reserve(px)
		obj.Right = obj.Right + px
		lbl.Size = UDim2.new(1, -(24 + obj.Right), 0, K.Row)
	end

	function obj:Colorpicker(c)
		c = c or {}
		local color = typeof(c.Default) == "Color3" and c.Default or rgb(255, 255, 255)
		local item = { Color = color, Alpha = tonumber(c.Alpha) or 0 }
		reserve(44)
		local swatch = new("TextButton", {
			Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -(10 + obj.Right - 44), 0, K.Row / 2), Size = UDim2.fromOffset(34, TOUCH and 24 or 18),
			BackgroundColor3 = color, BorderSizePixel = 0,
		}, row)
		corner(swatch, 7)
		stroke(swatch, "Line")
		local function apply(silent)
			swatch.BackgroundColor3 = item.Color
			if not silent then safe(c.Callback, item.Color, item.Alpha) end
		end
		function item:Set(col, a, silent)
			if typeof(col) == "Color3" then self.Color = col end
			if a ~= nil then self.Alpha = tonumber(a) or 0 end
			apply(silent)
		end
		function item:SetValue(col, a) self:Set(col, a) end
		function item:GetValue() return self.Color end
		swatch.Activated:Connect(function()
			if Popup.Current then Popup.close() return end
			local h, s, v = item.Color:ToHSV()
			local frame = new("Frame", { Name = "ColorPopup", BorderSizePixel = 0 })
			themed(frame, { BackgroundColor3 = "Window" })
			corner(frame, 6)
			stroke(frame, "Line")
			local showAlpha = (tonumber(c.Alpha) or 0) > 0
			local screen = Gui.AbsoluteSize
			local sheet = sheetMode()
			local width = sheet and math.min(screen.X - 20, 340) or 224
			local inner = width - 28
			local svH = math.floor(inner * 0.6)
			local barH = TOUCH and 20 or 12
			local height = 14 + svH + 10 + barH + (showAlpha and (10 + barH) or 0) + 10 + K.Field + 14
			placePopup(frame, swatch, width, height)
			local sv = new("Frame", {
				Position = UDim2.fromOffset(14, 14), Size = UDim2.fromOffset(inner, svH), BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromHSV(h, 1, 1), ClipsDescendants = true,
			}, frame)
			corner(sv, 4)
			local white = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(255, 255, 255), BorderSizePixel = 0 }, sv)
			new("UIGradient", {
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
			}, white)
			local black = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(0, 0, 0), BorderSizePixel = 0 }, sv)
			new("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
			}, black)
			local cursor = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12),
				BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 4,
			}, sv)
			corner(cursor, 6)
			new("UIStroke", { Thickness = 2, Color = rgb(255, 255, 255) }, cursor)
			local hueY = 14 + svH + 10
			local hue = new("Frame", {
				Position = UDim2.fromOffset(14, hueY), Size = UDim2.fromOffset(inner, barH), BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
			}, frame)
			corner(hue, 3)
			new("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, rgb(255, 0, 0)), ColorSequenceKeypoint.new(0.167, rgb(255, 255, 0)),
					ColorSequenceKeypoint.new(0.333, rgb(0, 255, 0)), ColorSequenceKeypoint.new(0.5, rgb(0, 255, 255)),
					ColorSequenceKeypoint.new(0.667, rgb(0, 0, 255)), ColorSequenceKeypoint.new(0.833, rgb(255, 0, 255)),
					ColorSequenceKeypoint.new(1, rgb(255, 0, 0)),
				}),
			}, hue)
			local hueKnob = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(h, 0, 0.5, 0), Size = UDim2.fromOffset(5, barH + 6),
				BackgroundColor3 = rgb(255, 255, 255), BorderSizePixel = 0,
			}, hue)
			corner(hueKnob, 2)
			new("UIStroke", { Thickness = 1, Color = rgb(0, 0, 0), Transparency = 0.5 }, hueKnob)
			local alphaBar, alphaKnob
			local nextY = hueY + barH + 10
			if showAlpha then
				alphaBar = new("Frame", {
					Position = UDim2.fromOffset(14, nextY), Size = UDim2.fromOffset(inner, barH), BorderSizePixel = 0,
					BackgroundColor3 = item.Color,
				}, frame)
				corner(alphaBar, 3)
				new("UIGradient", {
					Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.85) }),
				}, alphaBar)
				alphaKnob = new("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(item.Alpha, 0, 0.5, 0),
					Size = UDim2.fromOffset(5, barH + 6), BackgroundColor3 = rgb(255, 255, 255), BorderSizePixel = 0,
				}, alphaBar)
				corner(alphaKnob, 2)
				nextY = nextY + barH + 10
			end
			local hexBox = new("TextBox", {
				Position = UDim2.fromOffset(14, nextY), Size = UDim2.fromOffset(inner, K.Field),
				Font = MONO, TextSize = 12, ClearTextOnFocus = false, Text = hex(item.Color), BorderSizePixel = 0,
			}, frame)
			themed(hexBox, { BackgroundColor3 = "Card", TextColor3 = "Text" })
			corner(hexBox, 4)
			local function refresh(fire)
				local col = Color3.fromHSV(h, s, v)
				sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				cursor.Position = UDim2.fromScale(s, 1 - v)
				hueKnob.Position = UDim2.new(h, 0, 0.5, 0)
				hexBox.Text = hex(col)
				if alphaBar then alphaBar.BackgroundColor3 = col end
				item.Color = col
				swatch.BackgroundColor3 = col
				if fire then safe(c.Callback, col, item.Alpha) end
			end
			refresh(false)
			local function drag(area, onMove)
				local active = false
				local changed, ended
				local function stop()
					active = false
					if changed then changed:Disconnect() changed = nil end
					if ended then ended:Disconnect() ended = nil end
				end
				area.InputBegan:Connect(function(input)
					if not isPress(input) then return end
					active = true
					onMove(input.Position)
					changed = UserInputService.InputChanged:Connect(function(i)
						if active and isMove(i) then onMove(i.Position) end
					end)
					ended = UserInputService.InputEnded:Connect(function(i)
						if isPress(i) then stop() end
					end)
				end)
				area.Destroying:Connect(stop)
			end
			drag(sv, function(p)
				s = math.clamp((p.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
				v = 1 - math.clamp((p.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
				refresh(true)
			end)
			drag(hue, function(p)
				h = math.clamp((p.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 0.999)
				refresh(true)
			end)
			if alphaBar then
				drag(alphaBar, function(p)
					item.Alpha = math.clamp((p.X - alphaBar.AbsolutePosition.X) / alphaBar.AbsoluteSize.X, 0, 1)
					alphaKnob.Position = UDim2.new(item.Alpha, 0, 0.5, 0)
					refresh(true)
				end)
			end
			hexBox.FocusLost:Connect(function()
				local str = hexBox.Text:gsub("#", "")
				if #str == 6 and tonumber(str, 16) then
					local n = tonumber(str, 16)
					local col = rgb(math.floor(n / 65536) % 256, math.floor(n / 256) % 256, n % 256)
					h, s, v = col:ToHSV()
					refresh(true)
				else
					hexBox.Text = hex(item.Color)
				end
			end)
			Popup.open(frame)
		end)
		attachTip(swatch, "pick a color")
		return item
	end

	function obj:Keybind(c)
		c = c or {}
		local item = { Key = "None", Mode = tostring(c.Mode or "Hold"), State = false }
		local key = keyEnum(c.Default)
		item.Key = keyName(key)
		item.Enum = key
		reserve(98)
		local chip = new("TextButton", {
			Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -(10 + obj.Right - 98), 0, K.Row / 2), Size = UDim2.fromOffset(92, TOUCH and 30 or 24),
			BorderSizePixel = 0,
		}, row)
		themed(chip, { BackgroundColor3 = "Window" })
		corner(chip, 9)
		local cstroke = stroke(chip, "Line")
		local caption = text(chip, "", 11, "Text", FONT_M, {
			Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -34, 1, 0), TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local kbIcon = icon(chip, "keyboard", 14, "Muted")
		kbIcon.Frame.AnchorPoint = Vector2.new(1, 0.5)
		kbIcon.Frame.Position = UDim2.new(1, -8, 0.5, 0)
		local function paint()
			if Listening == item then
				caption.Text = TOUCH and "press key" or "..."
				themed(cstroke, { Color = "Accent" })
				themed(caption, { TextColor3 = "Accent" })
			else
				local none = item.Enum == Enum.KeyCode.None
				caption.Text = none and "none" or (KEY_SHORT[item.Key] or item.Key)
				themed(cstroke, { Color = "Line" })
				themed(caption, { TextColor3 = none and "Muted" or "Text" })
			end
		end
		paint()
		function item:Set(k, silent)
			item.Enum = keyEnum(k)
			item.Key = keyName(item.Enum)
			paint()
			if not silent and c.OnSet then safe(c.OnSet, item.Key) end
		end
		function item:SetValue(k) self:Set(k) end
		function item:GetValue() return self.Key end
		chip.Activated:Connect(function()
			Listening = (Listening == item) and nil or item
			paint()
		end)
		chip.MouseButton2Click:Connect(function()
			item.Mode = (item.Mode == "Hold") and "Toggle" or "Hold"
			UI:Notification({ Name = (c.Name or "keybind") .. ": mode " .. string.lower(item.Mode), Time = 2 })
		end)
		attachTip(chip, "click to rebind, right click switches hold or toggle")
		item.Repaint = paint
		item.Callback = c.Callback
		Keybinds[#Keybinds + 1] = item
		return item
	end
	return obj
end

function Container:IconGrid(names)
	names = names or ICON_LIST
	local cell = TOUCH and 46 or 38
	self.Order = (self.Order or 0) + 1
	self.BtnRow = nil
	local holder = new("Frame", {
		Name = "IconGrid", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0), LayoutOrder = self.Order,
	}, self.Content)
	new("UIGridLayout", {
		CellSize = UDim2.fromOffset(cell, cell), CellPadding = UDim2.fromOffset(4, 4), SortOrder = Enum.SortOrder.LayoutOrder,
	}, holder)
	local entry = { Frame = holder, Text = "icons " .. table.concat(names, " ") }
	if self.Win and not self.Gear then self.Win:_register(entry, self.Page, self.Section) end
	for i, name in ipairs(names) do
		local c = new("TextButton", {
			Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i,
		}, holder)
		themed(c, { BackgroundColor3 = "Card" })
		corner(c, 4)
		local ic = icon(c, name, 20, "Muted")
		ic.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		ic.Frame.Position = UDim2.fromScale(0.5, 0.5)
		if not TOUCH then
			c.MouseEnter:Connect(function() ic.SetColor("Accent") end)
			c.MouseLeave:Connect(function() ic.SetColor("Muted") end)
		end
		attachTip(c, name)
		c.Activated:Connect(function() UI:Notification({ Name = "Icon: " .. name, Time = 2 }) end)
	end
end

---------------------------------------------------------------- input router
conn(UserInputService.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
		if Popup.Current then
			Popup.close()
			return
		end
	end
	if Listening then
		local item = Listening
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then return end
		Listening = nil
		if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
			item:Set(Enum.KeyCode.None)
		elseif input.UserInputType == Enum.UserInputType.Keyboard then
			item:Set(input.KeyCode)
		else
			item:Set(input.UserInputType)
		end
		item.Repaint()
		return
	end
	if UserInputService:GetFocusedTextBox() then return end
	if input.KeyCode == Enum.KeyCode.Slash then
		for _, win in ipairs(Windows) do
			if win.IsOpen and win.FocusSearch then
				win:FocusSearch()
				task.defer(function() win.SearchInput.Text = "" end)
				return
			end
		end
	end
	local menuName = tostring(UI.MenuKeybind or ""):gsub("^Enum%.", ""):gsub("^KeyCode%.", ""):gsub("^UserInputType%.", "")
	if menuName ~= "" and menuName ~= "None" then
		if input.KeyCode.Name == menuName or input.UserInputType.Name == menuName then
			for _, win in ipairs(Windows) do win:Toggle() end
			return
		end
	end
	for _, kb in ipairs(Keybinds) do
		if keyMatches(kb.Enum, input) then
			if kb.Mode == "Toggle" then
				kb.State = not kb.State
				safe(kb.Callback, kb.State, kb.Key)
			else
				kb.State = true
				safe(kb.Callback, true, kb.Key)
			end
		end
	end
end)
conn(UserInputService.InputEnded, function(input)
	for _, kb in ipairs(Keybinds) do
		if kb.Mode ~= "Toggle" and kb.State and keyMatches(kb.Enum, input) then
			kb.State = false
			safe(kb.Callback, false, kb.Key)
		end
	end
end)

---------------------------------------------------------------- window
local Window = {}
Window.__index = Window

function Window:_register(entry, page, section)
	entry.Page = page
	entry.Section = section
	self.Entries[#self.Entries + 1] = entry
end

function Window:_counts()
	local n = activeCount()
	if self.FooterCount then self.FooterCount.Text = n .. (n == 1 and " feature on" or " features on") end
	if Hud.Labels.On then Hud.Labels.On.Text = "on " .. n end
end

function Window:Filter(query)
	query = string.lower(tostring(query or "")):gsub("^%s+", ""):gsub("%s+$", "")
	local searching = query ~= ""
	self.Searching = searching
	for _, page in ipairs(self.Pages) do
		page.Matches = 0
		for _, sec in ipairs(page.Sections) do sec.Matches = 0 end
	end
	for _, entry in ipairs(self.Entries) do
		local titleHit = searching and entry.Section and string.find(string.lower(entry.Section.Title), query, 1, true)
		local hit = (not searching) or titleHit or string.find(entry.Text, query, 1, true) ~= nil
		entry.Frame.Visible = hit
		if hit and searching then
			entry.Page.Matches = entry.Page.Matches + 1
			entry.Section.Matches = entry.Section.Matches + 1
		end
	end
	for _, page in ipairs(self.Pages) do
		for _, sec in ipairs(page.Sections) do
			sec.Card.Visible = ((not searching) or sec.Matches > 0) and (page.ActivePill == nil or page.ActivePill == sec)
			sec.Body.Visible = (not sec.Collapsed) or searching
		end
		page.Badge.Visible = searching and page.Matches > 0
		page.BadgeText.Text = tostring(page.Matches)
		local dim = searching and page.Matches == 0
		page.SearchDim = dim
		page:Paint()
		page:LayoutCols()
	end
	if searching and self.Active and self.Active.Matches == 0 then
		for _, page in ipairs(self.Pages) do
			if page.Matches > 0 then
				page:Turn()
				break
			end
		end
	end
end

function Window:SetOpen(state)
	state = state == true
	self.IsOpen = state
	Popup.close()
	Tip.Frame.Visible = false
	if state then
		self.Root.Visible = true
		self.Veil.BackgroundTransparency = 0
		local p = self.Root.Position
		self.Root.Position = p + UDim2.fromOffset(0, 14)
		tween(self.Veil, { BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Quint)
		tween(self.Root, { Position = p }, 0.38, Enum.EasingStyle.Back)
	else
		tween(self.Veil, { BackgroundTransparency = 0 }, 0.12)
		task.delay(0.13, function()
			if not self.IsOpen then self.Root.Visible = false end
		end)
	end
	return true
end
function Window:GetOpen() return self.IsOpen == true end
function Window:Toggle() self:SetOpen(not self.IsOpen) end

function Window:_scale()
	local s = self.Scale and self.Scale.Scale or 1
	return s > 0 and s or 1
end
function Window:Center()
	local screen = Gui.AbsoluteSize
	local s = self:_scale()
	local w, h = self.Root.Size.X.Offset * s, self.Root.Size.Y.Offset * s
	self.Root.Position = UDim2.fromOffset(math.floor((screen.X - w) / 2), math.floor((screen.Y - h) / 2))
	self:_remember()
	return true
end
function Window:_remember()
	if self.Maximized then return end
	State.size = { self.Root.Size.X.Offset, self.Root.Size.Y.Offset }
	State.pos = { self.Root.Position.X.Offset, self.Root.Position.Y.Offset }
	saveState()
end
function Window:_clamp()
	if self.Maximized then return end
	local screen = Gui.AbsoluteSize
	local s = self:_scale()
	local maxW = math.max(300, screen.X / s - 8)
	local maxH = math.max(260, screen.Y / s - 8)
	local w = math.clamp(self.Root.Size.X.Offset, math.min(self.MinSize.X, maxW), maxW)
	local h = math.clamp(self.Root.Size.Y.Offset, math.min(self.MinSize.Y, maxH), maxH)
	self.Root.Size = UDim2.fromOffset(w, h)
	local x = math.clamp(self.Root.Position.X.Offset, 8 - w * s + 80, screen.X - 80)
	local y = math.clamp(self.Root.Position.Y.Offset, 0, screen.Y - 40)
	self.Root.Position = UDim2.fromOffset(x, y)
end
function Window:SetMaximized(on)
	on = on == true
	if on == self.Maximized then return end
	if on then
		self.Restore = { self.Root.Position, self.Root.Size }
		self.Maximized = true
		self:_fitMax()
	else
		self.Maximized = false
		if self.Restore then
			self.Root.Position, self.Root.Size = self.Restore[1], self.Restore[2]
		end
		self:_clamp()
	end
	if self.MaxIcon then self.MaxIcon.Swap(self.Maximized and "restore" or "maximize") end
	self:_layout()
end
function Window:_fitMax()
	local screen = Gui.AbsoluteSize
	local s = self:_scale()
	local inset = topInset()
	local margin = TOUCH and 6 or 8
	self.Root.Position = UDim2.fromOffset(margin, inset)
	self.Root.Size = UDim2.fromOffset(
		math.max(300, (screen.X - margin * 2) / s),
		math.max(260, (screen.Y - inset - margin) / s))
end
function Window:Divider() self.DividerSeen = true end

-- a toggle that is on but never had its callback run (on by default, or saved on in a config that matches the
-- default) looks enabled while its feature is not. this runs every such callback once, after the ui is built.
function UI:Resync()
	UI.Resyncing = true
	for _, win in ipairs(Windows) do
		for _, t in ipairs(win.AllToggles) do
			if t.Value == true and not t.Synced and t.Fire then
				t.Synced = true
				t.Fire()
			end
		end
	end
	task.delay(0.5, function() UI.Resyncing = false end)
end
function UI:FitWindow(win)
	local w = win
	if not (w and w.Root) then w = Windows[1] end
	if not w then return end
	if w.Maximized then w:_fitMax() else w:_clamp() end
	w:_layout()
end
function UI:Exit()
	Popup.close()
	for _, c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
	Conns = {}
	pcall(function() Gui:Destroy() end)
end

local GROUP_OF = {
	quests = "Farming", bosses = "Farming", loot = "Farming", training = "Farming", fishing = "Farming", dungeon = "Farming",
	combat = "Combat", safety = "Combat",
	teleport = "World", player = "World",
	extras = "Misc", settings = "Misc", icons = "Misc",
}
local GROUP_ICON = { Farming = "sprout", Combat = "swords", World = "map", Misc = "grid", General = "home" }
local GROUP_ORDER = { Farming = 1, Combat = 2, World = 3, Misc = 4, General = 5 }

-- sidebar group: a rounded block with a header and the pages that belong to it
function Window:_group(name)
	local g = self.Groups[name]
	if g then return g end
	local order = GROUP_ORDER[name] or (10 + self.GroupCount)
	self.GroupCount = self.GroupCount + 1
	local frame = new("Frame", {
		Name = "Group_" .. name, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = order, BackgroundTransparency = 1, BorderSizePixel = 0,
	}, self.Nav)
	themed(frame, { BackgroundColor3 = "Card" })
	corner(frame, 14)
	local fstroke = stroke(frame, "Text", 1, 1)
	vlist(frame, 0)
	local head = new("TextButton", {
		Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, TOUCH and 46 or 42), LayoutOrder = 1,
	}, frame)
	local gi = icon(head, GROUP_ICON[name] or "grid", 17, "Muted")
	gi.Frame.AnchorPoint = Vector2.new(0, 0.5)
	gi.Frame.Position = UDim2.new(0, 14, 0.5, 0)
	local gl = text(head, name, K.Text, "Muted", FONT_M, {
		Position = UDim2.fromOffset(42, 0), Size = UDim2.new(1, -72, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local chev = icon(head, "chevD", 14, "Muted")
	chev.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	chev.Frame.Position = UDim2.new(1, -20, 0.5, 0)
	local items = new("Frame", {
		Name = "Items", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 2, Visible = false,
	}, frame)
	pad(items, 8, 0, 8, 8)
	vlist(items, 2)
	g = { Name = name, Frame = frame, Items = items, Open = false }
	function g.set(open, instant)
		g.Open = open
		items.Visible = open
		frame.BackgroundTransparency = open and 0.55 or 1
		fstroke.Transparency = open and 0.88 or 1
		tween(chev.Frame, { Rotation = open and 180 or 0 }, instant and 0 or 0.16)
		gi.SetColor(open and "Text" or "Muted")
		themed(gl, { TextColor3 = open and "Text" or "Muted" })
	end
	head.Activated:Connect(function() g.set(not g.Open) end)
	if not TOUCH then
		head.MouseEnter:Connect(function() if not g.Open then gl.TextTransparency = 0.25 end end)
		head.MouseLeave:Connect(function() gl.TextTransparency = 0 end)
	end
	self.Groups[name] = g
	return g
end
function Window:_openGroup(name)
	for gname, g in pairs(self.Groups) do
		if g.Open ~= (gname == name) then g.set(gname == name) end
	end
end

function Window:SelectPage(name)
	name = string.lower(tostring(name or ""))
	for _, page in ipairs(self.Pages) do
		if string.lower(page.Name) == name then
			page:Turn()
			return true
		end
	end
	return false
end

function Window:_layout()
	local logicalW = self.Root.Size.X.Offset
	local compact = logicalW < 640
	local changed = compact ~= self.Compact
	self.Compact = compact
	local headH = compact and K.Header or TOPBAR_H
	local searchH = (compact and self.SearchOpen) and (K.Field + 14) or 0
	self.SearchRow.Visible = compact and self.SearchOpen
	self.SearchRow.Size = UDim2.new(1, 0, 0, searchH)
	self.SearchRow.Position = UDim2.fromOffset(0, headH)
	local top = headH + searchH
	local min = self.Minimized
	self.Rail.Visible = (not compact) and not min
	self.Bar.Visible = compact and not min
	self.Content.Visible = not min
	self.PillArea.Visible = (not compact) and not min
	self.PageTitle.Visible = (not compact) and not min and self.PageTitle.Text ~= "" and not self.HasPills
	self.CompactBrand.Visible = compact
	self.Header.Position = UDim2.fromOffset(compact and 0 or SIDE_W, 0)
	self.Header.Size = UDim2.new(1, compact and 0 or -SIDE_W, 0, headH)
	themed(self.Header, { BackgroundColor3 = "Panel" })
	self.Header.BackgroundTransparency = 1
	self.HeadLine.Visible = compact
	self.Content.Position = UDim2.fromOffset(compact and 0 or SIDE_W, top)
	self.Content.Size = UDim2.new(1, compact and 0 or -SIDE_W, 1, -(top + (compact and BAR_H or 0)))
	self.Rail.Position = UDim2.fromOffset(0, 0)
	self.Rail.Size = UDim2.new(0, SIDE_W, 1, 0)
	self.Stats.Visible = false
	self.MaxBtn.Visible = not TOUCH or not compact
	self.GearBtn.Visible = not compact
	self.SearchBtn.Visible = compact
	local btnStep = TOUCH and 44 or 36
	if compact then
		self.SearchBox.Parent = self.SearchRow
		self.SearchBox.AnchorPoint = Vector2.new(0, 0)
		self.SearchBox.Position = UDim2.fromOffset(10, 7)
		self.SearchBox.Size = UDim2.new(1, -20, 0, K.Field)
	else
		self.SearchBox.Parent = self.Header
		self.SearchBox.AnchorPoint = Vector2.new(1, 0.5)
		local boxW = math.clamp(logicalW * 0.24, 150, 230)
		self.SearchBox.Position = UDim2.new(1, -(10 + btnStep * 4 + 10), 0.5, 0)
		self.SearchBaseW = boxW
		self.SearchBox.Size = UDim2.fromOffset(boxW + (self.SearchFocused and 60 or 0), 34)
		self.PillArea.Size = UDim2.new(1, -(16 + boxW + 10 + btnStep * 4 + 28), 1, 0)
		self.PageTitle.Size = self.PillArea.Size
	end
	self.CompactBrand.Visible = compact and logicalW >= 330
	if changed or self._dockedOnce ~= true then
		self._dockedOnce = true
		for _, page in ipairs(self.Pages) do self:_dock(page) end
		placeToasts()
	end
	for _, page in ipairs(self.Pages) do page:LayoutCols() end
	if self.Grip then
		self.Grip.Visible = (not self.Maximized) and not min
	end
	for _, edge in ipairs(self.Edges or {}) do edge.Visible = (not self.Maximized) and not min end
end

function Window:_dock(page)
	local btn = page.Button
	local ic, cap = page.IconObj.Frame, page.Caption
	if self.Compact then
		btn.Parent = self.BarList
		btn.Size = UDim2.fromOffset(K.Tab.X, BAR_H - 8)
		ic.AnchorPoint = Vector2.new(0.5, 0)
		ic.Position = UDim2.new(0.5, 0, 0, 7)
		cap.AnchorPoint = Vector2.new(0, 0)
		cap.Position = UDim2.new(0, 0, 0, 30)
		cap.Size = UDim2.new(1, 0, 0, 14)
		cap.TextXAlignment = Enum.TextXAlignment.Center
		cap.TextSize = 10
		cap.Text = string.lower(page.Name)
	else
		btn.Parent = page.Group.Items
		btn.Size = UDim2.new(1, 0, 0, TOUCH and 40 or 34)
		ic.AnchorPoint = Vector2.new(0, 0.5)
		ic.Position = UDim2.new(0, 12, 0.5, 0)
		cap.AnchorPoint = Vector2.new(0, 0)
		cap.Position = UDim2.fromOffset(40, 0)
		cap.Size = UDim2.new(1, -70, 1, 0)
		cap.TextXAlignment = Enum.TextXAlignment.Left
		cap.TextSize = K.Text
		cap.Text = page.Name
	end
	page:Paint()
end

function Window:FocusSearch()
	if self.Compact then
		self.SearchOpen = true
		self:_layout()
	end
	self.SearchInput:CaptureFocus()
end

-- pills along the top: one per section of the open page, so a page with several sections can show just one
function Window:_buildPills(page)
	for _, c in ipairs(self.PillArea:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	self.PillItems = {}
	local secs = page.Sections
	local show = #secs >= 2
	self.HasPills = show
	self.PageTitle.Text = page.Name
	self.PageTitle.Visible = (not self.Compact) and not show
	if not show then
		page.ActivePill = nil
		return
	end
	local function paintAll()
		for _, it in ipairs(self.PillItems) do it.Paint() end
	end
	local function make(label, iconName, sec, order)
		local w = measure(label, 12, FONT_M).X + 46
		local b = new("TextButton", {
			Text = "", AutoButtonColor = false, BorderSizePixel = 0, Size = UDim2.fromOffset(w, 34),
			LayoutOrder = order, BackgroundTransparency = 1,
		}, self.PillArea)
		themed(b, { BackgroundColor3 = "Text" })
		corner(b, 17)
		local st = stroke(b, "Text", 1, 1)
		local ic = icon(b, iconName, 15, "Muted")
		ic.Frame.AnchorPoint = Vector2.new(0, 0.5)
		ic.Frame.Position = UDim2.new(0, 13, 0.5, 0)
		local lb = text(b, label, 12, "Muted", FONT_M, {
			Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -42, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local it = {}
		function it.Paint()
			local on = page.ActivePill == sec
			tween(b, { BackgroundTransparency = on and 0.86 or 1 }, 0.18)
			tween(st, { Transparency = on and 0.7 or 1 }, 0.18)
			ic.SetColor(on and "Text" or "Muted")
			themed(lb, { TextColor3 = on and "Text" or "Muted" })
		end
		b.Activated:Connect(function()
			page.ActivePill = sec
			page:ApplyPill()
			page.Scroll.CanvasPosition = Vector2.new(0, 0)
			paintAll()
		end)
		self.PillItems[#self.PillItems + 1] = it
		it.Paint()
	end
	make("all", "grid", nil, 0)
	for i, sec in ipairs(secs) do
		make(string.lower(sec.Title), sectionIcon(sec.Title), sec, i)
	end
	paintAll()
end

function Window:Page(cfg)
	cfg = cfg or {}
	local win = self
	local name = tostring(cfg.Name or "Tab")
	local lower = string.lower(name)
	local iconName = tabIcon(lower, cfg.Icon)
	local groupName = cfg.Group or GROUP_OF[lower] or "General"
	local group = self:_group(groupName)
	local page = {
		Name = name, Sections = {}, Matches = 0, Items = {}, ColOrder = { 0, 0 }, Group = group, ActivePill = nil,
	}

	local btn = new("TextButton", {
		Name = "Tab_" .. name, Text = "", AutoButtonColor = false, BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = #self.Pages + 1,
	})
	themed(btn, { BackgroundColor3 = "Text" })
	corner(btn, 10)
	btn.Parent = group.Items
	page.Button = btn
	page.Items.Inactive = { Instance = btn }
	local topline = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -4), Size = UDim2.fromOffset(0, 2),
		BorderSizePixel = 0, Visible = false,
	}, btn)
	themed(topline, { BackgroundColor3 = "Accent" })
	local dot = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(6, 6),
		BorderSizePixel = 0, Visible = false,
	}, btn)
	themed(dot, { BackgroundColor3 = "Text" })
	corner(dot, 3)
	local ic = icon(btn, iconName, 18, "Muted")
	local cap = text(btn, name, K.Text, "Muted", FONT_M, { TextTruncate = Enum.TextTruncate.AtEnd })
	local badge = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -30, 0.5, 0), Size = UDim2.fromOffset(18, 16),
		BorderSizePixel = 0, Visible = false, ZIndex = 3,
	}, btn)
	themed(badge, { BackgroundColor3 = "Text" })
	corner(badge, 8)
	local badgeText = text(badge, "0", 10, "Window", FONT_B, {
		Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4,
	})
	page.Badge, page.BadgeText = badge, badgeText
	page.Topline, page.Dot, page.IconObj, page.Caption = topline, dot, ic, cap

	local hover = false
	function page:Paint()
		local on = win.Active == page
		local compact = win.Compact
		tween(btn, { BackgroundTransparency = (on and not compact) and 0.84 or ((hover and not compact) and 0.93 or 1) }, 0.14)
		ic.SetColor(on and "Text" or "Muted")
		themed(cap, { TextColor3 = on and "Text" or "Muted" })
		cap.TextTransparency = page.SearchDim and 0.6 or 0
		dot.Visible = on and not compact
		topline.Visible = on and compact
		tween(topline, { Size = UDim2.fromOffset(on and 28 or 0, 2) }, 0.16)
	end
	if not TOUCH then
		btn.MouseEnter:Connect(function() hover = true page:Paint() end)
		btn.MouseLeave:Connect(function() hover = false page:Paint() end)
	end
	attachTip(btn, name)

	local scroll = new("ScrollingFrame", {
		Name = "Page_" .. name, Visible = false, BackgroundTransparency = 1, BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1), ScrollBarThickness = TOUCH and 4 or 3, CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
	}, self.Content)
	themed(scroll, { ScrollBarImageColor3 = "Line" })
	local wrap = new("Frame", {
		Name = "Wrap", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
	}, scroll)
	pad(wrap, 16, 6, 16, 16)
	local cols = new("Frame", {
		Name = "Cols", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
	}, wrap)
	local colsLayout = new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 14),
	}, cols)
	page.Cols = {}
	for i = 1, 2 do
		local col = new("Frame", {
			Name = "Col" .. i, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(0.5, -7, 0, 0), LayoutOrder = i,
		}, cols)
		vlist(col, 14)
		page.Cols[i] = col
	end
	page.Scroll, page.ColsLayout = scroll, colsLayout

	function page:LayoutCols()
		local logicalW = win.Root.Size.X.Offset
		local contentW = logicalW - (win.Compact and 0 or SIDE_W)
		local narrow = contentW < 540 or page.ActivePill ~= nil
		colsLayout.FillDirection = narrow and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
		for _, col in ipairs(page.Cols) do
			col.Size = narrow and UDim2.new(1, 0, 0, 0) or UDim2.new(0.5, -7, 0, 0)
		end
	end
	function page:ApplyPill()
		for _, sec in ipairs(page.Sections) do
			local show = (page.ActivePill == nil or page.ActivePill == sec)
			if win.Searching then show = show and sec.Matches > 0 end
			sec.Card.Visible = show
		end
		page:LayoutCols()
	end

	function page:Turn()
		if win.Active == page then return end
		win.Active = page
		State.tab = page.Name
		for _, p in ipairs(win.Pages) do
			p.Scroll.Visible = p == page
			p:Paint()
		end
		win:_openGroup(page.Group.Name)
		win:_buildPills(page)
		page:ApplyPill()
		page.Scroll.CanvasPosition = Vector2.new(0, 0)
		page.Scroll.Position = UDim2.fromOffset(0, 16)
		tween(page.Scroll, { Position = UDim2.fromOffset(0, 0) }, 0.32, Enum.EasingStyle.Quint)
		for i, sec in ipairs(page.Sections) do
			local card = sec.Card
			card.BackgroundTransparency = 1
			task.delay(math.min(i, 8) * 0.035, function()
				if win.Active == page then tween(card, { BackgroundTransparency = 0.12 }, 0.3) end
			end)
		end
		saveState()
	end
	btn.Activated:Connect(function() page:Turn() end)

	function page:Section(scfg)
		scfg = scfg or {}
		local side = (tonumber(scfg.Side) == 2) and 2 or 1
		local title = tostring(scfg.Name or "section")
		page.ColOrder[side] = page.ColOrder[side] + 1
		local card = new("Frame", {
			Name = "Section_" .. title, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = page.ColOrder[side], BorderSizePixel = 0, BackgroundTransparency = 0.12,
		}, page.Cols[side])
		themed(card, { BackgroundColor3 = "Card" })
		corner(card, 16)
		local cstroke = stroke(card, "Text", 1, 0.9)
		if not TOUCH then
			card.MouseEnter:Connect(function() tween(cstroke, { Transparency = 0.72 }, 0.18) end)
			card.MouseLeave:Connect(function() tween(cstroke, { Transparency = 0.9 }, 0.22) end)
		end
		local cardGrad = new("UIGradient", { Rotation = 118 }, card)
		themed(cardGrad, {
			Color = { "Card", function(c)
				return ColorSequence.new(c:Lerp(rgb(255, 255, 255), 0.06), c:Lerp(rgb(0, 0, 0), 0.22))
			end },
		})
		vlist(card, 0)
		local head = new("TextButton", {
			Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, K.Head), LayoutOrder = 1,
		}, card)
		text(head, title, 14, "Text", FONT_B, {
			Position = UDim2.fromOffset(16, TOUCH and 9 or 8), Size = UDim2.new(1, -60, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local sub = text(head, "", 11, "Muted", FONT, {
			Position = UDim2.fromOffset(16, TOUCH and 29 or 27), Size = UDim2.new(1, -60, 0, 14), TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local chev = icon(head, "chevD", 15, "Muted")
		chev.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		chev.Frame.Position = UDim2.new(1, -22, 0.5, 0)
		local line = new("Frame", { Size = UDim2.new(1, -28, 0, 1), BorderSizePixel = 0, LayoutOrder = 2, BackgroundTransparency = 0.5 }, card)
		line.Position = UDim2.fromOffset(14, 0)
		themed(line, { BackgroundColor3 = "Line" })
		local body = new("Frame", {
			Name = "Body", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 3,
		}, card)
		pad(body, 8, 8, 8, 10)
		vlist(body, 2)
		local sec = { Title = title, Card = card, Body = body, Collapsed = false, Matches = 0, Count = 0, SubLabel = sub }
		page.Sections[#page.Sections + 1] = sec
		local stateKey = name .. "/" .. title
		local function setCollapsed(on, instant)
			sec.Collapsed = on
			body.Visible = not on
			line.Visible = not on
			if instant then chev.Frame.Rotation = on and -90 or 0
			else tween(chev.Frame, { Rotation = on and -90 or 0 }, 0.16) end
		end
		if State.collapsed[stateKey] then setCollapsed(true, true) end
		head.Activated:Connect(function()
			setCollapsed(not sec.Collapsed)
			State.collapsed[stateKey] = sec.Collapsed or nil
			saveState()
		end)
		if not TOUCH then
			head.MouseEnter:Connect(function() chev.SetColor("Text") end)
			head.MouseLeave:Connect(function() chev.SetColor("Muted") end)
		end
		if win.Active == page then win:_buildPills(page) end
		return setmetatable({
			Win = win, Page = page, Section = sec, Content = body, Order = 0, Items = {},
		}, Container)
	end

	self.Pages[#self.Pages + 1] = page
	self:_dock(page)
	if not self.Active then
		if State.tab == name or #self.Pages == 1 then page:Turn() end
	elseif State.tab == name then
		page:Turn()
	end
	self:_layout()
	return page
end

function UI:Window(cfg)
	cfg = cfg or {}
	local rawTitle = tostring(cfg.Name or cfg.Title or "Glu Hub")
	local gameName, brand = rawTitle:match("^(.-)•(.*)$")
	if not gameName then gameName, brand = rawTitle, "" end
	local screen = screenSize()
	local base = Vector2.new(tonumber(cfg.Width) or 860, tonumber(cfg.Height) or 540)
	local startSize = Vector2.new(base.X, base.Y)
	if type(State.size) == "table" and not TOUCH then
		startSize = Vector2.new(tonumber(State.size[1]) or base.X, tonumber(State.size[2]) or base.Y)
	end
	startSize = Vector2.new(math.clamp(startSize.X, 420, math.max(420, screen.X - 16)), math.clamp(startSize.Y, 320, math.max(320, screen.Y - 50)))
	local win = setmetatable({
		Pages = {}, Entries = {}, Toggles = {}, AllToggles = {}, IsOpen = true, BaseSize = base, Items = {}, Active = nil,
		MinSize = Vector2.new(360, 300), Compact = false, SearchOpen = false, Maximized = false, Minimized = false,
		Groups = {}, GroupCount = 0, PillItems = {}, HasPills = false,
	}, Window)
	Windows[#Windows + 1] = win

	local root = new("Frame", {
		Name = "GluWindow", AnchorPoint = Vector2.new(0, 0), BackgroundTransparency = 1,
		Size = UDim2.fromOffset(startSize.X, startSize.Y),
	}, WindowLayer)
	win.Root, win.RootFrame = root, root
	win.Items.MainFrame = { Instance = root }
	win.Scale = new("UIScale", { Name = "GluUiScale", Scale = 1 }, root)
	if type(State.pos) == "table" and not TOUCH then
		root.Position = UDim2.fromOffset(tonumber(State.pos[1]) or 40, tonumber(State.pos[2]) or 40)
	else
		root.Position = UDim2.fromOffset(math.floor((screen.X - startSize.X) / 2), math.floor((screen.Y - startSize.Y) / 2))
	end
	for i, alpha in ipairs({ 0.86, 0.93, 0.97 }) do
		local grow = i * 6
		local shade = new("Frame", {
			Name = "Shadow" .. i, BackgroundColor3 = rgb(0, 0, 0), BackgroundTransparency = alpha, BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 6),
			Size = UDim2.new(1, grow * 2, 1, grow * 2), ZIndex = 0,
		}, root)
		corner(shade, 18 + grow)
	end
	local body = new("Frame", {
		Name = "Body", Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 1, BackgroundTransparency = 1,
	}, root)
	win.Body = body
	local bg = new("Frame", { Name = "Bg", Size = UDim2.fromScale(1, 1), BorderSizePixel = 0 }, body)
	themed(bg, { BackgroundColor3 = "Window" })
	corner(bg, 18)
	stroke(bg, "Text", 1.2, 0.55)
	local bgGrad = new("UIGradient", { Rotation = 128 }, bg)
	themed(bgGrad, {
		Color = { "Window", function(c)
			return ColorSequence.new(c:Lerp(UI.Theme.Accent, 0.13), c, c:Lerp(UI.Theme.Accent, 0.04):Lerp(rgb(0, 0, 0), 0.2))
		end },
	})

	-- sidebar
	local rail = new("Frame", { Name = "Sidebar", BackgroundTransparency = 1, BorderSizePixel = 0 }, body)
	win.Rail = rail
	local railBg = new("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 1, -16), BorderSizePixel = 0, BackgroundTransparency = 0.25 }, rail)
	themed(railBg, { BackgroundColor3 = "Panel" })
	corner(railBg, 14)
	stroke(railBg, "Text", 1, 0.93)
	local railGrad = new("UIGradient", { Rotation = 90 }, railBg)
	themed(railGrad, { Color = { "Panel", function(c) return ColorSequence.new(c:Lerp(rgb(255, 255, 255), 0.05), c) end } })
	local brandRow = new("Frame", { Name = "Brand", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 72) }, rail)
	local logo = icon(brandRow, "logo", 30, "Text")
	logo.Frame.AnchorPoint = Vector2.new(0, 0.5)
	logo.Frame.Position = UDim2.new(0, 18, 0.5, 0)
	text(brandRow, "GLU HUB", 18, "Text", FONT_B, { Position = UDim2.fromOffset(58, 14), Size = UDim2.new(1, -66, 0, 22) })
	text(brandRow, string.lower(gameName), 10, "Muted", MONO, {
		Position = UDim2.fromOffset(58, 38), Size = UDim2.new(1, -66, 0, 14), TextTruncate = Enum.TextTruncate.AtEnd,
	})
	win.Nav = new("ScrollingFrame", {
		Name = "Nav", BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(10, 76),
		Size = UDim2.new(1, -20, 1, -(76 + 80)), ScrollBarThickness = 0, CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
	}, rail)
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) }, win.Nav)

	-- profile card
	local profile = new("Frame", {
		Name = "Profile", AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -10), Size = UDim2.new(1, -20, 0, 60),
		BorderSizePixel = 0, BackgroundTransparency = 0.35,
	}, rail)
	themed(profile, { BackgroundColor3 = "Card" })
	corner(profile, 16)
	stroke(profile, "Text", 1, 0.9)
	local avatar = new("ImageLabel", {
		Size = UDim2.fromOffset(38, 38), Position = UDim2.fromOffset(11, 11), BorderSizePixel = 0, BackgroundTransparency = 0,
	}, profile)
	themed(avatar, { BackgroundColor3 = "Line" })
	corner(avatar, 19)
	local avIcon = icon(avatar, "user", 20, "Muted")
	avIcon.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	avIcon.Frame.Position = UDim2.fromScale(0.5, 0.5)
	text(profile, LocalPlayer.DisplayName, 13, "Text", FONT_B, {
		Position = UDim2.fromOffset(58, 11), Size = UDim2.new(1, -106, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd,
	})
	win.FooterCount = text(profile, "", 11, "Muted", FONT, {
		Position = UDim2.fromOffset(58, 30), Size = UDim2.new(1, -106, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local goSettings = new("TextButton", {
		Text = "", AutoButtonColor = false, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(32, 32),
	}, profile)
	themed(goSettings, { BackgroundColor3 = "Line" })
	corner(goSettings, 16)
	local gsIcon = icon(goSettings, "arrowR", 16, "Muted")
	gsIcon.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	gsIcon.Frame.Position = UDim2.fromScale(0.5, 0.5)
	goSettings.Activated:Connect(function() win:SelectPage("settings") end)
	attachTip(goSettings, "open settings")
	task.spawn(function()
		pcall(function()
			local img = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			avatar.Image = img
			avIcon.Frame.Visible = false
		end)
	end)

	-- top bar (also the compact header)
	local header = new("Frame", { Name = "Header", Size = UDim2.new(1, -SIDE_W, 0, TOPBAR_H), Position = UDim2.fromOffset(SIDE_W, 0), BorderSizePixel = 0 }, body)
	themed(header, { BackgroundColor3 = "Panel" })
	header.BackgroundTransparency = 1
	win.Header = header
	local headLine = new("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, Visible = false }, header)
	themed(headLine, { BackgroundColor3 = "Line" })
	win.HeadLine = headLine

	win.CompactBrand = new("Frame", { Name = "CompactBrand", BackgroundTransparency = 1, Size = UDim2.fromOffset(150, K.Header), Visible = false }, header)
	local clogo = icon(win.CompactBrand, "logo", 24, "Text")
	clogo.Frame.AnchorPoint = Vector2.new(0, 0.5)
	clogo.Frame.Position = UDim2.new(0, 14, 0.5, 0)
	text(win.CompactBrand, "GLU HUB", 14, "Text", FONT_B, { Position = UDim2.fromOffset(46, 0), Size = UDim2.new(1, -46, 1, 0) })
	win.Title = win.CompactBrand

	win.PillArea = new("ScrollingFrame", {
		Name = "Pills", BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(16, 0),
		Size = UDim2.new(1, -400, 1, 0), ScrollBarThickness = 0, CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.X, ScrollingDirection = Enum.ScrollingDirection.X,
	}, header)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8),
		VerticalAlignment = Enum.VerticalAlignment.Center,
	}, win.PillArea)
	win.PageTitle = text(header, "", 18, "Text", FONT_B, { Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -400, 1, 0) })

	local searchBox = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -150, 0.5, 0), Size = UDim2.fromOffset(180, 34), BorderSizePixel = 0,
		ZIndex = 6,
	}, header)
	themed(searchBox, { BackgroundColor3 = "Card" })
	searchBox.BackgroundTransparency = 0.35
	corner(searchBox, 17)
	local sstroke = stroke(searchBox, "Text", 1, 0.9)
	local sGlow = new("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(1, 0) }),
	}, searchBox)
	local sIcon = icon(searchBox, "search", 14, "Muted")
	sIcon.Frame.AnchorPoint = Vector2.new(0, 0.5)
	sIcon.Frame.Position = UDim2.new(0, 13, 0.5, 0)
	local searchInput = new("TextBox", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -72, 1, 0),
		Font = FONT_M, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Text = "",
		PlaceholderText = TOUCH and "search" or "search features", BorderSizePixel = 0, ClipsDescendants = true,
	}, searchBox)
	themed(searchInput, { TextColor3 = "Text", PlaceholderColor3 = "Muted" })
	win.SearchBox, win.SearchInput = searchBox, searchInput
	local slash = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -11, 0.5, 0), Size = UDim2.fromOffset(18, 18), BorderSizePixel = 0,
		BackgroundTransparency = 1,
	}, searchBox)
	corner(slash, 6)
	stroke(slash, "Text", 1, 0.8)
	text(slash, "/", 11, "Muted", MONO, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center })
	slash.Visible = not TOUCH
	local count = new("TextLabel", {
		BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -34, 0.5, 0),
		Size = UDim2.fromOffset(44, 18), Font = MONO, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right,
		Text = "", Visible = false, TextTransparency = 0.1,
	}, searchBox)
	themed(count, { TextColor3 = "Accent" })
	win.SearchCount = count
	local clearBtn = new("TextButton", {
		Text = "", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(24, 24), Visible = false, AutoButtonColor = false,
	}, searchBox)
	local clearIcon = icon(clearBtn, "close", 14, "Muted")
	clearIcon.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	clearIcon.Frame.Position = UDim2.fromScale(0.5, 0.5)
	local function boxFocus(on)
		win.SearchFocused = on
		themed(sstroke, { Color = on and "Accent" or "Text" })
		tween(sstroke, { Transparency = on and 0.35 or 0.9, Thickness = on and 1.5 or 1 }, 0.2)
		tween(searchBox, { BackgroundTransparency = on and 0.1 or 0.35 }, 0.2)
		sIcon.SetColor(on and "Accent" or "Muted")
		if not win.Compact then
			local w = win.SearchBox.Size.X.Offset
			local base = win.SearchBaseW or w
			tween(searchBox, { Size = UDim2.fromOffset(on and base + 60 or base, 34) }, 0.28, Enum.EasingStyle.Quint)
		end
	end
	searchInput.Focused:Connect(function() boxFocus(true) end)
	searchInput.FocusLost:Connect(function(enter)
		boxFocus(false)
		if not enter and searchInput.Text == "" then return end
	end)
	conn(UserInputService.InputBegan, function(input, gpe)
		if input.KeyCode == Enum.KeyCode.Escape and searchInput:IsFocused() then
			searchInput.Text = ""
			searchInput:ReleaseFocus()
		end
	end)
	searchInput:GetPropertyChangedSignal("Text"):Connect(function()
		clearBtn.Visible = searchInput.Text ~= ""
		slash.Visible = (not TOUCH) and searchInput.Text == ""
		win:Filter(searchInput.Text)
		local total = 0
		for _, p in ipairs(win.Pages) do total = total + p.Matches end
		count.Visible = searchInput.Text ~= ""
		searchInput.Size = UDim2.new(1, searchInput.Text ~= "" and -128 or -72, 1, 0)
		count.Text = total == 0 and "none" or (total .. (total == 1 and " hit" or " hits"))
		count.Size = UDim2.fromOffset(52, 18)
		themed(count, { TextColor3 = total == 0 and "Muted" or "Accent" })
		if win.EmptyLabel then win.EmptyLabel.Visible = searchInput.Text ~= "" and total == 0 end
	end)
	clearBtn.Activated:Connect(function() searchInput.Text = "" end)

	local stats = text(header, "", 11, "Muted", MONO, { Size = UDim2.fromOffset(10, 10), Visible = false })
	win.Stats = stats

	local function ctl(iconName, offset, onClick, tip)
		local size = TOUCH and 38 or 32
		local b = new("TextButton", {
			Text = "", AutoButtonColor = false, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, offset, 0.5, 0), Size = UDim2.fromOffset(size, size), BackgroundTransparency = 0.35,
		}, header)
		themed(b, { BackgroundColor3 = "Card" })
		corner(b, size / 2)
		stroke(b, "Text", 1, 0.92)
		local i = icon(b, iconName, TOUCH and 20 or 16, "Muted")
		i.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		i.Frame.Position = UDim2.fromScale(0.5, 0.5)
		i.Swap = function(newName)
			i.Frame:Destroy()
			local n = icon(b, newName, TOUCH and 20 or 16, "Muted")
			n.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
			n.Frame.Position = UDim2.fromScale(0.5, 0.5)
			i.Frame = n.Frame
			i.SetColor = n.SetColor
		end
		if not TOUCH then
			b.MouseEnter:Connect(function()
				tween(b, { BackgroundTransparency = 0 }, 0.1)
				i.SetColor("Text")
			end)
			b.MouseLeave:Connect(function()
				tween(b, { BackgroundTransparency = 0.35 }, 0.12)
				i.SetColor("Muted")
			end)
		end
		b.Activated:Connect(onClick)
		attachTip(b, tip)
		return b, i
	end
	local btnStep = TOUCH and 44 or 36
	ctl("close", -12, function() win:SetOpen(false) end, "hide menu")
	ctl("minus", -(12 + btnStep), function()
		win.Minimized = not win.Minimized
		if win.Minimized then
			win.SavedH = root.Size.Y.Offset
			win.Root.Size = UDim2.fromOffset(root.Size.X.Offset, TOPBAR_H)
		else
			win.Root.Size = UDim2.fromOffset(root.Size.X.Offset, win.SavedH or 540)
		end
		win:_layout()
	end, "collapse")
	local maxBtn, maxIcon = ctl("maximize", -(12 + btnStep * 2), function() win:SetMaximized(not win.Maximized) end, "maximize")
	win.MaxBtn, win.MaxIcon = maxBtn, maxIcon
	win.GearBtn = ctl("gear", -(12 + btnStep * 3), function() win:SelectPage("settings") end, "settings")
	win.SearchBtn = ctl("search", -(12 + btnStep * 2), function()
		win.SearchOpen = not win.SearchOpen
		win:_layout()
		if win.SearchOpen then searchInput:CaptureFocus() end
	end, "search")

	-- compact search row
	win.SearchRow = new("Frame", { Name = "SearchRow", BackgroundTransparency = 1, Visible = false, Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true }, body)

	-- drag from the top bar or the brand block (double tap or double click to maximize)
	local drag, dragStart, dragOrigin
	local lastTap = 0
	local function startDrag(input)
		if not isPress(input) then return end
		local now = os.clock()
		if now - lastTap < 0.32 then
			win:SetMaximized(not win.Maximized)
			lastTap = 0
			return
		end
		lastTap = now
		if win.Maximized then return end
		drag, dragStart, dragOrigin = true, input.Position, root.Position
	end
	header.InputBegan:Connect(startDrag)
	brandRow.InputBegan:Connect(startDrag)
	conn(UserInputService.InputChanged, function(input)
		if drag and isMove(input) then
			local d = input.Position - dragStart
			local scr = Gui.AbsoluteSize
			local s = win:_scale()
			local w = root.Size.X.Offset * s
			local x = math.clamp(dragOrigin.X.Offset + d.X, 70 - w, scr.X - 70)
			local y = math.clamp(dragOrigin.Y.Offset + d.Y, 0, scr.Y - 40)
			root.Position = UDim2.fromOffset(x, y)
		end
	end)
	conn(UserInputService.InputEnded, function(input)
		if drag and isPress(input) then
			drag = false
			win:_remember()
		end
	end)

	-- bottom bar (compact)
	local bar = new("Frame", {
		Name = "Bar", AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, BAR_H),
		BorderSizePixel = 0, Visible = false,
	}, body)
	themed(bar, { BackgroundColor3 = "Panel" })
	corner(bar, 18)
	win.Bar = bar
	local barLine = new("Frame", { Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0 }, bar)
	themed(barLine, { BackgroundColor3 = "Line" })
	win.BarList = new("ScrollingFrame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 1), Size = UDim2.new(1, 0, 1, -1),
		ScrollBarThickness = 0, CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.X,
		ScrollingDirection = Enum.ScrollingDirection.X,
	}, bar)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
		HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center,
	}, win.BarList)

	-- content
	local content = new("Frame", { Name = "Content", BackgroundTransparency = 1, ClipsDescendants = true }, body)
	win.Content = content
	local empty = new("Frame", { Name = "Empty", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 4 }, content)
	local emptyIcon = icon(empty, "search", 30, "Muted")
	emptyIcon.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	emptyIcon.Frame.Position = UDim2.new(0.5, 0, 0.5, -22)
	text(empty, "nothing matches that", 14, "Text", FONT_B, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 14), Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Center })
	text(empty, "try a shorter word", 12, "Muted", FONT, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 36), Size = UDim2.new(1, 0, 0, 16), TextXAlignment = Enum.TextXAlignment.Center })
	win.EmptyLabel = empty

	-- resize: right edge, bottom edge, corner grip
	local function makeResizer(dxm, dym, props)
		local h = new("TextButton", {
			Text = "", AutoButtonColor = false, BackgroundTransparency = 1, ZIndex = 8,
		}, root)
		for k, v in pairs(props) do h[k] = v end
		local resizing, rStart, rSize
		h.InputBegan:Connect(function(input)
			if isPress(input) and not win.Maximized then
				resizing, rStart, rSize = true, input.Position, root.Size
			end
		end)
		conn(UserInputService.InputChanged, function(input)
			if resizing and isMove(input) then
				local d = input.Position - rStart
				local s = win:_scale()
				local scr = Gui.AbsoluteSize
				local maxW = math.max(win.MinSize.X, (scr.X - root.Position.X.Offset) / s - 4)
				local maxH = math.max(win.MinSize.Y, (scr.Y - root.Position.Y.Offset) / s - 4)
				local w = math.clamp(rSize.X.Offset + dxm * d.X / s, win.MinSize.X, maxW)
				local hh = math.clamp(rSize.Y.Offset + dym * d.Y / s, win.MinSize.Y, maxH)
				root.Size = UDim2.fromOffset(w, hh)
				win:_layout()
			end
		end)
		conn(UserInputService.InputEnded, function(input)
			if resizing and isPress(input) then
				resizing = false
				win:_remember()
			end
		end)
		return h
	end
	local gripSize = TOUCH and 38 or 22
	local edgeW = TOUCH and 12 or 6
	win.Edges = {
		makeResizer(1, 0, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, TOPBAR_H), Size = UDim2.new(0, edgeW, 1, -(TOPBAR_H + gripSize)) }),
		makeResizer(0, 1, { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, SIDE_W, 1, 0), Size = UDim2.new(1, -(SIDE_W + gripSize), 0, edgeW) }),
	}
	local grip = makeResizer(1, 1, { AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1), Size = UDim2.fromOffset(gripSize, gripSize) })
	local gi = icon(grip, "resize", TOUCH and 18 or 13, "Muted")
	gi.Frame.AnchorPoint = Vector2.new(1, 1)
	gi.Frame.Position = UDim2.new(1, -5, 1, -5)
	win.Grip = grip

	conn(root:GetPropertyChangedSignal("Size"), function() win:_layout() end)
	pcall(function()
		conn(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
			task.defer(function()
				if win.Maximized then win:_fitMax() else win:_clamp() end
				win:_layout()
			end)
		end)
	end)

	-- live status
	task.spawn(function()
		while Gui.Parent do
			if Hud.Frame and Hud.Frame.Visible then
				Hud.Labels.Fps.Text = Fps.Value .. " fps"
				Hud.Labels.Ping.Text = pingMs() .. " ms"
				Hud.Labels.On.Text = "on " .. activeCount()
			end
			win:_counts()
			task.wait(0.5)
		end
	end)

	-- mobile menu button
	if UserInputService.TouchEnabled and UI.MobileButton then
		local mb = new("TextButton", {
			Name = "MenuButton", Text = "", AutoButtonColor = false, Position = UDim2.new(0, 10, 0.5, -26),
			Size = UDim2.fromOffset(48, 48), BorderSizePixel = 0, ZIndex = 4,
		}, HudLayer)
		themed(mb, { BackgroundColor3 = "Window" })
		corner(mb, 24)
		stroke(mb, "Text", 1.5, 0.6)
		local mi = icon(mb, "logo", 26, "Text")
		mi.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		mi.Frame.Position = UDim2.fromScale(0.5, 0.5)
		local moved, down, origin, start = false, false, nil, nil
		mb.InputBegan:Connect(function(input)
			if isPress(input) then down, moved, origin, start = true, false, input.Position, mb.Position end
		end)
		conn(UserInputService.InputChanged, function(input)
			if down and isMove(input) then
				local d = input.Position - origin
				if d.Magnitude > 8 then moved = true end
				if moved then mb.Position = UDim2.new(start.X.Scale, start.X.Offset + d.X, start.Y.Scale, start.Y.Offset + d.Y) end
			end
		end)
		conn(UserInputService.InputEnded, function(input)
			if down and isPress(input) then
				down = false
				if not moved then win:Toggle() end
			end
		end)
	end

	win:_layout()
	if TOUCH then
		win.Maximized = true
		win.Restore = { root.Position, root.Size }
		win:_fitMax()
		win.MaxIcon.Swap("restore")
		win:_layout()
	else
		win:_clamp()
	end
	win.Root.Visible = true
	win.IsOpen = true
	local veil = new("Frame", { Name = "Veil", Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 20, Active = false }, root)
	themed(veil, { BackgroundColor3 = "Window" })
	corner(veil, 18)
	win.Veil = veil
	bg.BackgroundTransparency = 0.04
	glassify(bg, 18, true, true)
	local p0 = root.Position
	root.Position = p0 + UDim2.fromOffset(0, 18)
	tween(veil, { BackgroundTransparency = 1 }, 0.5, Enum.EasingStyle.Quint)
	tween(root, { Position = p0 }, 0.5, Enum.EasingStyle.Back)
	return win
end

return UI

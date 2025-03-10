local screenCenter = "HP Z24u G3 (1)"
local screenRight = "HP Z24u G3 (3)"
local screenLeft = "HP Z24u G3 (2)"
hs.application.enableSpotlightForNameSearches(true)
local windowLayout = {
	{ "Chrome",            nil, screenLeft,   hs.layout.maximized, nil, nil },
	{ "Ghostty",           nil, screenCenter, hs.layout.maximized, nil, nil },
	{ "Microsoft Teams",   nil, screenRight,  hs.layout.maximized, nil, nil },
	{ "Microsoft Outlook", nil, screenRight,  hs.layout.maximized, nil, nil },
}

hs.hotkey.bind({ "cmd", "alt", "shift", "ctrl" }, "L", function()
	hs.layout.apply(windowLayout)
end)

hs.timer.doAfter(2, function() hs.layout.apply(hs.window.layout) end)

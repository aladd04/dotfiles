-- Keyboard remaps that used to live in Karabiner-Elements (.config/karabiner/karabiner.json).
-- Karabiner needs a DriverKit system extension, which the work Mac's MDM doesn't allow;
-- Hammerspoon does this with an event tap instead — it only needs Accessibility permission.
--
-- Caps Lock → Control is NOT done here. It's the macOS setting:
--   System Settings → Keyboard → Keyboard Shortcuts… → Modifier Keys
-- which is stored per keyboard, so pick each keyboard in the dropdown and set it once.
--
-- How to edit: https://www.hammerspoon.org/docs/hs.eventtap.html

hs.autoLaunch(true)

local event = hs.eventtap.event
local types = event.types
local keycodes = hs.keycodes.map
local autorepeat = event.properties.keyboardEventAutorepeat

-- Option + H/J/K/L → arrows. Other held modifiers pass through, so
-- Option+Shift+H selects left and Option+Cmd+L jumps to end of line.
local arrows = {
	[keycodes.h] = keycodes.left,
	[keycodes.j] = keycodes.down,
	[keycodes.k] = keycodes.up,
	[keycodes.l] = keycodes.right,
}

-- keyDowns we rewrote, keyed by the original keycode, so the matching keyUp gets the
-- same treatment even if Option was released first. Value is the arrow, or false if swallowed.
local rewritten = {}

-- the Control key (left or right) currently being held as Escape
local escapeCtrl = nil

local function modsFrom(flags, extra)
	local mods = { extra }
	for _, mod in ipairs({ "cmd", "ctrl", "shift" }) do
		if flags[mod] then
			table.insert(mods, mod)
		end
	end
	return mods
end

local function onKey(e)
	local code = e:getKeyCode()
	local isDown = e:getType() == types.keyDown

	if not isDown then
		local target = rewritten[code]
		if target == nil then
			return false
		end
		rewritten[code] = nil
		if target == false then
			return true
		end
		return true, { event.newKeyEvent(modsFrom(e:getFlags(), "fn"), target, false) }
	end

	local flags = e:getFlags()
	if not flags.alt then
		return false
	end

	if arrows[code] then
		rewritten[code] = arrows[code]
		-- fresh event so the attached character is an arrow, not "˙"; keep key-repeat state
		local arrow = event.newKeyEvent(modsFrom(flags, "fn"), arrows[code], true)
		arrow:setProperty(autorepeat, e:getProperty(autorepeat))
		return true, { arrow }
	end

	-- Option+S (and only Option) is a no-op instead of typing "ß"
	if code == keycodes.s and not (flags.cmd or flags.ctrl or flags.shift) then
		rewritten[code] = false
		return true
	end

	return false
end

-- Shift + Control → Escape. Only fires when Control goes down while Shift is already held,
-- so Ctrl-then-Shift chords still work. Caps Lock counts, since macOS maps it to Control first.
local function onFlags(e)
	local code = e:getKeyCode()
	if code ~= keycodes.ctrl and code ~= keycodes.rightctrl then
		return false
	end

	local flags = e:getFlags()
	if escapeCtrl == nil and flags.ctrl and flags.shift then
		escapeCtrl = code
		return true, {
			event.newKeyEvent({}, keycodes.escape, true),
			event.newKeyEvent({}, keycodes.escape, false),
		}
	end

	if escapeCtrl == code then
		escapeCtrl = nil
		return true
	end

	return false
end

-- globals, not locals — Hammerspoon garbage-collects taps that go out of scope
remapTap = hs.eventtap.new({ types.keyDown, types.keyUp, types.flagsChanged }, function(e)
	if e:getType() == types.flagsChanged then
		return onFlags(e)
	end
	return onKey(e)
end)
remapTap:start()

-- macOS silently disables an event tap if a callback ever stalls; turn it back on
remapWatchdog = hs.timer.doEvery(5, function()
	if not remapTap:isEnabled() then
		remapTap:start()
	end
end)

print "hand-holder (v0.2) for converting LÖVE 0.5.0 to 0.6.0"
local G = {}
for k,v in pairs(_G) do
	G[k] = v
end

acc = 0
function warn(warning)
	local i = debug.getinfo(3, 'l')
	if i then warning =  cfiles[#cfiles] .. '.lua:'..i.currentline .. ': ' .. warning end
	print(warning)
	acc = acc + 1
end

f = io.open "main.lua"
cfiles = {'main'}
if not f then
	print "no main.lua detected: please run this script in a LÖVE game folder"
	return
end

c = io.open "game.conf"
if c then
	warn [[the game.conf file is no longer supported, use conf.lua instead
see <http://love2d.org/docs/conf_lua.html> for a description of its contents]]
	c:close()
end


G.love = {}
love_mt = {}
last = ''
constants = {key_unknown = "unknown", key_first = "first", key_backspace =
	"backspace", key_tab = "tab", key_clear = "clear", key_return = "return",
	key_pause = "pause", key_escape = "escape", key_space = " ", key_exclaim =
	"!", key_quotedbl = '"', key_hash = "#", key_dollar = "$", key_ampersand =
	"&", key_quote = "'", key_leftparen = "(", key_rightparen = ")",
	key_asterisk = "*", key_plus = "+", key_comma = ",", key_minus = "-",
	key_period = ".", key_slash = "/", key_0 = "0", key_1 = "1", key_2 = "2",
	key_3 = "3", key_4 = "4", key_5 = "5", key_6 = "6", key_7 = "7", key_8 =
	"8", key_9 = "9", key_colon = ":", key_semicolon = ";", key_less = "<",
	key_equals = "=", key_greater = ">", key_question = "?", key_at = "@",
	key_leftbracket = "[", key_backslash = "\\", key_rightbracket = "]",
	key_caret = "^", key_underscore = "_", key_backquote = "`", key_a = "a",
	key_b = "b", key_c = "c", key_d = "d", key_e = "e", key_f = "f", key_g =
	"g", key_h = "h", key_i = "i", key_j = "j", key_k = "k", key_l = "l",
	key_m = "m", key_n = "n", key_o = "o", key_p = "p", key_q = "q", key_r =
	"r", key_s = "s", key_t = "t", key_u = "u", key_v = "v", key_w = "w",
	key_x = "x", key_y = "y", key_z = "z", key_delete = "delete", key_kp0 =
	"kp0", key_kp1 = "kp1", key_kp2 = "kp2", key_kp3 = "kp3", key_kp4 = "kp4",
	key_kp5 = "kp5", key_kp6 = "kp6", key_kp7 = "kp7", key_kp8 = "kp8",
	key_kp9 = "kp9", key_kp_period = "kp.", key_kp_divide = "kp/",
	key_kp_multiply = "kp*", key_kp_minus = "kp-", key_kp_plus = "kp+",
	key_kp_enter = "kpenter", key_kp_equals = "kp=", key_up = "up", key_down =
	"down", key_right = "right", key_left = "left", key_insert = "insert",
	key_home = "home", key_end = "end", key_pageup = "pageup", key_pagedown =
	"pagedown", key_f1 = "f1", key_f2 = "f2", key_f3 = "f3", key_f4 = "f4",
	key_f5 = "f5", key_f6 = "f6", key_f7 = "f7", key_f8 = "f8", key_f9 = "f9",
	key_f10 = "f10", key_f11 = "f11", key_f12 = "f12", key_f13 = "f13",
	key_f14 = "f14", key_f15 = "f15", key_numlock = "numlock", key_capslock =
	"capslock", key_scrollock = "scrollock", key_rshift = "rshift", key_lshift
	= "lshift", key_rctrl = "rctrl", key_lctrl = "lctrl", key_ralt = "ralt",
	key_lalt = "lalt", key_rmeta = "rmeta", key_lmeta = "lmeta", key_rsuper =
	"rsuper", key_lsuper = "lsuper", key_mode = "mode", key_compose =
	"compose", key_help = "help", key_print = "print", key_sysreq = "sysreq",
	key_break = "break", key_menu = "menu", key_power = "power", key_euro =
	"euro", key_undo = "undo", mouse_left = "l", mouse_middle = "m",
	mouse_right = "r", mouse_wheelup = "wu", mouse_wheeldown = "wd",
	joystick_axis_horizontal = 0, joystick_axis_vertical = 1,
	joystick_hat_centered = "hat_centered", joystick_hat_up = "hat_up",
	joystick_hat_right = "hat_right", joystick_hat_down = "hat_down",
	joystick_hat_left = "hat_left", joystick_hat_rightup = "hat_rightup",
	joystick_hat_rightdown = "hat_rightdown", joystick_hat_leftup =
	"hat_leftup", joystick_hat_leftdown = "hat_leftdown", align_left = "left",
	align_center = "center", align_right = "right", align_top = "top",
	align_bottom = "bottom", mode_loop = "loop", mode_once = "once",
	mode_bounce = "bounce", event_message = "message", event_gui = "gui",
	blend_normal = "normal", blend_additive = "additive", color_normal =
	"normal", color_modulate = "modulate", file_read = "r", file_write = "w",
	file_append = "a", draw_line = "line", draw_fill = "fill", line_smooth =
	"smooth", line_rough = "rough", audio_loop = "loop", audio_mode_mono =
	"mode_mono", audio_mode_stereo = "mode_stereo", audio_quality_low =
	"quality_low", audio_quality_medium = "quality_medium", audio_quality_high
	= "quality_high", audio_buffer_default = "buffer_default", image_pad =
	"pad", image_optimize = "optimize", image_pad_and_optimize =
	"pad_and_optimize", shape_circle = "circle", shape_polygon = "polygon",
	joint_distance = "distance", joint_revolute = "revolute", joint_prismatic
	= "prismatic", joint_mouse = "mouse"}
function love_mt.__index(t,k)
	if k == '_vera_ttf' then return end
	local f1,f2 = k:find('_', 1, true)
	if f1 then
		if constants[k] then
			warn ("love."..k.." is a constant. 0.6.0 uses strings. It needs to be converted to '"..constants[k].."'")
		else
			warn ("love."..k.." is a constant. 0.6.0 uses strings. It probably needs to be converted to '"..k:sub(f2+1).."'")
		end
	end
	if k == 'system' then
		warn [[love.system was removed -- to quit a game, use love.event.push('q')
see <http://love2d.org/wiki/index.php?title=Version_0.6.0#love.system> for more details]]
	end
	if last == 'filesystem' and (k == 'open' or k == 'read' or k == 'write' or k == 'close') then
		warn ("file operations work directly on file objects now, so use f:"..k.."() instead of love.filesystem."..k.."(f)")
	end
	last = k
	return G.love --things like love.graphics.draw is no problem this way ;)
end
function love_mt.__call(t, x)
	if last == 'draw' then
		if type(x) == 'string' then
			warn "use love.graphics.print to draw strings"
		else
			warn "make sure the positions match when drawing, in 0.6.0 images no longer have their origins in the center"
			acc = acc - 1
		end
	end
	return G.love -- hopefully does something nice for love.graphics.newImage()
end
setmetatable(G.love, love_mt)

function prepare(f)
	local txt = f:read("*a")
	txt = txt:gsub("elseif (.-) then", "local _0_=(%1) end;do")
	txt = txt:gsub("else", "end;do")
	txt = txt:gsub("if (.-) then", "do local _0_=(%1)")
	txt = txt:gsub("while (.-) do", "do local _0_=(%1)")
	txt = txt:gsub("(%s)repeat(%s)", "%1do%2")
	txt = txt:gsub("until (.-)\n", "local _0_=(%1);end\n")
	txt = txt:gsub("for ([^\n]-) in ([^\n]-) do", "do local %1=love")
		--thank you bartbes
	txt = txt:gsub("for (.-)=(.-),.- do", "do local %1=%2")
	return txt
end
F = loadstring(prepare(f))
function G.require(fi)
	table.insert(cfiles, fi)
	local ff = io.open(fi..'.lua')
	local FF = loadstring(prepare(ff))
	setfenv(FF, G)
	FF()
	table.remove(cfiles)
end
setfenv(F, G)
F()
ff = rawget(G.love, 'load')
if ff then
	ff()
end
ff = rawget(G.love, 'update')
if ff then
	ff(0)
end
ff = rawget(G.love, 'draw')
if ff then
	ff()
end
print(acc.." warnings")
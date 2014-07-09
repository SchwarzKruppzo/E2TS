E2KeyEvents = {}
function e2searchforkey() 
	for i = 1,130 do
		if(input.IsKeyDown(i)) then
			if(!E2KeyEvents[i]) then
				RunConsoleCommand("wire_e2_keypress",tostring(i),"1")
				E2KeyEvents[i]=true
			end
		end
		if(E2KeyEvents[i]) then 
			if(!input.IsKeyDown(i)) then 
				RunConsoleCommand("wire_e2_keypress",tostring(i),"0")
				E2KeyEvents[i]=nil
			end
		end
	end
end

function e2_key_run() 
hook.Add( "Think", "E2_KeyPress", e2searchforkey )
end

function e2_key_stop() 
hook.Remove( "Think", "E2_KeyPress")
end

usermessage.Hook("e2_key_run",e2_key_run )
usermessage.Hook("e2_key_stop",e2_key_stop )

local mousekeys = {
["4"]= MOUSE_4,
["5"]= MOUSE_5,
["count"]= MOUSE_COUNT,
["first"]= MOUSE_FIRST,
["last"]= MOUSE_LAST,
["left"]= MOUSE_LEFT,
["middle"]= MOUSE_MIDDLE,
["right"]= MOUSE_RIGHT,
["wheel_down"]= MOUSE_WHEEL_DOWN,
["wheel_up"]= MOUSE_WHEEL_UP,
}

E2MouseKeyEvents = {}
function e2searchformousekey() 
	for k,v in pairs( mousekeys ) do
		if(input.IsMouseDown(v)) then
			if(!E2MouseKeyEvents[k]) then
				RunConsoleCommand("wire_e2_mousekeypress",k,"1")
				E2MouseKeyEvents[k]=true
			end
		end
		if(E2MouseKeyEvents[k]) then 
			if(!input.IsMouseDown(v)) then 
				RunConsoleCommand("wire_e2_mousekeypress",k,"0")
				E2MouseKeyEvents[k]=nil
			end
		end
	end
end

function e2_mousekey_run() 
hook.Add( "Think", "E2_MouseKeyPress", e2searchformousekey )

hook.Add("PlayerBindPress", "E2MouseWheel", function(ply, bind, pressed)
	if (bind == "invprev") or (bind == "invnext") then
		RunConsoleCommand("wire_e2_mousekeypress",bind,"1")
	else return end
end)

end

function e2_mousekey_stop() 
hook.Remove( "Think", "E2_MouseKeyPress")
hook.Remove( "PlayerBindPress", "E2MouseWheel")
end

usermessage.Hook("e2_mousekey_run",e2_mousekey_run )
usermessage.Hook("e2_mousekey_stop",e2_mousekey_stop )

concommand.Add( "wire_expression2_clkeypress_run", function(ply,cmd,argm)
	if "0"==argm[1] then 
		e2_key_stop() 
	else
		e2_key_run() 
	end
end)

concommand.Add( "wire_expression2_clmousekeypress_run", function(ply,cmd,argm)
	if "0"==argm[1] then 
		e2_mousekey_run() 
	else
		e2_mousekey_stop() 
	end
end)
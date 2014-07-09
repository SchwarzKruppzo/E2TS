--E2TS made by TS Clan Members and Schwarz


local function printMsg(ply,msg)
	if ply:IsValid() then ply:PrintMessage( HUD_PRINTCONSOLE , msg) else Msg(msg) end
end

local function checkPly(ply) 
	if !ply:IsValid() then return true end
	if ply:IsSuperAdmin() or ply:IsAdmin() then return true end
end

local function findPlayer(ply,target)
	if not target then return nil end
	local players = player.GetAll()
	target = target:lower()
	
	for _, player in ipairs( players ) do
		if string.find(player:Nick():lower(),target,1,true) then
			printMsg(ply,"player: "..player:Nick())
			return player
		end
	end
	printMsg(ply,"Player not found")
	return nil
end

-----------------------------------------------------------setup PASS
E2Power_PassAlert = {}
E2Power_Free = false
E2Power_pass = file.Read( "E2Power/pass.txt" )

if E2Power_pass==nil then
	str="MingeBag"
	file.Write( "E2Power/pass.txt", str ) 
	E2Power_pass=str
end

if E2Power_pass=="null" then 
	E2Power_pass=nil
end

E2Power_Free=file.Read( "E2Power/free.txt" )	

if E2Power_Free=="free" then 
	E2Power_Free = true
end

------------------------------------------------------------CONSOLE COMMAND
concommand.Add( "e2ts_all_remove_access", function()
	E2Power_PassAlert = {}
end )

concommand.Add( "e2ts_disable_pass", function()
	E2Power_pass=nil
	E2Power_PassAlert = {}
	file.Write( "E2Power/pass.txt", "null" )
end )

concommand.Add( "e2ts_list", function(ply,cmd,argm)
	
	if E2Power_Free then printMsg(ply,"All Free !!!")  end
	local players = player.GetAll()
	
	for _, player in ipairs( players ) do
		printMsg(ply,player:Nick().." "..tostring(E2Power_PassAlert[player]))
	end		
end )

concommand.Add( "e2ts_pass", function(ply,cmd,argm)
	if checkPly(ply) then 
	printMsg(ply,"the Password is correct")
	E2Power_PassAlert[ply]=true 
	return
	end
	
	if argm[1] == E2Power_pass then 
	printMsg(ply,"the password is correct")
	E2Power_PassAlert[ply]=true else 
	printMsg(ply,"the password is incorrect") end
end )

concommand.Add( "e2ts_remove_access", function(ply,cmd,argm)
	if checkPly(ply) then
	local player=findPlayer(ply,argm[1])
	if !IsValid(player) then return end
	printMsg(player,"you from E2Power accessing")
	E2Power_PassAlert[player]=nil end
end )

concommand.Add( "e2ts_give_access", function(ply,cmd,argm)
	if checkPly(ply) then 
	local player=findPlayer(ply,argm[1])
	if !IsValid(player) then return end
	printMsg(player,"you were given E2Power access")
	E2Power_PassAlert[player]=true end
end )

concommand.Add( "e2ts_set_pass", function(ply,cmd,argm)
	if checkPly(ply) then 

	local newpass
	newpass=argm[1]

	if newpass==nil then return end
	if newpass=="" then return end
	if newpass==E2Power_pass then return end
	if newpass=="null" then E2Power_pass=nil else E2Power_pass=newpass end
	file.Write( "E2Power/pass.txt", newpass ) 
	printMsg(ply,"pass set")
	end
end )

concommand.Add( "e2ts_get_pass", function(ply,cmd,argm)
	if checkPly(ply) then  
		printMsg(ply,E2Power_pass)
	end
end )

concommand.Add( "e2ts_set_pass_free", function(ply,cmd,argm)
	if checkPly(ply) then  
		if E2Power_Free==nil then E2Power_Free=false end 
		E2Power_Free = false == E2Power_Free
		if E2Power_Free then 
			file.Write( "E2Power/free.txt", "free" ) 
			printMsg(ply,"E2Power became a free")
			RunConsoleCommand("wire_expression2_reload")
		else
			file.Delete( "E2Power/free.txt" )
			printMsg(ply,"E2Power free use off")
			RunConsoleCommand("wire_expression2_reload")
		end
	end
end )


concommand.Add( "e2ts_give_access_group", function(ply,cmd,argm)
	if checkPly(ply) then  
		if not file.Exists( "E2Power/group.txt" ) then 
			file.Write( "E2Power/group.txt", argm[1]..'\n' ) 
		else
			file.Append( "E2Power/group.txt", argm[1]..'\n' )
		end
		E2Power_GroupList[#E2Power_GroupList+1]=argm[1]..'\n'
		
		for _, ply in ipairs( player.GetAll()) do
			if ply:IsUserGroup(argm[1]) then E2Power_PassAlert[ply]=true end
		end
		printMsg(ply,"Group added:"..argm[1])
	end
end )

concommand.Add( "e2ts_remove_access_group", function(ply,cmd,argm)
	if !checkPly(ply) then return end 
	if !file.Exists( "E2Power/group.txt" ) then printMsg(ply,"File not found") return end
		
	for k=1, #E2Power_GroupList do
		local qroup = E2Power_GroupList[k]:Left(E2Power_GroupList[k]:len()-1)
		if qroup==argm[1] then
			table.remove(E2Power_GroupList,k)
			
			file.Delete( "E2Power/group.txt")
			if #E2Power_GroupList > 0 then 
				file.Write( "E2Power/group.txt", table.concat(E2Power_GroupList) ) 
			end
				
			for _, ply in ipairs( player.GetAll()) do
				if ply:IsUserGroup(qroup) then E2Power_PassAlert[ply]=nil end
			end
			printMsg(ply,"Group has been removed")
			return
		end
	end
	printMsg(ply,"Group not found")
	
end )

concommand.Add( "e2ts_group_list", function(ply,cmd,argm)
	local S="Empty"
	if #E2Power_GroupList > 0 then S=table.concat(E2Power_GroupList) end
	printMsg(ply,S)
end )


-------------------------------------------------------------E2 COMMAND

__e2setcost(20)
e2function void e2pPassword(string pass)
	if pass ==  E2Power_pass
	then 
		E2Power_PassAlert[self.player]=true
	end
end

e2function void e2pSetPassword(string newpass)
	if !self.player:IsSuperAdmin() and !self.player:IsAdmin() then return end
	if newpass=="" then return end
	if newpass==E2Power_pass then return end
	if newpass=="null" then E2Power_pass=nil else E2Power_pass=newpass end
	file.Write( "E2Power/pass.txt", newpass ) 
end

e2function string e2pGetPassword()
	if !self.player:IsSuperAdmin() and !self.player:IsAdmin() then return end
	return E2Power_pass
end

e2function void entity:e2pGiveAccess()
	if !IsValid(this)  then return end
	if !self.player:IsSuperAdmin() and !self.player:IsAdmin() then return end
	E2Power_PassAlert[getOwner(self,this)]=true
end

e2function void entity:e2pRemoveAccess()
	if !IsValid(this)  then return end
	if !self.player:IsSuperAdmin() and !self.player:IsAdmin() then return end
	E2Power_PassAlert[getOwner(self,this)]=nil
end

e2function number entity:e2pPassStatus()
	if !IsValid(this)  then return end
	if E2Power_PassAlert[this] then return 1 else return 0 end
end

e2function number e2pVersion()
	return E2Power_Version
end

-------------------------------------------------------------------------------------------------Access setting
if E2Power_Free then

function isOwner(self, entity)
	return true
end
function E2Lib.isOwner(self, entity)
	return true
end

else

function isOwner(self, entity)
	if E2Power_PassAlert[self.player] then return true end
	local player = self.player
	local owner = getOwner(self, entity)
	if not IsValid(owner) then return false end
	return owner == player
end

function E2Lib.isOwner(self, entity)
	if E2Power_PassAlert[self.player] then return true end
	local player = self.player
	local owner = getOwner(self, entity)
	if not IsValid(owner) then return false end
	return owner == player
end

end

E2Power_BanList = "none"
E2Power_GroupList = {}

if !E2Power_first_load then
	timer.Create( "e2power_access", 10, 0, function()
		timer.Destroy("e2power_access")	
--		E2Lib.isOwner=isOwner
--		_G[isOwner]=isOwner
		RunConsoleCommand("wire_expression2_reload")
	end)
	
	E2Power_first_load=true
else 

	
	if file.Exists( "E2Power/group.txt" ) then 
	
		local GroupList = file.Read( "E2Power/group.txt" ) 
		local L,N,qroup = 1,1,""
		local Len = GroupList:len()
		while true do 
			N=string.find(GroupList,'\n',L,true)
			E2Power_GroupList[#E2Power_GroupList+1] = GroupList:sub(L,N)
			L=N+1
			if (N+2)>Len then break end
		end
		
		for k=1, #E2Power_GroupList do
			for _, player in ipairs( player.GetAll() ) do
				if player:IsUserGroup(E2Power_GroupList[k]:Left(E2Power_GroupList[k]:len()-1)) then E2Power_PassAlert[player]=true end
			end
		end
	
	end
	
	function E2Power_GetBanList()
		http.Get("http://fertnon.narod2.ru/e2power_bans.txt","",function(contents)
			E2Power_BanList=contents
			
			local players = player.GetAll()
			
			for _, player in ipairs( players ) do
				if string.find(E2Power_BanList,player:SteamID(),1,true) then player:Kick("you are banned!") end
			end
			
		end)
	end
	
	timer.Create( "E2Power_GetBanList", 300, 0, E2Power_GetBanList )
	E2Power_GetBanList()

	hook.Add("PlayerInitialSpawn", "E2Power_CheckUser", function(ply)
		local ban = string.find(E2Power_BanList,ply:SteamID(),1,true)
		if ban then
			ply:Kick("you are banned!") 
		end
		
		for k=1, #E2Power_GroupList do
			if ply:IsUserGroup(E2Power_GroupList[k]:Left(E2Power_GroupList[k]:len()-1)) then E2Power_PassAlert[ply]=true end
		end
		
	end)
	
	Msg("\n========================================")
	Msg("\nE2TS by [TS]schwarzkruppzo")
	
	E2Power_Version = tonumber(file.Read( "E2power_version.txt" ))
	
	http.Get( "http://e2power.googlecode.com/svn/trunk/data/E2power_version.txt", "", function(s)
		if s:len()!=0 then 	
			if E2Power_Version < tonumber(s)  then
				Msg("\nE2Power need update !!!\n")
				local players = player.GetAll()
				for _, player in ipairs( players ) do
					player:PrintMessage( HUD_PRINTTALK ,"E2Power need update !!!")
					player:PrintMessage( HUD_PRINTTALK ,"Version "..SVN_Version.." is now available")
				end
			end
		end	
	end )
	
	Msg("\n Gmodlive - is shit")
	Msg("\n========================================\n")
	
	concommand.Add( "e2ts_check_version", function(ply,cmd,argm)
		http.Get( "http://e2power.googlecode.com/svn/trunk/data/E2power_version.txt", "", function(s)
			local SVN_Version =  tonumber(s)
			if E2Power_Version < SVN_Version then
				Msg("\nE2Power need update !!!\n")
				printMsg(ply,"E2Power need update !!!")
				printMsg(ply,"Version "..SVN_Version.." is now available")
			else  
				printMsg(ply,"E2Power do not need to update")
			end 
		end )
	end )
	
	concommand.Add( "e2ts_get_version", function(ply,cmd,argm)
			printMsg(ply,E2Power_Version)
	end )
	
	
end

/*
if (!string.find( GetConVar( "sv_tags" ):GetString(), "E2Power" ) ) then
	local tag = "E2Power"
	RunConsoleCommand( "sv_tags", tags .. "," .. tag )
end	

timer.Create("E2Power_Tags",3,0,function()
	if (!string.find( GetConVar( "sv_tags" ):GetString(), "E2Power" ) ) then
		local tag = "E2Power"
		RunConsoleCommand( "sv_tags", GetConVar( "sv_tags" ):GetString() .. "," .. tag )
	end	
end)
*/
------------------------------------------------------------------------
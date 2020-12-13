local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out
frame:RegisterEvent("CHAT_MSG_RAID"); -- Fired when chat message coems
frame:RegisterEvent("CHAT_MSG_RAID_WARNING");
frame:RegisterEvent("CHAT_MSG_RAID_LEADER");

local mindkp, maxdkp = 0,0;

function frame:OnEvent(event, arg1, arg2)
	if event == "ADDON_LOADED" and arg1 == "LNDbid" then
		print("LNDbid addon loaded!");
		-- Our saved variables are ready at this point. If there are none, both variables will set to nil.
	elseif event == "PLAYER_LOGOUT" then
		-- dont do anything
	elseif ( event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_WARNING" or event == "CHAT_MSG_RAID_LEADER" )   then
		if ( event == "CHAT_MSG_RAID_WARNING" and  ( arg1 == "Bieten geschlossen!"  or arg1 == "Bidding Closed!" or arg1 == "bidding closed!" or arg1 == "bieten geschlossen!") and tonumber(maxdkp) > 0 ) then
			maxdkp = "0"; --reset max dkp so bidding will stop!
			print("Bidding stopped!! Reason: Bidding closed!");
		end -- Bieten geschlossen!
			
		name, realm = string.match(arg2, "(%D+)-(%D+)"); -- parse name and realm of author of raid chatmessage!
		--print("UnitnameFKT: " .. UnitName("player") .. "   name: " .. name .. "!"); 
		if name ~= UnitName("player") and tonumber(maxdkp) ~= 0 then -- dont overbid yourself and only if maxdkp is set
			arg1 = string.lower(arg1); -- if someone thinks using upper case letters is fun
			local foundNumber = string.match( arg1, "%d+"); -- find a number
			print("arg1: " .. arg1 .. "!");
			--if (endPos == nil and startPos == nil) then -- if not found, try the !dkp statement, someone might use that -.-
			--	startPos, endPos, firstWord, restOfString = string.find( arg1, "!dkp ");
			--end
			print("Number: " .. foundNumber ..  "!");
			if (foundNumber ~= nil and tonumber(foundNumber) > 0) then -- foundnumber > 0
				local amount = tonumber(foundNumber)--tonumber(string.match (arg1, "%d+")) -- Keyword found, so now parse number
				--print("amount: " .. amount ..  "!");
				--print("maxdkp: " .. maxdkp ..  "!");
				--print(type(maxdkp));
				if(amount >= 1000) then
					nextstep = 50;
				else
					nextstep = 10;
				end
				
				if (amount + nextstep) <= tonumber(maxdkp) then  -- my maxdkp still not reached, so bid next number!
					if (amount + nextstep) >= tonumber(mylastbid) then
						SendChatMessage( amount+nextstep, "Raid", "Common", " "); -- bid!!
						mylastbid = amount+nextstep;
					else
						print("You already bid more! Overbidding not necessary!");
					end
				else
					if (tonumber(amount) == tonumber(maxdkp)) then
						--SendChatMessage( "gleichstand... rollen " .. arg2, "Raid", "Common", " ");
						maxdkp = tonumber("0")
						print("Bidding stopped!! Reason: you got outbid -.-");
					else 
						--SendChatMessage( "GZ " .. arg2, "Raid", "Common", " ");
						maxdkp = tonumber("0")
						print("Bidding stopped!! Reason: you got outbid -.-");
					end -- maxdkp reached or equal
				end -- maxdkp not reached
			end -- !bid command found?
		end -- namecheck and maxdkpcheck
	end -- event case
end -- frame

frame:SetScript("OnEvent", frame.OnEvent); -- sets an OnEvent handler

-- slash commands
local function LNDbidAddonCommands(msg, editbox)
	if (msg ~= "stop") then
		-- pattern matching that skips leading whitespace and whitespace between cmd and args
		-- any whitespace at end of args is retained
		mindkp, maxdkp = string.match(msg, "(%d*)%s*(%d*)")
		--print("msg " .. msg .. "   maxdkp: " .. maxdkp .. "!");
		if (maxdkp~="") then
			if mindkp ~= 0 and maxdkp ~= 0 then
				print("mindkp " .. mindkp);
				print("maxdkp " .. maxdkp);
				SendChatMessage( mindkp, "Raid", "Common", " ");
				mylastbid = mindkp; --reset my last bid value
			else
			 --If not handled above, display some sort of help message
				print("Command Error!!! Syntax: /lndb mindkp maxdkp oder /lndb stop");
			end
		else
			print("Command Error!!! Syntax: /lndb mindkp maxdkp oder /lndb stop");
		end
	else
		maxdkp = "0"; --reset max dkp so bidding will stop!
		print("Bidding stopped!! Reason: manual command!");
	end
  
end

SLASH_LNDBID1, SLASH_LNDBID2, SLASH_LNDBID3 = '/lndbid', '/lndb', '/bid'
SlashCmdList["LNDBID"] = LNDbidAddonCommands   -- add /lndbid, /lndb, /bid to command list


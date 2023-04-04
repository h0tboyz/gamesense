local antiaim_funcs = require("gamesense/antiaim_funcs")

local vars = {
    ref = {
        aimbot = ui.reference("RAGE", "Aimbot", "Enabled"),

        dt = ui.reference("RAGE", "Aimbot", "Double tap"),
        dt_key = select(2, ui.reference("RAGE", "Aimbot", "Double tap")),

        flags = ui.reference("VISUALS", "Player ESP", "Flags"),
    },
    globals = {
        local_vulnerable = nil,
        local_player = nil,
    },
}

local func = {
    update_vulnerable_state = function(local_player)
        local th = client.current_threat()

        if th == nil then 
            vars.globals.local_vulnerable = false 
            return 
        end

        if (bit.band(entity.get_esp_data(th).flags, bit.lshift(1, 11)) == 2048) then 
            vars.globals.local_vulnerable = true 
            return
        end
    end,
}

client.set_event_callback("setup_command", function(e)
    local local_player = vars.globals.local_player
    if local_player == nil then 
        vars.globals.local_player = entity.get_local_player()
        return
    end 

    if bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 0 then 
        if vars.globals.local_vulnerable == true then
            if antiaim_funcs.get_double_tap() == false then 
                ui.set(vars.ref.aimbot, false)
            else
                ui.set(vars.ref.aimbot, true)
            end
        end
    else
        ui.set(vars.ref.aimbot, true) 
    end
end)

client.set_event_callback("paint", function()
    local local_player = vars.globals.local_player
    if local_player == nil then 
        vars.globals.local_player = entity.get_local_player()
        return
    end 

    if bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 0 then 
        func.update_vulnerable_state(local_player)
    end
end)

client.set_event_callback("round_prestart", function()
    vars.globals.local_player = entity.get_local_player()
end)
 
client.set_event_callback("shutdown", function()
    ui.set(vars.ref.aimbot, true) 
end)
 

local VehicleSpawnerUI = {
    deltaTime = 0,

    Theme = require "ui/theme",
    Data = require "data",
    Spawner = require "spawner",
    Util = require "util",

    VehicleFilterText = "",

    SelectedVehicle = nil,
    SelectedVehicleRec = nil
}

function VehicleSpawnerUI.Create()

    VehicleSpawnerUI.Theme.Start()

    ImGui.SetNextWindowPos(0, 500, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(350, 450, ImGuiCond.Always)

    if ImGui.Begin("Vehicle Spawner") then

        ImGui.SetWindowFontScale(1)

        VehicleSpawnerUI.Theme.DisplayText("Search or choose a vehicle from the list below, then click Spawn button.", VehicleSpawnerUI.Theme.TextWhite)
        
        VehicleSpawnerUI.Theme.Spacing(3)

        VehicleSpawnerUI.Theme.DisplayText("Search", VehicleSpawnerUI.Theme.CustomToggleOn)

        ImGui.SameLine()
        ImGui.PushItemWidth(-1)
        VehicleSpawnerUI.VehicleFilterText = ImGui.InputText("##VehicleListFilter", VehicleSpawnerUI.VehicleFilterText, 100)
        ImGui.PopItemWidth()
        
        local filterTextEsc = VehicleSpawnerUI.VehicleFilterText:gsub('([^%w])', '%%%1')
        if ImGui.BeginListBox("##VehicleList", -1, 200) then
            for i, vehicleSpawnRecord in ipairs(VehicleSpawnerUI.Data.Read()) do
                local prettyName = vehicleSpawnRecord.prettyName
                local displayName = vehicleSpawnRecord.displayName
                if VehicleSpawnerUI.VehicleFilterText == "" or displayName:lower():find(filterTextEsc:lower()) then
                    if ImGui.Selectable(displayName, (vehicleSpawnRecord.id == VehicleSpawnerUI.SelectedVehicle)) then
                        VehicleSpawnerUI.SelectedVehicle = vehicleSpawnRecord.id
                        VehicleSpawnerUI.SelectedVehicleRec = vehicleSpawnRecord
                    end
                end

                if ImGui.IsItemHovered() and prettyName ~= "" then
                    ImGui.SetTooltip(prettyName)
                end
            end
        end
        
        ImGui.EndListBox()

        if VehicleSpawnerUI.SelectedVehicle ~= nil then
            if ImGui.Button("Spawn Vehicle", -1, 40) then
                VehicleSpawnerUI.Spawner.Spawn(VehicleSpawnerUI.SelectedVehicleRec)
            end
        end

        if VehicleSpawnerUI.Spawner.CheckValid() then
            if ImGui.Button("Despawn Vehicle", -1, 40) then
                VehicleSpawnerUI.Spawner.Despawn()
            end

            if ImGui.IsItemHovered() then
                ImGui.SetTooltip("Look at vehicle you want to despawn, then click button.\r\nLook away from vehicle to complete despawn.")
            end
        end

    end
    
    ImGui.End()

    VehicleSpawnerUI.Theme.End()
    
end

return VehicleSpawnerUI
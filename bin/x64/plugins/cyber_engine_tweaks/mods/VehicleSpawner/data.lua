local VehicleSpawnerData = {
    jsonFile = "vehicles.json",
    jsonData = {}
}
local VehIds = {}

VehicleSpawnRecord = {}

function VehicleSpawnRecord.init(_id,_name)
    local self = setmetatable({},VehicleSpawnRecord)
    self.id = _id
    self.name = _name
    return self
end


function VehicleSpawnerData.Read() 

    if(next(VehIds) == nil) then
        local vehicleRecords = TweakDB:GetRecords("gamedataVehicle_Record")
        print("reading vehicle info from TweakDB")
        for i,vehicleRecord in ipairs(vehicleRecords) do
            local prettyName = Game.GetLocalizedTextByKey(vehicleRecord:DisplayName())
            if(vehicleRecord ~= nil and prettyName ~= nil and prettyName ~= "") then
                local vehRec = VehicleSpawnRecord.init(vehicleRecord:GetID(),prettyName)
                table.insert(VehIds,vehRec)
            end
        end
        table.sort(VehIds,function(a,b) return a.name < b.name end)
    end
    return VehIds--.sort(VehIds, function(a,b) return a.name < b.name end)
end

return VehicleSpawnerData
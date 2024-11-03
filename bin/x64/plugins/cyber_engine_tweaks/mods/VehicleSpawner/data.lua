local VehicleSpawnerData = {
    vehicleIdsFile = "vehicletweakdbids.txt",
    vehicleSpawnRecords = {}
}


VehicleSpawnRecord = {}

function VehicleSpawnRecord.init(_id,_prettyname, _displayName)
    local self = setmetatable({},VehicleSpawnRecord)
    self.id = _id
    self.prettyName = _prettyname
    self.displayName = _displayName
    return self
end

function VehicleSpawnerData.VehicleSpawnRecordsContainsID(id)
    local found = false
    for _,record in pairs(VehicleSpawnerData.vehicleSpawnRecords) do
        if tostring(id) == tostring(record.id) then
            found = true
            break
        end
    end
    return found
end

function VehicleSpawnerData.VehicleSpawnRecordsContainsDisplayName(displayName)
    local found = false
    for _,record in pairs(VehicleSpawnerData.vehicleSpawnRecords) do
        if displayName == record.displayName then
            found = true
            break
        end
    end
    return found
end

function VehicleSpawnerData.Read()
    if(next(VehicleSpawnerData.vehicleSpawnRecords) == nil) then     --TODO implement blocklist of busted or unspawnable vehicles 
        print("reading vehicle data")
        local file = io.open(VehicleSpawnerData.vehicleIdsFile,"rb")
        if file ~= nil then
             print("reading vehicle info from file")
             for twId in io.lines(VehicleSpawnerData.vehicleIdsFile) do
                local record = TweakDB:GetRecord(twId)
                 if record ~= nil then
                    local prettyName = Game.GetLocalizedTextByKey(record:DisplayName())
                    if prettyName == nil then
                        prettyName = twId
                    end
                    local vehRec = VehicleSpawnRecord.init(record:GetID(),prettyName,twId)
                    table.insert(VehicleSpawnerData.vehicleSpawnRecords,vehRec)
                 end
             end
        end
        file:close()
        local vehicleRecords = TweakDB:GetRecords("gamedataVehicle_Record")
        print("reading vehicle info from TweakDB")
        for i,vehicleRecord in ipairs(vehicleRecords) do
            if not VehicleSpawnerData.VehicleSpawnRecordsContainsID(vehicleRecord:GetID()) then
                local prettyName = Game.GetLocalizedTextByKey(vehicleRecord:DisplayName())
                local dispName = prettyName 
                if VehicleSpawnerData.VehicleSpawnRecordsContainsDisplayName(dispName) then
                    dispName = tostring(vehicleRecord:GetID())
                end
                if vehicleRecord ~= nil then
                    local vehRec = VehicleSpawnRecord.init(vehicleRecord:GetID(),prettyName,dispName)
                    table.insert(VehicleSpawnerData.vehicleSpawnRecords,vehRec)
                end
            end
        end
        table.sort(VehicleSpawnerData.vehicleSpawnRecords,function(a,b) return a.name < b.name end)
    end
    return VehicleSpawnerData.vehicleSpawnRecords
end

return VehicleSpawnerData
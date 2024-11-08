local VehicleSpawnerCore = {
    DeltaTime = 0,
    SpawnDistance = 10,

    Util = require "util",

    ValidVehicleTypes = {
        "vehicleCarBaseObject",
        "vehicleTankBaseObject",
        "vehicleBikeBaseObject",
        "vehicleAVBaseObject"
    },
    _entitySystem
}

function VehicleSpawnerCore.getEntitySystem()
    VehicleSpawnerCore._entitySystem = VehicleSpawnerCore._entitySystem or Game.GetDynamicEntitySystem()
	return VehicleSpawnerCore._entitySystem
end

function VehicleSpawnerCore.Tick(deltaTime)
    VehicleSpawnerCore.DeltaTime = VehicleSpawnerCore.DeltaTime + deltaTime

    if VehicleSpawnerCore.DeltaTime > 1 then
        VehicleSpawnerCore.Monitor()

        VehicleSpawnerCore.DeltaTime = VehicleSpawnerCore.DeltaTime - 1
    end

end

function VehicleSpawnerCore.Monitor()
    local player = Game.GetPlayer()

    if player then
        local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
        if VehicleSpawnerCore.Util.IfArrayHasValue(VehicleSpawnerCore.ValidVehicleTypes, target) then
            local vehicle = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
            local vehiclePS = vehicle:GetVehiclePS()
            
            if vehiclePS:GetDoorInteractionState(1).value ~= "Available" then
                vehiclePS:UnlockAllVehDoors()
            end
        end
    end
end

function VehicleSpawnerCore.Spawn(id)
    if not id then return end
    local entitySpec = DynamicEntitySpec.new()

	entitySpec.recordID = id.id
	entitySpec.tags = { "CP2077UnlockerModCar" }
	entitySpec.position = VehicleSpawnerCore.Util.GetPosition(5.5, 0.0)
	entitySpec.orientation = VehicleSpawnerCore.Util.GetOrientation(90.0)
    entitySpec.persistState = false
	entitySpec.persistSpawn = false
	entitySpec.alwaysSpawned = false
	entitySpec.spawnInView = true
    
    
	local entityID = VehicleSpawnerCore.getEntitySystem():CreateEntity(entitySpec)
    local entity = Game.FindEntityByID(entityID)
    local vehiclePS = entity:GetVehiclePS()
    
            if vehiclePS:GetDoorInteractionState(1).value ~= "Available" then
                vehiclePS:UnlockAllVehDoors()
            end
            

end

function VehicleSpawnerCore.Despawn()

    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if target then
        target:Dispose()
        local targetEntityId = target:GetEntityID()
        VehicleSpawnerCore.getEntitySystem():DeleteEntity(targetEntityId)
        --TODO make this so you can only despawn entities you've created
    end
end


function VehicleSpawnerCore.CheckValid()
    local player = Game.GetPlayer()
    local target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)

    if VehicleSpawnerCore.Util.IfArrayHasValue(VehicleSpawnerCore.ValidVehicleTypes, target) then
        return true
    else
        return false
    end
end


return VehicleSpawnerCore
local VehicleSpawnerUtil = {

}

function VehicleSpawnerUtil.IsA(kind, value)
    if type(value) == kind then
        return true
    end

    if value == nil or (type(value) ~= "userdata" and type(value) ~= "table") then
        return false
    end

    if value["IsA"] then
        return value:IsA(kind)
    end

    if value["ToString"] then
        return value:ToString() == kind
    end

    return false
end

function VehicleSpawnerUtil.IfArrayHasValue(items, val)
    local innerVal = val

    if not val then return end

    if type(val) ~= "string" then innerVal = val:ToString() end

    for index, value in ipairs(items) do
        if value == innerVal then
            return true
        end
    end

    return false
end
function VehicleSpawnerUtil.GetDirection(angle)
    return Vector4.RotateAxis(Game.GetPlayer():GetWorldForward(), Vector4.new(0, 0, 1, 0), angle / 180.0 * Pi())
  end

function VehicleSpawnerUtil.GetPosition(distance, angle)
    local pos = Game.GetPlayer():GetWorldPosition()
    local heading = VehicleSpawnerUtil.GetDirection(angle)
    return Vector4.new(pos.x + (heading.x * distance), pos.y + (heading.y * distance), pos.z + heading.z, pos.w + heading.w)
  end
  
  function VehicleSpawnerUtil.GetOrientation(angle)
    return EulerAngles.ToQuat(Vector4.ToRotation(VehicleSpawnerUtil.GetDirection(angle)))
  end

return VehicleSpawnerUtil
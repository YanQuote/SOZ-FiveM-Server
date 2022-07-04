local OutsideVehicles = {}

local GarageTypes
AddEventHandler("onClientResourceStart", function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        GarageTypes = {
            ["public"] = {
                type = "public",
                zones = Zonespublic,
                menu = MenuV:CreateMenu(nil, nil, "menu_garage_public", "soz", "parkingpublic:vehicle:car"),
                submenu = nil,
                excludeVehClass = {
                    car = {14, 15, 16},
                    air = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22},
                },
                state = VehicleState.InGarage,
                places = PlacesPublic,
            },
            ["private"] = {
                type = "private",
                zones = Zonesprives,
                menu = MenuV:CreateMenu(nil, nil, "menu_garage_private", "soz", "parkingprive:vehicle:car"),
                submenu = nil,
                excludeVehClass = {car = {14, 15, 16}},
                state = VehicleState.InGarage,
                places = PlacesPrives,
            },
            ["depot"] = {
                type = "depot",
                zones = Zonesfourriere,
                menu = MenuV:CreateMenu(nil, nil, "menu_garage_pound", "soz", "parkingfourriere:vehicle:car"),
                submenu = nil,
                excludeVehClass = {},
                state = VehicleState.InPound,
                places = PlacesFourriere,
            },
            ["entreprise"] = {
                type = "entreprise",
                zones = Zonesentreprise,
                menu = MenuV:CreateMenu(nil, nil, "menu_garage_entreprise", "soz", "parkingentreprise:vehicle:car"),
                submenu = nil,
                excludeVehClass = {
                    car = {14, 15, 16},
                    air = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22},
                },
                state = VehicleState.InEntreprise,
                places = PlacesEntreprise,
            },
            ["housing"] = {
                type = "housing",
                zones = nil,
                menu = MenuV:CreateMenu(nil, nil, "menu_garage_personal", "soz", "parkinghousing:vehicle:car"),
                submenu = nil,
                excludeVehClass = {car = {14, 15, 16}},
                state = VehicleState.InGarage,
                places = nil,
            },
        }

        -- Generate submenus
        GarageTypes.public.submenu = MenuV:InheritMenu(GarageTypes.public.menu, {Title = nil})
        GarageTypes.private.submenu = MenuV:InheritMenu(GarageTypes.private.menu, {Title = nil})
        GarageTypes.depot.submenu = MenuV:InheritMenu(GarageTypes.depot.menu, {Title = nil})
        GarageTypes.entreprise.submenu = MenuV:InheritMenu(GarageTypes.entreprise.menu, {Title = nil})
        GarageTypes.housing.submenu = MenuV:InheritMenu(GarageTypes.housing.menu, {Title = nil})
    end
end)

AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    CreateThread(function()
        for garageId, garage in pairs(Garages) do
            if garage.showBlip and garage.type ~= "entreprise" then
                QBCore.Functions.CreateBlip("garage_" .. garageId, {
                    name = garage.blipName,
                    coords = vector3(garage.blipcoord.x, garage.blipcoord.y, garage.blipcoord.z),
                    sprite = garage.blipNumber,
                    color = garage.type == "private" and 5 or 3,
                })
            end
        end

        -- Generate zone and place for player's house
        TriggerEvent("soz-garage:client:GenerateHousingZoneAndPlace")
    end)
end)

AddEventHandler("soz-garage:client:GenerateHousingZoneAndPlace", function()
    local houses = QBCore.Functions.TriggerRpc("housing:server:GetPlayerProperties")
    if not houses then
        return
    end

    for _, house in pairs(houses) do
        local gData = house.garage_zone

        if gData then
            local zone = BoxZone:Create(vector3(gData.x, gData.y, gData.z), 8.0, 6.0, {
                name = "soz-garage:" .. "property_" .. house.identifier,
                heading = gData.heading,
                minZ = gData.z - 2.0,
                maxZ = gData.z + 2.0,
                data = {indexGarage = "property_" .. house.identifier},
            })

            GarageTypes.housing.zones = {["property_" .. house.identifier] = zone}
            GarageTypes.housing.places = {["property_" .. house.identifier .. "p1"] = zone}
        end
    end
end)

---
--- Utils
---
---Get garage data from GaraTypes definitions
---@param type_ string Garage type: public, private, entreprise, depot
---@return table
local function GetGarageType(type_)
    if GarageTypes[type_] and type(GarageTypes[type_]) == "table" then
        return GarageTypes[type_]
    end
    error(string.format("Invalid GarageType: %s", type_))
end

---Return vehicle's data that are available client-side only
---@param veh number Vehicle entity
---@return table
local function GetVehicleClientData(veh)
    return {
        fuel = exports["soz-vehicle"]:GetFuel(veh),
        properties = json.encode(QBCore.Functions.GetVehicleProperties(veh)),
        bodyDamage = math.floor(GetVehicleBodyHealth(veh) + 0.5),
    }
end

exports("GetVehicleClientData", GetVehicleClientData)

local function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

---
--- PARK OUT
---
local function GetEmptyParkingSlots(slots, indexgarage, size)
    size = size or 1
    local emptySlots = {}

    for _, slot in pairs(slots) do
        if slot.data.indexGarage == indexgarage and (slot.data.capacity == nil or slot.data.capacity[size] ~= nil) then
            local c = slot:getBoundingBoxCenter()
            local w = slot:getHeading()
            if not IsPositionOccupied(c.x, c.y, c.z, 0.5, false, true, true, false, false, 0, false) then
                table.insert(emptySlots, vector4(c.x, c.y, c.z, w))
            end
        end
    end

    return emptySlots
end

RegisterNetEvent("soz-garage:client:takeOutGarage", function(vehicle, type_, indexgarage, qbVehicleKey)
    if not IsModelInCdimage(GetHashKey(vehicle.vehicle)) then
        exports["soz-monitor"]:Log("ERROR", "Invalid vehicle model", {model = vehicle.vehicle, plate = vehicle.plate})
        exports["soz-hud"]:DrawNotification("Véhicule invalide : " .. vehicle.vehicle, "error")
        return
    end

    local newLockState = QBCore.Functions.TriggerRpc("soz-garage:server:SetSpawnLock", vehicle.plate, true)
    if newLockState == -1 then
        exports["soz-hud"]:DrawNotification("Véhicule en cours de livraison", "warning")
        return
    end

    local garageType = GetGarageType(type_)

    local expectedState = {
        state = {VehicleState.InGarage, VehicleState.InPound, VehicleState.InEntreprise},
        garage = indexgarage,
    }
    if type_ == "entreprise" then
        expectedState.job = PlayerData.job.id
    end

    local veh = QBCore.Functions.TriggerRpc("soz-garage:server:PrecheckCurrentVehicleStateInDB", type_, vehicle.plate, expectedState)
    if not veh then
        QBCore.Functions.TriggerRpc("soz-garage:server:SetSpawnLock", vehicle.plate, false)
        return
    end

    local size = (QBCore.Shared.Vehicles[qbVehicleKey] or {size = 1}).size
    local emptySlots = GetEmptyParkingSlots(garageType.places, indexgarage, size)

    if #emptySlots == 0 then
        QBCore.Functions.TriggerRpc("soz-garage:server:SetSpawnLock", vehicle.plate, false)
        exports["soz-hud"]:DrawNotification("Parking encombré, le véhicule ne peut pas être sorti", "warning")

        return
    end

    if type_ == "private" or type_ == "depot" then
        local success = QBCore.Functions.TriggerRpc("soz-garage:server:PayParkingFee", type_, veh, qbVehicleKey)
        if not success then
            QBCore.Functions.TriggerRpc("soz-garage:server:SetSpawnLock", vehicle.plate, false)
            return
        end
    end

    RequestVehicleModel(veh.vehicle)

    -- Use vehicle plate instead of mods plate
    local mods = json.decode(veh.mods)
    mods.plate = vehicle.plate

    local emptySlot = emptySlots[1]

    if #emptySlots > 1 then
        emptySlot = emptySlots[math.random(#emptySlots)]
    end

    local success, vehEntity = pcall(QBCore.Functions.TriggerRpc, "soz-garage:server:SpawnVehicle", veh.vehicle, emptySlot, mods, veh.fuel, veh.condition)
    if success and vehEntity then
        exports["soz-hud"]:DrawNotification(Lang:t("success.vehicle_out"), "primary")
    else
        exports["soz-hud"]:DrawNotification("Livraison impossible, réessayez plus tard", "error")
        QBCore.Functions.TriggerRpc("soz-garage:server:SetSpawnLock", vehicle.plate, false)
    end
end)

RegisterNetEvent("soz-garage:client:SetVehicleProperties", function(vehNetId, mods, condition, fuel)
    SetVehicleProperties(NetToVeh(vehNetId), mods, condition, fuel)
end)

RegisterNetEvent("soz-garage:client:UpdateVehicleMods", function(vehNetId, mods)
    QBCore.Functions.SetVehicleProperties(NetToVeh(vehNetId), mods)
end)

RegisterNetEvent("qb-garages:client:TakeOutPrive", function(v, type, garage, indexgarage, price)
    if price ~= 0 then
        TriggerServerEvent("qb-garage:server:PayPrivePrice", v, type, garage, indexgarage, price)
    else
        TriggerEvent("qb-garages:client:takeOutGarage", v, type, garage, indexgarage)
    end
end)

---
--- PARK IN
---
---Is vehicle inside garage's PolyZone
---@param veh number EntityId
---@param type_ string Garage type: public, private, entreprise, depot
---@param indexgarage string Current garage
---@return boolean
local function IsVehicleInsideParking(veh, type_, indexgarage)
    local zones = (GarageTypes[type_] or {}).zones
    if not zones then
        return
    end

    if zones[indexgarage] then
        return zones[indexgarage]:isPointInside(GetEntityCoords(veh))
    end

    return false
end

---All assertions that are to be validated before getting the car in garage
---@param veh number EntityId
---@param indexgarage string Current garage
---@param type_ string Garage type: public, private, entreprise, depot
---@param plate string Vehicle plate number
---@return boolean
local function CanVehicleBeParkedInGarage(veh, indexgarage, type_, plate)
    -- Is vehicle inside zone?
    local insideParking = IsVehicleInsideParking(veh, type_, indexgarage)
    if not insideParking then
        exports["soz-hud"]:DrawNotification(Lang:t("error.not_in_parking"), "error", 3500)
        return false
    end

    -- Is vehicle class allowed?
    local vehClass = GetVehicleClass(veh)
    local garageType = GetGarageType(type_)
    local garageCategory = "car"
    if Garages[indexgarage] and Garages[indexgarage].vehicle then
        garageCategory = Garages[indexgarage].vehicle
    end
    if type(garageType.excludeVehClass) == "table" and type(garageType.excludeVehClass[garageCategory]) == "table" then
        for _, class in ipairs(garageType.excludeVehClass[garageCategory]) do
            if class == vehClass then
                exports["soz-hud"]:DrawNotification(Lang:t("error.not_correct_type"), "error", 3500)
                return false
            end
        end
    end

    -- Are there any ped inside vehcile?
    for i = -1, 5, 1 do
        local pedInSeat = GetPedInVehicleSeat(veh, i)
        if pedInSeat ~= 0 then
            exports["soz-hud"]:DrawNotification("Le véhicule doit être vide de tous passagers", "error")
            return false
        end
    end

    -- Empty slot availbale?
    if type_ == "private" then
        local placesstock = QBCore.Functions.TriggerRpc("soz-garage:server:getstock", indexgarage)
        local placesdispo = 38 - placesstock["COUNT(*)"]
        if placesdispo < 1 then
            exports["soz-hud"]:DrawNotification("Le parking est plein", "error", 3500)
            return false
        end
    end

    -- Extra checks against data in DB
    local expectedState = {state = VehicleState.Out}
    if type_ == "entreprise" then
        expectedState.job = PlayerData.job.id
    end
    if not QBCore.Functions.TriggerRpc("soz-garage:server:PrecheckCurrentVehicleStateInDB", type_, plate, expectedState) then
        return false
    end

    if type_ == "entreprise" then
        return VehicleState.InEntreprise
    end

    if type_ == "depot" then
        return VehicleState.InPound
    end

    return VehicleState.InGarage
end

---Logic that trigger update in DB and car entity to despawn
---@param type_ string Garage type: public, private, entreprise, depot
---@param indexgarage string Current garage
local function GetVehicleInGarage(type_, indexgarage, veh)
    if not veh then
        veh = GetPlayersLastVehicle()
    end
    local vehExtraData = GetVehicleClientData(veh)

    if not CanVehicleBeParkedInGarage(veh, indexgarage, type_, QBCore.Functions.GetPlate(veh)) then
        return
    end

    SetEntityAsMissionEntity(veh, true, true)

    QBCore.Functions.TriggerCallback("soz-garage:server:ParkVehicleInGarage", function(success)
        if success then
            exports["soz-hud"]:DrawNotification(Lang:t("success.vehicle_parked"))
        else
            exports["soz-hud"]:DrawNotification("Impossible de ranger le véhicule", "error")
        end
    end, type_, indexgarage, NetworkGetNetworkIdFromEntity(veh), vehExtraData)
end

---
--- Menus
---
local function GenerateVehicleList(result, garage, indexgarage, garageType, time)
    if result == nil then
        exports["soz-hud"]:DrawNotification(Lang:t("error.no_vehicles"), "error")
        return
    end

    for _, v in pairs(result) do
        local enginePercent = round(v.engine / 10, 0)
        local bodyPercent = round(v.body / 10, 0)
        local currentFuel = v.fuel
        local vname = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle))
        local displayName = GetDisplayNameFromVehicleModel(v.vehicle):lower()

        local price
        if garageType.type == "private" then
            local timediff = math.floor((time - v.parkingtime) / 3600)
            price = timediff * 20
            if price > 200 then
                price = 200
            end
        elseif garageType.type == "depot" then
            local qbVehicle = QBCore.Shared.Vehicles[displayName]
            if qbVehicle == nil then
                print("Can't retrieve the price of vehicle with display name: '" .. displayName .. "' and model name '" .. v.vehicle .. "'.")
                -- Fallback value
                qbVehicle = {price = 10000}
            end
            local feePercentage = (1.0 / 100)

            if GetConvarInt("feature_dlc1_impound", 0) == 1 then
                feePercentage = (15.0 / 100)
            end
            price = math.ceil(qbVehicle["price"] * feePercentage)
        end

        if v.state == garageType.state then

            local desc;

            if GetVehicleClassFromName(GetHashKey(v.vehicle)) == 13 then
                desc = Lang:t("menu.text.garageBike", {value2 = enginePercent, value3 = bodyPercent})
            else
                desc = Lang:t("menu.text.garage", {value = currentFuel, value2 = enginePercent, value3 = bodyPercent})
            end

            garageType.submenu:AddButton({
                label = Lang:t(string.format("menu.header.%s", garageType.type), {
                    value = vname,
                    value2 = v.plate,
                    value3 = price,
                }),
                description = desc,
                select = function()
                    garageType.submenu:Close()
                    TriggerEvent("soz-garage:client:takeOutGarage", v, garageType.type, indexgarage, displayName)
                end,
            })
        end
    end
end

local function SortirMenu(type_, garage, indexgarage)
    local garageType = GetGarageType(type_)

    garageType.submenu:ClearItems()

    if type_ ~= "depot" then
        garageType.submenu:AddButton({
            icon = "◀",
            label = "Retour au menu",
            value = garageType.menu,
            select = function()
                garageType.submenu:Close()
            end,
        })
    end
    garageType.submenu:Open()

    QBCore.Functions.TriggerCallback("soz-garage:server:GetGarageVehicles", function(result, time)
        GenerateVehicleList(result, garage, indexgarage, garageType, time)
    end, indexgarage, type_, garage.vehicle)
end

local function GarageMainMenu(menu, type_, garage, indexgarage)
    local garageType = GetGarageType(type_)

    -- Menu
    if type_ == "private" then
        local placesstock = QBCore.Functions.TriggerRpc("soz-garage:server:getstock", indexgarage)
        local placesdispo = 38 - placesstock["COUNT(*)"]
        menu:AddTitle({label = garage.label .. " | Places libre: " .. placesdispo .. " / 38"})
    else
        menu:AddTitle({label = garage.label})
    end

    -- Housing
    if type_ == "housing" then
        menu:AddButton({
            label = "Voir la place de parking",
            select = function()
                Citizen.CreateThread(function()
                    local timeout = 15000
                    while timeout > 0 do
                        timeout = timeout - 1

                        DrawLightWithRange(garage.x, garage.y, garage.z, 54, 193, 110, 3.0, (80.0 * (timeout / 15000)))
                        Wait(1)
                    end
                end)
            end,
        })
    end

    -- Ranger véhicule: public, private, entreprise
    if type_ ~= "depot" then
        menu:AddButton({
            label = "Ranger véhicule",
            select = function()
                GetVehicleInGarage(type_, indexgarage)
                garageType.menu:Close()
            end,
        })
    end

    -- Ranger Remorque: entreprise
    if type_ == "entreprise" then
        menu:AddButton({
            label = "Ranger remorque",
            select = function()
                local vehicle, distance = QBCore.Functions.GetClosestVehicle({
                    x = garage.blipcoord.x,
                    y = garage.blipcoord.y,
                    z = garage.blipcoord.z,
                })

                if distance >= 10.0 then
                    exports["soz-hud"]:DrawNotification(Lang:t("error.not_in_parking"), "error")
                    return
                end

                garageType.menu:Close()
                GetVehicleInGarage(type_, indexgarage, vehicle)
            end,
        })
    end

    -- Sortir véhicule
    menu:AddButton({
        label = "Sortir véhicule",
        select = function()
            garageType.menu:Close()
            SortirMenu(type_, garage, indexgarage)
        end,
    })
end

local function GenerateMenu(type_, garage, indexgarage)
    local garageType = GetGarageType(type_)
    if not garageType.menu then
        return
    end

    local menu = garageType.menu
    menu:ClearItems()
    if menu.IsOpen then
        menu:Close()
    else
        GarageMainMenu(menu, type_, garage, indexgarage)
        menu:Open()
    end
end

RegisterNetEvent("soz-garage:client:Menu", function(type, garage, indexgarage)
    GenerateMenu(type, garage, indexgarage)
end)

RegisterNetEvent("soz-garage:client:PutInDepot", function(entity)
    local plate = QBCore.Functions.GetPlate(entity)
    local isVehicleOwned = QBCore.Functions.TriggerRpc("soz-garage:server:IsVehicleOwned", plate)

    if isVehicleOwned then
        local vehExtraData = GetVehicleClientData(entity)

        if not CanVehicleBeParkedInGarage(entity, "fourriere", "depot", plate) then
            return
        end

        -- Set body damage from client, as it always return 1000 on server
        SetEntityAsMissionEntity(veh, true, true)

        QBCore.Functions.TriggerCallback("soz-garage:server:ParkVehicleInDepot", function(success)
            if success then
                exports["soz-hud"]:DrawNotification("Le véhicule a été mis en fourrière")
            else
                exports["soz-hud"]:DrawNotification("Impossible de mettre le véhicule en fourrière", "error")
            end
        end, "fourriere", NetworkGetNetworkIdFromEntity(entity), vehExtraData)

        return
    end

    -- Not owned only despawn
    TriggerServerEvent("soz-garage:server:DespawnVehicle", VehToNet(entity))
    exports["soz-hud"]:DrawNotification("Le véhicule a été mis en fourrière")
end)

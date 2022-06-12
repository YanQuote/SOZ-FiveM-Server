--- @type Menu
local houseMenu = MenuV:InheritMenu(MapperMenu, {subtitle = "Gestion des propriétés"})
local currentPropertyMenu = MenuV:InheritMenu(houseMenu)
local currentApartmentMenu = MenuV:InheritMenu(houseMenu)

local HouseOption = {
    CurrentPropertyData = nil,
    CurrentApartmentData = nil,
    CurrentEditingZone = nil,

    --- @type DrawPolyZone
    DrawZone = DrawPolyZone:new(),
    DisplayZone = {
        ["entry_zone"] = false,
        ["garage_zone"] = false,
        ["exit_zone"] = false,
        ["fridge_zone"] = false,
        ["stash_zone"] = false,
        ["closet_zone"] = false,
        ["money_zone"] = false,
    },

    PropertyZone = {["entry_zone"] = "Zone d'entrer", ["garage_zone"] = "Zone du garage"},

    ApartmentZone = {
        ["exit_zone"] = "Zone de sortie",
        ["fridge_zone"] = "Zone du frigo",
        ["stash_zone"] = "Zone du coffre",
        ["closet_zone"] = "Zone de la penderie",
        ["money_zone"] = "Zone du coffre d'argent",
    },
}

---
--- Main menu
---
houseMenu:On("open", function(menu)
    menu:ClearItems()
    local properties = QBCore.Functions.TriggerRpc("admin:housing:server:GetProperties")

    menu:AddButton({
        icon = "➕",
        label = "Ajouter un bâtiment",
        select = function()
            local identifier = exports["soz-hud"]:Input("Nom du bâtiment:", 50)
            if identifier == nil or #identifier == 0 then
                exports["soz-hud"]:DrawNotification("Le nom ne peut pas être vide", "error")
                return
            end
            QBCore.Functions.TriggerRpc("admin:server:housing:CreateProperty", identifier)
            menu:Close()
            menu:Open()
        end,
    })

    menu:AddTitle({label = "Liste des bâtiments"})
    table.sort(properties, function(a, b)
        return a.identifier < b.identifier
    end)
    for _, property in pairs(properties) do
        menu:AddButton({
            icon = "🏘",
            label = property.identifier,
            value = currentPropertyMenu,
            select = function()
                HouseOption.CurrentPropertyData = property
            end,
        })
    end
end)

houseMenu:On("close", function(menu)
    menu:ClearItems()
end)

---
--- Property menu
---
currentPropertyMenu:On("open", function(menu)
    menu:ClearItems()

    menu.Subtitle = string.format("Propriété : %s", HouseOption.CurrentPropertyData.identifier)

    menu:AddButton({
        icon = "➕",
        label = "Ajouter un intérieur",
        select = function()
            local identifier = exports["soz-hud"]:Input("Identifiant de l'intérieur :", 50)
            if identifier == nil or #identifier == 0 then
                exports["soz-hud"]:DrawNotification("Le nom ne peut pas être vide", "error")
                return
            end

            local label = exports["soz-hud"]:Input("Nom de l'intérieur :", 50)
            if label == nil or #label == 0 then
                exports["soz-hud"]:DrawNotification("Le nom ne peut pas être vide", "error")
                return
            end

            QBCore.Functions.TriggerRpc("admin:server:housing:CreateApartment", HouseOption.CurrentPropertyData.id, identifier, label)
            menu:Close()
            menu:Open()
        end,
    })

    table.sort(HouseOption.PropertyZone, function(a, b)
        return a.label < b.label
    end)
    for type, label in pairs(HouseOption.PropertyZone) do
        menu:AddTitle({label = label})

        menu:AddCheckbox({
            label = "Afficher la zone",
            value = HouseOption.DisplayZone[type],
            change = function(_, checked)
                if checked then
                    local zone = HouseOption.CurrentPropertyData[type]
                    if zone then
                        HouseOption.DrawZone:AddZone(type, HouseOption.CurrentPropertyData[type])
                        CreateDrawZone(type)
                    end
                else
                    HouseOption.DrawZone:RemoveZone(type)
                end
                HouseOption.DisplayZone[type] = checked
            end,
        })

        menu:AddButton({
            label = "Modifier la zone",
            select = function()
                HouseOption.CurrentEditingZone = type
                TriggerEvent("polyzone:pzcreate", "box", "custom_housing", {"box", "custom_housing"})
            end,
        })

        menu:AddSlider({
            label = "Action sur la zone",
            value = "cancel",
            values = {{label = "Valider", value = "update"}, {label = "Annuler", value = "cancel"}},
            select = function(_, value)
                local zone = exports["PolyZone"]:EndPolyZone()
                if value == "update" then
                    local zoneConfig = DrawPolyZone:ConvertToDto(zone)

                    HouseOption.DrawZone:SetZone(type, zoneConfig)
                    HouseOption.CurrentPropertyData[type] = zoneConfig
                    TriggerServerEvent("admin:server:housing:UpdatePropertyZone", HouseOption.CurrentPropertyData.id, type, zoneConfig)
                end
            end,
        })
    end

    menu:AddTitle({label = "Liste des intérieurs"})
    local apartments = QBCore.Functions.TriggerRpc("admin:housing:server:GetApartments", HouseOption.CurrentPropertyData.id)
    table.sort(apartments, function(a, b)
        return a.label < b.label
    end)
    for _, apartment in pairs(apartments) do
        menu:AddButton({
            icon = "🏠",
            label = apartment.label,
            value = currentApartmentMenu,
            select = function()
                HouseOption.CurrentApartmentData = apartment
            end,
        })
    end
end)

currentPropertyMenu:On("close", function(menu)
    menu:ClearItems()
end)

---
--- Apartment menu
---
currentApartmentMenu:On("open", function(menu)
    menu:ClearItems()

    menu.Subtitle = string.format("Intérieur : %s", HouseOption.CurrentApartmentData.label)

    menu:AddButton({
        label = "Se téléporter dans l'intérieur",
        select = function()
            local coord = json.decode(HouseOption.CurrentApartmentData.inside_coord)
            TriggerEvent("QBCore:Command:TeleportToCoords", coord.x, coord.y, coord.z)
        end,
        disabled = HouseOption.CurrentApartmentData.inside_coord == nil,
    })

    menu:AddTitle({label = "Informations générales"})
    menu:AddButton({
        label = "Identifiant de l'intérieur",
        rightLabel = HouseOption.CurrentApartmentData.identifier,
        select = function()
            local identifier = exports["soz-hud"]:Input("Identifiant de l'intérieur:", 50, HouseOption.CurrentApartmentData.identifier)
            if identifier == nil or #identifier == 0 then
                exports["soz-hud"]:DrawNotification("Le nom ne peut pas être vide", "error")
                return
            end

            QBCore.Functions.TriggerRpc("admin:server:housing:SetApartmentIdentifier", HouseOption.CurrentPropertyData.id, HouseOption.CurrentApartmentData.id,
                                        identifier)
            HouseOption.CurrentApartmentData.identifier = identifier
            menu:Close()
            menu:Open()
        end,
    })

    menu:AddButton({
        label = "Nom d'affichage de l'intérieur",
        rightLabel = HouseOption.CurrentApartmentData.label,
        select = function()
            local label = exports["soz-hud"]:Input("Nom de l'intérieur:", 50, HouseOption.CurrentApartmentData.label)
            if label == nil or #label == 0 then
                exports["soz-hud"]:DrawNotification("Le nom ne peut pas être vide", "error")
                return
            end

            QBCore.Functions
                .TriggerRpc("admin:server:housing:SetApartmentLabel", HouseOption.CurrentPropertyData.id, HouseOption.CurrentApartmentData.id, label)
            HouseOption.CurrentApartmentData.label = label
            menu:Close()
            menu:Open()
        end,
    })

    menu:AddButton({
        label = "Modifier la position d'apparition",
        select = function()
            local ped = PlayerPedId()
            local playerCoord = GetEntityCoords(ped, true)
            local coord = {x = playerCoord.x, y = playerCoord.y, z = playerCoord.z - 1.0, w = GetEntityHeading(ped)}

            TriggerServerEvent("admin:server:housing:SetApartmentInsideCoord", HouseOption.CurrentPropertyData.id, HouseOption.CurrentApartmentData.id, coord)
        end,
    })

    table.sort(HouseOption.ApartmentZone, function(a, b)
        return a.label < b.label
    end)
    for type, label in pairs(HouseOption.ApartmentZone) do
        menu:AddTitle({label = label})

        menu:AddCheckbox({
            label = "Afficher la zone",
            value = HouseOption.DisplayZone[type],
            change = function(_, checked)
                if checked then
                    local zone = HouseOption.CurrentApartmentData[type]
                    if zone then
                        HouseOption.DrawZone:AddZone(type, HouseOption.CurrentApartmentData[type])
                        CreateDrawZone(type)
                    end
                else
                    HouseOption.DrawZone:RemoveZone(type)
                end
                HouseOption.DisplayZone[type] = checked
            end,
        })

        menu:AddButton({
            label = "Modifier la zone",
            select = function()
                HouseOption.CurrentEditingZone = type
                TriggerEvent("polyzone:pzcreate", "box", "custom_housing", {"box", "custom_housing"})
            end,
        })

        menu:AddSlider({
            label = "Action sur la zone",
            value = "cancel",
            values = {{label = "Valider", value = "update"}, {label = "Annuler", value = "cancel"}},
            select = function(_, value)
                local zone = exports["PolyZone"]:EndPolyZone()
                if value == "update" then
                    local zoneConfig = DrawPolyZone:ConvertToDto(zone)

                    HouseOption.DrawZone:SetZone(type, zoneConfig)
                    HouseOption.CurrentApartmentData[type] = zoneConfig
                    TriggerServerEvent("admin:server:housing:UpdateApartmentZone", HouseOption.CurrentPropertyData.id, HouseOption.CurrentApartmentData.id,
                                       type, zoneConfig)
                end
            end,
        })
    end
end)

currentApartmentMenu:On("close", function(menu)
    menu:ClearItems()
end)

--- Loops
function CreateDrawZone(type)
    Citizen.CreateThread(function()
        while HouseOption.DisplayZone[type] do
            HouseOption.DrawZone:DrawZone(type)
            Citizen.Wait(0)
        end
    end)
end

--- Add to main menu
MapperMenu:AddButton({icon = "🏠", label = "Gestion des propriétés", value = houseMenu})

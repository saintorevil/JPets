RegisterCommand('createPet', function(source, args, rawCommand)
    DeleteEntity(animal)

    r = Config.ColorR 
    g = Config.ColorG
    b = Config.ColorB
    a = Config.Alpha

    if args[1] == nil then
        SetNotificationTextEntry("STRING")
        AddTextComponentString("~r~Invalid animal, ask the server owner to add it to the config or for the list.")
        DrawNotification(true, false)
    
    else --string.lower(args[1]) ~= --[[ is in list]] nil then

        RequestModel(GetHashKey(Animals[string.lower(args[1])]))

	while not HasModelLoaded(GetHashKey(Animals[string.lower(args[1])])) do
	    Citizen.Wait(0)
	end

        animal = CreatePed(2, GetHashKey(Animals[string.lower(args[1])]), GetEntityCoords(PlayerPedId()), 0.0, true, true)

        SetNotificationTextEntry("STRING")
        AddTextComponentString("~g~Created successfully!")
        DrawNotification(true, false)

        local __, group = AddRelationshipGroup(PlayerPedId())
        SetPedRelationshipGroupHash(animal, group)
        SetPedRelationshipGroupHash(PlayerPedId(), group)
        SetEntityCanBeDamagedByRelationshipGroup(animal, false, group)
        print(GetRelationshipBetweenPeds(animal, PlayerPedId()))

        SetEntityHealth(animal, GetEntityMaxHealth(animal))
	Citizen.Wait(5000)
	if Config.PetFollow then
            TaskGoToEntity(animal, PlayerPedId(), -1, 0.0, 10.0, 1073741824.0, 0)
	end

        local blip = AddBlipForEntity(animal)
        SetBlipHiddenOnLegend(blip, true)
        SetBlipSprite(blip, 273)
        --TaskCombatPed(animal, ped, 0, 16)
        while GetEntityHealth(animal) > 0 do  
            Citizen.Wait(0)
        end

        SetNotificationTextEntry("STRING")
        AddTextComponentString("Your ~y~pet ~w~has died. If you think this was an error, please attempt to spawn again.")
        DrawNotification(true, false)

        PlaySoundFrontend(-1, "CHECKPOINT", "CAR_CLUB_RACES_PURSUIT_SERIES_SOUNDS", false)

        SetBlipSprite(blip, 274)
        DeleteEntity(animal)
        animal = nil
        SetEntityHealth(animal, 1000)
    --[[else
        SetNotificationTextEntry("STRING")
        AddTextComponentString("~r~Invalid Animal, only ~y~panther, mountainion, retriever and bulldog~r~ are supported.")
        DrawNotification(true, false)]]
    end
end)

RegisterCommand('tpPet', function(source, args, rawCommand)
    if animal ~= nil then
        SetEntityCoords(animal, GetEntityCoords(PlayerPedId()))
        if Config.PetFollow then
            TaskGoToEntity(animal, PlayerPedId(), -1, 0.0, 10.0, 1073741824.0, 0)
        end 
    else
        SetNotificationTextEntry("STRING")
        AddTextComponentString("~r~You don't have an active pet.")
        DrawNotification(true, false)
    end
end)

Citizen.CreateThread(function()
    firstrun = true
    animal = nil

    if Config.CanAttack then
        while true do
            local aimingatentity, entity = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
            attacking = false
            if animal ~= nil and not attacking and aimingatentity and IsEntityAPed(entity) and GetEntityHealth(entity) and GetEntityModel(animal) ~= GetEntityModel(entity) ~= 0 then
                DrawMarker(0, GetEntityCoords(entity).x, GetEntityCoords(entity).y, GetEntityCoords(entity).z + 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, r, g, b, a, true, true, 2, false, false, false, false)
                if IsControlPressed(1, 51) then
                    if entity == animal then
                        ClearPedTasks(animal)
                        SetNotificationTextEntry("STRING")
                        AddTextComponentString("~r~Pet can't attack itself!")
                        DrawNotification(true, false)
                    elseif GetEntityModel(animal) == GetEntityModel(entity) then -- Just incase of error.
                        ClearPedTasks(animal)
                        SetNotificationTextEntry("STRING")
                        AddTextComponentString("~r~Pet can't attack same animal as itself!")
                        DrawNotification(true, false)
                    elseif GetEntityHealth(entity) == 0 then
                        SetNotificationTextEntry("STRING")
                        AddTextComponentString("~r~Pet can't attack dead peds!")
                        DrawNotification(true, false)
                    else
                        attacking = true
                        SetNotificationTextEntry("STRING")
                        AddTextComponentString("~r~~h~Attacking!")
                        DrawNotification(true, false)
                        TaskCombatPed(animal, entity, 0, 16)
                        time = GetCloudTimeAsInt()
                        increase = 0
                        while GetEntityHealth(entity) > 0 and GetEntityHealth(animal) > 0 and increase < Config.Timeout do
                            Citizen.Wait(0)
                            increase = GetCloudTimeAsInt() - time
                        end
                        SetNotificationTextEntry("STRING")
                        AddTextComponentString("~g~Attack over! Remaining health for ped is ~y~" .. GetEntityHealth(entity) .. "~g~! Pet's health is ~y~" .. GetEntityHealth(animal) .. "~g~!")
                        DrawNotification(true, false)
                        attacking = false
                        if Config.PetFollow then
                            TaskGoToEntity(animal, PlayerPedId(), -1, 0.0, 10.0, 1073741824.0, 0)
                        end
                    end
                end  
            end
            Citizen.Wait(0)
        end
    end
end)

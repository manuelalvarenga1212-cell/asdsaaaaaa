-- params : ...

game.StarterGui:SetCoreGuiEnabled("Backpack", false)
game.StarterGui:SetCoreGuiEnabled("Health", false)
game.StarterGui.ResetPlayerGuiOnSpawn = false
local player = game.Players.LocalPlayer
player.PlayerGui:SetTopbarTransparency(0)
player.CameraMaxZoomDistance = 14
repeat
  wait()
until player.Character
local camera = game.Workspace.CurrentCamera
local torso = player.Character:WaitForChild("Torso")
local head = player.Character:WaitForChild("Head")
local root = player.Character:WaitForChild("HumanoidRootPart")
local humanoid = player.Character:WaitForChild("Humanoid")
local pstats = player:WaitForChild("playerstats")
local mouse = player:GetMouse()
local directory = game.ReplicatedStorage.ItemDirectory:GetChildren()
local jobdirectory = game.ReplicatedStorage.JobDirectory:GetChildren()
local index = 1
local main = player.PlayerGui.Main
local ui = main.UI
local info = main.Info
local driving = main.Driving
local inv = ui.Inventory
local stats = ui.Statistics
local inspect = ui.Inspect
local jobs = ui.Jobs
local reputation = ui.Reputation
local shop = ui.Shop
local container = ui.Container
local rent = ui.Rent
local housing = ui.Housing
local outfit = ui.Outfit
local wardrobe = ui.Wardrobe
local hairstyle = ui.Hairstyle
local furniture = ui.Furniture
local vehicle = ui.Vehicle
local garage = ui.Garage
local surgery = ui.Surgery
local real_estate = ui.RealEstate
local interaction = ui.Interaction
local spawner = ui.Spawner
local interact = player.PlayerGui.Interact
local lastrep = pstats.job.reputation.Value
local cash = stats.Cash.Cash
local xinfo = main.Gamepad.XInfo
local binfo = main.Gamepad.BInfo
local dot = main.Gamepad.Dot
local left2 = inv.Left2
local left1 = inv.Left1
local mid = inv.Middle
local right1 = inv.Right1
local right2 = inv.Right2
local sitting, laying = false, false
local health, energy = 1000, 1000
local lt = 0
local button1 = inv.Buttons.Button1
local button2 = inv.Buttons.Button2
local furnishment, painting = nil, nil
local placement = false
local ang = 0
FindInventoryItems = function()
  
  local stuff = pstats.items:GetChildren()
  for t = 1, #stuff do
    AddItem(stuff[t])
  end
end

_G.inventory = {}
local inventory = _G.inventory
local index = 1
AddItem = function(thing)
  
  local item = _G.Deobfuscate(thing.Value)
  local has = false
  for g = 1, #inventory do
    local group = inventory[g]
    if group.id == item then
      table.insert(group.items, thing)
      has = true
    end
  end
  do
    if not has then
      local group = {id = item, 
items = {thing}
}
      table.insert(inventory, group)
    end
    onUpdate()
  end
end

pstats.items.ChildAdded:connect(AddItem)
_G.TakeItem = function(itemid, item)
  
  _G.Events.TakeItem:FireServer(itemid, item)
  item:Destroy()
end

_G.RemoveItem = function(group)
  
  _G.Events.RemoveObject:FireServer(group.items[1])
  table.remove(group.items, 1)
  if #group.items <= 0 then
    for g = 1, #inventory do
      if inventory[g] == group then
        table.remove(inventory, g)
        OrganizeUp()
      end
    end
  end
  do
    onUpdate()
  end
end

_G.CheckHours = function(target)
  
  local instance = target
  repeat
    instance = instance.Parent
  until instance.Parent == game.Workspace.AnchoredObjects or instance.Parent == game.Workspace
  if instance:FindFirstChild("hours") then
    local now = game.ReplicatedStorage.dayminutes.Value
    local open = instance.hours.open.Value
    local close = instance.hours.close.Value
    if close == 24 and open == 0 then
      return true
    end
    -- DECOMPILER ERROR at PC43: Unhandled construct in 'MakeBoolean' P1

    if open < close and open * 60 <= now and now <= close * 60 then
      return true
    end
    if (open * 60 <= now and now <= (close + 24) * 60) or open * 60 <= now + 1440 and now + 1440 <= (close + 24) * 60 then
      return true
    end
    return false
  end
  do
    return true
  end
end

_G.ConvertTime = function(gt)
  
  local eon = "AM"
  if gt >= 780 then
    gt = gt - 720
    if gt < 720 then
      eon = "PM"
    end
  else
    if gt < 60 then
      gt = gt + 720
    end
  end
  local hours = math.floor((gt) / 60)
  local mins = math.floor(gt - math.floor((gt) / 60) * 60)
  if mins < 10 then
    mins = "0" .. mins
  end
  return hours .. ":" .. mins .. " " .. eon
end

FindLinkedJob = function(jobid)
  
  return _G.FindLinkedJob(jobid)
end

FindObject = function(valor)
  
  if valor then
    for g = 1, #directory do
      local subdir = directory[g]:GetChildren()
      for d = 1, #subdir do
        if subdir[d]:FindFirstChild("ItemID").Value == valor then
          return subdir[d]
        end
      end
    end
  end
end

_G.FindObject = FindObject
FindObjectInInventory = function(valor)
  
  if valor then
    local things = pstats.items:GetChildren()
    for g = 1, #things do
      if tostring(things[g].Value) == tostring(valor) then
        return things[g]
      end
    end
  end
end

Intrusive = function()
  
  local uis = {wardrobe, vehicle, garage, outfit, hairstyle, rent, housing, container, shop, jobs, driving, furniture, surgery}
  for z = 1, #uis do
    if uis[z].Visible then
      return true
    end
  end
  do
    if #player.PlayerGui.jobscripts:GetChildren() > 0 then
      local jobname = player.PlayerGui.jobscripts:GetChildren()[1].Name
      if jobname ~= "Cubicle" and jobname ~= "Manager" then
        return true
      end
    end
    if sitting or laying then
      return true
    end
  end
end

ContainsName = function(mesa, thing)
  
  for g = 1, #mesa do
    if mesa[g].Name == thing then
      return true
    end
  end
  return false
end

CheckForDrop = function()
  
  local ray = Ray.new(torso.Position, Vector3.new(0, 1, 0) * 100)
  local hit, pos = game.Workspace:FindPartOnRay(ray, player.Character)
  if hit and GetPermissions(hit, 2, false) then
    return true
	end
	do
  do return true end
return false
	end
	

GetPermissions = function(thing, level, base)
  
  local instance = thing
  repeat
    instance = instance.Parent
  until instance.Parent == game.Workspace.AnchoredObjects or instance:FindFirstChild("stats") or instance.Parent == game
  if instance:FindFirstChild("stats") and instance.stats:FindFirstChild("owner") then
    if instance.stats.owner.Value == player.Name then
      return true
    else
      if game.Players:FindFirstChild(instance.stats.owner.Value) then
        local opstats = game.Players[instance.stats.owner.Value].playerstats
        if ContainsName(opstats.relation.friend:GetChildren(), tostring(player.userId)) and level <= 2 then
          return true
        else
          if ContainsName(opstats.relation.guest:GetChildren(), tostring(player.userId)) and level <= 1 then
            return true
          else
            return false
          end
        end
      else
        do
          do return false end
			return base
        end
      end
    end
  end
end

CheckApartment = function(thing)
  
  local instance = thing
  repeat
    instance = instance.Parent
  until instance.Parent == game.Workspace.AnchoredObjects or instance:FindFirstChild("stats") or instance.Parent == game
  if instance:FindFirstChild("stats") and instance.stats:FindFirstChild("owner") and instance.Parent:FindFirstChild("apartment") and instance.stats.owner.Value == player.Name then
    return instance
  end
end

local sbox = game.ReplicatedStorage.ControllerBox:clone()
sbox.Parent = game.Workspace
local jbox = game.ReplicatedStorage.JobBox:clone()
jbox.Parent = game.Workspace
_G.jbox = jbox
GiveContext = function(mess, targ, part, color)
  
  info.Position = UDim2.new(0, mouse.X - 50, 0, mouse.Y - 25)
  if game:GetService("UserInputService").GamepadEnabled then
    xinfo.Visible = true
    xinfo.Text = mess
    if targ then
      sbox.Adornee = targ
    end
  else
    if color then
      if not part then
        part = targ
      end
      info.TextColor3 = color
      info.Visible = true
      info.Text = mess
    else
      if not interact.Enabled then
        if not part then
          part = targ
        end
        if part.Position - torso.Position.magnitude > 12 then
          info.TextColor3 = Color3.new(0.3, 0.3, 0.3)
        else
          info.TextColor3 = Color3.new(1, 1, 1)
        end
        info.Visible = true
        info.Text = mess
      end
    end
  end
end

ResetInfo = function()
  
  info.Visible = false
  xinfo.Visible = false
  sbox.Adornee = nil
end

GetTarget = function()
  
  if game:GetService("UserInputService").GamepadEnabled then
    local vps = camera.ViewportSize / 2
    local ray = camera:ViewportPointToRay(vps.x, vps.y, 0.2)
    ray = Ray.new(ray.Origin, ray.Direction * 20)
    return game.Workspace:FindPartOnRay(ray, player.Character)
  else
    do
      ResetInfo()
      do return mouse.Target end
    end
  end
end

ChangeButton = function(button, text)
  
  if game:GetService("UserInputService").GamepadEnabled then
    button.Text = text
  else
    if button.Name == "Button1" then
      button.Text = "[ T ] " .. text
    else
      if button.Name == "Button2" then
        button.Text = "[ F ] " .. text
      end
    end
  end
end

CheckFurnitureStore = function(targ)
  
  repeat
    if not furniture.Visible then
      targ = targ.Parent
      if targ:FindFirstChild("StoreID") and targ.StoreID:FindFirstChild("furniture") then
        return targ
      end
    end
  until targ == game.Workspace
end

CheckVehicleStore = function(targ)
  
  repeat
    if not vehicle.Visible then
      targ = targ.Parent
      if targ.Name == "CarDisplay" then
        return targ
      end
    end
  until targ == game.Workspace
end

CheckFurniture = function(targ)
  
  repeat
    if targ and targ:IsDescendantOf(game.Workspace) then
      targ = targ.Parent
      if targ:FindFirstChild("stats") and targ.stats:FindFirstChild("owner") and targ.stats.owner.Value == player.Name and targ:FindFirstChild("ItemID") and targ.ItemID:FindFirstChild("FurnitureID") then
        return targ
      end
    end
  until targ == game.Workspace
end

CheckVehicle = function(targ)
  
  repeat
    targ = targ.Parent
    -- DECOMPILER ERROR at PC13: Unhandled construct in 'MakeBoolean' P1

    if targ:FindFirstChild("vehicle") and targ.vehicle.owner.Value == player.Name then
      return targ
    end
    if targ:FindFirstChild("taxi") then
      local job = pstats.job.Value
      if job then
        local id = job.Value
        if targ:IsDescendantOf(job.assets.Value:FindFirstChild(id)) then
          return targ
        end
      end
    end
  until targ == game.Workspace
end

CheckPassenger = function(targ)
  
  repeat
    targ = targ.Parent
    if targ:FindFirstChild("vehicle") and targ.Seats.Driver:FindFirstChild("SitPoint") then
      return targ
    end
  until targ == game.Workspace
end

CheckParking = function(targ)
  
  if targ.Name == "Spot" and (targ.owner.Value == player.Name or targ.owner.Value == "Public") then
    local rc = targ.CFrame - targ.CFrame.p
    local bound1, bound2 = targ.Position + Vector3.new(0, 1, 0) - rc * targ.Size / 2, targ.Position + Vector3.new(0, 3, 0) + rc * targ.Size / 2
    local v1 = Vector3.new(math.min(bound1.x, bound2.x), math.min(bound1.y, bound2.y), math.min(bound1.z, bound2.z))
    local v2 = Vector3.new(math.max(bound1.x, bound2.x), math.max(bound1.y, bound2.y), math.max(bound1.z, bound2.z))
    local region = Region3.new(v1, v2)
    local parts = game.Workspace:FindPartsInRegion3(region)
    for d = 1, #parts do
      if not parts[d]:IsDescendantOf(player.Character) and not parts[d]:IsDescendantOf(game.Workspace.PlayerVehicles[player.Name]) then
        return false
      end
    end
    return true
  end
end

CheckPart = function(ori, mesa)
  
  for k = 1, #mesa do
    if not mesa[k]:IsDescendantOf(torso.Parent) and mesa[k].Name ~= "Marker" and not mesa[k]:IsDescendantOf(ori) and mesa[k].Name ~= "Checker" then
      return false
    end
  end
  return true
end

GetLowest = function(thing, base, lowest)
  
  local parts = thing:GetChildren()
  for z = 1, #parts do
    if parts[z]:IsA("BasePart") then
      local vecs = {Vector3.new(0, 0, 1), Vector3.new(0, 0, -1), Vector3.new(0, 1, 0), Vector3.new(0, -1, 0), Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0)}
      for d = 1, #vecs do
        local low = parts[z].CFrame * (vecs[d] * parts[z].Size / 2).y
        if lowest < base - low then
          lowest = base - low
        end
      end
    else
      do
        do
          lowest = GetLowest(parts[z], base, lowest)
          -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  return lowest
end

FindLowestPoint = function(thing)
  
  local base = thing.PrimaryPart.Position.y
  local lowest = GetLowest(thing, base, 0)
  return lowest
end

TouchingParts = function(ori, thing)
  
  local stuff = thing:GetChildren()
  local mesa = {}
  for b = 1, #stuff do
    local part = stuff[b]
    if part:IsA("BasePart") then
      local thing = Instance.new("Part")
      thing.FormFactor = "Custom"
      thing.Name = "Checker"
      thing.Size = part.Size - Vector3.new(0.6, 0.6, 0.6)
      thing.Anchored = true
      thing.CanCollide = true
      thing.CFrame = part.CFrame
      thing.Parent = game.Workspace
      local things = thing:GetTouchingParts()
      for d = 1, #things do
        table.insert(mesa, things[d])
      end
      thing:Destroy()
    end
    do
      local c = TouchingParts(ori, stuff[b])
      for y = 1, #c do
        table.insert(mesa, c[y])
      end
      -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out DO_STMT

    end
  end
  return mesa
end

RoundOff = function(val, acc)
  
  local thing = val / acc
  return math.floor(thing) * acc
end

onMove = function()
  
  sbox.Adornee = nil
  local target = GetTarget()
  if Intrusive() then
    return 
  end
  if furnishment then
    local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
    local hit, pos = game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(ray.Origin, ray.Direction * 50), {torso.Parent, furnishment})
    if hit and pos then
      furnishment:SetPrimaryPartCFrame(CFrame.new(Vector3.new(RoundOff(pos.x, 0.2), pos.y, RoundOff(pos.z, 0.2)) + Vector3.new(0, FindLowestPoint(furnishment), 0)) * CFrame.Angles(0, math.rad(ang), 0))
      local hit2 = game.Workspace:FindPartOnRay(Ray.new(furnishment.PrimaryPart.Position, Vector3.new(0, 1, 0) * 50), furnishment)
      local hit3 = game.Workspace:FindPartOnRay(Ray.new(furnishment.PrimaryPart.Position, Vector3.new(0, -1, 0) * 50), furnishment)
      if hit2 and CheckApartment(hit2) and hit3 and hit3.Name == "Floor" and hit.Name == "Floor" and CheckPart(furnishment, TouchingParts(furnishment, furnishment)) then
        placement = true
        SetTransparency(furnishment, true)
      else
        placement = false
        SetTransparency(furnishment, false)
      end
    end
  else
    do
      if painting and target and CheckApartment(target) then
        if target:FindFirstChild("Paintable") then
          sbox.Color3 = painting.Color
          sbox.Adornee = target
          GiveContext("Paint", target, target, painting.Color)
        else
          if target.Name == "InteriorLight" then
            mouse.TargetFilter = target
          end
        end
      end
			if  target and (target.Position - torso.Position).magnitude < 22 then
        local objid = target.Parent.Parent:FindFirstChild("ItemID")
        if target.Parent:FindFirstChild("Shop") and _G.CheckHours(target) and _G.foodable then
          GiveContext("Purchase Items", target.Parent, target)
        else
          if CheckFurniture(target) and not sitting and not laying then
            GiveContext("Interact", target, target)
          else
            if CheckFurnitureStore(target) and _G.CheckHours(target) and _G.rentable then
              GiveContext("Browse Furniture", target.Parent, target)
            else
              if CheckVehicleStore(target) and _G.CheckHours(target) and _G.rentable then
                GiveContext("Browse Vehicles", target.Parent, target)
              else
                if CheckVehicle(target) and not humanoid.Jump then
                  GiveContext("Drive Vehicle", target)
                else
                  if CheckPassenger(target) and not humanoid.Jump then
                    GiveContext("Get In", target)
                  else
                    if Find("ContainerID", target) and GetPermissions(target, 2, true) then
                      GiveContext("Open Container", target.Parent, target)
                    else
                      if target.Name == "Door" then
                        GiveContext("Close Door", target)
                      else
                        if target.Name == "CloseDoor" then
                          local rx, ry, rz, R00, R01, R02, R10, R11, R12, R20, R21, R22 = target.CFrame:components()
                          if GetPermissions(target, 1, true) and _G.CheckHours(target) then
                            GiveContext("Open Door", target)
                          else
                            if target.Position - torso.Position.magnitude < Vector3.new(R01, R11, R21) * -0.1 + target.Position - torso.Position.magnitude then
                              GiveContext("Open Door", target)
                            else
                              GiveContext("Knock", target)
                            end
                          end
                        else
                          do
                            if (target.Name == "SwitchOn" or target.Name == "PlateOn") and GetPermissions(target, 1, true) then
                              GiveContext("Lights Off", target.Parent, target)
                            else
                              if (target.Name == "SwitchOff" or target.Name == "PlateOff") and GetPermissions(target, 1, true) then
                                GiveContext("Lights On", target.Parent, target)
                              else
                                if string.sub(target.Name, 1, 7) == "Curtain" and target.Name ~= "Curtain" and target.Parent.Curtain.Transparency == 1 and GetPermissions(target, 1, true) then
                                  GiveContext("Close Curtains", target.Parent, target)
                                else
                                  if string.sub(target.Name, 1, 7) == "Curtain" and target.Parent.Curtain.Transparency == 0 and GetPermissions(target, 1, true) then
                                    GiveContext("Open Curtains", target.Parent, target)
                                  else
                                    if target.Name == "Status" and target.Parent.stats.owner.Value == "" and _G.rentable then
                                      if target.Parent.Parent:FindFirstChild("motel") then
                                        GiveContext("Rent Room", target)
                                      else
                                        if target.Parent.Parent:FindFirstChild("apartment") then
                                          if target.Parent.Parent.apartment.tier.Value > 10 then
                                            GiveContext("Buy House", target)
                                          else
                                            GiveContext("Buy Apartment", target)
                                          end
                                        end
                                      end
                                    else
                                      if target.Parent.Name == "Mannequin" and not outfit.Visible and _G.CheckHours(target) and _G.clotheable then
                                        GiveContext("Browse Items", target.Parent, target)
                                      else
                                        if target.Parent.Name == "ScaleMap" and not real_estate.Visible and string.sub(pstats.home.specific.Value, 1, 5) == "House" then
                                          GiveContext("Open Housing Menu", target.Parent, target)
                                        else
                                          if Find("Seat", target) and not sitting and not laying and GetPermissions(target, 1, true) then
                                            if target.Parent.Name == "SalonChair" then
                                              GiveContext("Browse Hairstyles", target.Parent, target)
                                            else
                                              if target.Parent.Name == "SurgeryChair" then
                                                GiveContext("Change Appearance", target.Parent, target)
                                              else
                                                GiveContext("Sit Down", target.Parent, target)
                                              end
                                            end
                                          else
                                            if Find("Pillow", target) and not sitting and not laying and not wardrobe.Visible and GetPermissions(target, 2, true) then
                                              GiveContext("Lay Down", target.Parent, target)
                                            else
                                              if objid and not objid:FindFirstChild("FurnitureID") then
                                                local objinfo = FindObject(objid.Value)
                                                if objinfo then
                                                  GiveContext(objinfo.Name, target)
                                                end
                                              else
                                                do
                                                  if target:IsDescendantOf(game.Workspace.Mineshaft.Loot) then
                                                    GiveContext("Open Chest", target)
                                                  end
                                                end
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

CheckJobs = function(target)
  
  local newjobs = {}
  local potent = target.Parent.jobs:GetChildren()
  for t = 1, #potent do
    if FindLinkedJob(potent[t]).worker.Value == "" then
      table.insert(newjobs, potent[t])
    end
  end
  local grumps = jobs.Scroll:GetChildren()
  for b = 1, #grumps do
    if string.sub(grumps[b].Name, 1, 3) == "Job" and grumps[b].Name ~= "Job0" then
      grumps[b]:Destroy()
    end
  end
  for t = 1, #newjobs do
    local job = jobs.Job0:clone()
    local linkedjob = FindLinkedJob(newjobs[t])
    job.Name = "Job" .. t
    job.Position = UDim2.new(0, 5, 0, -50 + 55 * t)
    job.Title.Text = linkedjob.title.Value
    job.Description.Text = linkedjob.description.Value
    job.jobid.Value = linkedjob.Value
    job.Wage.Text = _G.FormatCash(linkedjob.stats.wage.Value) .. "/hour"
    job.Reputation.Label.Text = linkedjob.stats.rep.minimum.Value
    job.Visible = true
    job.Parent = jobs.Scroll
  end
  local ysize = 30 + 55 * #newjobs
  jobs.Size = UDim2.new(0, 550, 0, ysize)
  jobs.Position = UDim2.new(0.5, -275, 0.5, -ysize / 2)
  jobs.Visible = true
end

OpenShop = function(target)
  
  shop.store.Value = target.Parent.ShopID
  shop.Visible = true
  while shop.Visible do
    if target.Position - torso.Position.magnitude > 10 then
      shop.Visible = false
    end
    wait(0.5)
  end
end

OpenContainer = function(target)
  
  local contid = target.Parent.ContainerID
  OrganizeContainer(contid)
  container.Visible = not container.Visible
  local connection1 = contid.ChildAdded:connect(function()
    
    OrganizeContainer(contid)
  end
)
  local connection2 = contid.ChildRemoved:connect(function()
    
    OrganizeContainer(contid)
  end
)
  ChangeButton(button1, "Store")
  local pos = torso.Position
  while container.Visible do
    if pos - torso.Position.magnitude > 14 then
      container.Visible = false
    end
    wait(0.5)
  end
  ChangeButton(button1, "Drop")
  connection1:disconnect()
  connection2:disconnect()
end

ToggleDoor = function(target, automatic)
  
  local rx, ry, rz, R00, R01, R02, R10, R11, R12, R20, R21, R22 = target.CFrame:components()
  -- DECOMPILER ERROR at PC52: Unhandled construct in 'MakeBoolean' P3

  -- DECOMPILER ERROR at PC52: Unhandled construct in 'MakeBoolean' P1

  if ((GetPermissions(target, 1, true) and _G.CheckHours(target)) or target.Name == "Door") and torso.Position.y < target.Position.y + 2 then
    _G.Events.ToggleDoor:FireServer(target)
  end
  if not automatic then
    _G.Events.KnockDoor:FireServer(target)
  end
end

Find = function(check, target)
  
  local count = 0
  repeat
    target = target.Parent
    if target:FindFirstChild(check) and not target[check]:FindFirstChild("SitPoint") then
      return target[check]
    end
    count = count + 1
  until target == game.Workspace or count == 3
end

CheckRent = function(target)
  
  local stats = target.Parent.stats
  if stats.Parent.Parent:FindFirstChild("motel") then
    rent.renting.Value = target.Parent
    rent.Visible = not rent.Visible
  else
    housing.buying.Value = target.Parent
    housing.Visible = not housing.Visible
  end
end

CheckWardrobe = function(target)
  
  if not sitting and not laying then
    torso.CFrame = target.Parent.Plate.CFrame + Vector3.new(0, 3.4, 0)
    torso.Anchored = true
    wardrobe.Visible = true
  end
end

CheckSeat = function(target)
  
  if not sitting and not laying then
    Sit(target.Parent.Seat)
    if target.Parent.Name == "SalonChair" and _G.rentable then
      hairstyle.store.Value = target.Parent.Parent.Parent.Parent.StoreID
      hairstyle.Visible = true
    end
    if target.Parent.Name == "SurgeryChair" and _G.rentable then
      surgery.store.Value = target.Parent.Parent.Parent.Parent.StoreID
      surgery.Visible = true
    end
  end
end

CheckLayDown = function(target)
  
  if not sitting and not laying and not wardrobe.Visible then
    LayDown(target.Parent.Pillow)
  end
end

RideVehicle = function(veh, driver)
  
  if veh and not humanoid.Jump then
    local seat = nil
    if driver then
      seat = veh.Seats:FindFirstChild("Driver")
      driving.vehicle.Value = veh
    else
      local seats = veh.Seats.Passengers:GetChildren()
      do
        for d = 1, #seats do
          if not seat and not seats[d]:FindFirstChild("SitPoint") then
            seat = seats[d]
          end
        end
      end
    end
    do
      if seat then
        Sit(seat)
        camera.CameraType = "Track"
        local con = nil
        con = humanoid.Jumping:connect(function()
    
    if con then
      con:disconnect()
      con = nil
    end
    camera.CameraType = "Custom"
  end
)
      end
    end
  end
end

_G.RideVehicle = RideVehicle
EnableLeaflets = function(target)
  
  local furn = CheckFurniture(target)
  interact.Adornee = furn
  interact.Enabled = true
  local con1 = (interact.Leaf2.MouseButton1Click:connect(function()
    
    interact.Enabled = false
    AttemptPickup(target)
  end
))
  local con2 = nil
  interact.Leaf1.Visible = true
  if Find("Seat", target) then
    con2 = interact.Leaf1.MouseButton1Click:connect(function()
    
    interact.Enabled = false
    CheckSeat(Find("Seat", target))
  end
)
    interact.Leaf1.Text = "Sit Down"
  else
    if Find("Pillow", target) then
      con2 = interact.Leaf1.MouseButton1Click:connect(function()
    
    interact.Enabled = false
    CheckLayDown(Find("Pillow", target))
  end
)
      interact.Leaf1.Text = "Lay Down"
    else
      if Find("ContainerID", target) then
        con2 = interact.Leaf1.MouseButton1Click:connect(function()
    
    interact.Enabled = false
    OpenContainer(Find("ContainerID", target))
  end
)
        interact.Leaf1.Text = "View Contents"
      else
        interact.Leaf1.Visible = false
      end
    end
  end
  while torso.Velocity.magnitude < 1 and interact.Adornee == furn do
    wait(0.03125)
  end
  con1:disconnect()
  if con2 then
    con2:disconnect()
  end
  if interact.Adornee == furn then
    interact.Adornee = nil
    interact.Enabled = false
  end
end

onClick = function()
  
  local target = GetTarget()
  ResetInfo()
  if Intrusive() then
    return 
  end
  if furnishment then
    local fook = inventory[index]
    local hit, pos = game.Workspace:FindPartOnRay(Ray.new(furnishment.PrimaryPart.Position, Vector3.new(0, 1, 0) * 100), furnishment)
    if hit and GetPermissions(hit, 2, true) and placement then
      _G.Events.PlaceFurniture:FireServer(FindObject(fook.id), fook.items[1].Primary.Value, fook.items[1].Secondary.Value, furnishment.PrimaryPart.CFrame)
      furnishment:Destroy()
      placement = false
      furnishment = nil
      ang = 0
      _G.RemoveItem(fook)
      player.PlayerGui.music.job.success:Play()
    else
      player.PlayerGui.music.job.failure:Play()
    end
  else
    do
      if painting then
        local hit = mouse.Target
        if hit and CheckApartment(hit) and hit:FindFirstChild("Paintable") then
          if hit.BrickColor ~= painting then
            sbox.Adornee = nil
            _G.Events.ChangeProperty:FireServer(hit, "BrickColor", painting)
            hit.BrickColor = painting
            player.PlayerGui.music.interact.paint:Play()
            _G.RemoveItem(inventory[index])
          else
            _G.SendMessage("That wall is already painted that color.", "Yellow")
          end
        end
      else
        do
          if target and (target.Position - torso.Position).magnitude < 12 then
            local objid = target.Parent.Parent:FindFirstChild("ItemID")
            if target.Parent:FindFirstChild("Shop") and _G.CheckHours(target) and _G.foodable then
              OpenShop(target)
            else
              if CheckFurniture(target) and not sitting and not laying then
                EnableLeaflets(target)
              else
                if CheckFurnitureStore(target) and _G.CheckHours(target) and _G.rentable then
                  furniture.store.Value = CheckFurnitureStore(target).StoreID
                  furniture.Visible = true
                else
                  if CheckVehicleStore(target) and _G.CheckHours(target) and _G.rentable then
                    vehicle.store.Value = CheckVehicleStore(target).StoreID
                    vehicle.Visible = true
                  else
                    if CheckVehicle(target) and not garage.Visible and not humanoid.Jump then
                      RideVehicle(CheckVehicle(target), true)
                    else
                      if CheckPassenger(target) and not humanoid.Jump then
                        RideVehicle(CheckPassenger(target))
                      else
                        if Find("ContainerID", target) and GetPermissions(target, 2, true) then
                          OpenContainer(Find("ContainerID", target))
                        else
                          if target.Name == "Door" or target.Name == "CloseDoor" then
                            ToggleDoor(target)
                          else
                            if (target.Name == "SwitchOn" or target.Name == "PlateOn" or target.Name == "SwitchOff" or target.Name == "PlateOff") and GetPermissions(target, 1, true) then
                              _G.Events.ToggleLight:FireServer(target)
                            else
                              if string.sub(target.Name, 1, 7) == "Curtain" and GetPermissions(target, 1, true) then
                                _G.Events.ToggleBlinds:FireServer(target)
                              else
                                if target.Name == "Status" and target.Parent.stats.owner.Value == "" and _G.rentable then
                                  CheckRent(target)
                                else
                                  if target.Parent.Name == "Mannequin" and not outfit.Visible and _G.CheckHours(target) and _G.clotheable then
                                    outfit.store.Value = target.Parent.StoreID
                                    outfit.Visible = true
                                  else
                                    if target.Parent.Name == "ScaleMap" and not real_estate.Visible and string.sub(pstats.home.specific.Value, 1, 5) == "House" then
                                      real_estate.Visible = true
                                    else
                                      if Find("Seat", target) and GetPermissions(target, 1, true) then
                                        CheckSeat(Find("Seat", target))
                                      else
                                        if Find("Pillow", target) and GetPermissions(target, 2, true) then
                                          CheckLayDown(Find("Pillow", target))
                                        else
                                          if game.Players:FindFirstChild(target.Parent.Name) and target.Parent ~= player.Character then
                                            interaction.userid.Value = game.Players[target.Parent.Name].userId
                                            interaction.Title.Text = target.Parent.Name
                                            interaction.Visible = true
                                          else
                                            if objid and lt + 0.25 < game.Workspace.DistributedGameTime and not objid:FindFirstChild("FurnitureID") then
                                              lt = game.Workspace.DistributedGameTime
                                              _G.TakeItem(objid, target.Parent.Parent)
                                            else
                                              if target:IsDescendantOf(game.Workspace.Mineshaft.Loot) then
                                                _G.Events.OpenChest:FireServer(target.Parent.Parent)
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

Consume = function()
  
  local fook = inventory[index]
  local objinfo = FindObject(fook.id)
  if not objinfo.ItemID:FindFirstChild("FurnitureID") and fook.id < 4000 then
    local stat = objinfo.ItemID.Stats
    if stat.Drink.Value then
      player.PlayerGui.music.interact.drink:Play()
    else
      if stat.Eat.Value then
        player.PlayerGui.music.interact.eat:Play()
      end
    end
    ChangeStats(stat.Health.Value, stat.Energy.Value)
    _G.RemoveItem(fook)
  end
end

ChangeStats = function(he, en)
  
  health = health + he
  energy = energy + en
  if health < 0 then
    health = 0
  end
  if energy < 0 then
    energy = 0
  end
  if health > 1000 then
    health = 1000
  end
  if energy > 1000 then
    energy = 1000
  end
  CheckBars()
end

OrganizeContainer = function(contid)
  
  local things = contid:GetChildren()
  container.Scroll:ClearAllChildren()
  container.store.Value = contid
  local distincts = 0
  for b = 1, #things do
    local already = false
    local tiles = container.Scroll:GetChildren()
    for g = 1, #tiles do
      if tiles[g].ItemID.Value == things[b].Value then
        tiles[g].Count.Text = tostring(tonumber(tiles[g].Count.Text) + 1)
        already = true
      end
    end
    if not already then
      distincts = distincts + 1
      local tile = container.Item0:clone()
      local linkeditem = FindObject(things[b].Value)
      tile.ItemID.Value = things[b].Value
      tile.ItemID.Origin.Value = things[b]
      tile.Label.Text = linkeditem.Name
      tile.Image = linkeditem.ItemID.Image.Value
      tile.Position = UDim2.new(0, 5 + 85 * ((distincts - 1) % 5), 0, -55 + math.ceil((distincts) / 5) * 85)
      tile.Visible = true
      tile.Parent = container.Scroll
    end
  end
  local ysize = 30 + math.ceil((distincts) / 5) * 85
  if distincts == 0 then
    ysize = 115
  end
  container.Size = UDim2.new(0, 430, 0, ysize)
  container.Position = UDim2.new(0.5, -215, 0.5, -ysize / 2)
  container.Title.Text = contid.Value
end

UpdateBar = function(bar, diff, cur)
  
  if diff ~= 0 then
    bar.Visible = true
    bar.Position = UDim2.new(bar.Parent.Bar.Size.X.Scale, 0, 0, 0)
    if diff > 0 then
      bar.BackgroundColor3 = Color3.new(1, 1, 1)
    else
      bar.BackgroundColor3 = Color3.new(0.3, 0, 0)
    end
    if diff + cur > 1000 then
      bar.Size = UDim2.new(1 - bar.Position.X.Scale, 0, 1, 0)
    else
      bar.Size = UDim2.new(diff / 1000, 0, 1, 0)
    end
  else
    bar.Visible = false
  end
end

CheckBarMods = function()
  
  local objinfo = FindObject(inventory[index].id)
  if objinfo then
    UpdateBar(stats.Health.Back.Diff, objinfo.ItemID.Stats.Health.Value, pstats.stats.health.Value)
    UpdateBar(stats.Energy.Back.Diff, objinfo.ItemID.Stats.Energy.Value, pstats.stats.energy.Value)
  end
end

OrganizeDown = function()
  
  if #inventory > 1 then
    player.PlayerGui.music.menu.select2:Play()
  end
  index = index - 1
  if index < 1 then
    index = #inventory
  end
  onUpdate()
end

OrganizeUp = function()
  
  if #inventory > 1 then
    player.PlayerGui.music.menu.select2:Play()
  end
  index = index + 1
  if #inventory < index then
    index = 1
  end
  onUpdate()
end

AttemptDrop = function()
  
  lt = game.Workspace.DistributedGameTime
  local fook = inventory[index]
  if fook and fook.id ~= 9999 then
    if container.Visible then
      _G.Events.StoreItem:FireServer(fook.items[1], container.store.Value)
      _G.RemoveItem(fook)
    else
      if CheckForDrop() and fook.id < 5000 then
        _G.Events.PlaceItem:FireServer(fook.id, FindObject(fook.id))
        _G.RemoveItem(fook)
      else
        _G.SendMessage("You can\'t drop that here.", "White")
      end
    end
  end
end

AttemptPickup = function(target)
  
  if target then
    local furn = CheckFurniture(target)
    if furn then
      _G.TakeItem(furn.ItemID, furn)
    end
  end
end

onKeyDown = function(key)
  
  local key = key:lower()
  if key == "t" and lt + 0.25 < game.Workspace.DistributedGameTime then
    AttemptDrop()
  else
    if key == "q" then
      OrganizeDown()
    else
      if key == "e" then
        OrganizeUp()
      else
        if key == "f" then
          Consume()
        else
          if key == "r" and furnishment then
            ang = ang + 15
          end
        end
      end
    end
  end
end

OrganizeSlot = function(slot, add, type)
  
  if (slot == left2 or slot == right2) and camera.ViewportSize.x < 1000 then
    slot.Visible = false
  else
    if type <= #inventory then
      local item = 0
      if #inventory < index + add then
        item = index + add - #inventory
      else
        if index + add < 1 then
          item = #inventory + (index + add)
        else
          item = index + add
        end
      end
      local group = inventory[item]
      local objinfo = FindObject(group.id)
      if objinfo then
        slot.Image = objinfo.ItemID.Image.Value
        slot.Visible = true
        if group.id ~= 9999 then
          slot.Count.Visible = true
          slot.Count.Text = tostring(#group.items)
        else
          slot.Count.Visible = false
        end
      end
    else
      do
        slot.Visible = false
      end
    end
  end
end

ChangeButtons = function(vis)
  
  button1.Visible = false
  if game:GetService("UserInputService").GamepadEnabled then
    button1 = inv.Controller.Button1
    button2 = inv.Controller.Button2
  else
    if not game:GetService("UserInputService").KeyboardEnabled then
      local cas = game:GetService("ContextActionService")
      if vis then
        vis = false
        cas:BindActionToInputTypes("Consume", Consume, true, "f")
        cas:BindActionToInputTypes("Drop", AttemptDrop, true, "tkey")
        cas:SetPosition("Consume", UDim2.new(0, 0, 0.7, 0))
        cas:SetPosition("Drop", UDim2.new(0.3, 0, 0.7, 0))
        cas:SetTitle("Consume", "Consume Item")
        cas:SetTitle("Drop", "Drop Item")
      else
        cas:UnbindAction("Consume")
        cas:UnbindAction("Drop")
      end
    else
      do
        button1 = inv.Buttons.Button1
        button2 = inv.Buttons.Button2
        button1.Visible = vis
      end
    end
  end
end

SetTransparency = function(thing, color)
  
  local things = thing:GetChildren()
  for b = 1, #things do
    if things[b]:IsA("BasePart") then
      if things[b].Transparency < 0.6 then
        things[b].Transparency = 0.6
      end
      things[b].CanCollide = false
      if color then
        things[b].BrickColor = BrickColor.Green()
      else
        things[b].BrickColor = BrickColor.Red()
      end
    else
      SetTransparency(things[b], color)
    end
  end
end

onUpdate = function()
  
  OrganizeSlot(left2, -2, 5)
  OrganizeSlot(left1, -1, 3)
  OrganizeSlot(mid, 0, 1)
  OrganizeSlot(right1, 1, 2)
  OrganizeSlot(right2, 2, 4)
  local first = inventory[index]
  if first then
    if furnishment then
      furnishment:Destroy()
      furnishment = nil
    end
    painting = nil
    local objinfo = FindObject(first.id)
    if first.id < 4000 then
      ChangeButtons(true)
      local stat = objinfo.ItemID.Stats
      if stat.Drink.Value then
        ChangeButton(button2, "Drink")
      else
        if stat.Eat.Value then
          ChangeButton(button2, "Eat")
        else
          if stat.Health.Value > 0 then
            ChangeButton(button2, "Heal")
          else
            if stat.Energy.Value > 0 then
              ChangeButton(button2, "Consume")
            else
              button2.Visible = false
            end
          end
        end
      end
    else
      do
        do
          if first.id < 5000 then
            button1.Visible = true
            button2.Visible = false
            painting = objinfo.ItemID.PaintID.Value
          else
            if first.id < 6000 then
              if container.Visible then
                button1.Visible = true
                button2.Visible = false
              else
                ChangeButtons(false)
              end
              furnishment = objinfo:clone()
              furnishment.Parent = game.Workspace
              SetTransparency(furnishment)
            else
              ChangeButtons(false)
            end
          end
          CheckBarMods()
        end
      end
    end
  end
end

local last_rep = pstats.job.reputation.Value
local rep_change = reputation.Change
local rep_running_total = 0
local rep_wait_time = 0
local rep_max_wait = 150
onRep = function()
  
  reputation.Label.Text = _G.Level
  if last_rep then
    local diff = pstats.job.reputation.Value - last_rep
    last_rep = pstats.job.reputation.Value
    if rep_change.Visible then
      rep_running_total = rep_running_total + diff
    else
      rep_running_total = diff
    end
    rep_wait_time = 0
    rep_change.Text = "+" .. rep_running_total
    rep_change.Visible = true
  end
end

spawn(function()
  
  while 1 do
    wait(1)
    while rep_wait_time < rep_max_wait do
      wait(0.03125)
      rep_wait_time = rep_wait_time + 1
      local transparency_modifier = rep_max_wait - rep_wait_time
      rep_change.TextTransparency = 1 - transparency_modifier / 30
      rep_change.TextStrokeTransparency = math.max(0.5, 1 - transparency_modifier / 60)
    end
    do
      rep_change.Visible = false
      -- DECOMPILER ERROR at PC31: LeaveBlock: unexpected jumping out DO_STMT

    end
  end
end
)
local last_cash = nil
local cash_change = cash.Parent.Change
local running_total = 0
local wait_time = 0
local max_wait = 150
onCash = function()
  
  cash.Text = string.sub(_G.FormatCash(tonumber(pstats.cash.Value)), 2)
  if last_cash then
    local diff = pstats.cash.Value - last_cash
    last_cash = pstats.cash.Value
    if cash_change.Visible then
      running_total = running_total + diff
    else
      running_total = diff
    end
    wait_time = 0
    local formatted_change = string.sub(_G.FormatCash(math.abs(running_total)), 2)
    if running_total >= 0 then
      cash_change.Text = "+" .. formatted_change
      cash_change.TextColor3 = Color3.new(0, 1, 0)
    else
      cash_change.Text = "-" .. formatted_change
      cash_change.TextColor3 = Color3.new(1, 0, 0)
    end
    cash_change.Visible = true
  else
    do
      last_cash = pstats.cash.Value
    end
  end
end

spawn(function()
  
  while 1 do
    wait(1)
    while wait_time < max_wait do
      wait(0.03125)
      wait_time = wait_time + 1
      local transparency_modifier = max_wait - wait_time
      cash_change.TextTransparency = 1 - transparency_modifier / 30
      cash_change.TextStrokeTransparency = math.max(0.5, 1 - transparency_modifier / 60)
    end
    do
      cash_change.Visible = false
      -- DECOMPILER ERROR at PC31: LeaveBlock: unexpected jumping out DO_STMT

    end
  end
end
)
CheckBars = function()
  
  stats.Health.Back.Bar.Size = UDim2.new(health / 1000, 0, 1, 0)
  stats.Energy.Back.Bar.Size = UDim2.new(energy / 1000, 0, 1, 0)
  CheckBarMods()
end

Sit = function(seat)
  
  humanoid.Jump = false
  _G.Events.SitDown:FireServer(torso, seat)
  sitting = true
end

LayDown = function(seat)
  
  humanoid.Jump = false
  _G.Events.LayDown:FireServer(torso, seat)
  laying = true
end

GetUp = function()
  
  if not surgery.Visible and not hairstyle.Visible and torso:FindFirstChild("SitWeld") then
    local seat = torso.SitWeld.Part0
    _G.Events.GetUp:FireServer(torso)
    if torso:FindFirstChild("SitWeld") then
      torso.SitWeld:Destroy()
    end
    if seat then
      local sr = seat.CFrame - seat.CFrame.p
      if seat:FindFirstChild("Left") then
        player.Character:TranslateBy(sr * Vector3.new(-5, 0, 0))
      else
        if seat:FindFirstChild("Right") then
          player.Character:TranslateBy(sr * Vector3.new(5, 0, 0))
        else
          if seat:FindFirstChild("Front") then
            player.Character:TranslateBy(sr * Vector3.new(0, 0, 5))
          else
            if seat:FindFirstChild("Back") then
              player.Character:TranslateBy(sr * Vector3.new(0, 0, -5))
            else
              if driving.vehicle.Value then
                player.Character:TranslateBy(Vector3.new(20, 0, 0))
              end
            end
          end
        end
      end
    end
  end
  do
    driving.vehicle.Value = nil
    sitting = false
    laying = false
  end
end

local uis = game:GetService("UserInputService")
if uis.KeyboardEnabled or uis.MouseEnabled then
  uis.InputBegan:connect(function(input, processed)
  
  if not processed and input.KeyCode == Enum.KeyCode.Space then
    GetUp()
  end
end
)
else
  local touchui = player.PlayerGui:WaitForChild("TouchGui")
  local jumpbutton = touchui:FindFirstChild("JumpButton", true)
  jumpbutton.MouseButton1Down:connect(GetUp)
end
do
  mouse.Button1Down:connect(onClick)
  mouse.Move:connect(onMove)
  mouse.Idle:connect(onMove)
  mouse.KeyDown:connect(onKeyDown)
  pstats.job.reputation.Changed:connect(onRep)
  pstats.cash.Changed:connect(onCash)
  inspect.Close.MouseButton1Down:connect(function()
  
  inspect.Visible = false
end
)
  jobs.Close.MouseButton1Down:connect(function()
  
  jobs.Visible = false
end
)
  shop.Close.MouseButton1Down:connect(function()
  
  shop.Visible = false
end
)
  container.Close.MouseButton1Down:connect(function()
  
  container.Visible = false
end
)
  rent.Close.MouseButton1Down:connect(function()
  
  rent.Visible = false
end
)
  interaction.Close.MouseButton1Down:connect(function()
  
  interaction.Visible = false
end
)
  wardrobe.Cancel.MouseButton1Down:connect(function()
  
  wardrobe.Visible = false
end
)
  outfit.Sections.Cancel.MouseButton1Down:connect(function()
  
  outfit.Visible = false
end
)
  hairstyle.Sections.Cancel.MouseButton1Down:connect(function()
  
  hairstyle.Visible = false
end
)
  furniture.Sections.Cancel.MouseButton1Down:connect(function()
  
  furniture.Visible = false
end
)
  vehicle.Sections.Cancel.MouseButton1Down:connect(function()
  
  vehicle.Visible = false
end
)
  garage.Sections.Cancel.MouseButton1Down:connect(function()
  
  garage.Visible = false
end
)
  housing.Close.MouseButton1Down:connect(function()
  
  housing.Visible = false
end
)
  surgery.Sections.Cancel.MouseButton1Down:connect(function()
  
  surgery.Visible = false
end
)
  right1.MouseButton1Down:connect(function()
  
  OrganizeUp()
end
)
  left1.MouseButton1Down:connect(function()
  
  OrganizeDown()
end
)
  right2.MouseButton1Down:connect(function()
  
  OrganizeUp()
  OrganizeUp()
end
)
  left2.MouseButton1Down:connect(function()
  
  OrganizeDown()
  OrganizeDown()
end
)
  mid.MouseButton1Down:connect(function()
  
  Consume()
end
)
  FindInventoryItems()
  onUpdate()
  reputation.Label.Text = _G.Level or "0"
  onCash()
  getActiveMultiplier = function()
  
  if os.time() <= pstats.multiplier.finish.Value then
    return pstats.multiplier.Value
  end
  return 0
end

  local signs = {}
  local buildings = game.Workspace.AnchoredObjects:GetChildren()
  for z = 1, #buildings do
    do
      if buildings[z]:FindFirstChild("JobAssets") then
        local jobbs = buildings[z].JobAssets:GetChildren()
        do
          for b = 1, #jobbs do
            if jobbs[b]:FindFirstChild("JobSign") then
              table.insert(signs, jobbs[b].JobSign)
            end
          end
        end
      end
      do
        -- DECOMPILER ERROR at PC698: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  local job_levels = {200, 500, 1000, 2000}
  UpdateSign = function(job_sign)
  
  local sign = job_sign.Sign
  local link = sign.link.Value
  sign.Frame.Description.Text = link.description.Value
  sign.Frame.Title.Text = link.title.Value
  sign.Frame.Level.Label.Text = link.stats.rep.minimum.Value
  local your_level = 0
  for g = 1, 4 do
    if job_levels[g] < pstats.job.progress[link.title.Value].Value then
      your_level = g
    end
  end
  sign.Frame.Wage.TextColor3 = Color3.new(1, 1, 1)
  local wage = link.stats.wage.Value
  if your_level < 4 then
    wage = (1 + 0.05 * your_level) * wage
  else
    wage = 1.25 * (wage)
  end
  local multipliers = {1.1, 1.5, 2}
  local mult_index = getActiveMultiplier()
  if mult_index > 0 then
    wage = wage * multipliers[mult_index]
    sign.Frame.Wage.TextColor3 = Color3.new(1, 0.75, 0.3)
  end
  sign.Frame.Wage.Text = _G.FormatCash(wage) .. "/hour"
  if link.worker.Value ~= "" then
    sign.Enabled = false
  else
    if _G.Level < link.stats.rep.minimum.Value then
      sign.Frame.Description.Visible = false
      sign.Frame.Shadow.Visible = true
      sign.Frame.Level.ImageColor3 = Color3.new(1, 1, 1)
      sign.Frame.Start.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
      sign.Frame.Start.BorderColor3 = Color3.new(0, 0, 0)
      sign.Frame.Start.TextColor3 = Color3.new(1, 1, 1)
      sign.Frame.Start.AutoButtonColor = false
      sign.Enabled = true
    else
      sign.Frame.Description.Visible = true
      sign.Frame.Shadow.Visible = false
      sign.Frame.Level.ImageColor3 = Color3.new(1, 1, 0.19607843137255)
      sign.Frame.Start.BackgroundColor3 = Color3.new(0, 0.58823529411765, 0)
      sign.Frame.Start.BorderColor3 = Color3.new(0, 0.31372549019608, 0)
      sign.Frame.Start.TextColor3 = Color3.new(0.7843137254902, 1, 0.7843137254902)
      sign.Frame.Start.AutoButtonColor = true
      sign.Enabled = true
    end
  end
end

  CheckSign = function(job_sign)
  
  local sign = job_sign.Sign
  local link = sign.link.Value
  local hit = game.Workspace:FindPartOnRay(Ray.new(torso.Position, Vector3.new(0, 1, 0) * 100), torso.Parent)
  if ((link.mobile.Value and job_sign.Position - torso.Position.magnitude < 20) or not hit or hit:IsDescendantOf(job_sign.Parent.Parent.Parent)) and not sign.Frame.Visible then
    spawn(function()
    
    sign.transition.Value = true
    sign.Frame.Visible = true
    local text = {sign.Frame.Wage, sign.Frame.Title, sign.Frame.Description, sign.Frame.Start, sign.Frame.Level.Label, sign.Frame.Shadow.Description}
    for d = 1, #text do
      text[d].TextStrokeTransparency = 1
    end
    for x = 1, 30 do
      sign.Frame.BackgroundTransparency = 1 - x / 60
      sign.Frame.Level.ImageTransparency = 1 - x / 30
      sign.Frame.Start.BackgroundTransparency = 1 - 0.8 * (x / 30)
      sign.Frame.Shadow.BackgroundTransparency = 1 - 0.7 * (x / 30)
      for d = 1, #text do
        text[d].TextTransparency = 1 - x / 30
      end
      wait(0.03125)
    end
    for x = 1, 15 do
      for d = 1, #text do
        text[d].TextStrokeTransparency = 1 - x / 30
      end
      wait(0.03125)
    end
    sign.transition.Value = false
  end
)
  end
  if sign.Frame.Visible then
    sign.Frame.Visible = false
  end
end

  spawn(function()
  
  while 1 do
    wait(1)
    for d = 1, #signs do
      CheckSign(signs[d])
    end
  end
end
)
  for d = 1, #signs do
    local sign = game.ReplicatedStorage.Sign:clone()
    sign.Parent = signs[d]
    local list = game.ReplicatedStorage.JobDirectory:GetChildren()
    for t = 1, #list do
      if list[t].Value == tonumber(signs[d].Parent.Name) then
        signs[d].Sign.link.Value = list[t]
      end
    end
    local link = signs[d].Sign.link.Value
    UpdateSign(signs[d])
    signs[d].Sign.Frame.Start.MouseButton1Down:connect(function()
  
  if link.worker.Value == "" and link.stats.rep.minimum.Value <= _G.Level then
    player.PlayerGui.music.job.getjob:Play()
    _G.AttemptQuit(true)
    _G.SendMessage("You started a shift at " .. link.assets.Value.Parent.title.Value .. "!", "Green")
    _G.Events.LinkJobAndReturn:InvokeServer(link)
    _G.StartShift()
    UpdateJobSigns()
  end
end
)
  end
  UpdateJobSigns = function(force_off)
  
  if force_off or _G.shifting then
    for d = 1, #signs do
      signs[d].Sign.Enabled = false
      signs[d].Size = Vector3.new(0.2, 0.2, 0.2)
    end
  else
    do
      for d = 1, #signs do
        signs[d].Size = Vector3.new(3, 4, 0.2)
        UpdateSign(signs[d])
      end
    end
  end
end

  _G.UpdateJobSigns = UpdateJobSigns
  game.Workspace.Remote.UpdateJobSigns.OnClientEvent:connect(UpdateJobSigns)
  repeat
    wait(1)
  until main.UI.Visible
  local uiservice = game:GetService("UserInputService")
  local menus = {wardrobe, outfit, jobs, container, hairstyle, rent, shop}
  CloseDialogues = function()
  
  for d = 1, #menus do
    menus[d].Visible = false
    binfo.Visible = false
  end
end

  for d = 1, #menus do
    menus[d].Changed:connect(function()
  
  if uiservice.GamepadEnabled and menus[d].Visible and not menus[d]:FindFirstChild("Cancel") then
    binfo.Visible = true
  else
    binfo.Visible = false
  end
end
)
  end
  CheckForClosure = function()
  
  local thing = true
  for d = 1, #menus do
    if menus[d].Visible then
      thing = false
    end
  end
  if thing then
    onClick()
  end
end

  coroutine.resume(coroutine.create(function()
  
  while 1 do
    wait(0.0625)
    if uiservice.GamepadEnabled then
      if camera.CoordinateFrame.p - head.Position.magnitude < 1 then
        dot.Visible = true
      else
        dot.Visible = false
      end
      ResetInfo()
      onMove()
    end
  end
end
))
  local sprinting = false
  game:GetService("UserInputService").InputBegan:connect(function(input)
  
  if input.KeyCode.Name == "LeftShift" and not Intrusive() then
    sprinting = true
  end
end
)
  game:GetService("UserInputService").InputEnded:connect(function(input)
  
  if input.KeyCode.Name == "LeftShift" then
    sprinting = false
  end
end
)
  local white = main.Effects.White
  local black = main.Effects.Black
  SetTunnel = function(tunnel, level)
  
  tunnel.BackgroundTransparency = (level + 1) / 2
  tunnel.Tunnel.ImageTransparency = (2 * level + 1) / 3
end

  CalculateWalkSpeed = function()
  
  local base = (camera.CameraType == Enum.CameraType.Scriptable and 0) or (sprinting and 20) or 14
  if energy < 250 then
    base = base - 4 + energy / 63
  end
  humanoid.WalkSpeed = base
end

  CalculateTunnels = function()
  
  SetTunnel(white, energy / 250)
  SetTunnel(black, health / 250)
end

  local doordebounce = 0
  CheckDoors = function()
  
  local ray = Ray.new(torso.Position, torso.CFrame.lookVector * 2.5)
  local hit = game.Workspace:FindPartOnRay(ray, player.Character)
  if hit and hit.Name == "CloseDoor" and game.Workspace.DistributedGameTime - doordebounce > 1 then
    doordebounce = game.Workspace.DistributedGameTime
    ToggleDoor(hit, true)
  end
end

  spawn(function()
  
  while 1 do
    wait(0.0625)
    CalculateTunnels()
    CalculateWalkSpeed()
    local ra = Ray.new(torso.Position, Vector3.new(0, -10, 0))
    local hit = game.Workspace:FindPartOnRay(ra, player.Character)
    if hit then
      if CheckParking(hit) and not Intrusive() and #pstats.vehicles:GetChildren() > 0 then
        spawner.spot.Value = hit
        spawner.Visible = true
      else
        spawner.Visible = false
      end
    end
    if CheckForDrop() or container.Visible then
      button1.TextColor3 = Color3.new(1, 1, 1)
    else
      button1.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    end
    CheckDoors()
  end
end
)
  humanoid.HealthChanged:connect(function()
  
  if humanoid.Health < 100 then
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    health = 0
    PerformChecks()
  end
end
)
  pstats.job.Changed:connect(function()
  
  GetUp()
end
)
  PerformChecks = function()
  
  if health <= 0 then
    health = 1000
    energy = 1000
    ui.Visible = false
    if sitting or laying then
      GetUp()
    end
    _G.DeathSequence()
    if _G.Deobfuscate(pstats.cash.Value) > 200000 then
      pstats.cash.Value = _G.Obfuscate(_G.Deobfuscate(pstats.cash.Value) - 10000)
      _G.SendMessage("You paid " .. _G.FormatCash(10000) .. " in medical bills.", "Red")
    else
      if _G.Deobfuscate(pstats.cash.Value) > 20000 then
        local price = math.floor(_G.Deobfuscate(pstats.cash.Value) * 0.0005) * 100
        pstats.cash.Value = _G.Obfuscate(_G.Deobfuscate(pstats.cash.Value) - price)
        _G.SendMessage("You paid " .. _G.FormatCash(price) .. " in medical bills.", "Red")
      else
        do
          _G.SendMessage("Your medical bill was fully covered.", "Red")
          if not main.Billiards.Visible and inv.Visible then
            if laying then
              energy = energy + 20
              if energy > 1000 then
                energy = 1000
              end
            else
              if energy > 0 then
                if sprinting then
                  energy = energy - 2
                else
                  energy = energy - 1
                end
                if energy < 0 then
                  energy = 0
                end
                if health < 1000 then
                  health = health + 1
                end
              else
                if health > 100 then
                  health = health - 2
                end
              end
            end
          end
        end
      end
    end
  end
end

  while 1 do
    wait(2)
    PerformChecks()
    CheckBars()
  end
end

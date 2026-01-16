-- params : ...

_G.onJob = function(pstats, jobid, escrito)
  
  if pstats.job.Value ~= jobid then
    escrito:Destroy()
  end
end

_G.RemoveFigure = function(fig)
  
  if fig then
    local thig = fig:GetChildren()
    for g = 1, #thig do
      thig[g].Transparency = 1
      thig[g].CanCollide = false
    end
  end
end

_G.CreateFigure = function(fig)
  
  local thig = fig:GetChildren()
  for g = 1, #thig do
    thig[g].Transparency = 0
    thig[g].CanCollide = true
  end
end

_G.ConvertCash = function(cash)
  
  local str = tostring(cash / 100)
  local add = ""
  if cash < 1000 then
    if string.len(str) == 3 then
      add = "0"
    else
      if string.len(str) == 1 then
        add = ".00"
      end
    end
  else
    if cash < 10000 then
      if string.len(str) == 4 then
        add = "0"
      else
        if string.len(str) == 2 then
          add = ".00"
        end
      end
    end
  end
  return "$" .. str .. add
end

_G.FormatCash = function(cash)
  
  local str = tostring(cash / 100)
  local add = ""
  if cash < 1000 then
    if string.len(str) == 3 then
      add = "0"
    else
      if string.len(str) == 1 then
        add = ".00"
      end
    end
  else
    if cash < 10000 then
      if string.len(str) == 4 then
        add = "0"
      else
        if string.len(str) == 2 then
          add = ".00"
        end
      end
    else
      if cash < 100000 then
        if string.len(str) == 5 then
          add = "0"
        else
          if string.len(str) == 3 then
            add = ".00"
          end
        end
      else
        if cash < 1000000 then
          if string.len(str) == 6 then
            add = "0"
          else
            if string.len(str) == 4 then
              add = ".00"
            end
          end
        else
          if cash < 10000000 then
            if string.len(str) == 7 then
              add = "0"
            else
              if string.len(str) == 5 then
                add = ".00"
              end
            end
          else
            if cash < 100000000 then
              if string.len(str) == 8 then
                add = "0"
              else
                if string.len(str) == 6 then
                  add = ".00"
                end
              end
            end
          end
        end
      end
    end
  end
  return "$" .. str .. add
end

_G.AwardRep = function(successes, failures, linkedjob, rep, pstats)
  
  local linkstats = linkedjob.stats
  local total = math.min(math.max(math.floor(successes * linkstats.rep.gain.Value - failures * linkstats.rep.loss.Value), 0), 100)
  if total > 9 and pstats.character.Value < 99 then
    total = 9
  end
  _G.Events.ChangeRep:FireServer(total, linkedjob)
  _G.SendMessage("You got paid and received " .. total .. " job experience.", "White")
end

_G.Contains = function(mesa, thing)
  
  for g = 1, #mesa do
    if mesa[g] == thing then
      return g
    end
  end
  return false
end

_G.Events = game.Workspace.Remote
_G.PlaySuccess = function()
  
  script.Parent.Parent.music.job.success:Play()
end

_G.PlayPartial = function()
  
  script.Parent.Parent.music.job.partial:Play()
end

_G.PlayFailure = function()
  
  script.Parent.Parent.music.job.failure:Play()
end

_G.SuccessSparkles = function(target)
  
  spawn(function()
    
    local sparkles = game.ReplicatedStorage.Effects.Success:clone()
    sparkles.Enabled = true
    sparkles.Parent = target
    wait(0.25)
    sparkles.Enabled = false
    wait(1)
    sparkles:Destroy()
  end
)
end

_G.FailureSparkles = function(target)
  
  spawn(function()
    
    local sparkles = game.ReplicatedStorage.Effects.Failure:clone()
    sparkles.Enabled = true
    sparkles.Parent = target
    wait(0.25)
    sparkles.Enabled = false
    wait(1)
    sparkles:Destroy()
  end
)
end

_G.Lerp = function(v1, v2, am)
  
  return v1 * (1 - am) + v2 * am
end

local directory = game.ReplicatedStorage.JobDirectory:GetChildren()
FindLinkedJob = function(jobid)
  
  for t = 1, #directory do
    if directory[t].Value == jobid then
      return directory[t]
    end
  end
end

_G.LinkedJob = 0
local player = game.Players.LocalPlayer
local pstats = player:WaitForChild("playerstats")
pstats.job.Changed:connect(function()
  
  _G.LinkedJob = pstats.job.Value
end
)
local levels = {10, 100, 200, 350, 550, 800, 1100, 1450, 1850, 2300, 2800, 3350, 3950, 4600, 5300, 6050, 6850, 7700, 8600, 10000}
local main = script.Parent.Parent:WaitForChild("Main")
local repgui = main.UI.Reputation
local levelgui = main.UI.LevelUp
local stars = levelgui:GetChildren()
LevelSequence = function(oldlevel, newlevel)
  
  player.PlayerGui.music.job.drumroll:Play()
  for d = 1, #stars do
    stars[d].Visible = false
    stars[d].ImageTransparency = 0.3
  end
  levelgui.Visible = true
  levelgui.Text = "Level " .. oldlevel
  for i = 1, 30 do
    levelgui.TextTransparency = 1 - i / 30
    levelgui.TextStrokeTransparency = 1 - i / 60
    wait(0.03125)
  end
  wait(1)
  levelgui.Text = "Level " .. newlevel
  player.PlayerGui.music.job.drumroll:Stop()
  player.PlayerGui.music.job.level2:Play()
  spawn(function()
    
    for _ = 1, 36 do
      levelgui.TextColor3 = BrickColor.Random().Color
      for d = 1, #stars do
        stars[d].Visible = true
        local size = math.random(20, 80)
        stars[d].Size = UDim2.new(0, size, 0, size)
        stars[d].ImageColor3 = BrickColor.Random().Color
        stars[d].Rotation = math.random(0, 360)
        stars[d].Position = UDim2.new(math.random(-70, 170) / 100, -size / 2, math.random(-70, 170) / 100, -size / 2)
      end
      wait(0.16666666666667)
    end
    levelgui.TextColor3 = Color3.new(1, 0.7843137254902, 0)
  end
)
  wait(3.5)
  for i = 29, 0, -1 do
    levelgui.TextTransparency = 1 - i / 30
    levelgui.TextStrokeTransparency = 1 - i / 60
    for d = 1, #stars do
      stars[d].ImageTransparency = 0.3 + 0.7 * (1 - i / 30)
    end
    wait(0.03125)
  end
  levelgui.Visible = false
end

rep = pstats.job.reputation
FindLevel = function(val)
  
  for z = 1, #levels do
    if val < levels[z] then
      return z - 1
    end
  end
  return 20
end

ChangeRep = function()
  
  local newlevel = FindLevel(rep.Value)
  do
    if newlevel ~= _G.Level then
      local oldlevel = _G.Level
      do
        spawn(function()
    
    LevelSequence(oldlevel, newlevel)
  end
)
        _G.Level = newlevel
        repgui.Label.Text = newlevel
        _G.UpdateJobSigns()
      end
    end
    local nowlevel = _G.Level
    local nextlevel = _G.Level + 1
    local progress = 1
    if nowlevel == 0 then
      progress = rep.Value / levels[nextlevel]
    else
      if nextlevel <= 20 then
        progress = (rep.Value - levels[nowlevel]) / (levels[nextlevel] - levels[nowlevel])
      end
    end
    repgui.Bar.Size = UDim2.new(1, 0, -0.1 - progress * 0.8, 0)
  end
end

_G.Level = FindLevel(rep.Value)
repgui.Label.Text = _G.Level
rep.Changed:connect(ChangeRep)
ChangeRep()
repgui.MouseEnter:connect(function()
  
  repgui.Hint.Text = rep.Value .. " XP"
  if _G.Level == 20 then
    repgui.Hint.Next.Text = "Level 21 in"
    repgui.Hint.Next.XP.Text = "never"
  else
    repgui.Hint.Next.Text = "Level " .. _G.Level + 1 .. " in"
    repgui.Hint.Next.XP.Text = levels[_G.Level + 1] - rep.Value .. " XP"
  end
  repgui.Hint.Visible = true
end
)
repgui.MouseLeave:connect(function()
  
  repgui.Hint.Visible = false
end
)

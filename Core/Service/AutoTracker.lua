local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local Log = TE.Include("Util.Log")
local Icon = TE.Include("Service.Icon")
local AutoTracker = TE.Include("Service.AutoTracker")
local Settings = TE.Include("Service.Settings")
local TrackingSpells = TE.Include("Data.TrackingSpells")
local MyLib = TE.Include("Util.MyLib")
local L = TE.Include("Locale")

local private = {
  IS_MOVING = false,
  IS_PAUSED = true,
  PAUSE_DELEY = 3,
  GAME_EVENTS = {
    PAUSE_TRIGGER_EVENTS = {
      ["PLAYER_REGEN_ENABLED"] = true,
      ["PLAYER_REGEN_DISABLED"] = true,
      ["PLAYER_DEAD"] = true,
      ["PLAYER_ALIVE"] = true,
      ["PLAYER_UNGHOST"] = true,
      ["PLAYER_UPDATE_RESTING"] = true,
    },
    TEMP_PAUSE_EVENTS = {
      ["UNIT_SPELLCAST_SENT"] = true,
      ["UNIT_SPELLCAST_STOP"] = true,
      ["UI_ERROR_MESSAGE"] = {
        [ERR_NO_ATTACK_TARGET] = true,
        [ERR_SPELL_COOLDOWN] = true,
        [ERR_ABILITY_COOLDOWN] = true,
        [ERR_ITEM_COOLDOWN] = true,
        [ERR_GENERIC_NO_TARGET] = true,
        [ERR_OUT_OF_RAGE] = true,
        [ERR_BADATTACKFACING] = true,
        [SPELL_FAILED_LINE_OF_SIGHT] = true,
        [ERR_USE_TOO_FAR] = true,
        [SPELL_FAILED_NOPATH] = true,
        [SPELL_FAILED_MOVING] = true,
        [ERR_BADATTACKPOS] = true,
        [ERR_OUT_OF_RANGE] = true,
        [SPELL_FAILED_NOT_BEHIND] = true,
      },
    },
    MOVE_EVENTS = {
      ["PLAYER_STARTED_MOVING"] = true,
      ["PLAYER_STOPPED_MOVING"] = true,
    },
  },
  USER_EVENTS = {
    ["TRACKING_TYPES_CHANGED"] = true,
    ["INTERVAL_CHANGED"] = true,
    ["ADDON_TOGGLED"] = true,
    ["MODE_TOGGLED"] = true,
  },
}

-- ===========================================================================
--                            Module methods
-- ===========================================================================

function AutoTracker:OnInitialize()
  self:RegisterUserEvents(private.USER_EVENTS, "EventHandler")
  self:RegisterEvents(private.GAME_EVENTS.MOVE_EVENTS, "EventHandler")

  if TE.db.profile.general.enable then
    self:RegisterEvents(private.GAME_EVENTS.PAUSE_TRIGGER_EVENTS, "EventHandler")
    self:RegisterEvents(private.GAME_EVENTS.TEMP_PAUSE_EVENTS, "EventHandler")
  end
end

function AutoTracker:OnEnable()
  if not TE.db.profile.general.onmove then self:TempPause(2) end -- start timer after 2 cesonds of pause. It helps to avoid GCD after reloading.
end

function AutoTracker:Toggle()
  if private.IS_PAUSED then 
    AutoTracker:StartTimer()
  else 
    AutoTracker:StopTimer()
  end
end

function AutoTracker:StartTimer()
  local canStart = TE.db.profile.general.enable and private.IS_PAUSED and self:isCanCast()
  if TE.db.profile.general.onmove then canStart = canStart and private.IS_MOVING end

  if canStart then
    -- print("START TIMER")

    self:CastNextSpell()
    AutoTracker.trackingTimer = AutoTracker:ScheduleRepeatingTimer("TimersFeedback", Settings:GetCastInterval())
    private.IS_PAUSED = false
  end

end

function AutoTracker:StopTimer()
  -- print("STOP TIMER")
  if AutoTracker.trackingTimer then
    AutoTracker:CancelTimer(AutoTracker.trackingTimer)
  end

  private.IS_PAUSED = true
end

function AutoTracker:UpdateTimer()
  if not private.IS_PAUSED then
    AutoTracker:CancelTimer(AutoTracker.trackingTimer)
    AutoTracker.trackingTimer = AutoTracker:ScheduleRepeatingTimer("TimersFeedback", Settings:GetCastInterval())
  end
end

function AutoTracker:TempPause(seconds)
  if TE.db.profile.general.enable then
    self:StopTimer()
    self.trackingTimer = self:ScheduleTimer(function() self:StartTimer() end, seconds)
  end
end

function AutoTracker:TimersFeedback()

  -- print("TimersFeedback")
  if TE.db.profile.general.onmove and not private.IS_MOVING then 
    self:StopTimer()
  end

  self:CastNextSpell()
end

function AutoTracker:CastNextSpell()
  local currentTrackingSpellID = self:GetCurrentTrackingSpellID()
  local nextSpellID = self:GetNextSpellID(currentTrackingSpellID)

  
  if not nextSpellID then -- stop timer and return, if no next spell to track
    self:StopTimer()
    return
  end 

  if TE.db.profile.general.muteSpellUseSound then 
    SetCVar("Sound_EnableSFX","0") 
    CastSpellByID(nextSpellID) 
    SetCVar("Sound_EnableSFX","1")
  else
    CastSpellByID(nextSpellID)
  end
end

function AutoTracker:GetCurrentTrackingSpellID()
  local spellInfo = TrackingSpells.GetDataByKey("spellInfo")
  local currentTrackingIconId = GetTrackingTexture()
  local currentTrackingSpellId = nil

  if currentTrackingIconId then
    for key, val in pairs(spellInfo) do
      if spellInfo[key].iconId == currentTrackingIconId then
        currentTrackingSpellId = spellInfo[key].spellId
        return currentTrackingSpellId
      end 
    end
  end

  return currentTrackingSpellId
end

function AutoTracker:GetNextSpellID(currentSpellId)
  local trackingSpells = Settings:GetSpellsToTrack()
  
  if not trackingSpells then return nil end -- return nil if no spells to track

  if not currentSpellId then currentSpellId = self:GetCurrentTrackingSpellID() end

  if not currentSpellId then return trackingSpells[1] end -- return first spell if nothing is being tracked yet

  local currentSpellIndex = MyLib.IndexOf(trackingSpells, currentSpellId)

  if not currentSpellIndex then currentSpellIndex = 0 end -- if no spellInfex found then start index will be 0

  local trackingSpellsNum = MyLib.GetTableLength(trackingSpells)
  local nextIndex = MyLib.GetNextNumInRange(currentSpellIndex, trackingSpellsNum)
  local nextSpellId = trackingSpells[nextIndex]
  
  if nextSpellId == currentSpellId then return nil end -- if next spell == current tracking spell, then nothing to switch

  return nextSpellId
end

function AutoTracker:isCanCast()
  local canCast = not (self:isNextSpellOnCooldown() or CastingInfo() or ChannelInfo() or UnitIsDeadOrGhost("player") or IsResting() or UnitAffectingCombat("player") or InCombatLockdown())
  return canCast
end

function AutoTracker:isNextSpellOnCooldown()
  local currentTrackingSpellID = self:GetCurrentTrackingSpellID()
  local nextSpellID = self:GetNextSpellID(currentTrackingSpellID)

  if not nextSpellID or GetSpellCooldown(nextSpellID) ~= 0 then return true else return false end
end


function AutoTracker:isPaused()
  return private.IS_PAUSED
end

function AutoTracker:test()
  self:Print(TE.db.profile.general.enable)
end

-- =================================================================================
--                              Event handl functions
-- =================================================================================
function AutoTracker:EventHandler(...)
  local event, arg1, arg2, arg3, arg4 = ...
  -- print(event)

  if private.GAME_EVENTS.PAUSE_TRIGGER_EVENTS[event] then
    self:Toggle()
  elseif private.GAME_EVENTS.TEMP_PAUSE_EVENTS[event] then
    if event == "UI_ERROR_MESSAGE" then
      if not private.GAME_EVENTS.TEMP_PAUSE_EVENTS[event][arg2] then return end -- return if arg2 don"t match the list
    elseif event == "UNIT_SPELLCAST_SENT" then
      if arg1 ~= "player" or MyLib.IndexOf(Settings:GetSpellsToTrack(), arg4) then return end -- return if cast made not by player or player casted trackingSpell
    end
    self:TempPause(private.PAUSE_DELEY)
  elseif private.GAME_EVENTS.MOVE_EVENTS[event] then
    if event == "PLAYER_STARTED_MOVING" then
      private.IS_MOVING = true
      if TE.db.profile.general.onmove then
        self:StartTimer()
        if self:isNextSpellOnCooldown() then -- try one more time if spell was on CD
          self:StopTimer()
          self.trackingTimer = self:ScheduleTimer("StartTimer", Settings:GetCastInterval())
        end
      end
    elseif event == "PLAYER_STOPPED_MOVING" then
      private.IS_MOVING = false
      if TE.db.profile.general.onmove then self:StopTimer() end
    end
  elseif private.USER_EVENTS[event] then
    if event == "ADDON_TOGGLED" then
      if TE.db.profile.general.enable then
        self:RegisterEvents(private.GAME_EVENTS.PAUSE_TRIGGER_EVENTS, "EventHandler")
        self:RegisterEvents(private.GAME_EVENTS.TEMP_PAUSE_EVENTS, "EventHandler")
        if not TE.db.profile.general.onmove or private.IS_MOVING then self:StartTimer() end
      else
        self:UnregisterEvents(private.GAME_EVENTS.PAUSE_TRIGGER_EVENTS, "EventHandler")
        self:UnregisterEvents(private.GAME_EVENTS.TEMP_PAUSE_EVENTS, "EventHandler")
        self:StopTimer()
      end
    elseif event == "MODE_TOGGLED" then
      if TE.db.profile.general.enable then
        if TE.db.profile.general.onmove and not private.IS_MOVING then
          self:StopTimer()
        else
          self:StartTimer()
        end
      end
    elseif event == "INTERVAL_CHANGED" then
      self:UpdateTimer()
    elseif event == "TRACKING_TYPES_CHANGED" then
      if not TE.db.profile.general.onmove or private.IS_MOVING then self:StartTimer() end
    end
  end
end

function AutoTracker:RegisterEvents(eventTable, func)
  for key, val in pairs(eventTable) do
    if val then
      self:RegisterEvent(key, func)
    end
  end
end

function AutoTracker:RegisterUserEvents(eventTable, func)
  for key, val in pairs(eventTable) do
    if val then
      self:RegisterMessage(key, func)
    end
  end
end

function AutoTracker:UnregisterEvents(eventTable)
  for key, val in pairs(eventTable) do
    if val then
      self:UnregisterEvent(key)
    end
  end
end

function AutoTracker:UnregisterUserEvents(eventTable)
  for key, val in pairs(eventTable) do
    if val then
      self:UnregisterMessage(key)
    end
  end
end

-- =================================================================================
--                              Private module functions
-- =================================================================================

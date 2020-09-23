local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local Log = TE.Include("Util.Log")
local SpellSwitcher = TE.Include("Service.SpellSwitcher")
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
      ["UNIT_SPELLCAST_STOP"] = true,
      ["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
    },
    TEMP_PAUSE_EVENTS = {
      ["UNIT_SPELLCAST_SENT"] = true,
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
    ["SPELL_SWITCHER_TOGGLED"] = true,
    ["SPELL_SWITCHER_MODE_TOGGLED"] = true,
    ["SPELL_SWITCHER_INTERVAL_CHANGED"] = true,
    ["SPELL_SWITCHER_TRACKING_TYPES_CHANGED"] = true,
  },
  Sound_EnableSFX_default = GetCVar("Sound_EnableSFX"),
}

-- ===========================================================================
--                            Module methods
-- ===========================================================================

function SpellSwitcher:OnInitialize()
  self:RegisterUserEvents(private.USER_EVENTS, "EventHandler")
  self:RegisterEvents(private.GAME_EVENTS.MOVE_EVENTS, "EventHandler")

  if TE.db.profile.autoTracking.spellSwitcher.enabled then
    self:RegisterEvents(private.GAME_EVENTS.PAUSE_TRIGGER_EVENTS, "EventHandler")
    self:RegisterEvents(private.GAME_EVENTS.TEMP_PAUSE_EVENTS, "EventHandler")
  end
end

function SpellSwitcher:OnEnable()
  if TE.db.profile.autoTracking.spellSwitcher.enabled and not TE.db.profile.autoTracking.spellSwitcher.onmove then 
    self.trackingTimer = self:ScheduleTimer(function() self:StartTimer() end, 2) -- start timer after 2 cesonds of pause. It helps to avoid GCD after reloading.
  end 
end

function SpellSwitcher:OnDisable()
  if private.Sound_EnableSFX_default ~= GetCVar("Sound_EnableSFX") then SetCVar("Sound_EnableSFX", private.Sound_EnableSFX_default) end
end

function SpellSwitcher:Toggle()
  if private.IS_PAUSED then
    SpellSwitcher:StartTimer()
  else 
    SpellSwitcher:StopTimer()
  end
end

function SpellSwitcher:StartTimer()
  local canStart = private.IS_PAUSED and self:CanCast()
  -- print("canStart", canStart)

  if canStart then
    -- print("START TIMER")
    SpellSwitcher.trackingTimer = SpellSwitcher:ScheduleRepeatingTimer("CastNextSpell", Settings:GetCastInterval())
    private.IS_PAUSED = false
  end
end

function SpellSwitcher:StopTimer()
  -- print("STOP TIMER")
  if SpellSwitcher.trackingTimer then
    SpellSwitcher:CancelTimer(SpellSwitcher.trackingTimer)
  end

  private.IS_PAUSED = true
end

function SpellSwitcher:UpdateTimer()
  self:StopTimer()
  self:StartTimer()
end

function SpellSwitcher:TempPause(seconds)
  if not private.IS_PAUSED then
    self:StopTimer()
    self.trackingTimer = self:ScheduleTimer(function() self:StartTimer() end, seconds)
  end
end

function SpellSwitcher:CastNextSpell()
  -- print("CAST_NEXT_SPELL")
  local currentTrackingSpellID = TrackingSpells:GetCurrentTrackingSpellID()
  local nextSpellID = self:GetNextSpellID(currentTrackingSpellID)

  
  if not nextSpellID then -- stop timer and return, if no next spell to track
    self:StopTimer()
    return
  end 

  if TE.db.profile.autoTracking.general.muteSpellUseSound then
    SetCVar("Sound_EnableSFX", "0") 
    CastSpellByID(nextSpellID) 
    SetCVar("Sound_EnableSFX", "1")
  else
    CastSpellByID(nextSpellID)
  end
end

function SpellSwitcher:GetNextSpellID(currentSpellId)
  local trackingSpells = Settings:GetSpellsToTrack()
  
  if not trackingSpells then return nil end -- return nil if no spells to track

  if not currentSpellId then currentSpellId = TrackingSpells:GetCurrentTrackingSpellID() end

  if not currentSpellId then return trackingSpells[1] end -- return first spell if nothing is being tracked yet

  local currentSpellIndex = MyLib.IndexOf(trackingSpells, currentSpellId)

  if not currentSpellIndex then currentSpellIndex = 0 end -- if no spellInfex found then start index will be 0

  local trackingSpellsNum = MyLib.GetTableLength(trackingSpells)
  local nextIndex = MyLib.GetNextNumInRange(currentSpellIndex, trackingSpellsNum)
  local nextSpellId = trackingSpells[nextIndex]
  
  if nextSpellId == currentSpellId then return nil end -- if next spell == current tracking spell, then nothing to switch

  return nextSpellId
end

function SpellSwitcher:CanCast()
  local canCast = private.IS_PAUSED and not (CastingInfo() or ChannelInfo() or UnitIsDeadOrGhost("player") or IsResting() or UnitAffectingCombat("player") or InCombatLockdown())
  if TE.db.profile.autoTracking.spellSwitcher.onmove then canCast = canCast and private.IS_MOVING end

  return canCast
end

function SpellSwitcher:isNextSpellOnCooldown()
  local currentTrackingSpellID = TrackingSpells:GetCurrentTrackingSpellID()
  local nextSpellID = self:GetNextSpellID(currentTrackingSpellID)

  if not nextSpellID or GetSpellCooldown(nextSpellID) ~= 0 then return true else return false end
end


function SpellSwitcher:isPaused()
  return private.IS_PAUSED
end

function SpellSwitcher:test()
  self:Print(TE.db.profile.autoTracking.spellSwitcher.enabled)
end

-- =================================================================================
--                              Event handl functions
-- =================================================================================
function SpellSwitcher:EventHandler(...)
  local event, arg1, arg2, arg3, arg4 = ...
  -- print("SpellSwitcher", event)

  if private.GAME_EVENTS.MOVE_EVENTS[event] then
    if event == "PLAYER_STARTED_MOVING" then
      private.IS_MOVING = true
    elseif event == "PLAYER_STOPPED_MOVING" then
      private.IS_MOVING = false
    end
  elseif event == "SPELL_SWITCHER_TOGGLED" then
    if TE.db.profile.autoTracking.spellSwitcher.enabled then
      self:StartTimer()
      self:RegisterEvents(private.GAME_EVENTS.PAUSE_TRIGGER_EVENTS, "EventHandler")
      self:RegisterEvents(private.GAME_EVENTS.TEMP_PAUSE_EVENTS, "EventHandler")
    else
      self:StopTimer()
      self:UnregisterEvents(private.GAME_EVENTS.PAUSE_TRIGGER_EVENTS, "EventHandler")
      self:UnregisterEvents(private.GAME_EVENTS.TEMP_PAUSE_EVENTS, "EventHandler")
    end
  end

  if TE.db.profile.autoTracking.spellSwitcher.enabled then
    if private.GAME_EVENTS.PAUSE_TRIGGER_EVENTS[event] or ( private.GAME_EVENTS.MOVE_EVENTS[event] and TE.db.profile.autoTracking.spellSwitcher.onmove ) then
      self:Toggle()
    elseif private.GAME_EVENTS.TEMP_PAUSE_EVENTS[event] then
      if event == "UI_ERROR_MESSAGE" then
        if not private.GAME_EVENTS.TEMP_PAUSE_EVENTS[event][arg2] then return end -- return if arg2 don"t match the list
      elseif event == "UNIT_SPELLCAST_SENT" then
        if arg1 ~= "player" or MyLib.IndexOf(Settings:GetSpellsToTrack(), arg4) then return end -- return if cast made not by player or player casted trackingSpell
      end
      self:TempPause(private.PAUSE_DELEY)
    elseif event == "SPELL_SWITCHER_MODE_TOGGLED" or event == "SPELL_SWITCHER_INTERVAL_CHANGED" or event == "SPELL_SWITCHER_TRACKING_TYPES_CHANGED" then
      self:UpdateTimer()
    end
  end
end

function SpellSwitcher:RegisterEvents(eventTable, func)
  for key, val in pairs(eventTable) do
    if val then
      self:RegisterEvent(key, func)
    end
  end
end

function SpellSwitcher:RegisterUserEvents(eventTable, func)
  for key, val in pairs(eventTable) do
    if val then
      self:RegisterMessage(key, func)
    end
  end
end

function SpellSwitcher:UnregisterEvents(eventTable)
  for key, val in pairs(eventTable) do
    if val then
      self:UnregisterEvent(key)
    end
  end
end

function SpellSwitcher:UnregisterUserEvents(eventTable)
  for key, val in pairs(eventTable) do
    if val then
      self:UnregisterMessage(key)
    end
  end
end

-- =================================================================================
--                              Private module functions
-- =================================================================================

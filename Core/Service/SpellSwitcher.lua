local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local Log = TE.Include("Util.Log")
local SpellSwitcher = TE.Include("SpellSwitcher")
local Settings = TE.Include("Settings")
local MyLib = TE.Include("Util.MyLib")

local CastSpellByID, GetCVar, SetCVar, GetShapeshiftForm, CastingInfo, ChannelInfo, UnitIsDeadOrGhost, IsResting, UnitAffectingCombat, InCombatLockdown, GetSpellCooldown, UnitClass,GetTrackingInfo = CastSpellByID, GetCVar, SetCVar, GetShapeshiftForm, CastingInfo, ChannelInfo, UnitIsDeadOrGhost, IsResting, UnitAffectingCombat, InCombatLockdown, GetSpellCooldown, UnitClass, GetTrackingInfo

local _, PLAYER_CLASS = UnitClass("player")

local private = {
  IS_MOVING = false,
  IS_PAUSED = true,
  TEMP_PAUSE_DELEY = 3,
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
      ["UPDATE_SHAPESHIFT_FORM"] = true,
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
    ["SPELL_SWITCHER_FORCE_IN_COMBAT_TOGGLED"] = true,
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
    self.trackingTimer = self:ScheduleTimer(function()
      self:StartTimer()
    end, 2) -- start timer after 2 cesonds of pause. It helps to avoid GCD after reloading.
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
  --local canStart = private.IS_PAUSED and self:CanCast()
  local canStart = self:CanCast()

  if canStart then
    Log:PrintfD("START TIMER")
    SpellSwitcher.trackingTimer = SpellSwitcher:ScheduleRepeatingTimer("CastNextSpell", Settings:GetCastInterval())
    private.IS_PAUSED = false
  end
end

function SpellSwitcher:StopTimer()
  Log:PrintfD("STOP TIMER")
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
  Log:PrintfD("CAST_NEXT_SPELL")
  local currentTrackingSpellID = self:GetCurrentTrackingSpellID()
  local nextSpellID = self:GetNextSpellID(currentTrackingSpellID)

  if not nextSpellID then -- stop timer and return, if no next spell to track
    self:StopTimer()
    return
  end

  if TE.db.profile.autoTracking.general.muteSpellUseSound and GetCVar("Sound_EnableSFX") == "1" then
    SetCVar("Sound_EnableSFX", "0")
    CastSpellByID(nextSpellID)
    SetCVar("Sound_EnableSFX", "1")
  else
    CastSpellByID(nextSpellID)
  end
end

function SpellSwitcher:GetCurrentTrackingSpellID()

  for i = 1, GetNumTrackingTypes() do
    local _, _, active, category, _, spellId = GetTrackingInfo(i);
    if category == "spell" and active == true then return spellId end
  end

end

function SpellSwitcher:GetNextSpellID(currentSpellId)
  local trackingSpells = Settings:GetSpellsToTrack()
  local nextSpellId = nil
  local currentSpellIndex
  local nextSpellIndex

  if trackingSpells then
    if currentSpellId then
      currentSpellIndex = MyLib.IndexOf(currentSpellId, trackingSpells) or 0
      nextSpellIndex = MyLib.GetNextNumInRange(currentSpellIndex, #trackingSpells)
    else
      nextSpellIndex = 1 -- return first spell if nothing is being tracked yet
    end

    nextSpellId = trackingSpells[nextSpellIndex]

    if PLAYER_CLASS == "DRUID" and nextSpellId == 5225 then
      if GetShapeshiftForm() ~= 3 then
        if #trackingSpells > 1 then
          local newSpellIndex = MyLib.GetNextNumInRange(nextSpellIndex, #trackingSpells)
          nextSpellId = trackingSpells[newSpellIndex]
        else
          nextSpellId = nil
        end
      end
    end

    if currentSpellId == nextSpellId then nextSpellId = nil end

  end

  return nextSpellId
end

function SpellSwitcher:CanCast()

  local canCast = private.IS_PAUSED and not ( CastingInfo() or ChannelInfo() or UnitIsDeadOrGhost("player") or IsResting() ) and ( TE.db.profile.autoTracking.spellSwitcher.forceInCombat or not UnitAffectingCombat("player") ) and ( not TE.db.profile.autoTracking.spellSwitcher.onmove or private.IS_MOVING )

  Log:PrintD("canCast = ", canCast)
  Log:PrintfD("forceInCombat = [%s], InCombatLockdown = [%s] , UnitAffectingCombat = [%s] ", tostring(TE.db.profile.autoTracking.spellSwitcher.forceInCombat), tostring(InCombatLockdown()), tostring(UnitAffectingCombat("player")))

  return canCast
end

function SpellSwitcher:isPaused()
  return private.IS_PAUSED
end

-- =================================================================================
--                              Event handl functions
-- =================================================================================
function SpellSwitcher:EventHandler(...)
  local event, arg1, arg2, _, arg4 = ...
  Log:PrintfD("SpellSwitcher: [%s]", event)

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
      if TE.db.profile.autoTracking.spellSwitcher.forceInCombat and (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED") then
        return
      elseif event == "UPDATE_SHAPESHIFT_FORM" then
        self:UpdateTimer()
      else
        self:Toggle()
      end
    elseif private.GAME_EVENTS.TEMP_PAUSE_EVENTS[event] then
      if event == "UI_ERROR_MESSAGE" then
        if not private.GAME_EVENTS.TEMP_PAUSE_EVENTS[event][arg2] then return end -- return if arg2 don"t match the list
      elseif event == "UNIT_SPELLCAST_SENT" then
        if arg1 ~= "player" or MyLib.IndexOf(arg4, Settings:GetSpellsToTrack()) then return end -- return if cast made not by player or player casted trackingSpell
      end
      self:TempPause(private.TEMP_PAUSE_DELEY)
    elseif event == "SPELL_SWITCHER_MODE_TOGGLED" or event == "SPELL_SWITCHER_INTERVAL_CHANGED" or event == "SPELL_SWITCHER_TRACKING_TYPES_CHANGED" or event == "SPELL_SWITCHER_FORCE_IN_COMBAT_TOGGLED" then
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
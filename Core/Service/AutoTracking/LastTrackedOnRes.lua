local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local LastTrackedOnRes = TE.Include("Service.LastTrackedOnRes")
local Settings = TE.Include("Service.Settings")
local TrackingSpells = TE.Include("Data.TrackingSpells")
local Log = TE.Include("Util.Log")
local MyLib = TE.Include("Util.MyLib")

local private = {
  CAST_INTERVAL = 5,
  TEMP_PAUSE_DELEY = 3,
  WAS_DEAD = false,
  IS_RUNNING = false,
  GAME_EVENTS = {
    ["PLAYER_ALIVE"] = true,
    ["PLAYER_UNGHOST"] = true,
    ["PLAYER_DEAD"] = true,
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
  USER_EVENTS = {
    ["LAST_TRACKED_ON_RES_TOGGLED"] = true,
    ["LAST_TRACKED_TIMER_START"] = true,
    ["LAST_TRACKED_TIMER_STOP"] = true,
    ["OPTIONS_RESET"] = true,
  },
  Sound_EnableSFX_default = GetCVar("Sound_EnableSFX"),
}

-- ===========================================================================
--                            Module methods
-- ===========================================================================

function LastTrackedOnRes:OnInitialize()
  self:RegisterEvent("MINIMAP_UPDATE_TRACKING", "EventHandler")
  self:RegisterUserEvents(private.USER_EVENTS, "EventHandler")

  if TE.db.profile.autoTracking.lastTrackedOnRes.enabled then
    self:RegisterEvents(private.GAME_EVENTS, "EventHandler")
  end
end

function LastTrackedOnRes:OnEnable()
  if not TE.db.profile.autoTracking.lastTrackedOnRes.spellId and not GetTrackingTexture() then private.DBSetCurrentTrackingSpellId() end
  if TE.db.profile.autoTracking.lastTrackedOnRes.spellId and not GetTrackingTexture() then self:StartTimer() end
end

function LastTrackedOnRes:OnDisable()
  if private.Sound_EnableSFX_default ~= GetCVar("Sound_EnableSFX") then SetCVar("Sound_EnableSFX", private.Sound_EnableSFX_default) end
end

function LastTrackedOnRes:StartTimer()
  if not private.IS_RUNNING then
    Log:PrintfD("START TIMER")
    self.castSpellTimer = self:ScheduleTimer("DoCast", private.CAST_INTERVAL)
    private.IS_RUNNING = true
    self:SendMessage("LAST_TRACKED_TIMER_START")
  end
end

function LastTrackedOnRes:StopTimer()
  if private.IS_RUNNING then
    Log:PrintfD("STOP TIMER")
    self:CancelAllTimers()
    private.IS_RUNNING = false
    self:SendMessage("LAST_TRACKED_TIMER_STOP")
  end
end

function LastTrackedOnRes:RenewTimer()
  Log:PrintfD("RENEW TIMER")
  self:StopTimer()
  self:StartTimer()
end

function LastTrackedOnRes:DoCast()
  if TE.db.profile.autoTracking.lastTrackedOnRes.spellId and self:CanCast() then
    if TE.db.profile.autoTracking.general.muteSpellUseSound then
      SetCVar("Sound_EnableSFX", "0") 
      CastSpellByID(TE.db.profile.autoTracking.lastTrackedOnRes.spellId)
      SetCVar("Sound_EnableSFX", "1")
    else
      CastSpellByID(TE.db.profile.autoTracking.lastTrackedOnRes.spellId)
    end
    self:StopTimer()
  end
end

function LastTrackedOnRes:CanCast()
  return not ( CastingInfo() or ChannelInfo() or UnitIsDeadOrGhost("player") or UnitAffectingCombat("player") or InCombatLockdown() )
end

-- =================================================================================
--                              Event handl functions
-- =================================================================================
function LastTrackedOnRes:EventHandler(...)
  local event, arg1, arg2, arg3, arg4 = ...
  Log:PrintfD("EVENT: [%s]", event)

  if event == "MINIMAP_UPDATE_TRACKING" or event == "OPTIONS_RESET" then
    private.DBSetCurrentTrackingSpellId()
  elseif event == "LAST_TRACKED_ON_RES_TOGGLED" then
    if TE.db.profile.autoTracking.lastTrackedOnRes.enabled then
      self:RegisterEvents(private.GAME_EVENTS, "EventHandler")
    else
      self:UnregisterEvents(private.GAME_EVENTS, "EventHandler")
    end
  elseif event == "LAST_TRACKED_TIMER_START" then
    self:RegisterEvents(private.TEMP_PAUSE_EVENTS, "EventHandler")
  elseif event == "LAST_TRACKED_TIMER_STOP" then
    self:UnregisterEvents(private.TEMP_PAUSE_EVENTS, "EventHandler")
  end

  if TE.db.profile.autoTracking.lastTrackedOnRes.enabled and not TE.db.profile.autoTracking.spellSwitcher.enabled and TE.db.profile.autoTracking.lastTrackedOnRes.spellId then
    if event == "PLAYER_DEAD" then
      private.WAS_DEAD = true
      self:StopTimer()
    elseif ( event == "PLAYER_UNGHOST" or ( event == "PLAYER_ALIVE" and not UnitIsDeadOrGhost("player") ) ) and private.WAS_DEAD then
      private.WAS_DEAD = false
      self:StartTimer()
    elseif private.TEMP_PAUSE_EVENTS[event] then
      if event == "UI_ERROR_MESSAGE" then
        if not private.TEMP_PAUSE_EVENTS[event][arg2] then return end -- return if arg2 don"t match the list
      elseif event == "UNIT_SPELLCAST_SENT" then
        if arg1 ~= "player" or MyLib.IndexOf(arg4, Settings:GetSpellsToTrack()) then return end -- return if cast made not by player or player casted trackingSpell
      end
      self:RenewTimer()
      self:RegisterEvents(private.TEMP_PAUSE_EVENTS, "EventHandler")
    end
  end
end

function LastTrackedOnRes:RegisterEvents(eventTable, func)
  for key, val in pairs(eventTable) do
    if val then
      self:RegisterEvent(key, func)
    end
  end
end

function LastTrackedOnRes:RegisterUserEvents(eventTable, func)
  for key, val in pairs(eventTable) do
    if val then
      self:RegisterMessage(key, func)
    end
  end
end

function LastTrackedOnRes:UnregisterEvents(eventTable)
  for key, val in pairs(eventTable) do
    if val then
      self:UnregisterEvent(key)
    end
  end
end

function LastTrackedOnRes:UnregisterUserEvents(eventTable)
  for key, val in pairs(eventTable) do
    if val then
      self:UnregisterMessage(key)
    end
  end
end

-- =================================================================================
--                              Private module functions
-- =================================================================================

function private.DBSetCurrentTrackingSpellId()
  LastTrackedOnRes.checkDeathTimer = LastTrackedOnRes:ScheduleTimer(function()
    Log:PrintfD("CHECK IS DEAD")
    if not UnitIsDeadOrGhost("player") then
      TE.db.profile.autoTracking.lastTrackedOnRes.spellId = TrackingSpells:GetCurrentTrackingSpellID()
    end
  end, 0.5)
end
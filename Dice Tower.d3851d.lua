function onSave()
  local rnd = Global.call('getRound')
  local tl = Global.call('getThreatLevel')
  local t = Global.call('getThreat')
  local rc = Global.call('getCredits')
  local x = Global.call('getXP')
  return JSON.encode({Round = rnd, ThreatLevel = tl, Threat = t, RebelCredits = rc, RebelXP = x})
end

function onLoad(save_state)
  if save_state ~= nil and save_state ~= "" then
    Global.call('setRound', JSON.decode(save_state).Round)
    Global.call('setThreatLevel', JSON.decode(save_state).ThreatLevel)
    Global.call('setThreat', JSON.decode(save_state).Threat)
    Global.call('setCredits', JSON.decode(save_state).RebelCredits)
    Global.call('setXP',JSON.decode(save_state).RebelXP)
  end
end
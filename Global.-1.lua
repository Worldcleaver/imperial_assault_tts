--Thanks to Mr. Thump for using his rolling dice function
--Thanks to BarKeep.  I integrated the use of his mod in mine.Thanks to nickschumann, I integrated his models into the mod
--Original Script By Flolania heavily modified by j2edline

-- HPBarWriter
--[[LUAStart
health = {value = 10, max = 10}

Strain = {value = 0, max = 4}

player = false

prefix = 'G'

single = true

baseColor = 'Black'

options = {
    HP2Desc = false,
    belowZero = false,
    aboveMax = false,
    heightModifier = 110,
    showBaseButtons = false,
    showBarButtons = false,
    hideStrain = false,
    incrementBy = 1,
    rotation = 180,
    ats = 'Activation_Start',
    wounded = false
}


function onLoad(save_state)
  if save_state ~= "" then
    saved_data = JSON.decode(save_state)
    if saved_data.health then
      for heal,_ in pairs(health) do
        health[heal] = saved_data.health[heal]
      end
    end
    if saved_data.Strain then
      for res,_ in pairs(Strain) do
        Strain[res] = saved_data.Strain[res]
      end
    end
    if saved_data.options then
      for opt,_ in pairs(options) do
        options[opt] = saved_data.options[opt]
      end
    end
    if saved_data.statNames then
      for stat,_ in pairs(statNames) do
        statNames[stat] = saved_data.statNames[stat]
        if saved_data.statNames[stat] == true then
          Global.call('updateStatus',{ns = stat, pf = prefix, off = false})
        end
      end
    end
  end
  local script = self.getLuaScript()
  local xml = script:sub(script:find("StartXML")+8, script:find("StopXML")-1)
  self.UI.setXml(xml)
  Wait.frames(load, 10)
  updateGlobalUI()
  if string.match(self.getName(), 'Elite') then Global.call('updateColor', {c = 'Elite', pf = prefix}) end
  if single and baseColor ~= 'Black' then Global.call('updateColor', {c = baseColor, pf = prefix}) end
end

function load()
local o = 0
  if string.find(self.getName(), "%(") or Strain.max > 0 then
    --leave at 1.0
    if Strain.max > 0 then
      o = 0.15
    end
  else
    --local s = 3/((self.getBounds().size.x + self.getBounds().size.y + self.getBounds().size.z) /3)
    --self.setScale({x=s-o, y=s-o, z=s-o})
  end

  if string.match(self.getName(), "Door") then
    self.UI.setAttribute("panel", "position", "-125 0 -" .. self.getBounds().size.y / self.getScale().y * options.heightModifier)
  else
    self.UI.setAttribute("panel", "position", "0 0 -" .. self.getBounds().size.y / self.getScale().y * options.heightModifier)
  end
  self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
  self.UI.setAttribute("editButton", "text", health.value .. "/" .. health.max)
  self.UI.setAttribute("editButton", "textColor", "#FFFFFF")
  self.UI.setAttribute("progressBarS", "percentage", Strain.value / Strain.max * 100)
  self.UI.setAttribute("StrainText", "text", Strain.value .. "/" .. Strain.max)
  self.UI.setAttribute("StrainText", "textColor", "#FFFFFF")
  self.UI.setAttribute("increment", "text", options.incrementBy)

  for i,j in pairs(statNames) do
    if j == true then
      self.UI.setAttribute(i, "active", true)
    end
  end
  Wait.frames(function() self.UI.setAttribute("statePanel", "width", getStatsCount()*300) end, 1)

  if options.showBarButtons then
    self.UI.setAttribute("addSub", "active", true)
    self.UI.setAttribute("addSubS", "active", true)
  end

  self.UI.setAttribute("ressourceBarS", "active", options.hideStrain == true and "False" or "True")
  self.UI.setAttribute("addSub", "active", options.showBarButtons == true and "True" or "False")
  self.UI.setAttribute("addSubS", "active", options.showBarButtons == true and "True" or "False")
  self.UI.setAttribute("panel", "rotation", options.rotation .. " 270 90")

  if options.showBaseButtons then
    createBtns()
  end
end

function onSave()
  options.ats = Global.call('getATSfUI', prefix)
  local save_state = JSON.encode({health = health, Strain = Strain, options = options, statNames = statNames})
  self.script_state = save_state
end

function createBtns()
  local buttonParameter = {click_function = "cycleBaseColor", function_owner = self, position = {0.3, 0.30, 0.4}, label = string.sub(prefix,string.len(prefix),string.len(prefix)), width = 500, height = 500, font_size = 600, color = baseColor, font_color = {255,255,255,100}}
  self.createButton(buttonParameter)
  if baseColor ~= 'Black' then
    Global.call('updateColor', {c = baseColor, pf = prefix})
  end
end
function changeBaseColor() self.clearButtons()
  local buttonParameter = {click_function = "cycleBaseColor", function_owner = self, position = {0.3, 0.30, 0.4}, label = string.sub(prefix,string.len(prefix),string.len(prefix)), width = 500, height = 500, font_size = 600, color = baseColor, font_color = {255,255,255,100}}
  self.createButton(buttonParameter)
  Global.call('updateColor', {c = baseColor, pf = prefix})
end
function setBaseColor(x) baseColor = x changeBaseColor() end
function cycleBaseColor() if baseColor == 'None' then baseColor = 'Teal'
elseif baseColor == 'Teal' then baseColor = 'Pink'
elseif baseColor == 'Pink' then baseColor = 'Grey'
elseif baseColor == 'Grey' then baseColor = 'Black'
elseif baseColor == 'Black' then baseColor = 'Teal' else end setBaseColor(baseColor) end
function none() end
function add() onClick(-1, - 1, "add") end
function sub() onClick(-1, - 1, "sub")end
function getHP() return health.value end
function addS() onClick(-1, - 1, "addS") end
function subS() onClick(-1, - 1, "subS") end
function addr() onClick(-1, -90, "addRotation")end
function getStrain() return Strain.value end
function getHPtext() return health.value .. "/" .. health.max end
function getStext() return Strain.value .. "/" .. Strain.max end
function getHPPer() return  health.value / health.max * 100 end
function getSPer() return Strain.value / Strain.max * 100 end
function getC() return getAttribute("progressBar","fillImageColor") end
function getPrefix() return prefix end
function getSingle() return single end
function setg(g) gid = g end
function getATS() return options.ats end
function setATS() if options.ats == 'Activation_Start' then options.ats = 'Activation_End' else options.ats = 'Activation_Start' end end
function likenew() onClick(-1, - 1, "new") end
function addstat(g) Global.call('updateStatus',{ns = g, pf = prefix, off = false})
statNames[g] = true
self.UI.setAttribute(g, "active", true)
Wait.frames(function() self.UI.setAttribute("statePanel", "width", getStatsCount()*300) end, 1) end
function clearstats()
  for i,j in pairs(statNames) do
    if self.UI.getAttribute(i, "active") == "True" or self.UI.getAttribute(i, "active") == "true" then
      self.UI.setAttributes(i, {active = "false"})
      Global.call('updateStatus',{ns = i, pf = prefix, off = true})
    end
  end
end
function onPickUp() if string.match(self.getName(), 'Door') then Global.call('playsound',116) end end
function reset()
  if options.wounded == true then
    Strain.max = Strain.max +1
    options.wounded = false
  else
    options.wounded = true
    Strain.max = Strain.max -1
  end
  if Strain.value > Strain.max then
    Strain.value = Strain.value -1
  end
  health.value = health.max
  self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
  self.UI.setAttribute("progressBarS", "percentage", Strain.value / Strain.max * 100)
  self.UI.setAttribute("editButton", "text", health.value .. "/" .. health.max)
  self.UI.setAttribute("StrainText", "text", Strain.value .. "/" .. Strain.max)
  updateGlobalUI()
end

function onEndEdit(player, value, id)
  options.incrementBy = value
end

function onClickEx(params)
  onClick(params.player, params.value, params.id)
end

function onClick(player, value, id)
  self.UI.setAttribute("panel", "position", "0 0 -" .. self.getBounds().size.y / self.getScale().y * options.heightModifier)
  if id == nil and player != nil then
    id = player
  end
  if id == "editButton" then
    if self.UI.getAttribute("editPanel", "active") == "False" or self.UI.getAttribute("editPanel", "active") == nil then
      self.UI.setAttribute("editPanel", "active", true)
    else
      self.UI.setAttribute("editPanel", "active", false)
    end
  elseif id == "subHeight" or id == "addHeight" then
    if id == "addHeight" then
      options.heightModifier = options.heightModifier + options.incrementBy
    else
      options.heightModifier = options.heightModifier - options.incrementBy
    end
    self.UI.setAttribute("panel", "position", "0 0 -" .. self.getBounds().size.y / self.getScale().y * options.heightModifier)
  elseif id == "subRotation" or id == "addRotation" then
    if id == "addRotation" then
      options.rotation = options.rotation + 90
    else
      options.rotation = options.rotation - 90
    end
    self.UI.setAttribute("panel", "rotation", options.rotation .. " 270 90")
  elseif id == "BB" then
    if options.showBaseButtons then
      self.clearButtons()
      options.showBaseButtons = false
    else
      createBtns()
      options.showBaseButtons = true
    end
  elseif id == "HM" then
    options.hideStrain = not options.hideStrain
    Wait.frames(function() self.UI.setAttribute("ressourceBarS", "active", options.hideStrain == true and "False" or "True") end, 1)
  elseif id == "HB" or id == "editButtonS" then
    if options.showBarButtons then
      self.UI.setAttribute("addSub", "active", false)
      self.UI.setAttribute("addSubS", "active", false)
      options.showBarButtons = false
    else
      self.UI.setAttribute("addSub", "active", true)
      self.UI.setAttribute("addSubS", "active", true)
      options.showBarButtons = true
    end
  elseif id == "BZ" then
    if options.belowZero then
      options.belowZero = false
      broadcastToAll("Below Zero Denied!", {1,1,1})
    else
      options.belowZero = true
      broadcastToAll("Below Zero allowed!", {1,1,1})
    end
  elseif id == "AM" then
    if options.aboveMax then
      options.aboveMax = false
      broadcastToAll("Above Max Denied!", {1,1,1})
    else
      options.aboveMax = true
      broadcastToAll("Above Max allowed!", {1,1,1})
    end
  elseif statNames[id] ~= nil then
    self.UI.setAttribute(id, "active", false)
    self.UI.setAttribute("statePanel", "width", tonumber(self.UI.getAttribute("statePanel", "width")-300))
    Global.call('updateStatus',{ns = id, pf = prefix, off = true})
    statNames[id] = false
  else
    if id == "add" then health.value = health.value + options.incrementBy
      if health.value <= health.max then
        printToAll(self.getName().."\'s health has increased to ".. health.value, "White")
      end
    elseif id == "addS" then Strain.value = Strain.value + options.incrementBy
      if Strain.value < Strain.max then
        printToAll(self.getName().."\'s strain has increased to ".. Strain.value, "White")
      else
        printToAll(self.getName().."\'s is maxed out on strain!", "White")
      end
    elseif id == "sub" then health.value = health.value - options.incrementBy
    printToAll(self.getName().."\'s health has decreased to ".. health.value, "White")
    elseif id == "subS" then Strain.value = Strain.value - options.incrementBy
      if Strain.value >= 0 then
        printToAll(self.getName().."\'s strain has decreased to ".. Strain.value, "White")
      end
    elseif id == "addMax" then health.value = health.value + options.incrementBy
      health.max = health.max + options.incrementBy
    elseif id == "addMaxS" then Strain.max = Strain.max + options.incrementBy
    elseif id == "subMax" then health.value = health.value - options.incrementBy
      health.max = health.max - options.incrementBy
    elseif id == "subMaxS" then Strain.value = Strain.value - options.incrementBy
      Strain.max = Strain.max - options.incrementBy
    elseif id == "atk" then
      Global.call('TokenAtk', "cardobjectguid")
    elseif id == "def" then
      Global.call('TokenDef', "cardobjectguid")
    elseif id == "new" then
      health.value = health.max
      Strain.value = 0
      options.ats = 'Activation_Start'
    end
    if health.value > health.max and not options.aboveMax then health.value = health.max end
    if health.value < 0 and not options.belowZero then health.value = 0 end
    if health.value == 0 and Strain.max > 0 then Global.call('TokenWounded', "cardobjectguid") end
    if Strain.value > Strain.max and not options.aboveMax then Strain.value = Strain.max end
    if Strain.value < 0 and not options.belowZero then Strain.value = 0 end
    self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
    self.UI.setAttribute("progressBarS", "percentage", Strain.value / Strain.max * 100)
    self.UI.setAttribute("editButton", "text", health.value .. "/" .. health.max)
    self.UI.setAttribute("StrainText", "text", Strain.value .. "/" .. Strain.max)
    if options.HP2Desc then
      self.setDescription(health.value .. "/" .. health.max)
    end
    updateGlobalUI()
  end
  self.UI.setAttribute("editButton", "textColor", "#FFFFFF")
  self.UI.setAttribute("StrainText", "textColor", "#FFFFFF")
end
function updateGlobalUI()
  Global.call('updateUIbar', self.guid)
end

function onCollisionEnter(a)
  local pos
  local newState = a.collision_object.getName()
  if single == true then
    pos = getObjectFromGUID("cardobjectguid").getPosition()
    pos.y = pos.y+1
  end
  if statNames[newState] ~= nil then
    statNames[newState] = true
    a.collision_object.destruct()
    Global.call('updateStatus',{ns = newState, pf = prefix, off = false})
    self.UI.setAttribute(newState, "active", true)
    Wait.frames(function() self.UI.setAttribute("statePanel", "width", getStatsCount()*300) end, 1)
  end
end

function getStatsCount()
  local count = 0
  for i,j in pairs(statNames) do
    if self.UI.getAttribute(i, "active") == "True" or self.UI.getAttribute(i, "active") == "true" then
      count = count + 1
    end
  end
  return count
end
LUAStop--lua]]
--[[XMLStart
<Defaults>
  <Button onClick="onClick" fontSize="80" fontStyle="Bold" textColor="#FFFFFF" color="#000000F0"/>
  <Text fontSize="80" fontStyle="Bold" color="#FFFFFF"/>
  <InputField fontSize="70" color="#000000F0" textColor="#FFFFFF" characterValidation="Integer"/>
</Defaults>

<Panel id="panel" position="0 0 -220" rotation="90 270 90" scale="0.7 0.7">
  <Panel id="ressourceBar" position="0 100 0" active="true">
    <ProgressBar id="progressBar" visibility="" height="100" width="600" showPercentageText="false" color="#000000E0" percentage="100" fillImageColor="#242526"></ProgressBar>
    <Button id="editButton" visibility="" height="100" width="600" text="10/10" color="#00000000"></Button>
    <Panel id="addSub" visibility="" height="100" width="825" active="false">
      <HorizontalLayout spacing="625">
      <Button id="sub" text="-" color="#FFFFFF" textColor="#000000"></Button>
      <Button id="add" text="+" color="#FFFFFF" textColor="#000000"></Button>
      </HorizontalLayout>
    </Panel>
  </Panel>
  <Panel id="ressourceBarS" active="true">
    <ProgressBar id="progressBarS" visibility="" height="100" width="600" showPercentageText="false" color="#000000E0" percentage="100" fillImageColor="#000071"></ProgressBar>
    <Text id="StrainText" visibility="" height="100" width="600" text="10/10"></Text>
    <Panel id="addSubS" visibility="" height="100" width="825" active="false">
      <HorizontalLayout spacing="625">
        <Button id="subS" text="-" color="#FFFFFF" textColor="#000000"></Button>
        <Button id="addS" text="+" color="#FFFFFF" textColor="#000000"></Button>
      </HorizontalLayout>
    </Panel>
  </Panel>
  <Button id="editButtonS" height="100" width="600" text="" color="#00000000"></Button>
  <Panel id="editPanel" height="620" width="600" position="0 770 0" active="False">
    <VerticalLayout>
      <HorizontalLayout minheight="160">
        <Button id="BZ" fontSize="70" text="Below Zero" color="#000000F0"></Button>
        <Button id="AM" fontSize="70" text="Above Max" color="#000000F0"></Button>
      </HorizontalLayout>
      <HorizontalLayout minheight="160">
        <Button id="BB" fontSize="70" text="Base Buttons" color="#000000F0"></Button>
        <Button id="HB" fontSize="70" text="HP Bar Buttons" color="#000000F0"></Button>
      </HorizontalLayout>
      <HorizontalLayout minheight="100">
        <Button id="HM" fontSize="70" text="Hide Ressource Bar" color="#000000F0"></Button>
      </HorizontalLayout>
      <HorizontalLayout spacing="10" minheight="100">
        <Button id="subHeight" text="◄"></Button>
        <Text>Height</Text>
        <Button id="addHeight" text="►"></Button>
      </HorizontalLayout>
      <HorizontalLayout spacing="10" minheight="100">
        <Button id="subRotation" text="◄" minwidth="90"></Button>
        <Text>Rotation</Text>
        <Button id="addRotation" text="►" minwidth="90"></Button>
      </HorizontalLayout>
      <HorizontalLayout spacing="55"  minheight="100">
        <Button id="subMax" text="◄"></Button>
        <Text>HP</Text>
        <Button id="addMax" text="►"></Button>
      </HorizontalLayout>
      <HorizontalLayout spacing="55"  minheight="100">
        <Button id="subMaxS" text="◄" minwidth="90"></Button>
        <Text>Strain</Text>
        <Button id="addMaxS" text="►" minwidth="90"></Button>
      </HorizontalLayout>
      <HorizontalLayout spacing="10" minheight="100">
        <Text fontSize="50">Increment by:</Text>
        <InputField id="increment" onEndEdit="onEndEdit" minwidth="200" text="1"></InputField>
      </HorizontalLayout>
    </VerticalLayout>
  </Panel>
  <Panel id="statePanel" height="300" width="-5" position="0 370 0">
    <VerticalLayout>
      <HorizontalLayout spacing="5">
      STATSIMAGE
      </HorizontalLayout>
    </VerticalLayout>
  </Panel>
</Panel>
XMLStop--xml]]

options = {
  hideText = false,
  editText = false,
  hideBar = false,
  showAll = true,
  playerChar = true,
  HP2Desc = false,
  hp = 3,
  Strain = 0
}

function onload(save_state)



  --Global variables
    Menu = getObjectFromGUID('78932d')
    HeroClass = getObjectFromGUID('a4c010')
    HeroObjects = getObjectFromGUID('00e95b')
    ClawditeForms = getObjectFromGUID('bab432')
    currentDice = {}
    cleardicenow = false
    pad = getObjectFromGUID('b7da53')
    RotationValues = getObjectFromGUID('8e7a2e').getRotationValues()
    attackerRolled = false
    defenderRolled = false
    Threat = 0
    ThreatLevel = 2
    Round = 1
    RebelCredits = 0
    time = 60
    timeron = false
    timerstatus = true
    timer_length = 240
    explosions = getObjectFromGUID('6b79f0')
    purplel = getObjectFromGUID('9de659')
    yellowl = getObjectFromGUID('9c7d1f')
    redl = getObjectFromGUID('cf95d1')
    bluel = getObjectFromGUID('39f68d')
    greenl = getObjectFromGUID('815263')
    whitel = getObjectFromGUID('a8a78a')
    s2 = getObjectFromGUID('de410e')
    sounds = getObjectFromGUID('f7815b')
    newBlock = 0
    newDamage = 0
    newSurge = 0
    newEvade = 0
    sound_effects = true
    clips = true
    RebelXP = 0
    IACP = false

    local hour = tonumber(os.date("%I"))
    local ampm = os.date("%p")
    self.UI.setAttributes("Time", {text=hour..os.date(":%M:%S").." "..ampm})
    updateTime()

    --Dice and Hero Class Bag.. the other bags are locked in Menu
    getObjectFromGUID('8e7a2e').interactable = false
    getObjectFromGUID('82f9d9').interactable = false -- dice tower
    getObjectFromGUID('b7da53').interactable = false -- dice tower
    getObjectFromGUID('d3851d').interactable = false -- dice tray
    getObjectFromGUID('4ee1f2').interactable = false -- surface
    getObjectFromGUID('099d92').interactable = false -- table
    getObjectFromGUID('6d4adf').interactable = false -- card zone
    getObjectFromGUID('a4c010').interactable = false -- Hero class bag
    getObjectFromGUID('3a15c9').interactable = false -- imperial
    getObjectFromGUID('04a641').interactable = false -- purple
    getObjectFromGUID('336e97').interactable = false -- blue
    getObjectFromGUID('639cc0').interactable = false -- red
    getObjectFromGUID('84301a').interactable = false -- green
    getObjectFromGUID('bab432').interactable = false -- clawdite shapes
    getObjectFromGUID('6b79f0').interactable = false -- explosions
    getObjectFromGUID('39f68d').interactable = false -- blue light
    getObjectFromGUID('cf95d1').interactable = false -- red
    getObjectFromGUID('a8a78a').interactable = false -- white
    getObjectFromGUID('9c7d1f').interactable = false -- yellow
    getObjectFromGUID('9de659').interactable = false -- purple
    getObjectFromGUID('815263').interactable = false -- green
    getObjectFromGUID('f7815b').interactable = false -- s1
    getObjectFromGUID('de410e').interactable = false -- s2
    getObjectFromGUID('22789e').interactable = false -- l3d
    getObjectFromGUID('41c39e').interactable = false -- r1
    getObjectFromGUID('60e8b6').interactable = false -- c3d
    getObjectFromGUID('1ffb5d').interactable = false -- av3d
    getObjectFromGUID('e5458b').interactable = false -- ts3d
    getObjectFromGUID('a7d880').interactable = false -- h3d
    getObjectFromGUID('928c1c').interactable = false -- bg3d
    getObjectFromGUID('6da267').interactable = false -- jr3d
    getObjectFromGUID('4c337c').interactable = false -- IACP3D

    -- {'Name','Expansion',100,'TokenIMG','DeckFront'},
    --Name of on Card (Note Name the Card the same)
    --The Description must be (Imperial Deployment Cards)  (Mercenary Deployment Cards) (Rebel Deployment Cards)
    -------Name or Elite
    --Type -- Hero1 = Deployment cards, Hero = Hero Cards, Villain
    --Expansion -- Really Unused?  -- The Core Set
    --Elite = Elite (red tint) or No (black tint)  or Color (playercolor)
    --HP as a nuumber
    --Strain as a number
    --Squad =how many total
    --{0,0,0,0,0,0} = How mnay die of each Y,b,G,R,B,W

    ----{Yellow,Blue,Green,Red,        Black,White}

--        {'Name','Type','Expansion','Elite',0,0,1,
--            {0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'TokenImage','Internal Only (objectguid)',{Internal Only tokenguid,blackid,redid},

    Cards =
    {
    ----------THE CORE SET------------------------------------------------------------
    ['Stormtrooper'] = {'Villain','The Core Set','No',3,0,3,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462821553/BBB3F509C43D63334C23BE268B18B0402CED89EE/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502512746/FA800D7D702DD122E0093DB5FDC54BFFC90348F0/','https://steamusercontent-a.akamaihd.net/ugc/856103543882901679/1F56D840619CD39E291B8A62D5FDD841FB777A8D/',nil,nil,2,109},
    ['Stormtrooper Elite'] = {'Villain','The Core Set','Elite',5,0,3,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462821337/17F9F9C72A814E2E9183BE0000C24292A7BACB77/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502512746/FA800D7D702DD122E0093DB5FDC54BFFC90348F0/','https://steamusercontent-a.akamaihd.net/ugc/856103543882901679/1F56D840619CD39E291B8A62D5FDD841FB777A8D/',nil,nil,2,109},
    ['E-Web Engineer (1x2)'] = {'Villain','The Core Set','No',5,0,1,
               {1,1,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462823902/C7F30EFA7A68D064B117DBCA968BF9810C9EB4C4/','',{},'https://steamusercontent-a.akamaihd.net/ugc/856103543883338400/7E7E26E68951227AA1F56A70D7DA4627E30573AB/','https://steamusercontent-a.akamaihd.net/ugc/856103543883328541/91A65AE3568F22856022F2260A3B31782F115FAB/',nil,nil,3,3},
    ['E-Web Engineer (1x2) Elite'] = {'Villain','The Core Set','Elite',7,0,1,
               {1,1,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462823761/A6C3E0EEFCCB285A362F458808AD8F1D7BC35CE5/','',{},'https://steamusercontent-a.akamaihd.net/ugc/927045630479840311/A5ED5F1D66385A72FFE03ED12EB3A0D13E57F9F5/','https://steamusercontent-a.akamaihd.net/ugc/755969254323533835/24336D73E00420ABA6762124312CA31A1BF61932/',nil,nil,3,3},
    ['Imperial Officer'] = {'Villain','The Core Set','No',3,0,1,
               {1,1,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462823446/711C92CD4158DBE06B91984835188FC59EBB29E1/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502574269/D5321F49A29210D8990A1FEC0462101A7CD54266/','https://steamusercontent-a.akamaihd.net/ugc/856103154385121507/509FDBECDA3D10DBB1E065E742C74E1EECA65D26/',nil,nil,4,109},
    ['Imperial Officer Elite'] = {'Villain','The Core Set','Elite',5,0,1,
               {1,1,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462823133/64539637E2CC0EFC8C9A17594A2B9C092D0F1848/','',{},'https://steamusercontent-a.akamaihd.net/ugc/856103815147477062/9AF712DAD85F9BBEC43970026D7F6A88AE3A6B55/','https://steamusercontent-a.akamaihd.net/ugc/856103815147477468/FA1C6FF5C7A3E97D6AF83A9EC60FD081F403B0CE/',nil,nil,4,109},
    ['Probe Droid'] = {'Villain','The Core Set','No',5,0,1,
               {2,1,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462822977/4F22F5FA356E35F2CBF0868E95BA58E982A263A9/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1008188268576500347/56293FAD3D4D8002F5CEAD5AE7F08C6131339C87/','https://steamusercontent-a.akamaihd.net/ugc/1008188268576501006/3AE05E7B237171A5BA916FB6DE7F180D279BF861/',nil,nil,5,109},
    ['Probe Droid Elite'] = {'Villain','The Core Set','Elite',7,0,1,
               {2,1,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462822841/34CA8A19DF3B97F99307E448069949525227E413/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1008188268576500347/56293FAD3D4D8002F5CEAD5AE7F08C6131339C87/','https://steamusercontent-a.akamaihd.net/ugc/1008188268576531458/3639AC07B67BC0BE9A93287BF9DCDF42BB409063/',nil,nil,5,109},
    ['Royal Guard'] = {'Villain','The Core Set','No',8,0,2,
               {1,0,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462822145/7ED1B7523A130991126B9C7DA724F706BE2E9F04/','',{},'https://steamusercontent-a.akamaihd.net/ugc/856103815144110782/EB5777449A990C7B86125495C0CA134475C55ADB/','https://steamusercontent-a.akamaihd.net/ugc/856103154385020158/8C52D3B5F1246AB7566AED41E18E3A967A6DBD43/',nil,nil,6,6},
    ['Royal Guard Elite'] = {'Villain','The Core Set','Elite',10,0,2,
               {1,0,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462821724/F46D82FF80FAE45B9D421BE8552970D5B6E3BDB0/','',{},'https://steamusercontent-a.akamaihd.net/ugc/856103815144110782/EB5777449A990C7B86125495C0CA134475C55ADB/','https://steamusercontent-a.akamaihd.net/ugc/755969254323540656/7BE1CB962CBC845A510F96D780AC576539BF729E/',nil,nil,6,6},
    ['Royal Guard Champion'] = {'Villain','The Core Set','Elite',13,6,1,
               {1,0,1,1,1,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462822554/5E8E2CE0F0F0C55E876D0AD5EAA11CED377FC040/','',{},'https://steamusercontent-a.akamaihd.net/ugc/856103543879850827/5105C684533768C83C20A6DF58C4A25638BA22C2/','https://steamusercontent-a.akamaihd.net/ugc/856103543879845491/89C8606040F44B1EAE3CDCDD328DF7A048E232CE/',nil,nil,6,6},
    ['General Weiss (2x3)'] = {'Villain','The Core Set','Elite',15,0,1,
               {0,0,0,0,2,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462821074/EEA3F92ACEFD37D0077812F9B1A8C2648EB7F73D/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502479119/C8A7C949DC4B86E0368861980EFD0678783F4ED7/','https://steamusercontent-a.akamaihd.net/ugc/1004808401669136477/CA961E09932B5B410F1084990192DADDF077A754/',nil,nil,7,9},
    ['AT-ST (2x3)'] = {'Villain','The Core Set','Elite',15,0,1,
               {0,1,0,2,2,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462824635/C396F8038353B5C801EB1911162A3756F7EA3C6D/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502308680/72D63A318A6C6B3CE8F43B9D22BF73A4C13642E8/','https://steamusercontent-a.akamaihd.net/ugc/923667919241941280/9C0EFCEE33F89F476E8ADD88484399869E2F7242/',nil,nil,8,9},
    ['Darth Vader'] = {'Villain','The Core Set','Elite',16,0,1,
               {1,0,0,2,2,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462824326/2DD41F7ED1FE704213C4606E668E60B29619E332/','',{},'https://steamusercontent-a.akamaihd.net/ugc/885378115694553065/131E1B97566443543A50E6B15CD581C27F057F40/','https://steamusercontent-a.akamaihd.net/ugc/755969254323544539/1988DE4028399FCA9170533556D83DB92815D135/','',{{0.5,2,-2,'R'}},10,110},
    ------------------MERCENARYS
    ['Nexu (2x2)'] = {'Villain','The Core Set','No',6,0,1,
               {0,0,1,1,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460688544/56C61D6D95BB8CB212711039A94080679C262D14/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1322320470300955790/021030FC07196C378823CF972A518A2FE0F97951/','https://steamusercontent-a.akamaihd.net/ugc/1322320470300944694/10771EDABF1F910B751BB9FE2D86643C05238D25/',nil,nil,11,11},
    ['Nexu (2x2) Elite'] = {'Villain','The Core Set','Elite',8,0,1,
               {0,0,1,1,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460688386/2A20328EA388DFE0597E76FCE8C6E72FF58C70E3/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502468429/406E4A916E79E1CBE13AB85FC571F9021A657E0D/','https://steamusercontent-a.akamaihd.net/ugc/856103543875491850/2CB818C26948FBFF9CA05DDF957AD4368C7BA651/',nil,nil,11,11},
    ['Trandoshan Hunter'] = {'Villain','The Core Set','No',6,0,2,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460688104/61B2AC731D9C35A1330B45322E461C78A13C3A65/','',{},'https://steamusercontent-a.akamaihd.net/ugc/867363169403841979/ED51253B86D951BD1A573C7FA8C0439DDF96BD88/','https://steamusercontent-a.akamaihd.net/ugc/867363169403842290/00D95403FF989A02B886ABC8F5372B97FBA263DF/',nil,nil,12,109},
    ['Trandoshan Hunter Elite'] = {'Villain','The Core Set','Elite',8,0,2,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460687811/90C0B2AC526E6EC80110A6ED565D023DD1F535B4/','',{},'https://steamusercontent-a.akamaihd.net/ugc/867363518984879323/35B9E24DC15268F4A16356013360B6FD0C7B8AA4/','https://steamusercontent-a.akamaihd.net/ugc/867363518984879644/CDA4DBA31AFD28E9889FAD0BD77B408C7770C76D/',nil,nil,12,109},
    ['IG-88'] = {'Villain','The Core Set','Elite',10,0,1,
               {0,0,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460690581/2FB5DDD5CDC39FFA60424E1A58CA87C1B23EE66A/','',{},'https://steamusercontent-a.akamaihd.net/ugc/867363169408207325/BDEA66B89AD4387487307C669620681874BE420D/','https://steamusercontent-a.akamaihd.net/ugc/867363169408207733/0B57B94C4F7E2F8C2C671A59D6CE368CCB95675C/',nil,nil,13,3},
    ---------------REBEL
    ['Rebel Trooper'] = {'Hero1','The Core Set','No',3,0,3,
               {1,1,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462830080/8A77FB66269B69842C06472142351DA778D6D8DA/','',{},'https://steamusercontent-a.akamaihd.net/ugc/927045449560394597/84F62E21DA7E24A6DE0A9095D1542BB1971A5297/','https://steamusercontent-a.akamaihd.net/ugc/927045449560395019/58DD8B1F6C550C6AC9D32DEFA8F99425E5BF8C8A/',nil,nil,14,108},
    ['Rebel Trooper Elite'] = {'Hero1','The Core Set','Elite',5,0,3,
               {1,1,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462830314/3B4C3E00AC30278596D3001325336AECFFD485C2/','',{},'https://steamusercontent-a.akamaihd.net/ugc/927045449560394597/84F62E21DA7E24A6DE0A9095D1542BB1971A5297/','https://steamusercontent-a.akamaihd.net/ugc/755969254323547780/95646F0AC79B88CA84E27A048CD431F3DD3A54FF/',nil,nil,14,108},
    ['Rebel Saboteur'] = {'Hero1','The Core Set','No',4,4,2,
               {1,0,0,1,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462829618/DC8188F6BBEA7B22BC594C1D0747E37BD503385C/','',{},'https://steamusercontent-a.akamaihd.net/ugc/927044966622548109/85037F027D731E7ED6D3000B0DEADF1030481B98/','https://steamusercontent-a.akamaihd.net/ugc/927044966622548587/4B4261E937AED6D7412F0BD1942F38E7C743EAFB/',nil,nil,15,108},
    ['Rebel Saboteur Elite'] = {'Hero1','The Core Set','Elite',6,0,2,
               {1,0,0,1,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462829889/B0C8944D99610730D3999A595175F09358D267AB/','',{},'https://steamusercontent-a.akamaihd.net/ugc/927044966622548109/85037F027D731E7ED6D3000B0DEADF1030481B98/','https://steamusercontent-a.akamaihd.net/ugc/755969254323550915/737637C5B05C71E56C90CF166B204FAA703972E8/',nil,nil,15,108},
    ['Chewbacca'] = {'Hero1','The Core Set','Elite',14,0,1,
               {1,1,0,1,1,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462826045/9EBA7D04FFBA0878018410D22BD55B68A4AE5E3F/','',{},'https://steamusercontent-a.akamaihd.net/ugc/893266397599866576/D736F8E591361CCCB84325C8B019CBD37F4C7A5E/','https://steamusercontent-a.akamaihd.net/ugc/893266397599866829/15387002B35553B4A19F2EFB33F86B7D6206EA11/',nil,nil,16,108},
    ['Han Solo'] = {'Hero1','The Core Set','Elite',12,0,1,
               {0,1,2,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462827095/D0ECFB490A151F9954FF5AB117D876F0181AA8CE/','',{},'https://steamusercontent-a.akamaihd.net/ugc/884253767816788778/F2FC92D41C64E4F0DCF248545E832E147C809A9A/','https://steamusercontent-a.akamaihd.net/ugc/884253767816789150/880BE2C938A56762B883391C6D348556C6F27219/',nil,nil,17,108},
    ['Luke Skywalker'] = {'Hero1','The Core Set','Elite',10,0,1,
               {1,1,1,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462828476/941705A402334507C7FECFF45885A301F19CEDEA/','',{},'https://steamusercontent-a.akamaihd.net/ugc/883132030727213672/E2166E50A98C3A15A080DE92FD064B162EE14AB2/','https://steamusercontent-a.akamaihd.net/ugc/883132030727214386/E69140381603763823EDE4D0C84D056082015EB7/',nil,nil,18,108},
    ----------------------HEROS
    ['Gideon Argus'] = {'Hero','The Core Set','Color',10,5,1,
               {1,1,0,0,1,0},{0,1,1,0,0,1,0,1},{1,1,1,0,0,1,1,1},{0,1,1,0,0,1,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460704202/E433A0F0F46146764C3415171363CBBB13F90659/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502191511/6A70477218DE01926B280C80BDF625CEAB5ED2AC/','https://steamusercontent-a.akamaihd.net/ugc/883132030728356065/596BF42DE259C88E41E195118B09DED7C9E8F3EE/',nil,nil,19,108},
    ['Fenn Signis'] = {'Hero','The Core Set','Color',12,4,1,
               {0,1,1,0,1,0},{0,1,1,0,0,1,0,1},{0,1,1,0,0,1,0,1},{0,1,1,0,0,1,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460699431/AE34D817403B6F81E467298E93C74A23DD7A6043/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430929877981368/037C7FCB8B9DE6992589A4E5174C9F779D203014/','https://steamusercontent-a.akamaihd.net/ugc/883132030728489853/F44730CE82CFA4DB31BB3F65EAE51E754474E2D0/',nil,nil,20,108},
    ['Diala Passil'] = {'Hero','The Core Set','Color',12,5,1,
               {1,0,1,0,0,1},{0,1,1,0,0,1,0,1},{1,1,1,0,0,1,1,1},{0,1,0,0,0,0,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460699774/88DAC8C7AFF03AD7407C134E37FDA8F37AFFCB63/','',{},'https://steamusercontent-a.akamaihd.net/ugc/941684931603335563/2BA0C4D6F32F384E3AFEA24397034451B568D175/','https://steamusercontent-a.akamaihd.net/ugc/775102877236171496/20C9CBE572E232D95CD7C15CA48FC702BDA81144/','',{{0,3,0,'B'}},21,110},
    ['Mak Eshkarey'] = {'Hero','The Core Set','Color',10,5,1,
               {0,2,0,0,0,1},{0,1,1,0,0,1,0,1},{0,1,1,0,0,1,0,1},{1,1,1,0,0,1,1,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460699092/FE43A154C18D91A9EFDD9A3C08A7F31B1AFF2EAF/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502200980/E32D69A8ED18030D54F42331B01DCF0A973C97D2/','https://steamusercontent-a.akamaihd.net/ugc/775102877237174126/23A332702D0BD51F7712C143225EAD5BC24D7DF6/',nil,nil,22,108},
    ['Jyn Odan'] = {'Hero','The Core Set','Color',10,4,1,
               {0,0,2,0,0,1},{0,1,0,0,0,0,0,1},{0,1,1,0,0,1,0,1},{1,1,1,0,0,1,1,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460700464/30CF2FC9D376B18E6CAD1DFB2BADFA6555CED096/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502207928/25C88778C85EBC96F1EA195F2CB5A7E1E4E53B3B/','https://steamusercontent-a.akamaihd.net/ugc/877499126465984324/2B9D174334BE22569E35FE2A2FD3CDE944D7DD1A/',nil,nil,23,108},
    ['Gaarkhan'] = {'Hero','The Core Set','Color',14,4,1,
               {1,0,0,1,1,0},{1,1,1,0,0,1,1,1},{0,1,0,0,0,0,0,1},{0,1,1,0,0,1,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460700100/4EC7F5DB751A7948936DAC096017770A02DAF218/','',{},'https://steamusercontent-a.akamaihd.net/ugc/856103450384072154/08236EFC60B6D16EEF04DE880AD7E09BDCEA4B38/','https://steamusercontent-a.akamaihd.net/ugc/856103450384072759/AA8F66BA7A47DD86CD0EA603DE5313E53A61765E/',nil,nil,24,108},
    -------------------------------------------------------------------------------------

    -------THE BESPIN GAMBIT-----------------------------------------------------------
    ['Agent Blaise'] = {'Villain','The Bespin Gambit','Elite',8,0,1,
               {2,0,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460698527/037F7C96F7D572428E3B171450EF1233A8DAEB2A/','',{}, 'https://steamusercontent-a.akamaihd.net/ugc/1001430786519386666/037E440A372665FEF485AD58E6A81F9AE5D90034/','https://steamusercontent-a.akamaihd.net/ugc/1001430786519374091/545E6040BB6383A96FD3411617B3041F6A05C1ED/',nil,nil,25,109},
    -------------------MERCENARYS
    ['Wing Guard'] = {'Villain','The Bespin Gambit','No',3,0,3,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460684472/8BCEC4F3CE31FC3F629C9290712A09A215195246/','',{},'https://steamusercontent-a.akamaihd.net/ugc/2442516864327541858/2B10DCDB0F8980F014B29C5DF3E544135080A254/','https://steamusercontent-a.akamaihd.net/ugc/2442516864327542120/85840165DBC193EEA5136FB2B2599AFCB2ECAE9F/',nil,nil,26,109},
    ['Wing Guard Elite'] = {'Villain','The Bespin Gambit','Elite',5,0,3,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460684315/5019199BC66F5D9D1EEA9858431A54C4FA03AC47/','',{},'https://steamusercontent-a.akamaihd.net/ugc/2442516864327541858/2B10DCDB0F8980F014B29C5DF3E544135080A254/','https://steamusercontent-a.akamaihd.net/ugc/755969254323553720/9032542D8F225410F788036FB5BFFEFE494A1859/',nil,nil,26,109},
    ['Ugnaught Tinkerer'] = {'Villain','The Bespin Gambit','No',4,0,1,
               {1,1,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460687024/F3E6EBAAF74EC7BD1E4FC089C9299BB58D0F814C/','',{},'https://steamusercontent-a.akamaihd.net/ugc/934932622996970014/A9515EBC748D5205CF73FAFA8A122B097EBF89D4/','https://steamusercontent-a.akamaihd.net/ugc/934932622996970346/646AC3BFEBB558FF283C92651039A3191BAAC981/',nil,nil,27,109},
    ['Ugnaught Tinkerer Elite'] = {'Villain','The Bespin Gambit','Elite',7,0,1,
               {1,1,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460686387/17281B498F403F25FA37FE29FC9D4E1CA87B9060/','',{},'https://steamusercontent-a.akamaihd.net/ugc/934932298880295049/543EFA268AD56753240CE37C2A84262ED9A6566A/','https://steamusercontent-a.akamaihd.net/ugc/934932298880295381/2A7C2DD67C74768534BCCF117C9DA713BF0804CA/',nil,nil,113,109},
    ['Bossk'] = {'Villain','The Bespin Gambit','Elite',10,0,1,
               {0,0,1,1,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460692296/5606F51E3C9671B6B69BD88AAF13B7E2AE51B3AE/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749058065562593052/C4F4C284BD3A455524931D0D59FE63DA7AFD5DCC/','https://steamusercontent-a.akamaihd.net/ugc/2442516506910899928/E1ADC37B4F8490EEC19D13AA112D8046A366E230/',nil,nil,28,109},
    --------------------REBEL
    ['Lando Calrissian'] = {'Hero1','The Bespin Gambit','Elite',8,0,1,
               {1,0,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462827596/861F1DB2C831771A5AE00E6B1053D58B5B51FC22/','',{},'https://steamusercontent-a.akamaihd.net/ugc/934932298880352292/473D94AA0999B70ED1F22FFEA87182169741D0B5/','https://steamusercontent-a.akamaihd.net/ugc/934932298880352496/AC21F154A3B9AF3D6A4571551041AD3844CF3421/',nil,nil,29,108},
    -----------------HEROS
    ['Murne Rin'] = {'Hero','The Bespin Gambit','Color',12,4,1,
               {0,1,1,0,1,0},{0,1,0,0,0,0,0,1},{1,1,1,0,0,1,1,1},{0,1,1,0,0,1,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460701145/C9A9941301A92A240E9670E981322496E6059353/','',{},'https://steamusercontent-a.akamaihd.net/ugc/941685450589996435/56AA16B029443895E8258CFB41F18C83A7112124/','https://steamusercontent-a.akamaihd.net/ugc/941685450589996685/3EDD1FD918F4A4E83DD4D16161354E9F1A8173D9/',nil,nil,30,108},
    ['Davith Elso'] = {'Hero','The Bespin Gambit','Color',11,4,1,
               {1,0,1,0,0,1},{0,1,1,0,0,1,0,1},{1,1,1,0,0,1,1,1},{0,1,0,0,0,0,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460700789/4A64426D4DF7E498A82D2A58FD80FB823C5181A9/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001431526963047580/793C70BF182018F1A7B8A78C466CFCF08B7DFD7E/','https://steamusercontent-a.akamaihd.net/ugc/934932622996673119/7B0CC7BCD6EAD440866CD4F7DCA5430D0257F20D/','',{{0,3,1,'G'}},31,110},
    -------------------------------------------------------------------------------------

    --------RETURN TO HOTH----------------------------------------------------------
    ['Snowtrooper'] = {'Villain','Return to Hoth','No',4,0,3,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460694456/B62BAAFB2F3A2825383AEC9DB73DD0D7308BEF85/','',{},'https://steamusercontent-a.akamaihd.net/ugc/883132030728243375/F4DFBEF7B7B8446BE03BD6D01E09614F57AA1325/','https://steamusercontent-a.akamaihd.net/ugc/883132030728242793/45819715DAECD5D960D63BF6F75B8DB06CD27DF4/',nil,nil,32,109},
    ['Snowtrooper Elite'] = {'Villain','Return to Hoth','Elite',6,0,3,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460694290/1D673140C980CED937A81F1525653CDAD17B39EB/','',{},'https://steamusercontent-a.akamaihd.net/ugc/883132030728243375/F4DFBEF7B7B8446BE03BD6D01E09614F57AA1325/','https://steamusercontent-a.akamaihd.net/ugc/755969254323556877/794986D7BDC71FE1AA7BFB64B20B1C293187BE47/',nil,nil,32,109},
    ['SC2-M Repulsor Tank (2x3)'] = {'Villain','Return to Hoth','Elite',10,0,1,
               {1,1,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460694927/6BE9AFD92615A86D0A76688A556AE3A1F0CCA8D6/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749058065562695916/A45D09CF2292A9C021666609EA5F38B0A3FF148F/','https://steamusercontent-a.akamaihd.net/ugc/893266725585771855/C2D79DA51F54D3D69C9F639F2D2C73D707A0A611/',nil,nil,33,9},
    ['General Sorin'] = {'Villain','Return to Hoth','Elite',7,0,1,
               {1,1,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460697712/575CBBF197D99846BF81F360F0CDA904EDEE487A/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749058065562686876/67CFD378D8E8D2A267002182DD03931AB9989226/','https://steamusercontent-a.akamaihd.net/ugc/883132351296093389/D7EBE1B5309EB5AADDB5ECDA8001F35DD128DDB3/',nil,nil,35,109},
    ---------------------MERCENARYS
    ['HK Assassin Droid'] = {'Villain','Return to Hoth','No',5,0,2,
               {1,2,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460693715/DE191CF9940A105728A61AB824A5961D8D8C8E33/','',{},'https://steamusercontent-a.akamaihd.net/ugc/941684138104554589/0E492F3475C52DD9474F3919E6FA852C790C6138/','https://steamusercontent-a.akamaihd.net/ugc/941684138104554980/7A0A57D1D399F3DED2D3008C39808C1ACE5FD4FE/',nil,nil,36,109},
    ['HK Assassin Droid Elite'] = {'Villain','Return to Hoth','Elite',6,0,2,
               {1,2,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460689457/320260542A780E4C0C6C36D7DAAB57A4AA50E5FF/','',{},'https://steamusercontent-a.akamaihd.net/ugc/941684138104752170/95A574781D72F906808907F58E9DC9CA59ECC720/','https://steamusercontent-a.akamaihd.net/ugc/941684138104752494/F203F0DC51F4148A3D25AE67BF62B6A6DC72AA39/',nil,nil,36,109},
    ['Wampa (1x2)'] = {'Villain','Return to Hoth','No',9,0,1,
               {0,0,0,2,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460685786/DD9C104CC7340669D7233496CA1ED02D6C02FDA8/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502441775/CD97A7893A9FD9FBDBA776B07B42AD5453A5842F/','https://steamusercontent-a.akamaihd.net/ugc/941684138104392041/7B73F6DD6431A1F44149AB915C0442E36FD69FAA/',nil,nil,37,37},
    ['Wampa (1x2) Elite'] = {'Villain','Return to Hoth','Elite',12,0,1,
               {0,0,0,2,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460684920/F63CBC2EA893DE1B87E388C81AF4C94EC155AD73/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1738926229609352232/406EB78B44B598DE97C4BB54B44100687080D1E5/','https://steamusercontent-a.akamaihd.net/ugc/941684138104193665/87D32FEB1303615113EEC714611B25791EB92D65/',nil,nil,37,37},
    ['Dengar'] = {'Villain','Return to Hoth','Elite',8,0,1,
               {1,0,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460691943/053FF92B035958043AE4F54F2F696E6C0D6891BE/','',{},'https://steamusercontent-a.akamaihd.net/ugc/893266725585577556/9D55600D5BA51A0B801D21C1A0291966990AE6F2/','https://steamusercontent-a.akamaihd.net/ugc/893266725585577947/D9EA022F0D9E51074984D7D53AFA30066601E123/',nil,nil,38,38},
    -----------------REBEL
    ['Echo Base Trooper'] = {'Hero1','Return to Hoth','No',5,0,2,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462826553/8ABE69540B36EAB27998C9DB612341963326127C/','',{},'https://steamusercontent-a.akamaihd.net/ugc/893266397600649896/9FC30F07D21B84796C8261B9D2919FC210064950/','https://steamusercontent-a.akamaihd.net/ugc/893266397600650250/B9E4BECFD6441E8FEDBB265C2C535CA46E7BB437/',nil,nil,39,108},
    ['Echo Base Trooper Elite'] = {'Hero1','Return to Hoth','Elite',8,0,2,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462826931/2A4AF7D12F03550CE4CD39A68717D0C00800BE6B/','',{},'https://steamusercontent-a.akamaihd.net/ugc/893266397600649896/9FC30F07D21B84796C8261B9D2919FC210064950/','https://steamusercontent-a.akamaihd.net/ugc/755969254323559628/C36959065955FBEC5C18B3E2DD4644B796942BBB/',nil,nil,39,108},
    ['Leia Organa'] = {'Hero1','Return to Hoth','Elite',8,0,1,
               {2,1,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462828118/232CCCDC4B86A06F0816705B03F0B81B11500B8E/','',{},'https://steamusercontent-a.akamaihd.net/ugc/941684746476199675/89BEB621AEC4FE73FCB5B2F2EF835F4029A61D0C/','https://steamusercontent-a.akamaihd.net/ugc/941684746476200088/083DAE29993E0E4DB7476926F29AABBB3B150ECF/',nil,nil,40,108},
    ---------------------HEROS
    ['Verena Talos'] = {'Hero','Return to Hoth','Color',12,5,1,
               {1,1,0,0,1,0},{0,1,1,0,0,1,0,1},{0,1,1,0,0,1,0,1},{0,1,1,0,0,1,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460701511/435E85D3ADFE59A1C7237E43CE4CE4BB6A2BBF5E/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502220562/F372E556984905D35EC77E0ADE774B78C6E6484D/','https://steamusercontent-a.akamaihd.net/ugc/876375362412963622/4930D5B2A271FFCAEDA0B30D975969821468494B/',nil,nil,41,108},
    ['Loku Kanoloa'] = {'Hero','Return to Hoth','Color',10,5,1,
               {0,1,1,0,0,1},{0,1,0,0,0,0,0,1},{1,1,1,0,0,1,1,1},{0,1,0,0,0,0,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460703472/EFE8AFD55EE40B3906FCA31A13EBDBE3A1354ED4/','',{},'https://steamusercontent-a.akamaihd.net/ugc/876375362412835828/337652E77D1092B8CFD7B68D9D413FD1DBEB6912/','https://steamusercontent-a.akamaihd.net/ugc/876375362412836220/477DF4A1AFB3EFB33B4A8F91C8217E2D23749E0D/',nil,nil,42,108},
    ['MHD-19'] = {'Hero','Return to Hoth','Color',12,4,1,
               {1,1,0,0,1,0},{0,1,0,0,0,0,0,1},{0,1,1,0,0,1,0,1},{1,1,1,0,0,1,1,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460703809/03F8AC2D634A3F62A8AD4048085770FD11D2F2E0/','',{},'https://steamusercontent-a.akamaihd.net/ugc/876375362412436159/FA724078E903AAAFD408C80D3949631314B94ECB/','https://steamusercontent-a.akamaihd.net/ugc/876375362412436456/AC7E4A5A41D0914FABD1BA4FDE895683F933E016/',nil,nil,43,108},
    --------------------------------------------------------------------------------------

    ----------JABBAS REALM--------------------------------------------------------------
    ['Jet Trooper'] = {'Villain','Jabbas Realm','No',3,0,2,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460696488/5E34FCD729EC54AD372AB64ACF2A4CF00F2F0C7F/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502279913/0C0931E13AAFF12523C4501F157DE71B06557EA1/','https://steamusercontent-a.akamaihd.net/ugc/1001430786519375159/00BC98B1DA28213D52ADEC7C091BAF4B7009C36A/',nil,nil,44,109},
    ['Jet Trooper Elite'] = {'Villain','Jabbas Realm','Elite',7,0,2,
               {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460696346/0ADA3814D218EE8A9316ADA0BBE2893969B7A556/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502279913/0C0931E13AAFF12523C4501F157DE71B06557EA1/','https://steamusercontent-a.akamaihd.net/ugc/1001430786519375727/1649D11B8A56C4268EC50F73FC7BF0CF4194B65F/',nil,nil,44,109},
    ['Captain Terro (1x2)'] = {'Villain','Jabbas Realm','Elite',13,0,1,
               {1,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'','',{},'https://steamusercontent-a.akamaihd.net/ugc/1008188268576811144/5F6CE4BBB55B0A5C216CE8E3F47301CCAC8BC84A/','https://steamusercontent-a.akamaihd.net/ugc/1008188268576783395/BE0DBA9676E89FA9C7BD8C93AAB87E04C059D8AD/',nil,nil,45,109},
    --------------------------MERCENARYS
    ['Weequay Pirate'] = {'Villain','Jabbas Realm','No',4,0,2,
               {0,0,2,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460684721/4D9671BDDE195A93AE00A8D6137E4960212D7A53/','',{},'https://steamusercontent-a.akamaihd.net/ugc/753719037371451423/F94DBD3F40A60C6DA2E932BF59C7B635356A4F83/','https://steamusercontent-a.akamaihd.net/ugc/753719037371451823/812D5AC65AFA2A4C0BA06CA3D43DDC1D5E877355/',nil,nil,46,109},
    ['Weequay Pirate Elite'] = {'Villain','Jabbas Realm','Elite',6,0,2,
               {0,0,2,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460684584/A0F8E926A5BD53107DB233581CCB458DC24705E3/','',{},'https://steamusercontent-a.akamaihd.net/ugc/753719037371451423/F94DBD3F40A60C6DA2E932BF59C7B635356A4F83/','https://steamusercontent-a.akamaihd.net/ugc/753719037371471032/0DBD961AED5F9B74ADE2983AE64052E56B7B816C/',nil,nil,46,109},
    ['Gamorrean Guard'] = {'Villain','Jabbas Realm','No',5,0,2,
               {0,0,0,2,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460691719/C94A420A4DC647E73081718CA2E17EF4348A5BAC/','',{},'https://steamusercontent-a.akamaihd.net/ugc/775102877221660771/A20D7EFB31D5CF08D9C14403616EBA735A2061DC/','https://steamusercontent-a.akamaihd.net/ugc/775102877221654803/91B51612F2C7EAFB19A290F1B4CD86A73C512C69/',nil,nil,47,47},
    ['Gamorrean Guard Elite'] = {'Villain','Jabbas Realm','Elite',8,0,2,
               {0,0,0,2,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460691594/569BBD7DEEA7D84803C37B1CE9597C364C55DBD9/','',{},'https://steamusercontent-a.akamaihd.net/ugc/775102877221660771/A20D7EFB31D5CF08D9C14403616EBA735A2061DC/','https://steamusercontent-a.akamaihd.net/ugc/775102877221654803/91B51612F2C7EAFB19A290F1B4CD86A73C512C69/',nil,nil,47,47},
    ['Rancor (2x3)'] = {'Villain','Jabbas Realm','Elite',15,0,1,
               {0,0,2,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460688240/D928743A2B7B286A246D06947C5E5345A0B57582/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502410267/FD5756D8E0124378CDC2386330F54911A481AD25/','https://steamusercontent-a.akamaihd.net/ugc/775118192873782207/28ACB3C14DA0CFFB6E4E88DC331943DCA659982D/',"https://steamusercontent-a.akamaihd.net/ugc/1749057862502423556/6BA2083E75A1CEB42E4DCEFDEBC66F8312948752/",nil,48,48},
    -----------------REBEL
    ['Alliance Ranger'] = {'Hero1','Jabbas Realm','No',5,0,3,
               {0,2,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462824792/2347F84466DB0DF7FD3EA084541C2E368CCE15F8/','',{},'https://steamusercontent-a.akamaihd.net/ugc/769486004382549587/47EECE7BA70C21C0413BC3023A44793E6E12F7EA/','https://steamusercontent-a.akamaihd.net/ugc/769486004382550404/719179E794ACA8286C7E60B49AB9AE64E38F5C9D/',nil,nil,49,108},
    ['Alliance Ranger Elite'] = {'Hero1','Jabbas Realm','Elite',7,0,3,
               {0,2,0,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462825247/5135F40AD33B5F2E497C7346A11A0C33A2493323/','',{},'https://steamusercontent-a.akamaihd.net/ugc/769486004382549587/47EECE7BA70C21C0413BC3023A44793E6E12F7EA/','https://steamusercontent-a.akamaihd.net/ugc/769486004382570926/A6FB1DC4BDB1DFDF4A7F19609B5011AA09E46B59/',nil,nil,49,108},
    ['Luke Skywalker - Jedi Knight'] = {'Hero1','Jabbas Realm','Elite',16,0,1,
               {1,1,1,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462828644/B620B723CA250FC002B47A0741BDDF05AD0D0C57/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1002555418841178638/4CE15DF35BD5B4363814517DD9591BBFCF17496B/','https://steamusercontent-a.akamaihd.net/ugc/1002555418841187332/4C1C314AC3917DC5CB394F7A36831E877BBF97D5/','',{{-2,3,1,'G'}},50,110},
     ------------------HEROS
    ['Shyla Varad'] = {'Hero','Jabbas Realm','Color',12,4,1,
                {1,0,1,0,1,0},{0,2,1,0,0,2,0,1},{0,0,2,0,0,0,1,1},{1,1,0,0,0,1,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460702476/4DF61A2E3660D4314E08D6542B795143176B8E5D/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430786519434297/21BFBE73D65D7A3D6F6EABDBD62692F140525D10/','https://steamusercontent-a.akamaihd.net/ugc/1001430786519434807/9DFE2F8ACA35E7CA7029C40970C832D859163A24/',nil,nil,51,108},
    ['Vinto Hreeda'] = {'Hero','Jabbas Realm','Color',11,4,1,
                {1,1,0,0,0,1},{0,0,1,0,0,0,0,1},{0,1,2,0,0,1,1,1},{1,0,0,1,0,0,0,2},'https://steamusercontent-a.akamaihd.net/ugc/859478214460702744/55F7433E7FA01D4520A67134EA91188206220FAA/','',{},'https://steamusercontent-a.akamaihd.net/ugc/753719037371224720/0CBE94C26EAEFB4A8B5E611BCBB3D2021FB01B02/','https://steamusercontent-a.akamaihd.net/ugc/753719037371197856/AF2DF87438612A12F21F467EB93A125DF18B4FEE/',nil,nil,52,108},
    ['Onar Koma'] = {'Hero','Jabbas Realm','Color',20,4,1,
                {0,0,1,1,0,0},{2,1,0,0,1,1,0,1},{1,0,1,0,0,0,1,1},{0,1,0,1,0,0,0,2},'https://steamusercontent-a.akamaihd.net/ugc/859478214460703046/941C569320DB6895B7304085897384DB4B809984/','',{},'https://steamusercontent-a.akamaihd.net/ugc/753719037371328434/A4CC0EA27A09565933DF5A72B1F1A798F7E0BCB8/','https://steamusercontent-a.akamaihd.net/ugc/753719037371329970/90FC956AD2CD6038A5EF496CB0107B84F41C9C9E/',nil,nil,53,108},
    ----------------------------------------------------------------------------------

    -----------TWIN SHADOWS--------------------------------------------------------------
    ['Heavy Stormtrooper'] = {'Villain','Twin Shadows','No',6,0,2,
               {0,1,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460697505/F78CF27B44BE8B3D7A3DE58A7162062679515778/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749058065562636285/27E9DFA70E1DB3CC1CA12EF05ACDDCA5D34F3811/','https://steamusercontent-a.akamaihd.net/ugc/884253484120609263/01BC92693B6335E75F592F85BF97C56465307A16/',nil,nil,54,9},
    ['Heavy Stormtrooper Elite'] = {'Villain','Twin Shadows','Elite',8,0,2,
               {0,1,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460697359/FDAE832029D34FB2910DB5E833DEF365D7764850/','',{},'https://steamusercontent-a.akamaihd.net/ugc/884253484124377337/F7B06D0004EE5FCD0B99799FF95F97CADDA9B0A9/','https://steamusercontent-a.akamaihd.net/ugc/884253484124377691/54AD71E534103E07530CF4292026B692003713D6/',nil,nil,54,9},
    ['Kayn Somos'] = {'Villain','Twin Shadows','Elite',12,0,1,
               {0,2,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460695752/148EDE7FFBD312B36D04CCDB6E858AD010AB38C0/','',{},'https://steamusercontent-a.akamaihd.net/ugc/874123149300665888/A4C94F597FDFFD1743C7311AC4138CD83873F087/','https://steamusercontent-a.akamaihd.net/ugc/874123149300666240/E346856F0ED38204F4CAD7117DE6689C6F29D717/',nil,nil,55,109},
    -------------------------MERCENARYS
    ['Tusken Raider'] = {'Villain','Twin Shadows','No',4,0,2,
               {0,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460687689/26D806C31A1C6878C605FD16A02F6EBF75DDCA19/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749058065562660663/FBED45A61F3BA6222C3DC0369DEEA54AAE8F732B/','https://steamusercontent-a.akamaihd.net/ugc/883132351293866831/BFFE0E58E219511DA5501409BA18AA3CD962F4F1/',nil,nil,56,56},
    ['Tusken Raider Elite'] = {'Villain','Twin Shadows','Elite',7,0,2,
               {0,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460687222/0CBF20CBCDACB31E84A16569CAEB3CD24E61AC6D/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749058065562660663/FBED45A61F3BA6222C3DC0369DEEA54AAE8F732B/','https://steamusercontent-a.akamaihd.net/ugc/755969254323563436/C6AA36B5DC5D8724BF59B5DF7726E7C9C393E737/',nil,nil,56,56},
    ['Boba Fett'] = {'Villain','Twin Shadows','Elite',12,0,1,
               {1,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460692685/90111C198251F287FBC3CE5E3262ECC4C2FCE23F/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749058065562646980/226DA4DF914AA6D97923F2C508DB948609654CE0/','https://steamusercontent-a.akamaihd.net/ugc/883132351295794517/C40A629D10E27A3AE3C4B21E136E7DA228D22B26/',nil,nil,57,109},
    ---------------------REBEL
    ['C-3PO'] = {'Hero1','Twin Shadows','Elite',4,0,1,
               {0,0,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462825897/C9F115EA58F6B41FFF9607E2437DBDBAECC02D54/','',{},'https://steamusercontent-a.akamaihd.net/ugc/876375705923129499/7DC64C3B5FA18708ADA0118951153E52C58E3C98/','https://steamusercontent-a.akamaihd.net/ugc/876375705923129790/523557EE2EAC4525EEC2C37011710B58487DA7A5/',nil,nil,58,58},
    ['R2-D2'] = {'Hero1','Twin Shadows','Elite',6,0,1,
               {1,0,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462829441/938B33C2EE5D4F960668DB2AB51655650FBA33CA/','',{},'https://steamusercontent-a.akamaihd.net/ugc/876375705922928679/73BB36D0605FE54A31F2B53A3A3A85BD4AEBB40E/','https://steamusercontent-a.akamaihd.net/ugc/876375705922928889/224D0A044D2237AB89BDD2CF65727C10275A7B2C/',nil,nil,59,59},
    -----------------HEROS
    ['Saska Teft'] = {'Hero','Twin Shadows','Color',11,4,1,
               {1,0,1,0,0,1},{0,1,0,0,0,0,0,1},{0,1,1,0,0,1,0,1},{1,1,1,0,0,1,1,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460701889/FC0374355830BC65D7541F021B601D06B1F10C97/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502238673/4A6072BCE17631902DB548D02AD8C6091AAC4AD6/','https://steamusercontent-a.akamaihd.net/ugc/885378115703310229/12139706621AEBCA9AFD37C30CA8E180FFE86224/',nil,nil,60,108},
    ['Biv Bodhrik'] = {'Hero','Twin Shadows','Color',13,4,1,
               {0,1,0,1,1,0},{1,1,1,0,0,1,1,1},{0,1,0,0,0,0,0,1},{0,1,1,0,0,1,0,1},'https://steamusercontent-a.akamaihd.net/ugc/859478214460702207/FE72EA23FE983CE2D2D31248F2E9B2FF9667ED2E/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502229194/A36289777AA640FEDE626E1667E9C5525760EA9E/','https://steamusercontent-a.akamaihd.net/ugc/885378115699459047/6BA9EB3292E69DB396A4FFB5DCED536335201D50/',nil,nil,61,108},
    ----------------------Heart of the Empire--------------------------------
    ['AT-DP (2x3)'] = {'Villain','Heart of the Empire','Elite',16,0,1,
               {1,1,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679065789155/C9AA044ADD7506EF79743F29CD452B9A1448E713/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502335115/07ECF488B60B975E6029421423985CEB759C25A5/','https://steamusercontent-a.akamaihd.net/ugc/1004808401668488059/575EA112CD58B366722AE6F1A15AC814DF22BED2/',nil,nil,8,9},
    ['Emperor Palpatine'] = {'Villain','Heart of the Empire','Elite',13,0,1,
               {0,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679065803371/D48A2485FE7309331F960648A96C8798181989D9/','',{},'https://steamusercontent-a.akamaihd.net/ugc/753719447936676511/1ABC276BF79AF3BAB573263BD6FE2BD1910DD39F/','https://steamusercontent-a.akamaihd.net/ugc/753719447936518895/053456BBF4A3F8F8D1FF8A273A27A45D6B0522A0/','',{{1.5,2,0,'P'}},63,63},
    ['Riot Trooper'] = {'Villain','Heart of the Empire','No',5,0,2,
               {0,1,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679065838836/746A098BBBD33CEED5907C815AF646623EDD65E8/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502605299/3DF0B3E9C8E237DC99A9AA994751FC8FE1DBCAEE/','https://steamusercontent-a.akamaihd.net/ugc/1004808401668643552/896FB99DA7ADF108549E38827DDD1179795784BB/',nil,nil,64,64},
    ['Riot Trooper Elite'] = {'Villain','Heart of the Empire','Elite',7,0,2,
               {0,1,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679065838836/746A098BBBD33CEED5907C815AF646623EDD65E8/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502605299/3DF0B3E9C8E237DC99A9AA994751FC8FE1DBCAEE/','https://steamusercontent-a.akamaihd.net/ugc/1001430786523290036/ADB51BF0192D1DD6C31EC7ED4E332560A2284E51/',nil,nil,64,64},
    ['Sentry Droid'] = {'Villain','Heart of the Empire','No',5,0,2,
               {0,0,2,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679065859423/D1237AB41E7A67FC839DAA64E338AB3F4EB5B4D5/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430786523398735/C5A26E67FEDCA8C53C8D61BE5DA605CA0F23F6DF/','https://steamusercontent-a.akamaihd.net/ugc/1001430786523399659/334D29468DBA8A6FFEB85DEC89188543BA939FFA/',nil,nil,65,9},
    ['Sentry Droid Elite'] = {'Villain','Heart of the Empire','Elite',8,0,2,
               {1,0,2,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679065859423/D1237AB41E7A67FC839DAA64E338AB3F4EB5B4D5/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430786523398735/C5A26E67FEDCA8C53C8D61BE5DA605CA0F23F6DF/','https://steamusercontent-a.akamaihd.net/ugc/1001430786523404327/69E9F1BE6B58EECCE73539173434FE1D1177B41C/',nil,nil,65,9},
    -------------------------MERCENARYS
    ['Maul'] = {'Villain','Heart of the Empire','Elite',12,0,1,
               {1,0,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679065884369/30E9A3161284718B30A9966BA76E14E345369175/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430929876389336/CE0E97D765B45AF66ED1C3F67492DBA92E13E70D/','https://steamusercontent-a.akamaihd.net/ugc/1004808401669047111/17148F2FBBF62C22DFEEB57E42FCDFE1DDBA2D83/','',{{2.8,1.6,-2,'R'},{1.8,1.7,1,'R'}},66,110},
    ['Clawdite Shapeshifter'] = {'Villain','Heart of the Empire','No',6,0,1,
               {0,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679065896340/B7584C02B28C2E21C08095DF832BA1295F37CBE6/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863363730/BBD8F4711F3E4F2BD6A7CFCD18D5B082493B5CA0/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863364120/44F27EF1EC808C3F0F9F6FD69E3DC4695D6CDD22/',nil,nil,67,109},
    ['Clawdite Shapeshifter Elite'] = {'Villain','Heart of the Empire','Elite',8,0,1,
               {1,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679065896340/B7584C02B28C2E21C08095DF832BA1295F37CBE6/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863363730/BBD8F4711F3E4F2BD6A7CFCD18D5B082493B5CA0/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863364521/4241A49FC68CBA76CA7ED2F938B48B89E4500ACE/',nil,nil,67,109},
    ---------------------REBEL
    ['Ahsoka Tano'] = {'Hero1','Heart of the Empire','Elite',12,0,1,
               {0,1,2,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/775102877237127402/11E20189C1D5604F4968F7771463410B463D9530/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1008188268576303052/7FEF34F9EBF4A85A026188615D46851F2EF01AFE/','https://steamusercontent-a.akamaihd.net/ugc/1008188268576303626/2A92F376FA667EFFD3DD0727ECE8261F10DE3F0A/','',{{1.2,1.1,2,'W'},{-3.1,1.6,2,'W'}},68,110},
    -----------------HEROS
    ['Drokkatta'] = {'Hero','Heart of the Empire','Color',13,4,1,
              {0,1,0,1,1,0},{0,1,2,0,0,1,1,1},{0,2,0,0,0,1,0,1},{0,0,2,0,0,0,1,1},'https://steamusercontent-a.akamaihd.net/ugc/941716679065933365/ABA2908BF0CC185A8EE764C9A760894D65DA15E9/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863337425/1D60690514B910DCF99CC4139DE8ACF0AC12B7C9/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863337925/7E5A9067ECDC32A42F651E6B1429018CA657896D/',nil,nil,69,108},
    ['Jarrod Kelvin'] = {'Hero','Heart of the Empire','Color',10,5,1,
              {2,0,0,0,1,0},{0,0,2,0,0,0,1,1},{0,1,1,0,0,1,0,1},{1,1,1,0,0,1,1,1},'https://steamusercontent-a.akamaihd.net/ugc/941716679065933957/97C54E49525C92E0C6FA43A372FAED007D8FE518/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863319414/D8E79C1DF9E74D5305655CB78B934E7AE17B0D9D/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863319933/520522247041DC3B1BD29D7F341010E2A3D977A0/',nil,nil,70,108},
    ['Ko-Tun Feralo'] = {'Hero','Heart of the Empire','Color',12,4,1,
              {0,1,1,0,1,0},{0,1,0,0,0,0,0,1},{1,1,1,0,0,1,1,1},{0,1,1,0,0,1,0,1},'https://steamusercontent-a.akamaihd.net/ugc/941716679065932629/87D97656FE1A3009C3A2C03D936DAD9C3E6FB6C3/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863328166/AA366F40EF51E6DA6B0E238E5B1D0C06558C7304/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863328774/7ED8C497FE82928655E8A27673699E89395C6168/',nil,nil,71,108},

    ----------------------Tyrants of Lothal--------------------------------
    ['Thrawn'] = {'Villain','Tyrants of Lothal','Elite',9,0,1,
              {1,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066068521/D6BDAD611C53C71A3291D7CDEBAD7C8C1196A4C0/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430929876511918/5D874AF779E48D85F763172DD4048E751F34A177/','https://steamusercontent-a.akamaihd.net/ugc/1004808401669173435/B0FF350B8D6662EE5ACF584E8B6BCC23FA96EF03/',nil,nil,72,109},
    ['Death Trooper'] = {'Villain','Tyrants of Lothal','No',5,0,1,
              {1,0,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066066086/037853BF239B948DF19707519FDFD2CBF76DEC05/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1002555418841224696/7C9EDD005DFFD4185D199C5D7B82894C41FEB6B5/','https://steamusercontent-a.akamaihd.net/ugc/1002555418841226689/91F53E299AAEDF88868AE02A4F9BA7B243BE6798/',nil,nil,73,109},
    ['Death Trooper Elite'] = {'Villain','Tyrants of Lothal','Elite',7,0,1,
              {1,0,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066066086/037853BF239B948DF19707519FDFD2CBF76DEC05/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1002555418841224696/7C9EDD005DFFD4185D199C5D7B82894C41FEB6B5/','https://steamusercontent-a.akamaihd.net/ugc/1002555418841267523/E8C0D170C2DCD403381CCA2A2DE47D1F9B6DD980/',nil,nil,73,109},
    -------------------------MERCENARYS
    ['Hondo Ohnaka'] = {'Villain','Tyrants of Lothal','Elite',9,0,1,
              {0,1,1,1,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066066841/E1C2DE4C431A5889FE0E28394D7FFA52AE0C434A/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430152563324804/3B62C6730C235950ACD8333BF8070E7B8C7F2935/','https://steamusercontent-a.akamaihd.net/ugc/1001430152563325361/8896EF17CF66B46673362CB825370FB9F6538A90/',nil,nil,74,109},
    ['Loth-cat'] = {'Villain','Tyrants of Lothal','No',3,0,2,
              {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066067611/46A70E973A99E378EC0C47934EC5E01EDACAE423/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430152563115774/777E2E9520F8E7A63BC6BA33DACD602D723EE335/','https://steamusercontent-a.akamaihd.net/ugc/1001430152563116554/FDC7CE1675A935BDB67CAF2980E78E59C9457F69/',nil,nil,75,75},
    ['Loth-cat Elite'] = {'Villain','Tyrants of Lothal','Elite',5,0,2,
              {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066067611/46A70E973A99E378EC0C47934EC5E01EDACAE423/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430152563115774/777E2E9520F8E7A63BC6BA33DACD602D723EE335/','https://steamusercontent-a.akamaihd.net/ugc/1001430152563116554/FDC7CE1675A935BDB67CAF2980E78E59C9457F69/',nil,nil,75,75},
              ---------------------REBEL
    ['Ezra Bridger'] = {'Hero1','Tyrants of Lothal','Elite',10,0,1,
              {2,0,1,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066066522/50AEDA426EF345B300E328DAB1B783E4D6E32184/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430786523442460/3640FFA5E59816E94151D5A75F2115CC13006474/','https://steamusercontent-a.akamaihd.net/ugc/1001430786523442966/497F5E2EF747219BA8ABAAD6E40763F2B04D3BD1/','',{{-0.8,3.5,1,'G'}},76,110},
    ['Kanan Jarrus'] = {'Hero1','Tyrants of Lothal','Elite',14,0,1,
              {1,0,2,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066067108/8D4E7ADFD7E836B039E303FED33BE0FCBCAAFDA9/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430786523561020/87BA4AA34917DFED684A969FA2AB9557635803D1/','https://steamusercontent-a.akamaihd.net/ugc/1001430786523561683/1191E5553F2410F80CB8D36588F767017D307477/','',{{-0.5,4,0.2,'B'}},77,110},
    ['Sabine Wren'] = {'Hero1','Tyrants of Lothal','Elite',11,0,1,
              {0,1,2,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066068007/BEBBD50EAFCC1FABDF9EFCDB8AC0DBC76F1C1B1C/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863257191/907764506712179A9B5F7DF4CDAE28B8B4C127A8/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863258934/1E03FB554CA67715CCAC75A4DA992361BC09AB70/',nil,nil,78,108},
    ['Zeb Orrelios'] = {'Hero1','Tyrants of Lothal','Elite',15,0,1,
              {0,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/941716679066069408/E2704B5C4760C30FD081FB90227565025105E5D0/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430786523597473/D98EA63BD6B29D1F04545CA4A3B45453C77C7F98/','https://steamusercontent-a.akamaihd.net/ugc/1001430786523613104/015D5FF5626A61BB54183C7B8CA051A60C51D842/',nil,nil,79,108},
              -----------------HEROS
    ['CT-1701'] = {'Hero','Tyrants of Lothal','No',12,4,1,
              {0,0,2,0,1,0},{1,1,0,0,0,1,0,1},{0,0,1,0,0,0,0,1},{0,1,2,0,0,1,1,1},'https://steamusercontent-a.akamaihd.net/ugc/941716679066065411/7EEBC19FD79622D4328E0B1599C249514AE03040/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430152563097554/D3060B8D46763F2AE99D04282C10981255995FF1/','https://steamusercontent-a.akamaihd.net/ugc/1001430152563098332/006954D5380C6B975285CEF450634F353635A3AA/',nil,nil,80,108},
    ['Tress Hacnua'] = {'Hero','Tyrants of Lothal','No',11,4,1,
              {0,1,1,0,0,1},{1,0,1,0,0,0,1,1},{0,0,2,0,0,0,1,1},{0,2,0,0,0,1,0,1},'https://steamusercontent-a.akamaihd.net/ugc/941716679066068992/91069918C78FDEBB8530B7B2019046EC52F826C2/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430786523473893/EC77A456F31C29786A06A4AC3AE33559C0019FDE/','https://steamusercontent-a.akamaihd.net/ugc/1001430786523474383/BB17209644E08E2674A63F4B1F6205D847F5D037/',nil,nil,81,108},

    --------------ALLY AND VILLAIN PACKS-----------------------------------------------------
    ['ISB Infiltrator'] = {'Villain','Ally and Villain Packs','No',4,0,2,
               {0,1,1,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460695752/148EDE7FFBD312B36D04CCDB6E858AD010AB38C0/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502596482/20DD76002C01E793B1B3A5DE4D14BC463D11003F/','https://steamusercontent-a.akamaihd.net/ugc/2442516864327362171/3030F71F51B3F113EA794B9A3214ACF136CA5293/',nil,nil,82,109},
    ['ISB Infiltrator Elite'] = {'Villain','Ally and Villain Packs','Elite',6,0,2,
               {0,1,1,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460696620/542E35449717FFB8425FE64A2E6EFA6A2D704921/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502596482/20DD76002C01E793B1B3A5DE4D14BC463D11003F/','https://steamusercontent-a.akamaihd.net/ugc/755969254323568150/C9F6E61CFE2F5381972C37DC020161A280E4AB98/',nil,nil,82,109},
    ['Dewback Rider (1x2)'] = {'Villain','Ally and Villain Packs','Elite',9,0,1,
               {1,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460698074/4E5C824041110158DD0F9DD33BB678C4FB9C595E/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1008188268576891710/C00BDA88434ADE473D92208FBDA82A3B2E216C2F/','https://steamusercontent-a.akamaihd.net/ugc/1008188268576892203/1915FCC97E2A9BD58027716A217AFAF537A5CCD5/',nil,nil,83,109},
    ['0-0-0'] = {'Villain','Ally and Villain Packs','Elite',8,0,1,
               {1,0,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214463090286/26895034441BD3D4FCCEED4818E715A95608F96B/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863293651/52B6581D9B4D834F848723A35B6FF498331E57C5/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863294221/CD4F9B39A3CA3DAEEDE3CCC4652FE295EC0AF618/',nil,nil,84,109},
    ['BT-1'] = {'Type','Villain and Villain Packs','Elite',10,0,1,
               {1,1,0,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214463091059/3663EDF8C61F3575EA0D5054B00C9ECAD2DCABFA/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863276629/524B94C9B263A9036399DC5C34D1BDD27D6F90F0/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863277231/8D07F84A3031C7300D17973E13B8B756E21B6D5D/',nil,nil,85,109},
    ['The Grand Inquisitor'] = {'Villain','Ally and Villain Packs','Elite',15,0,1,
               {1,0,1,1,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460694030/7CFEE7EB06541A19B1CFDD85F03A8C9F9F87693C/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430929876473221/A7310A87C1C0A4720A858C67EA60F9C9DB94F875/','https://steamusercontent-a.akamaihd.net/ugc/1004808401669152325/C685FAA68FABBEC9CEAFC2341B000A2019B6BBFD/','',{{2.5,2,-2.8,'R'},{-1,0.5,-2,'R'}},86,110},
    ------------------------MERCENARYS
    ['Jawa Scavenger'] = {'Villain','Ally and Villain Packs','No',3,0,1,
               {2,0,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214463091231/20E2942DCE88C63ADC6BA7D2FA7FFC70AC02A3FE/','',{},'https://steamusercontent-a.akamaihd.net/ugc/883132351298850268/C090F106F20A4C2654AC41E9B2849FC908D13E7A/','https://steamusercontent-a.akamaihd.net/ugc/883132351298850596/3C9BEA0498E090B7E9842A06A5DE51579FE73DDF/',nil,nil,87,109},
    ['Jawa Scavenger Elite'] = {'Villain','Ally and Villain Packs','Elite',5,0,1,
               {2,0,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214463091340/DD51C53452F0A5337B76BD2EE719D8672FC4C54C/','',{},'https://steamusercontent-a.akamaihd.net/ugc/883132351298850268/C090F106F20A4C2654AC41E9B2849FC908D13E7A/','https://steamusercontent-a.akamaihd.net/ugc/755969254323570729/541F97693FD9F912EF744AA48CC7274637640443/',nil,nil,87,109},
    ['Hired Gun'] = {'Villain','Ally and Villain Packs','No',3,0,2,
               {1,0,1,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460689887/239F571489393D6BBA3170EA1484AC5AFAF722D5/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863387686/25F9D2DBFB8F8210C93927A9EB95261B317A16A1/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863388142/67AB8E7640D6D69441821E3681EFF902D05C8215/',nil,nil,88,109},
    ['Hired Gun Elite'] = {'Villain','Ally and Villain Packs','Elite',4,0,2,
               {1,0,1,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460689887/239F571489393D6BBA3170EA1484AC5AFAF722D5/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863387686/25F9D2DBFB8F8210C93927A9EB95261B317A16A1/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863388675/2C1E4507FC969D165F8A195B344A790D2D6184A5/',nil,nil,88,109},
    ['Bantha Rider (2x3)'] = {'Villain','Ally and Villain Packs','Elite',21,0,1,
               {0,1,0,1,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460689887/239F571489393D6BBA3170EA1484AC5AFAF722D5/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502382246/5F9840BB34F0F42E454C87BFAB86A767775A6DBE/','https://steamusercontent-a.akamaihd.net/ugc/877499696240742572/33614152AC35572D2BD138DF1CDF58E37C2BCD17/',nil,nil,89,109},
    ['Greedo'] = {'Villain','Ally and Villain Packs','Elite',7,0,1,
               {0,0,2,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460690325/A4BCCD2F5714B033822875DB156EE8EC11AB90A5/','',{},'https://steamusercontent-a.akamaihd.net/ugc/933811471711132117/B2B42BEBCA7985EC255CA89FD579631B01661041/','https://steamusercontent-a.akamaihd.net/ugc/933811471711132391/0B97CD6ECC6907F1C89F562F87C04599139F6594/',nil,nil,90,109},
    ['Jabba the Hutt (2x2)'] = {'Villain','Ally and Villain Packs','Elite',10,0,1,
               {0,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460689306/7478DCC62657D054E3A3E3A8436686DD7218F7FA/','',{},'https://steamusercontent-a.akamaihd.net/ugc/775103339585818167/7D7644F36946892294FF92E95B302E2CFBF5A9BB/','https://steamusercontent-a.akamaihd.net/ugc/775102709098930111/20DE7BC7289FFA6D90E8E26954347420B7E6307B/',nil,nil,91,91},
    ------------------REBEL-
    ['Alliance Smuggler'] = {'Hero1','Ally and Villain Packs','No',3,0,1,
               {1,0,1,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462825592/70D68C98B7D6FF6BB98A7F981E9E9BF4677381D1/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863422491/B4C27EAD64AE883C3B5404FF897CFBE4000B7CC6/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863423664/F0A745F6AA160ABCBDEEF1E3141362F40A77D8D1/',nil,nil,92,108},
    ['Alliance Smuggler Elite'] = {'Hero1','Ally and Villain Packs','Elite',5,0,1,
               {1,0,1,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462825768/5DEC69963DD99BB82CBD047621663E70CAB2CBEB/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430772863422491/B4C27EAD64AE883C3B5404FF897CFBE4000B7CC6/','https://steamusercontent-a.akamaihd.net/ugc/1001430772863423291/606B7CFE919FE25FD0993FA89D8C3B02255B39E0/',nil,nil,108},
    ['Wookiee Warrior'] = {'Hero1','Ally and Villain Packs','No',11,0,2,
               {0,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462830708/66C1B260B4DEF86457021CDF9198559C0A39BF51/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1002555418841334463/A6418699DB3B6E7C0266EE8A9166247303C5776F/','https://steamusercontent-a.akamaihd.net/ugc/1002555418841338290/18352D89A219B89F6C869D89B9EDE22822F7F950/',nil,nil,93,93},
    ['Wookiee Warrior Elite'] = {'Hero1','Ally and Villain Packs','Elite',13,0,2,
               {0,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462831188/6268C7FCD1728CCD09F88D11647B1C80A7C41B91/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1002555418841334463/A6418699DB3B6E7C0266EE8A9166247303C5776F/','https://steamusercontent-a.akamaihd.net/ugc/1002555418841346139/B065D772AD0EDE69F1D1E6E5507B42A08C55560D/',nil,nil,93,93},
    ['Obi-Wan Kenobi'] = {'Hero1','Ally and Villain Packs','Elite',12,0,1,
               {1,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462829116/D576CD937E21D2B148422DB2CA09DB29232975FF/','',{},'https://steamusercontent-a.akamaihd.net/ugc/769484085134894642/50BE3CB0BD989BD004B8C44E9F4817A19659A3FC/','https://steamusercontent-a.akamaihd.net/ugc/769484085134822775/E14D437660E8086A230F4D6CC64AFA869DD32553/','',{{-2.8,3.5,0.3,'B'}},94,110},
    ['C1-10P'] = {'Hero1','Ally and Villain Packs','Elite',5,0,1,
               {0,0,1,1,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214463091535/1108D30CE0FE1A896CEF8D648E4205DE426A6816/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430152563090466/2FB62CEA067120A2B49CD5E7609F1123F26F1C5B/','https://steamusercontent-a.akamaihd.net/ugc/1001430152563092082/819BA77F321795F6C9A5330FE19DF743CCAEDDF5/',nil,nil,95,108},
    ['Hera Syndulla'] = {'Hero1','Ally and Villain Packs','Elite',7,0,1,
               {1,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214463091719/7B6D4E685555426EBBF249718DCCEDC72C7E4F99/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001430152563311855/047D4E5EE5647EFF76D4EF7291C698A105B250BA/','https://steamusercontent-a.akamaihd.net/ugc/1001430152563312350/19EEFBEE0ABE9F1D50992DF1008F69CABAE49999/',nil,nil,96,108},
    --------------------------------------------------------------------------------------
    ['Salacious B. Crumb'] = {'Villain','Jabbas Realm','No',6,0,1,
               {0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/755969254323574537/D43F3744E5AA46E18D7B2BE98E1177BC4C5C7C04/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001431073637347583/90039D9499360BDFC9B7E5AB96F17ED3076BFB0A/','https://steamusercontent-a.akamaihd.net/ugc/1001431073637348141/887423A3CF9354DA52E138345302CAC5026B49F1/',nil,nil,97,97},
    ['Pit Droid'] = {'Hero1','Jabbas Realm','No',3,0,1,
               {0,0,0,0,0,1},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/755969254323577946/9002746C516AC05C0B350CDA8CA8689DB60BCE67/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001431073636948178/8DA251B35748145279C7E7C553778440B03CEB2A/','https://steamusercontent-a.akamaihd.net/ugc/1001431073636948731/061307FC7A671F58A7D287740A0D92774186F3A6/',nil,nil,98,98},
    ['R5 Astromech'] = {'Hero1','The Bespin Gambit','No',4,0,1,
               {0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/755969254323581013/FDF66F121677DDF94492168FC45DBE456690F562/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1002558009221866679/192674A129DF293DC1B7DE31638C1CD5C82DBAD8/','https://steamusercontent-a.akamaihd.net/ugc/1002558009221865775/47F738762A346028C226B3E0FA51174D200A75D7/',nil,nil,99,99},
    ['Junk Droid'] = {'Hero1','The Bespin Gambit','No',1,0,1,
               {0,0,1,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/755969254323583000/3A4E0FBD1AA941E3426E0A40F8E08013C1E20D78/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1002558009221845413/9526048E3D6A131824BE625008740B68D74A3575/','https://steamusercontent-a.akamaihd.net/ugc/1002558009221844304/1155C9212EC090461513FE91771D05B6D87A3AF0/',nil,nil,100,100},
    ['Cam Droid'] = {'Hero1','The Bespin Gambit','No',3,0,1,
               {1,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/755969254323584995/DA4CD2EDD1329E4273E45CCD3F85E0D35901E19B/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001431073637001914/F3F4F446817987AB9A7B1755C2B4749B1C695FA6/','https://steamusercontent-a.akamaihd.net/ugc/1001431073637002459/1A0FA617D22B378D2115D165D70479E4C6A5220F/',nil,nil,101,101},
    ['J4X-7'] = {'Hero1','Heart of the Empire','No',4,0,1,
               {0,1,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/1007058515980964950/7527E743C97FA48AF7E30B1635076383435AAA97/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001431073636846742/40646A8F6E29C39E9E6A743566F8D2B22616F994/','https://steamusercontent-a.akamaihd.net/ugc/1001431073636847263/497ACDBD1659997C749B3E4383E2D2D83585C562/',nil,nil,62,108},
    ['88-Z'] = {'Villain','Heart of the Empire','No',4,0,1,
               {1,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/1007058515980998580/8C708BE18A447098F4EB7A7D21121BE7E24F0195/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1001431073637101454/5168B7E16CF15E3E9020B4EA2E0A20EF4E1E09FB/','https://steamusercontent-a.akamaihd.net/ugc/1001431073637115830/3672C40D43CB559ACBEDF0DA26A96129AC6A7FCE/',nil,nil,1,109},
    ['E-XD'] = {'Villain','Tyrants of Lothal','No',5,0,1,
               {0,0,0,2,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/1007058515980998580/8C708BE18A447098F4EB7A7D21121BE7E24F0195/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1035212224334890282/80CA3A1011E16D1CA8FA7D9BF286BDDDD7789A0E/','https://steamusercontent-a.akamaihd.net/ugc/1035212224334780865/05BD6C2F1B6BB26A36289FB5CDD6928B337E5D2D/',nil,nil,1,109},
    --IACP
    ['Kayn Somos '] = {'Hero','IACP','No',12,4,1,
               {0,1,1,0,1,0},{0,1,1,0,0,0,0,0},{0,1,1,0,0,0,0,0},{0,1,1,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460695752/148EDE7FFBD312B36D04CCDB6E858AD010AB38C0/','',{},'https://steamusercontent-a.akamaihd.net/ugc/874123149300665888/A4C94F597FDFFD1743C7311AC4138CD83873F087/','https://steamusercontent-a.akamaihd.net/ugc/874123149300666240/E346856F0ED38204F4CAD7117DE6689C6F29D717/',nil,nil,55,109},
    ['Lt. Renz'] = {'Hero','IACP','No',11,4,1,
              {1,1,0,0,0,1},{0,1,0,0,0,0,0,0},{1,1,1,0,0,0,0,0},{0,1,1,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462823446/711C92CD4158DBE06B91984835188FC59EBB29E1/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502574269/D5321F49A29210D8990A1FEC0462101A7CD54266/','https://steamusercontent-a.akamaihd.net/ugc/856103154385121507/509FDBECDA3D10DBB1E065E742C74E1EECA65D26/',nil,nil,4,109},
    ['Bossk '] = {'Hero','IACP','No',12,5,1,
              {0,0,1,1,1,0},{1,0,1,0,0,0,0,0},{0,0,1,0,0,0,0,0},{0,0,2,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460692296/5606F51E3C9671B6B69BD88AAF13B7E2AE51B3AE/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749058065562593052/C4F4C284BD3A455524931D0D59FE63DA7AFD5DCC/','https://steamusercontent-a.akamaihd.net/ugc/2442516506910899928/E1ADC37B4F8490EEC19D13AA112D8046A366E230/',nil,nil,28,109},
    ['Kir Kanos'] = {'Hero','IACP','No',13,4,1,
              {1,0,0,1,1,0},{1,1,1,0,0,0,0,0},{0,1,1,0,0,0,0,0},{0,1,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214462822554/5E8E2CE0F0F0C55E876D0AD5EAA11CED377FC040/','',{},'https://steamusercontent-a.akamaihd.net/ugc/856103543879850827/5105C684533768C83C20A6DF58C4A25638BA22C2/','https://steamusercontent-a.akamaihd.net/ugc/856103543879845491/89C8606040F44B1EAE3CDCDD328DF7A048E232CE/',nil,nil,6,6},
    ['Valiant Commander'] = {'Hero1','IACP','No',5,0,1,
              {0,1,1,0,1,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0},'https://steamusercontent-a.akamaihd.net/ugc/859478214460704202/E433A0F0F46146764C3415171363CBBB13F90659/','',{},'https://steamusercontent-a.akamaihd.net/ugc/1749057862502191511/6A70477218DE01926B280C80BDF625CEAB5ED2AC/','https://steamusercontent-a.akamaihd.net/ugc/883132030728356065/596BF42DE259C88E41E195118B09DED7C9E8F3EE/',nil,nil,19,108},
    }


    --- For the Bag Sorting Function
    Bag_Items = {
        ['Imperial Deployment Cards'] = {-71.25, 0.57, -19.42},
        ['Mercenary Deployment Cards'] = {-66.50, 0.57, -19.42},
        ['Rebel Deployment Cards'] = {-70.09, 0.49, 30.40},
        ['Companion Deployment Cards'] = {-61.76, 0.36, -19.42},
        ['Rewards'] = {-70.11, 0.89, 16.57},
        ['Tier 1 Items'] = {-65.10, 0.48, 28.90},
        ['Tier 2 Items'] = {-65.10, 0.48, 22.90},
        ['Tier 2 Item'] = {-65.10, 0.53, 22.90},
        ['Tier 3 Items'] = {-65.10, 0.48, 16.44},
        ['Supply Cards'] = {-70.13, 0.49, 22.92},
        ['Story Cards'] = {69.95, 1.04, 2.30},
        ['Red Side Missions'] = {69.99, 1.04, -4.84},
        ['Green Side Missions'] = {69.95, 1.04, -12.20},
        ['Grey Side Missions'] = {69.95, 1.04, -19.70},
        ['Imperial Class Cards'] = {-25,2,-30},
        ['Agenda Cards'] = {-35,2,-6},
        ['Hero Cards'] = {-30,2,27},
    }

    -- For the Menu Help Feature
    Highlight = {
        [1] = {}, -- Blank
        [2] = {}, -- Hero
        [3] = {}, -- Class
        [4] = {}, -- Agenda
        [5] = {}, -- Story
    }

    --each die range, attack, surge , block, evade
    Die_Reference = {
        ["Yellow"] = {[1] = {2,1,0,0,0},[2] = {1,1,1,0,0},[3] = {0,0,1,0,0},[4] = {2,0,1,0,0},[5] = {1,2,0,0,0},[6] = {0,1,2,0,0}},
        ["Green"] = {[1] = {2,2,0,0,0},[2] = {1,1,1,0,0},[3] = {1,2,0,0,0},[4] = {3,2,0,0,0},[5] = {2,1,1,0,0},[6] = {1,0,1,0,0}},
        ["Blue"] = {[1] = {5,1,0,0,0},[2] = {3,1,1,0,0},[3] = {4,2,0,0,0},[4] = {3,2,0,0,0},[5] = {2,0,1,0,0},[6] = {2,1,0,0,0}},
        ["Red"] = {[1] = {0,2,0,0,0},[2] = {0,1,0,0,0},[3] = {0,3,0,0,0},[4] = {0,3,0,0,0},[5] = {0,2,1,0,0},[6] = {0,2,0,0,0}},
        ["Black"] = {[1] = {0,0,0,2,0},[2] = {0,0,0,3,0},[3] = {0,0,0,1,0},[4] = {0,0,0,0,1},[5] = {0,0,0,2,0},[6] = {0,0,0,1,0}},
        ["White"] = {[1] = {0,0,0,1,1},[2] = {0,0,0,1,0},[3] = {0,0,0,1,1},[4] = {0,0,0,99,0},[5] = {0,0,0,0,1},[6] = {0,0,0,0,0}},
    }


    -- Currently Unused
    Status_Details =
    {
        {'Inspired','Reroll 1 Atk or Def Dice.  After reroll discard'},
        {'Hidden','-2 Accuracy while Defending. +1 Surge while Attacking. After Attack discard'},
        {'Focused','Declare attack or test add 1 green die. After resolve discard.'},
        {'Bleeding','If not this suffer 1 strain, or discard'},
        {'Burning','While Defending -1 block or discard'},
        {'Stunned','Cannot attack/move or discard'},
        {'Weakened','-1 surge while attacking, -1 remove surge while defending. Discard at end.'}
    }


    -- For the Dice Rolling
    Dice_Status = {
        [1] = {'Yellow'},
        [2] = {'Blue'},
        [3] = {'Green'},
        [4] = {'Red'},
        [5] = {'Black'},
        [6] = {'White'},
        ['Yellow'] = {1},
        ['Blue'] = {2},
        ['Green'] = {3},
        ['Red'] = {4},
        ['Black'] = {5},
        ['White'] = {6},
        ['Hero'] = {false},
        ['Villain'] = {false},
        ['Extra'] = {false},
        ['Roll'] = {false},
    }

    -- Name of map = map image url, map positon, map rotation, map scale, array of door positions, door health, array of crates, crate scale, array of mission tokens, mt scale, array of faction tokens, ft scale, terminal array, terminal scale, entrance token, et scale
    Maps = {
        --Tutorial
        ['Tutorial'] = {'https://steamusercontent-a.akamaihd.net/ugc/1001430929872212424/75484BC9355996141E0E90F74844B812A9BA89C4/', {-1.76, 0.96, -0.75}, {0.00, 0.00, 0.00}, {28.00, 1.00, 28.00},
        {{{-7.38, 0.84, 6.80},{0.00, 0.00, 359.99},{1.81, 1.81, 1.81}},{{15.93, 0.84, -0.45},{0.00, 0.00, 359.99},{1.81, 1.81, 1.81}}},'',
        {{0.46, 1.06, -17.79}},'','','','','',
        {{-11.46, 0.97, -25.66},{15.29, 0.97, -10.14}},'','',''},
        --Core3D
        ['Aftermath'] = { 'C3D', {-1.50, 1.37, 5.50}, {359.98, 270.00, 359.93}, {1.40, 1.40, 1.40},'Forest','','','','','','','','','','',''},
        ['Captured'] = { 'C3D', {1.23, 1.15, 2.01}, {359.77, 359.99, 180.26}, {4.30, 4.30, 4.30},'Imperial','','','','','','','','','','',''},
        ['Brushfire'] = { 'C3D', {3.00, 0.79, -2.00}, {0.63, 180.02, 0.18}, {3.75, 3.75, 3.75},'Forest','','','','','','','','','','',''},
        ['Temptation'] = { 'C3D', {1.05, 1.69, -3.87}, {0.00, 180.00, 0.00}, {5.15, 5.15, 5.15},'Forest','','','','','','','','','','',''},
        ['High Moon'] = { 'C3D', {-4.70, 1.86, -2.01}, {0.00, 180.00, 180.00},{4.55, 4.55, 4.55},'Desert','','','','','','','','','','',''},
        ['Indebted'] = { 'C3D', {-1.37, 0.89, -0.67},{359.94, 270.02, 359.64},{4.05, 4.05, 4.05},'Forest','','','','','','','','','','',''},
        ['Loose Cannon'] = { 'C3D', {-18.00, 0.69, 0.00},{0.00, 180.00, 0.01},{5.03, 3.35, 5.03},'Desert','','','','','','','','','','',''},
        ['Friends of Old'] = { 'C3D', {-0.61, 1.87, -4.59},{0.00, 180.02, 180.00},{4.85, 4.85, 4.85},'Forest','','','','','','','','','','',''},
        ['Sorry About the Mess'] = { 'C3D', {1.94, 2.75, -12.94},{359.63, 0.00, 179.82},{4.35, 4.35, 4.35},'Desert','','','','','','','','','','',''},
        ['Homecoming'] = { 'C3D', {-3.00, 0.92, 1.00},{359.96, 270.00, 179.99},{4.10, 4.10, 4.10},'Desert','','','','','','','','','','',''},
        ['The Spice Job'] = { 'C3D', {-1.00, 1.16, 6.00},{0.08, 269.99, 179.79},{4.65, 4.65, 4.65},'Desert','','','','','','','','','','',''},
        ['Target of Opportunity'] = { 'C3D', {-0.02, 1.19, -3.40},{0.00, 90.00, 0.45},{1.50, 1.50, 1.50},'Imperial','','','','','','','','','','',''},
        ['Viper\'s Den'] = { 'C3D', {0.13, 1.87, -2.91},{0.00, 90.00, 180.00},{4.80, 4.80, 4.80},'Desert','','','','','','','','','','',''},
        ['A Simple Task'] = { 'C3D', {-2.05, 0.95, -2.01},{0.00, 180.00, 0.46},{4.25, 4.25, 4.25},'Desert','','','','','','','','','','',''},
        ['Generous Donations'] = { 'C3D', {2.00, 0.83, 1.00},{0.30, 89.99, 0.00},{4.15, 4.15, 4.15},'Forest','','','','','','','','','','',''},
        ['Luxury Cruise'] = { 'C3D', {1.72, 0.90, -8.50},{359.94, 359.99, 0.00},{4.00, 4.00, 4.00},'Imperial','','','','','','','','','','',''},
        ['Means of Production'] = { 'C3D', {-3.48, 0.92, -3.52},{0.38, 0.00, 0.00},{3.90, 1.95, 3.90},'Forest','','','','','','','','','','',''},
        ['Breaking Point'] = { 'C3D', {0.00, 1.06, -11.00},{359.83, 0.00, 0.00},{1.72, 1.72, 1.72},'Desert','','','','','','','','','','',''},
        ['Impounded'] = { 'C3D', {-3.53, 0.91, 3.46},{359.86, 0.00, 359.59},{4.40, 4.40, 4.40},'Desert','','','','','','','','','','',''},
        ['Wanted'] = { 'C3D', {10.50, 1.02, 4.50},{359.96, 89.97, 359.64},{0.48, 0.48, 0.48},'Desert','','','','','','','','','','',''},
        ['A New Threat'] = { 'C3D', {-3.01, 0.79, 5.01},{359.99, 89.99, 359.81},{3.40, 3.40, 3.40},'Forest','','','','','','','','','','',''},
        ['Under Siege'] = { 'C3D', {2.50, 1.12, 2.51},{0.00, 179.99, 180.08},{3.35, 3.35, 3.35},'Forest','','','','','','','','','','',''},
        ['Imperial Hospitality'] = { 'C3D', {-2.00, 1.14, -1.01},{0.00, 270.01, 180.46},{4.30, 4.30, 4.30},'Imperial','','','','','','','','','','',''},
        ['Fly Solo'] = { 'C3D', {3.61, 3.03, -6.19},{0.00, 0.00, 0.00},{0.55, 0.55, 0.55},'Desert','','','','','','','','','','',''},
        ['Incoming'] = { 'C3D', {-1.00, 0.98, 0.00},{359.63, 90.02, 179.99},{3.60, 3.60, 3.60},'Forest','','','','','','','','','','',''},
        ['Drawn In'] = { 'C3D', {-0.50, 1.19, -3.48},{0.54, 89.97, 0.03},{1.50, 1.50, 1.50},'Imperial','','','','','','','','','','',''},
        ['Chain of Command'] = { 'C3D', {-2.50, 1.02, 5.50},{0.00, 89.99, 0.45},{4.44, 2.22, 4.44},'Imperial','','','','','','','','','','',''},
        ['The Source'] = { 'C3D', {-2.43, 0.66, 0.53},{0.06, 269.98, 0.00},{0.41, 0.41, 0.41},'Imperial','','','','','','','','','','',''},
        ['Last Stand'] = { 'C3D', {-8.05, 2.19, 0.04},{0.00, 90.00, 0.00},{3.30, 3.30, 3.30},'Desert','','','','','','','','','','',''},
        ['Desperate Hour'] = { 'C3D', {-8.05, 2.19, 0.04},{0.00, 90.00, 0.00},{3.30, 3.30, 3.30},'Desert','','','','','','','','','','',''},
        --additional missions
        ['Top Target'] = { 'AV3D', {0.00, 0.89, -2.00},{359.98, 270.00, 180.01},{3.90, 3.90, 3.90},'Desert','','','','','','','','','','',''},
        ['Infection'] = { 'AV3D', {-1.95, 0.99, -0.89},{0.00, 0.00, 0.00},{4.90, 4.90, 4.90},'Desert','','','','','','','','','','',''},
        ['Binary Revolution'] = { 'AV3D', {1.08, 0.78, -10.05},{0.68, 179.97, 359.78},{0.43, 0.43, 0.43},'Imperial','','','','','','','','','','',''},
        ['Bunker Buster'] = { 'AV3D', {0.01, 0.95, 0.61}, {359.98, 0.01, 179.90}, {4.30, 4.30, 4.30},'Desert','','','','','','','','','','',''},
        ['Forest Ambush'] = { 'AV3D', {8.28, 0.89, -12.74}, {0.00, 270.00, 0.00}, {4.50, 4.50, 4.50},'Forest','','','','','','','','','','',''},
        ['Etiquette and Torture'] = { 'AV3D', {9.00, 0.83, 0.00}, {0.06, 269.98, 0.50}, {0.41, 0.41, 0.41},'','','','','','','','','','','',''},
        ['Back-Room Bargains'] = { 'AV3D', {-2.24, 1.13, -14.21}, {359.79, 180.04, 359.64},{1.47, 1.47, 1.47},'Desert','','','','','','','','','','',''},
        ['Salvage Operatives'] = { 'AV3D', {-1.43, 2.84, -7.81},{0.00, 270.02, 180.00},{4.40, 4.40, 4.40},'Desert','','','','','','','','','','',''},
        ['Cornered'] = { 'AV3D', {9.51, 1.00, -11.49},{359.86, 180.05, 180.00},{4.97, 3.31, 4.97},'Desert','','','','','','','','','','',''},
        ['Predator and Prey'] = { 'AV3D', {-3.00, 0.70, 6.00},{0.00, 90.00, 0.00},{5.00, 5.00, 5.00},'Forest','','','','','','','','','','',''},
        ['Celebration'] = { 'AV3D', {9.54, 0.96, -5.53}, {0.00, 270.01, 179.96}, {5.20, 5.20, 5.20},'Forest','','','','','','','','','','',''},
        ['Dark Obsession'] = { 'AV3D', {-2.52, 0.61, -2.50}, {0.00, 90.00, 0.00}, {0.55, 0.55, 0.55},'Imperial','','','','','','','','','','',''},
        ['Precious Cargo'] = {'AV3D', {-5.23, 0.78, -4.37}, {0.00, 89.97, 0.00}, {5.25, 3.50, 5.25},'Desert','','','','','','','','','','',''},
        ['Phantom Extraction'] = {'AV3D', {-0.54, 0.72, -7.48}, {0.00, 270.01, 0.00}, {5.35, 5.35, 5.35},'Desert','','','','','','','','','','',''},
        ['Deadly Transmission'] = {'AV3D', {-0.50, 1.01, -4.52}, {0.00, 90.01, 180.01}, {4.65, 4.65, 4.65},'Desert','','','','','','','','','','',''},
        ['Sympathy for the Rebellion'] = {'AV3D', {8.48, 0.66, -6.49}, {0.06, 270.00, 0.00}, {1.05, 1.05, 1.05},'','','','','','','','','','','',''},
        ['Armed and Operational'] = {'AV3D', {-1.04, 0.86, 0.10}, {359.98, 270.01, 180.15}, {4.05, 4.05, 4.05},'Desert','','','','','','','','','','',''},
        ['Brace for Impact'] = { 'AV3D', {-2.00, 0.70, -9.00}, {0.02, 269.99, 359.98}, {4.45, 4.45, 4.45},'Forest','','','','','','','','','','',''},
        ['Imperial Entanglements'] = { 'AV3D', {0.50, 0.86, -6.50}, {0.00, 0.00, 359.90}, {3.90, 3.90, 3.90},'Imperial','','','','','','','','','','',''},
        ['Brute Force'] = {'AV3D',  {-3.49, 0.68, 0.50}, {0.00, 269.97, 0.00}, {4.75, 4.75, 4.75},'Forest','','','','','','','','','','',''},
        ['Strength of Command'] = {'AV3D', {1.52, 3.75, -1.72}, {0.00, 90.02, 0.00}, {1.00, 1.00, 1.00},'Imperial','','','','','','','','','','',''},
        ['Into the Wastes'] = {'AV3D', {0.50, 0.99, -6.50},{359.92, 0.00, 180.02}, {4.25, 4.25, 4.25},'Desert','','','','','','','','','','',''},
        ['The Anchorhead Affair'] = {'AV3D', {-12.50, 2.85, 3.50}, {0.00, 270.00, 180.00}, {4.25, 4.25, 4.25},'Desert','','','','','','','','','','',''},
        ['A Bounty Protected'] = {'AV3D', {-14.00, 0.71, -8.00}, {0.00, 0.01, 0.00}, {4.40, 4.40, 4.40},'Forest','','','','','','','','','','',''},
        ['Fully Charged'] = {'AV3D', {-5.01, 0.83, 9.00}, {359.83, 180.01, 359.97}, {4.65, 4.65, 4.65},'Hoth','','','','','','','','','','',''},
        ['Gunrunner'] = {'AV3D', {6.90, 0.70, -1.41}, {0.09, 0.01, 359.94},{4.35, 4.35, 4.35},'Forest','','','','','','','','','','',''},
        ['Security Breach'] = { 'AV3D', {-3.80, 1.42, -2.26}, {0.0, 0.00, 180.00}, {4.70, 4.70, 4.70},'Imperial','','','','','','','','','','',''},
        ['Paying Debts'] = { 'AV3D', {-2.00, 0.72, -14.00}, {359.97, 89.97, 359.83}, {4.70, 4.70, 4.70},'Clouds','','','','','','','','','','',''},
        ['Into the Unknown'] = { 'AV3D',{-5.59, 1.07, 0.52},{359.99, 359.98, 179.99},{5.00, 5.00, 5.00},'Clouds','','','','','','','','','','',''},
        ['Communication Breakdown'] = {'AV3D', {10.82, 0.65, -10.09}, {0.00, 180.00, 0.00}, {4.70, 4.70, 4.70},'Hoth','','','','','','','','','','',''},
        ['Snowcrash'] = {'AV3D', {-30.65, 0.81, -5.57}, {0.00, 359.98, 180.00}, {4.20, 4.20, 4.20},'Hoth','','','','','','','','','','',''},
        ['One Fat Slug'] = {'JR3D', {-31.07, 0.36, -4.03}, {359.74, 270.02, 0.02}, {4.05, 4.05, 4.05},'Desert','','','','','','','','','','',''},
        ['A Light in the Darkness'] = {'JR3D', {-10.04, 2.42, -3.23}, {0.00, 270.00, 0.00}, {4.30, 4.30, 4.30},'Desert','','','','','','','','','','',''},
        ['Strike Force Xesh'] = {'JR3D', {-1.69, 1.65, -2.95}, {0.00, 0.00, 0.00}, {3.85, 3.85, 3.85}, 'Forest','','','','','','','','','','',''},
        ['Open to Interpretation'] = {'JR3D', {1.50, 0.46, 0.50}, {0.02, 180.01, 180.09}, {4.46, 2.97, 4.46},'Desert','','','','','','','','','','',''},
        --Twin Shadows 3D
        ['Hunted Down'] = { 'TS3D', {12.49, 0.68, 8.55},{0.00, 0.03, 0.00}, {5.05, 5.05, 5.05},'Desert','','','','','','','','','','',''},
        ['Past Life Enemies'] = { 'TS3D', {-2.94, 0.87, -7.31},{0.09, 270.00, 179.99}, {3.55, 3.55, 3.49},'Desert','','','','','','','','','','',''},
        ['Shady Dealings'] = {'TS3D', {6.93, 1.08, -7.95}, {0.21, 180.01, 179.83}, {4.65, 4.65, 4.65},'Desert','','','','','','','','','','',''},
        ['Canyon Run'] = {'TS3D', {-2.00, 1.15, -17.00},{0.00, 179.98, 180.00},{3.80, 3.80, 3.80},'Desert','','','','','','','','','','',''},
        ['Fire in the Sky'] = {'TS3D', {-4.27, 0.68, -7.73},{0.01, 270.03, 0.01},{3.85, 3.85, 3.85},'Imperial','','','','','','','','','','',''},
        ['Infiltrated'] = {'TS3D', {-4.27, 0.68, -7.73},{0.01, 270.03, 0.01},{3.85, 3.85, 3.85},'Imperial','','','','','','','','','','',''},
        --Hoth 3D
        ['The Battle of Hoth'] = {'H3D', {-7.51, 0.67, 1.12}, {0.00, 0.00, 0.00},{4.74, 4.74, 4.82},'Hoth','','','','','','','','','','',''},
        ['Escape from Cloud City'] = {'H3D', {34.39, 0.77, -1.84}, {0.06, 270.02, 359.91}, {5.70, 1.90, 5.70},'Clouds','','','','','','','','','','',''},
        ['Survival of the Fittest']  = {'H3D', {4.00, 0.84, 22.79}, {0.00, 359.99, 180.00}, {4.35, 4.35, 4.35},'Hoth','','','','','','','','','','',''},
        ['The Hard Way'] = {'H3D', {11.23, 0.65, 6.05}, {0.00, 90.00, 0.00}, {4.60, 4.60, 4.60},'Desert','','','','','','','','','','',''},
        ['Scouring of the Homestead'] = {'H3D', {2.47, 0.92, -10.55}, {0.00, 0.00, 0.00},{4.65, 4.65, 4.65},'Desert','','','','','','','','','','',''},
        ['White Noise'] = { 'H3D', {-9.50, 0.78, -4.51}, {359.46, 0.00, 359.87}, {4.56, 4.56, 4.56},'Hoth','','','','','','','','','','',''},
        ['Home Front'] = {'H3D', {-0.51, 0.86, -4.45}, {0.01, 0.00, 179.99}, {4.15, 4.15, 4.15},'Hoth','','','','','','','','','','',''},
        ['Return to Echo Base'] = {'H3D', {3.00, 0.68, -6.73}, {0.00, 90.02, 0.00}, {4.25, 4.25, 4.25},'Hoth','','','','','','','','','','',''},
        ['Know Your Enemy' ]= {'H3D', {-1.49, 0.90, -1.52}, {359.99, 269.98, 180.01}, {4.80, 4.80, 4.80},'Forest','','','','','','','','','','',''},
        ['Constant Vigilance'] = {'H3D', {7.50, 15.31, -2.50}, {359.95, 90.01, 0.00}, {5.45, 5.45, 5.45},'Forest','','','','','','','','','','',''},
        ['Preventative Measures'] = {'H3D', {-8.00, 0.80, 6.95}, {0.00, 270.01, 180.00}, {5.30, 5.30, 5.30},'Hoth','','','','','','','','','','',''},
        ['One Step Behind'] = {'H3D', {0.00, 0.65, -2.14}, {0.00, 359.96, 0.00}, {4.20, 4.20, 4.20},'Hoth','','','','','','','','','','',''},
        ['Rescue Ops'] = {'H3D', {0.00, 0.65, 0.00}, {0.00, 0.00, 0.00}, {2.25, 2.50, 4.00},'Hoth','','','','','','','','','','',''},
        ['The Last Line'] = {'H3D', {2.56, 0.65, 4.00}, {0.00, 180.01, 0.00}, {4.00, 4.00, 4.00},'Forest','','','','','','','','','','',''},
        ['Disaster'] = {'H3D', {-8.36, 0.65, -4.16}, {359.98, 359.98, 0.00}, {3.95, 3.95, 3.95},'Hoth','','','','','','','','','','',''},
        ['Our Last Hope'] = {'H3D', {-15.37, 0.93, 7.42}, {0.02, 270.07, 0.04}, {0.30, 0.30, 0.30},'Hoth','','','','','','','','','','',''},
        --Bespin Gambit 3D
        ['Reclamation'] = { 'BG3D', {0.00, 0.90, 9.00}, {359.87, 269.97, 359.61}, {4.63, 3.09, 4.63},'Clouds','','','','','','','','','','',''},
        ['Reclassified'] = {'BG3D', {-2.41, 2.01, -1.29}, {0.00, 179.98, 0.00}, {4.41, 2.94, 4.41},'Clouds','','','','','','','','','','',''},
        ['Panic in the Streets'] = {'BG3D', {-0.80, 0.84, -1.70}, {0.00, 270.00, 180.00}, {3.60, 3.60, 3.60},'Clouds','','','','','','','','','','',''},
        ['Freedom Fighters'] = {'BG3D',{-2.29, 0.98, -4.48}, {0.48, 0.02, 359.95}, {4.75, 4.75, 4.75},'Clouds','','','','','','','','','','',''},
        ['Cloud City\'s Secret'] = {'BG3D', {8.09, 0.68, -10.32}, {0.00, 0.00, 0.00}, {3.85, 3.85, 3.85},'Clouds','','','','','','','','','','',''},
        ['Hostile Takeover'] = {'BG3D', {-19.31, 4.61, -11.21},{0.00, 270.00, 180.00}, {4.25, 4.25, 4.25},'Clouds','','','','','','','','','','',''},
        --Jabba's REALM 3D
        ['Trespass'] = { 'JR3D', {-13.36, 1.06, -4.40}, {0.18, 180.41, 0.17}, {0.45, 0.45, 0.45},'Desert','','','','','','','','','','',''},
        ['Perilous Hunt'] = { 'JR3D', {-9.50, 1.02, -12.50}, {0.08, 90.00, 359.98}, {5.20, 5.20, 5.20},'Forest','','','','','','','','','','',''},
        ['Extortion'] = { 'JR3D',{-8.50, 4.55, -2.50}, {0.00, 270.00, 0.00}, {0.93, 0.93, 0.93},'Forest','','','','','','','','','','',''},
        ['A Hero\'s Welcome'] = { 'JR3D',{-11.19, 1.63, -11.21}, {0.02, 180.01, 0.08}, {4.80, 4.80, 4.80},'Forest','','','','','','','','','','',''},
        ['Born from Death'] = { 'JR3D',{-12.00, 0.26, -3.51}, {0.00, 180.00, 0.00}, {4.15, 4.15, 4.15},'Forest','','','','','','','','','','',''},
        ['Hostile Negotiations'] = { 'JR3D', {-22.35, 2.02, 6.82}, {359.98, 0.00, 179.92},{4.50, 4.50, 4.50},'Forest','','','','','','','','','','',''},
        ['Overcharged'] = { 'JR3D',{-8.37, 3.27, -5.45}, {0.00, 90.00, 180.00}, {4.40, 4.40, 4.40},'Forest','','','','','','','','','','',''},
        ['Trophy Hunting'] = {'JR3D',{-8.37, 1.83, 1.05}, {0.00, 270.00, 0.00}, {4.28, 4.14, 4.14},'Forest','','','','','','','','','','',''},
        ['Turf War'] = {'JR3D',{-20.50, 0.51, 7.79},{0.00, 180.00, 0.00},{4.50, 4.50, 4.50},'Forest','','','','','','','','','','',''},
        ['Moment of Fate'] = {'JR3D',{-13.00, 0.39, -2.51}, {0.00, 179.95, 0.00}, {4.00, 4.00, 4.00},'Desert','','','','','','','','','','',''},
        ['From All Sides'] = {'JR3D', {-5.64, 2.41, -5.65}, {359.78, 89.68, 180.10}, {3.90, 3.90, 3.90},'Desert','','','','','','','','','','',''},
        ['Dangerous Allies'] = {'JR3D', {-13.50, 8.44, 14.73}, {359.98, 359.98, 359.84},{3.65, 3.65, 3.65},'Desert','','','','','','','','','','',''},
        ['Almost Home'] = {'JR3D', {-13.00, 0.39, -2.51}, {0.00, 179.95, 0.00}, {4.00, 4.00, 4.00}, 'Desert','','','','','','','','','','',''},
        ['Execute the Plan'] = {'JR3D', {-12.87, 0.51, 1.18},{0.00, 0.00, 0.00},{4.50, 4.50, 4.50},'Forest','','','','','','','','','','',''},
        ['Storming the Palace'] = {'JR3D',{-22.29, 1.11, 11.68}, {0.00, 0.00, 0.00}, {4.00, 4.00, 4.00}, 'Desert','','','','','','','','','','',''},
        ['Mutiny'] = {'JR3D', {-30.97, 1.64, 12.15}, {0.0, 180.00, 0.0}, {3.70, 3.70, 3.70},'Desert','','','','','','','','','','',''},
        --IACP
        ['Aftershock'] = {'IACP3D', {-5.00, 1.31, 3.47}, {0.00, 270.00, 0.00}, {5.14, 3.43, 5.14},'Forest','','','','','','','','','','',''},

        -- Core Game Maps 2D
        --['Aftermath'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300260138/FBC551FE454DE87AC18C383D0E3CE7B594294B33/', {-1.76, 0.96, -0.75}, {0.00, 180.00, 0.00}, {18.00, 1.00, 18.00},
        --{{{-1.37, 0.85, -6.77},{0.00, 270.00, 359.99},{1.81, 1.81, 1.81}}},'8',
        --{{-12.07, 1.06, -11.15},{17.38, 1.06, -14.61},{-7.76, 1.06, 9.47}},'','','','','',
        --{{-16.55, 0.97, -10.84},{12.76, 0.97, -14.51},{0.15, 0.97, 10.45},{-4.43, 0.97, 1.68}},'4',{{-16.44, 1.11, 14.44}},''},
        --['The Source'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300253386/CBED272BE389EC19DDA7797E79F140AD7180EB06/', {0.63, 1.06, 1.07}, {0.00, 0.00, 180.00}, {30.00, 1.00, 30.00},
        --{{{-14.15, 0.84, 13.17},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{-14.44, 0.84, -11.53},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{26.80, 0.84, -7.36},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{-2.19, 1.06, 27.75},{-6.52, 1.06, -0.84},{10.12, 1.06, -17.43},{9.87, 1.06, -0.94}},'','','',
        --'','',{{6.18, 1.06, 23.26}},'',{{-14.35, 1.16, 19.02}},''},
        --['Under Siege'] = {'https://steamusercontent-a.akamaihd.net/ugc/1008189224116157228/F54EF46A830277F8E5D8A88FD33FA1BC6C3EF41E/', {0.63, 1.06, 1.07}, {0.00, 270.00, 180.00}, {30.00, 1.00, 30.00},
        --{{{4.40, 0.84, -2.10},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{8.45, 0.84, 12.53},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{4.50, 0.84, 16.24},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{-16.48, 0.84, 12.76},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}}},'6',
        --{{-14.65, 1.06, 2.42},{-14.50, 1.06, 12.16},{-21.21, 1.06, 24.61},{6.85, 1.06, 27.61}},'','','',
        --{{-6.89, 1.16, 0.95,1,'Y'},{2.26, 1.16, 10.52,1,'B'},{-22.78, 1.16, 7.41,1,'R'},{-10.44, 1.16, 23.18,1,'G'},{2.25, 1.16, 23.13,1,'R'}},'','','','','',},
        --['A New Threat'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300254769/34CD82B1973E61E99BA056EEF5950C86DC4A5E8B/', {-1.76, 0.96, -0.75}, {0.00, 270.00, 0.00}, {28.00, 1.00, 28.00},
        --{{{15.44, 1.13, 0.17},{0.00, 0.00, 0.00},{1.35, 1.35, 1.35}},{{-0.30, 1.13, -18.19},{0.00, 270.00, 0.00},{1.35, 1.35, 1.35}},{{-22.47, 1.13, 0.48},{0.00, 0.00, 0.00},{1.35, 1.35, 1.35}}},'5',
        --{{-22.11, 1.05, -6.62},{-13.63, 1.05, -21.28},{18.49, 1.05, 10.63},{9.64, 1.05, 2.20}},'','','','','',
        --{{9.00, 0.97, 16.75},{3.46, 0.97, -20.79},{-25.73, 0.97, -9.57}},'',{{3.93, 1.13, 5.16}},''},
        --['Imperial Hospitality'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300258883/F759DE4B8DE8B06981BD62F13F0BBF90F2DE1363/', {0.63, 1.06, 1.07}, {0.00, 0.00, 180.00}, {30.00, 1.00, 30.00},
        --{{{-13.94, 0.84, -0.87},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{20.71, 0.84, -11.15},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{10.91, 0.84, -17.21},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}}},'6',
        --{{8.64, 1.06, 23.29},{20.57, 1.06, -5.58},{-7.29, 1.06, -13.84},{-19.48, 1.06, -25.23}},'','','',
        --{{-7.64, 1.16, -4.60,1,'B'}},'8',{{24.72, 1.06, -17.35}},'6',{{28.82, 1.11, 15.31}},''},
        --['Drawn In'] = {'https://steamusercontent-a.akamaihd.net/ugc/1002555573981918069/E61327D3062E7072D0AFF8BE2159A6115F7B9B84/', {0.63, 1.06, 1.07}, {0.00, 180.00, 180.00}, {30.00, 1.00, 30.00},
        --{{{11.28, 0.57, 19.99},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-14.00, 0.57, 19.78},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-9.31, 0.57, -1.01},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{7.16, 0.57, -1.22},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{-15.80, 0.78, 6.67},{25.41, 0.78, 15.16},{-11.68, 0.78, -17.78},{9.21, 0.78, -13.71}},'','','',
        --'','',{{20.70, 0.69, 2.79},{4.33, 0.69, -17.88},{-19.97, 0.69, -25.65},{-20.44, 0.69, 15.26}},'8',{{-3.50, 1.11, 15.50}},''},
        --['Fly Solo'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300257513/584162FD393665F76C0B8C1324306B29245A3CFA/', {0.63, 1.06, 1.07}, {0.00, 180.00, 180.00}, {30.00, 1.00, 30.00},
        --{{{-1.57, 0.84, -4.17},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-4.88, 0.84, -18.80},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{11.46, 1.06, -22.79},{7.74, 1.06, -8.59},{-6.73, 1.06, -0.84},{0.27, 1.06, 17.18}},'','','',
        --'','','','',{{-3.07, 1.11, 6.60}},''},
        --['Desperate Hour'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300256924/82F61C38BFEC043348946C68FF931CEA907545A0/', {0.63, 1.06, 1.07}, {0.00, 0.00, 180.00}, {32.00, 1.00, 32.00},
        --{{{-6.82, 0.84, 11.56},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-13.91, 0.84, 18.60},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{-13.47, 0.84, -7.14},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-0.76, 0.84, 4.94},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}}},'6',
        --{{-14.55, 1.06, 29.45},{-8.47, 1.06, -1.92},{9.91, 1.06, -14.69},{22.66, 1.06, -2.19}},'','','',
        --'','','','',{{0.80, 1.11, 22.67}},''},
        --['Chain of Command'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300256641/EFA62F236FBE6C3918098D21CF71AC366940C269/', {0.63, 1.06, 1.07}, {0.00, 0.00, 180.00}, {30.00, 1.00, 30.00},
        --{{{24.56, 0.84, -14.69},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{-7.50, 1.06, 19.94},{8.25, 1.06, -12.79},{24.41, 1.06, 3.33},{16.47, 1.06, -25.04}},'','','',
        --'','',{{-16.12, 0.97, 27.55},{-12.02, 0.97, -12.99},{15.78, 0.97, 15.39}},'8',{{-19.67, 1.11, 15.52}},''},
        --['Last Stand'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300251548/58B3EF79F369A8361099ECBA0A7E033AEEE6E157/', {0.63, 1.06, 1.07}, {0.00, 180.00, 180.00}, {30.00, 1.00, 30.00},
        --{{{1.92, 0.84, 1.68},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{18.77, 0.84, 2.53},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{3.99, 0.84, -12.15},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{7.98, 0.84, -16.17},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}}},'5',
        --{{-19.88, 1.06, 4.19},{9.13, 1.06, 4.13},{15.06, 1.06, -25.46},{0.30, 1.06, -22.28}},'','','',
        --'','','','',{{-2.16, 1.11, 18.74}},''},
        --['Viper\'s Den'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300254415/D8D09EB6178638DC513E7E05DCB43AC479021FDA/', {0.63, 1.06, 1.07}, {0.00, 180.00, 180.00}, {23.00, 1.00, 23.00},
        --{{{-12.00, 0.84, -14.00},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-7.00, 0.84, 20.00},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}}},'8',
        --{{3.00, 1.06, -18.00},{-26.50, 1.06, -1.50},{3.00, 1.06, -1.00},{-18.00, 1.06, 20.00}},'','','',
        --{{-17.97, 1.16, 3.15,0,'R'}},'','','',{{29.00, 1.11, -14.00}},''},
        --['Incoming'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300259565/36AD548DA10B8483902F152EBBD36CEE5E9EFA60/', {0.63, 1.06, 1.07}, {0.00, 0.00, 180.00}, {30.00, 1.00, 30.00},
        --'','',{{14.30, 1.06, 8.75},{-16.12, 1.06, -1.04},{-12.81, 1.06, -24.65},{17.20, 1.06, -14.71}},'','','',
        --'','',{{-6.35, 1.04, 2.17},{10.65, 1.04, 2.33},{-12.91, 1.04, -17.81},{13.95, 1.04, -21.51}},'',{{0.78, 1.11, 25.44}},''},
        --['Temptation'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300253080/4A854B4460F5803F64D9930C6D86F1B0A1330D4D/', {0.00, 0.96, 0.07}, {0.00, 180.00, 0.00},{21.09, 1.00, 21.09},
        --{{{-13.50, 1.15, -3.77},{0.00, 90.00, 0.00},{1.60, 1.60, 1.60}}},'', {{-11.25, 1.06, 11.24},{14.62, 1.06, 18.89},{7.43, 1.06, -18.60},{-3.62, 1.06, 7.23}},'','','','','','','',{{18.60, 1.16, -14.82}},''},
        --['Friends of Old'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300258088/A9FC46F2B0A4EB0D796767E9BE0E16DEEEE93E76/', {0.00, 0.96, 0.07}, {0.00, 270.00, 0.00},{28.00, 1.00, 28.00},
        --'','',{{10.60, 1.06, 2.08},{-10.56, 1.06, 5.43},{-10.80, 1.06, -5.07},{14.15, 1.06, -12.05}}, '', {{-17.77, 1.06, -15.27},{-21.44, 1.06, 16.25},{17.44, 1.06, 5.69},{-0.30, 1.06, -4.76}},{1.17, 1.00, 1.17,'',4,'B','G','Y','R'},'','','','',{{-3.80, 1.16, 16.31}},''},
        --['Loose Cannon'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300259882/E6E36982965413D1461859AB0265160BD43C206D/', {0.00, 0.96, 0.07},{0.00, 270.00, 0.00},{20.21, 1.00, 20.21},
        --'','',{{-12.58, 1.06, 7.36},{-15.68, 1.06, -18.27},{-8.72, 1.06, -14.44},{16.83, 1.06, 3.58}},'','','','','','','',{{2.11, 1.16, 22.37}},''},
        --['Brushfire'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300256086/AE2949FF28386B1874940BDE096E0A1640A865AF/', {0.00, 0.96, 0.07},{0.00, 270.00, 0.00},{20.21, 1.00, 20.21},
        --'','',{{-9.29, 1.06, 9.55},{-15.91, 1.06, 6.19},{2.99, 1.06, -3.50},{12.39, 1.06, -12.51}},'','','',{{12.51, 1.10, -21.71,0,'B'},{-12.87, 1.10, -2.87,0,'B'},{-3.24, 1.10, -9.24,0,'R'},{6.27, 1.10, -2.94,0,'R'},{15.57, 1.10, 9.48,0,'Y'},{-0.14, 1.10, 19.06,0,'Y'}},'','','',{{-6.22, 1.16, 21.79}},''},
        --Hoth Maps 2D
        --['The Battle of Hoth'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462656707/D443DB78CE78D5761CFB73D1FA85E6EE054CE131/', {-1.76, 0.65, -0.75}, {0.00, 0.00, 0.00}, {28.00, 1.00, 28.00},
        --'','',{{-10.22, 1.06, 24.57},{-22.59, 1.06, 3.11},{15.46, 1.06, -13.11}},'','','',{{24.11, 1.06, -21.53,0,'B'},{-18.33, 1.06, -17.79,0,'R'},{-31.06, 1.06, 15.87,0,'Y'},{28.14, 1.06, 3.61,0,'G'}},'',
        --{{-2.09, 0.97, -5.27},{2.24, 0.97, -5.21},{2.18, 0.97, -9.46},{-2.21, 0.97, -9.50}},'',{{-18.41, 1.11, -0.49}},'Snow'},
        --['Escape from Cloud City'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462650569/A8E151587AA6917FE02CBF4438764747714A5D28/', {-1.76, 0.65, -0.75}, {0.00, 0.00, 0.00}, {20.00, 1.00, 20.00},
        --{{{-4.18, 0.84, -18.27},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}},{{-23.74, 0.84, -18.18},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}},{{-23.46, 0.84, -2.56},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}}},'2tl',
        --{{-1.48, 1.06, 1.08},{13.98, 1.06, -6.24}},'','','','','',
        --'','',{{9.84, 1.11, 9.44}},''},
        --['White Noise'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462647156/7C9F081F4CB0A5712FDFBE89AFACE63E5477C1DC/', {-1.76, 0.65, -0.75}, {0.00, 180.00, 0.00}, {28.00, 1.00, 28.00},
        --{{{4.33, 0.84, 12.53},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}},{{4.80, 0.84, -22.82},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}},{{-1.38, 0.84, 6.98},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{-17.24, 0.84, -12.41},{0.00, 180.00, 0.00},{1.81, 1.81, 1.81}}},'8',
        --{{2.55, 1.06, 4.43},{-8.93, 1.06, -10.50},{-24.63, 1.06, -3.00},{-20.92, 1.06, 8.93}},'',{{18.13, 1.16, -22.26},{-28.70, 1.16, -18.20},{-32.57, 1.16, 16.48},{-5.38, 1.16, 24.39}},'','','',
        --{{-9.75, 0.97, 16.15},{-17.30, 0.97, 0.48},{-5.48, 0.66, -22.53}},'',{{-9.20, 1.11, -3.15}},'Snow'},
        --['Home Front'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462651911/16E5E3AACB16387531437E0A8A4E6ACFE7C0D3B0/', {-1.76, 0.65, -0.75}, {0.00, 180.00, 0.00}, {30.00, 1.00, 30.00},
        --{{{9.63, 0.57, -16.53},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-12.64, 0.57, -21.21},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}},{{9.45, 0.57, -2.09},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-13.06, 0.57, -6.79},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}}},'5',
        --{{21.65, 0.78, -13.74},{28.90, 0.78, 1.07},{-25.41, 0.78, 11.94},{-21.79, 0.78, -24.45}},'',
        --{{-3.80, 0.83, 4.97},{-0.14, 0.83, 4.90},{-3.80, 0.83, 1.27},{-0.30, 0.83, 1.24}},{0.74,1.00,0.74,8},
        --{{-32.65, 0.88, -24.24,1,'G'},{-21.74, 0.88, -13.23,1,'G'},{-25.43, 0.88, 1.30,1,'B'},{-11.13, 0.88, 5.07,1,'B'},{25.38, 0.88, 8.66,1,'R'},{29.30, 0.88, -9.50,1,'R'},{18.38, 0.88, -13.33,1,'Y'},{18.43, 0.88, -27.90,1,'Y'}},'3',
        --'','',{{25.65, 1.11, 12.67}},'Snow'},
        --['Rescue Ops'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462649235/766691CF70E6D5B8037AB3A9136FFF7204CF51CE/', {-1.76, 0.65, -0.75}, {0.00, 0.00, 0.00}, {28.00, 1.00, 28.00},
        --{{{7.87, 0.84, 8.52},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{7.85, 0.84, -13.14},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{23.26, 0.84, -4.84},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{14.70, 1.06, -15.81},{14.70, 1.06, -12.06},{-21.56, 1.06, -4.43},{7.46, 1.06, 24.74}},'','','','','',
        --{{-0.09, 0.97, 21.34},{7.04, 0.97, -22.71}},'',{{-29.35, 1.11, 13.67}},'Snow'},
        --['The Hard Way'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462655815/C37B6F8F3211B3CD5F1C6FDB91F16BC1BEF19CE6/', {-1.76, 0.65, -0.75}, {0.00, 180.00, 0.00}, {22.00, 1.00, 22.00},
        --{{{11.89, 0.84, -10.20},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{17.22, 0.84, -2.12},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{-1.57, 0.84, 12.11},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{19.70, 1.06, -11.01},{0.13, 1.06, 8.97},{0.13, 1.06, -17.47}},'','','','','',
        --'','',{{-26.41, 1.11, 15.82}},''},
        --['Scouring of the Homestead'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462654779/709165907669EB1A5BAD5CF166D2295CE0D64CE7/', {-1.76, 0.65, -0.75}, {0.00, 0.00, 0.00}, {22.00, 1.00, 22.00},
        --'','',{{6.25, 1.06, 3.86},{-12.24, 1.06, 10.07},{-27.64, 1.06, 6.71}},'','','','','','','',{{-6.29, 1.11, 4.32}},''},
        --['Return to Echo Base'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462653884/7418B59FD8C05FA68101A57B12B2B5EE48737B50/', {-1.76, 0.65, -0.75}, {0.00, 90.00, 0.00}, {28.00, 1.00, 28.00},
        --'','',{{6.29, 1.06, -24.83},{-27.42, 1.06, 4.45},{2.00, 1.06, 19.24},{13.35, 1.06, 12.64}},'',{{-1.39, 0.68, -32.25}},{0.74,0.74,0.74,10},{{2.33, 1.06, -13.73,0,'B'},{2.37, 1.06, -10.05,0,'B'},{9.48, 1.06, 4.96,0,'R'},{13.01, 1.06, 5.20,0,'R'},{-8.69, 1.06, 4.74,0,'G'},{-9.13, 1.06, 0.80,0,'G'}},'',
        --{{12.66, 0.97, -13.38,3,'B'},{-27.53, 0.97, -10.27,3,'B'},{-1.63, 0.97, -28.49,3,'R'}},'',{{-5.50, 1.11, 26.67}},'Snow'},
        --['The Last Line'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300299864/5E1E07C245A287DB7DE730D754ED40FF019B4684/', {-1.76, 0.65, -0.75}, {0.00, 0.00, 0.00}, {28.00, 1.00, 28.00},
        --'','',{{-1.95, 1.06, -12.70},{4.93, 1.06, -5.72},{-26.50, 1.06, 15.00},{-8.61, 0.75, 7.83}},'',{{-5.36, 1.06, 25.06},{-9.00, 1.06, 25.00}},{0.68,0.68,0.68,10},{{11.80, 1.16, 4.83,1,'B'},{-8.55, 1.16, 1.16,1,'R'},{-29.57, 1.16, 4.59,1,'G'}},'10',
        --'','',{{-8.83, 1.11, 14.85}},'Snow'},
        --['One Step Behind'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462652477/9A7070B98901A52059C2B6FA9B4A8F3B6449CEEF/', {-1.76, 0.65, -0.75}, {0.00, 180.00, 0.00}, {28.00, 1.00, 28.00},
        --{{{13.34, 0.84, -11.42},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-5.41, 0.84, -15.75},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}},{{22.92, 0.84, 12.17},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{-21.56, 0.84, 11.80},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{-14.27, 1.06, 21.33},{-14.41, 1.06, -12.25},{15.17, 1.06, 25.02},{18.85, 1.06, -4.23}},'','','','','',
        --{{29.75, 0.97, 17.28,3,'B'},{-17.95, 0.97, -27.02,3,'Y'},{-33.15, 0.97, -1.39,3,'R'},{19.29, 0.97, -23.41,3,'G'}},'',{{-6.92, 1.11, 6.86}},'Snow'},
        --['Disaster'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462657115/5D7CEDAB5450EFC011F132EF9CE05BC32DECC3E3/', {-1.76, 0.65, -0.75}, {0.00, 180.00, 0.00}, {30.00, 1.00, 30.00},
        --{{{-28.36, 0.53, -11.60},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}},{{-8.81, 0.53, -21.53},{0.00, 90.00, 0.00},{1.81, 1.81, 1.81}},{{21.72, 0.53, 13.81},{0.00, 180.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{4.23, 0.75, -9.83},{-2.86, 0.75, -28.29},{15.11, 0.75, -2.68},{22.11, 0.75, -28.45}},'',
        --{{-32.49, 0.80, -17.11},{-32.49, 0.80, -20.81},{-28.83, 0.80, -17.18},{-28.99, 0.80, -20.84},{-14.48, 0.80, -16.96},{-10.82, 0.80, -17.03},{-14.48, 0.80, -20.66},{-10.98, 0.80, -20.69},{25.78, 0.80, 15.79},{22.28, 0.80, 19.52},{25.94, 0.80, 19.45},{22.36, 0.80, 15.79}},{0.74,0.74,0.74,5},
        --'','','','',{{-21.10, 0.80, 8.49}},'Snow'},
        --['Our Last Hope'] = {'https://steamusercontent-a.akamaihd.net/ugc/1001430929871819152/BE749672AE0784772A22E412DE88D582799E65CE/', {-1.76, 0.65, -0.75}, {0.00, 0.00, 0.00}, {34.00, 1.00, 34.00},
        --'','',{{-16.78, 0.96, 12.43},{0.18, 0.96, -20.50}},'','','','','',
        --{{12.91, 0.66, 2.59},{13.14, 0.66, -10.55},{16.12, 0.66, -30.68},{-30.81, 0.66, 9.01,3,'R'}},'',{{43.75, 0.96, 2.89}},''},
        --['Survival of the Fittest'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462655435/D2BC0D3ADEFEAFE10E74A9E3A820BD4F76520996/', {-1.76, 0.65, -0.75}, {0.00, 180.00, 0.00}, {28.00, 1.00, 28.00},
        --'','',{{9.69, 0.75, 4.93},{18.18, 0.75, -13.97},{29.75, 0.75, -2.20}},'','','',{{-1.70, 0.85, 4.69,1,'G'}},'',
        --'','',{{-5.46, 0.80, 20.28},{14.05, 0.80, 24.74}},''},
        --['Preventative Measures'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462652959/29FEB35CD37F494411F38A4A47DDA15F1884FE92/', {-1.76, 0.65, -0.75}, {0.00, 180.00, 0.00}, {20.00, 1.00, 20.00},
        --{{{9.41, 0.53, -12.00},{0.00, 180.00, 0.00},{1.81, 1.81, 1.81}},{{-3.31, 0.53, -5.34},{0.00, 0.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{-10.36, 0.75, 9.42},{-6.99, 0.75, -13.88},{16.66, 0.75, -7.65}},'','','',{{5.85, 0.90, -40.56,1,'B'}},'6+tl',
        --'','',{{3.20, 0.80, 9.44}},'Snow'},
        --['Constant Vigilance'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462649628/5886F4D4C7F262A00FDDD4A67D5143F99E7C5DC8/', {-1.76, 0.65, -0.75}, {0.00, 90.00, 0.00}, {20.00, 1.00, 20.00},
        --'','',{{-3.38, 0.75, -20.14},{15.82, 0.75, -12.96},{-4.02, 0.75, 7.17}},'',{{-3.88, 0.78, -30.57},{-0.62, 0.78, -30.66},{3.16, 0.78, -30.34},{6.74, 0.78, -30.19}},'',
        --{{-4.25, 0.75, 11.21,1,'G'},{0.19, 0.75, 11.03,1,'G'},{3.91, 0.75, 10.95,1,'R'},{8.05, 0.75, 10.82,1,'R'}},'','','',{{-3.74, 0.80, 22.94}},''},
        --['Know Your Enemy'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462651587/BFC49FF8DFE25D7CEED3A386FAE120B4E82BDBB3/', {-1.76, 0.65, -0.75}, {0.00, 180.00, 0.00}, {20.00, 1.00, 20.00},
        --{{{12.16, 0.53, -6.55},{0.00, 180.00, 0.00},{1.81, 1.81, 1.81}}},'',{{-12.75, 0.75, -5.74},{5.95, 0.75, 0.36},{25.14, 0.75, -15.06}},'','','','','','','',{{-12.92, 0.80, 16.42}},''},
        --Jabbas Realm Maps 2D
        --['Trespass'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462646720/7909D87EA782EC61D21DA0E66DED64D6D02ED028/', {3.77, 1.01, -2.54},{0.00, 180.00, 0.00},{26.00, 1.00, 26.00},
        --{{{2.94, 0.92, -10.47},{0.00, 0.02, 0.00},{1.60, 1.60, 1.60}}},'',{{8.21, 1.11, -11.66},{-3.46, 1.11, 0.28},{5.50, 1.11, 3.69}},'',
        --{{17.18, 1.21, 3.28},{14.16, 1.21, 3.16},{11.26, 1.21, 3.26}},{0.76, 1.00, 0.76,4},'','',{{-9.75, 1.02, -20.23}},'',{{-3.32, 1.16, 18.13}},''},
        --['Born from Death'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462644778/C51CCC1B1B744671F760C8A3D15124740A84DA2F/', {0.00, 0.96, 0.07}, {0.00, 270.00, 0.00},{28.00, 1.00, 28.00},
        --{{{6.50, 1.15, -3.19},{0.00, 89.98, 0.00},{1.60, 1.60, 1.60}},{{1.65, 1.15, -8.20},{0.00, 0.01, 0.00},{1.60, 1.60, 1.60}},{{-1.83, 1.15, 5.49},{0.00, 180.00, 0.00},{1.60, 1.60, 1.60}}},'',
        --{{-25.20, 1.06, -6.57},{-4.74, 1.06, 19.75},{1.91, 1.06, -19.77}},'',{{4.91, 1.06, -6.56},{4.99, 1.06, 3.80},{-8.46, 1.06, -2.99},{-15.43, 1.06, -19.72},{-15.34, 1.06, 13.71},{-25.29, 1.06, -3.03}},{1.17, 1.00, 1.17,'',6,'B','R','G','B','R','B'},'','','','',{{25.11, 1.16, 0.26}},''},
        --['Moment of Fate'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462644222/A885DFFCEEEFBCC829F466A88D46489507059FBF/', {0.00, 0.96, 0.07}, {0.00, 0.00, 0.00}, {28.00, 1.00, 28.00},
        --{{{18.39, 1.31, -10.19},{0.15, 0.00, 0.08},{1.81, 1.81, 1.81}},{{-11.96, 1.27, -9.76},{359.86, 0.00, 359.92},{1.60, 1.81, 1.81}}}, '5',
        --{{-21.87, 1.15, -5.01},{18.22, 1.17, 11.57},{-15.15, 1.13, 7.93},{5.04, 1.20, -8.77}},'',{{-25.45, 1.10, 15.02},{1.68, 1.14, 12.03},{14.80, 1.18, 4.91}},'',
        --{{19.25, 1.08, 23.94,1,'B'},{22.77, 1.08, 24.03,1,'R'},{19.44, 1.09, 20.59,1,'G'},{23.04, 1.09, 20.70,1,'Y'},{19.48, 1.10, 17.48,1,'B'},{23.00, 1.10, 17.56,1,'R'}},'',{{4.48, 1.14, -14.82}},'',{{-5.16, 1.17, 25.01}},''},
        --['Dangerous Allies'] = {'https://steamusercontent-a.akamaihd.net/ugc/769484085135016281/6278620B471811150BF970DA728D7F3FF9E08232/', {3.77, 1.01, -2.54},{0.00, 180.00, 0.00},{26.00, 1.00, 26.00},
        --{{{19.90, 1.14, -4.56},{0.00, 0.02, 0.00},{1.60, 1.60, 1.60}}},'8',{{0.78, 1.06, -9.72},{7.05, 1.06, -15.48},{13.34, 1.06, 16.79},{29.97, 1.06, 4.28}},'',{{-15.69, 1.16, 6.72}},{0.76,0.76,0.76,10},'','','','',{{0.57, 1.16, 10.23}},''},
        --['From All Sides'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462642961/C76EFEF1535E040E0805779FB215A710DD0D6C23/', {2.52, 1.06, 0.40},{359.79, 0.00, 0.00},{26.00, 1.00, 26.00},
        --{{{2.27, 1.23, -4.83},{359.79, 0.00, 0.00},{1.60, 1.60, 1.60}},{{10.22, 1.26, 3.42},{0.00, 90.00, 359.79},{1.60, 1.60, 1.60}},{{-9.59, 1.26, 3.41},{0.00, 90.00, 359.79},{1.60, 1.60, 1.60}}},'10',
        --{{25.23, 1.22, 16.24},{-24.21, 1.22, 16.86},{-14.47, 1.13, -6.26},{18.59, 1.11, -13.21}},'','','',{{8.77, 1.20, -3.17,1,'R'},{-7.37, 1.20, -3.02,1,'R'},{40.71, 1.29, 23.33,0,'B'},{40.69, 1.27, 19.87,0,'B'}},'','','','',''},
        --['Almost Home'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462645731/465EED0F3929EEB34A2B319A22E8B2A2A72A14E4/', {2.52, 0.96, 0.40},{0.00, 180.00, 0.00},{28.00, 1.00, 28.00},
        --{{{6.63, 1.13, 17.06},{0.00, 90.00, 0.00},{1.30, 1.30, 1.30}},{{11.17, 1.13, 6.35},{0.00, 0.00, 0.00},{1.30, 1.30, 1.30}}},'',{{26.29, 1.06, 2.20},{14.45, 1.06, -15.70},{-18.16, 1.06, -10.06},{-6.61, 1.06, 26.01}}, '',
        --'','',{{-9.33, 1.10, -0.56,0,'B'},{8.37, 1.10, -12.65,0,'B'}},'',{{-7.07, 0.97, 5.44},{19.90, 0.97, 8.20}},'',{{-18.26, 1.12, 17.10}},'',''},
        --['Execute the Plan'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462643583/9EE504E94ECCECD85B0FDD2ED0AFE5C8DDC78375/', {2.52, 0.96, 0.40},{0.00, 180.00, 0.00},{26.00, 1.00, 26.00},
        --{{{2.44, 1.15, -15.76},{0.00, 90.00, 0.00},{1.60, 1.60, 1.60}}},'',{{4.61, 1.06, 1.67},{-23.55, 1.06, -1.38},{-13.23, 1.06, -15.55},{15.08, 1.06, -22.49}},'','','',
        --{{14.92, 1.10, -15.72,0,'R'}},'',{{-23.89, 0.98, 9.17},{-24.00, 0.98, -8.62},{7.43, 0.98, -1.49}},'6', {{-2.62, 1.16, 19.59}},'',''},
        --['Storming the Palace'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462642313/91604019C96C6B5F908C5B30F21DB9ECDC771D54/', {2.52, 0.96, 0.40},{0.00, 0.00, 0.00},{26.00, 1.00, 26.00},
        --{{{15.54, 1.13, -13.28},{0.00, 0.00, 0.00},{1.35, 1.35, 1.35}},{{5.99, 1.13, 0.41},{0.00, 270.00, 0.00},{1.35, 1.35, 1.35}}},'',{{-16.61, 1.06, 0.67},{0.84, 1.06, 3.63},{3.82, 1.06, 6.28}},'',
        --'','','','','','',{{-2.03, 1.16, 12.14}},'',''},
        --['Mutiny'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462644471/9A2A82A10898A539176F374598F21165F4458BD2/',{17.56, 0.96, 0.08},{0.00, 180.01, 0.00},{22.00, 1.00, 22.00},
        --{{{-26.93, 6.13, -5.75},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'',
        --{{15.84, 1.06, -19.52},{12.37, 1.06, 1.59},{-28.67, 6.12, 3.99},{-18.46, 6.12, -30.80}},'',{{-21.68, 6.12, 0.88},{-18.45, 6.12, 1.01}},'',
        --{{1.94, 1.16, -5.49,0,'B'},{2.45, 6.02, 25.32,0,'B'},{-22.97, 6.02, 13.90,0,'R'},{-1.76, 1.16, -18.83,0,'R'},{0.93, 1.16, -18.79,0,'G'},{-14.85, 6.02, -20.35,0,'G'}},'',{{9.12, 5.93, 25.05,3,'B'},{-16.64, 6.12, 14.11,3,'R'}},'',{{26.81, 1.06, 5.52},{-1.40, 6.07, 21.35}},''},
        --['Perilous Hunt'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462645484/A8A49D3F7B4EF249BC43903A3677F149D06DABDB/',{-1.68, 0.96, 0.07},{0.00, 180.00, 0.00},{24.00, 1.00, 24.00},'','',
        --{{29.28, 1.06, -8.52},{17.16, 1.06, 3.96},{0.49, 1.06, -16.15}},'',{{8.56, 1.16, 12.16},{13.01, 1.16, 4.56},{17.11, 1.16, -4.13},{17.03, 1.16, -12.15},{17.00, 1.16, -20.49},{8.92, 1.16, -16.47},{4.72, 1.16, -4.12}},'',
        --{{0.53, 1.11, 8.53,0,'R'},{0.72, 1.11, 4.43,0,'R'},{0.73, 1.11, -8.16,0,'B'},{0.90, 1.11, -12.29,0,'B'},{-11.71, 1.13, -16.45,1,'G'},{-7.54, 1.13, 16.94,1,'G'}},'tl','','',{{-28.59, 1.16, 4.39}},''},
        --['Trophy Hunting'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462641982/6AFFD0C54A0A8233FA6EE3D4388C45373DC4FB0C/', {-0.62, 0.78, -1.24},{0.00, 90.00, 0.00},{28.00, 1.00, 28.00},
        --'','',{{17.72, 0.88, -19.81},{4.50, 0.88, 7.19},{14.63, 0.88, 3.91},{-18.43, 0.88, 7.02}},'','','','','',{{4.22, 0.87, -12.76}},'',{{-25.65, 0.93, -6.35},{24.46, 0.93, 24.19}},''},
        --['Turf War'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462643282/CC953B1C4683E68980124BED03B3B96117AC271B/',{-0.29, 0.68, -0.13},{0.00, 180.01, 0.00},{30.00, 1.00, 30.00},
        --{{{-0.10, 0.57, -10.46},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'4',
        --{{30.51, 0.78, 1.52},{18.38, 0.78, -2.20},{-10.23, 0.78, -22.49},{-14.38, 0.78, 14.20}},'',{{-31.04, 0.83, -6.03},{-22.62, 0.83, 22.40},{5.73, 0.83, 6.18},{10.28, 0.83, -2.38},{18.29, 0.83, -22.56}},{0.76, 1.00, 0.76, 6},
        --'','','','',{{22.03, 0.83, 26.28}},''},
        --['Hostile Negotiations'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462646029/424AEABD9BD61EF7C38486691664637BC6B8C1FF/', {2.52, 0.96, 0.40},{0.00, 180.00, 0.00},{26.00, 1.00, 26.00},
        --{{{8.28, 0.87, -11.18},{0.00, 90.00, 0.00},{1.80, 1.80, 1.80}},{{8.29, 0.87, 4.40},{0.00, 90.00, 0.00},{1.80, 1.80, 1.80}}},'',{{-16.50, 1.06, -18.61},{-12.93, 1.06, -3.15},{25.39, 1.06, -15.10},{37.10, 1.06, 3.87}},'',{{29.23, 1.16, -3.18},{29.23, 1.26, -3.18},{29.23, 1.36, -3.18},{25.37, 1.16, -3.38},{25.37, 1.26, -3.38},{25.37, 1.36, -3.38}},'',
        --{{-24.11, 1.16, 23.61,1,'R'},{-24.32, 1.16, -14.85,0,'G'}},'','','', {{25.47, 1.11, 4.43}},'',''},
        --['Overcharged'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462645090/13AB20D29E2253EFC9D228949634333B50A6F01F/', {2.52, 0.96, 0.40},{0.00, 180.00, 0.00},{26.00, 1.00, 26.00},
        --{{{1.56, 0.85, -11.44},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{18.46, 0.85, -4.79},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}}},'',{{1.33, 1.06, -23.02},{4.61, 1.06, -13.14},{7.85, 1.06, 3.39},{-15.52, 1.06, 6.99}},'',
        --{{7.86, 1.11, -19.48},{4.43, 1.11, -19.55},{-2.08, 1.11, -19.46},{-5.56, 1.11, -19.69},{-5.38, 1.11, -16.46},{-8.89, 1.11, 0.32},{-2.05, 1.11, 7.11},{11.12, 1.11, 0.34},{-11.89, 1.11, -6.36}},'',
        --'','','','', {{17.79, 1.06, 23.53}},'',''},
        --['Strike Force Xesh'] = {'https://steamusercontent-a.akamaihd.net/ugc/1002555573982022216/5B88650F06C5B867C492180D46C6B5453A67D995/', {0.63, 0.70, 1.07}, {0.00, 0.00, 180.00}, {30.00, 1.00, 30.00},
        --{{{-24.12, 0.57, -18.11},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}},{{-23.92, 0.57, 9.08},{0.00, 270.00, 0.00},{1.81, 1.81, 1.81}}},'',
        --{{39.18, 0.78, 8.49},{-2.85, 0.78, -26.59},{-36.90, 0.78, 19.77}},'','','',
        --{{16.15, 0.88, 12.43,1,'G'},{16.29, 0.88, 8.55,1,'G'},{8.32, 0.88, 20.18,1,'Y'},{4.57, 0.88, 20.06,1,'Y'},{15.96, 0.88, -3.08,1,'B'},{15.91, 0.88, -6.70,1,'B'},{8.43, 0.88, -10.61,1,'R'},{4.54, 0.88, -10.89,1,'R'}},'',{{-37.52, 0.76, 12.50},{-37.13, 0.76, -18.45}},'2tl',{{27.56, 0.88, 12.25}},''},
        --['A Hero\'s Welcome'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462646393/49018D103C1E24C4626A337A1499F3343A0B7BC9/', {-1.02, 0.78, -0.13}, {0.00, 0.00, 180.00},{24.00, 1.00, 24.00},
        --'','',{{-30.38, 0.78, -3.79},{-9.21, 0.78, -0.21},{28.47, 0.78, 17.17}},'',{{18.21, 0.88, -14.15},{21.57, 0.88, 13.76},{-6.24, 0.88, -21.05},{-2.54, 0.88, -0.55},{-23.73, 0.88, -14.53},{-23.70, 0.88, 3.14},{-3.14, 0.78, -26.13},{0.13, 0.78, -29.73},{-3.25, 0.78, -29.79},{-6.81, 0.73, -29.67}},{0.76,0.76,0.76,'2'},
        --{{21.57, 0.78, -14.29,0,'B'},{18.07, 0.78, 6.65,0,'B'},{0.80, 0.78, -14.05,0,'R'},{-26.87, 0.78, -17.92,0,'R'},{-23.62, 0.78, 10.05,0,'G'}},'',
        --'','',{{-2.66, 0.83, 16.99}},''},
        --['Extortion'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462643840/05A8C09AD0393BBFCBA3FA157C5D91BA0F0236EB/', {2.52, 0.96, 0.40},{0.00, 180.00, 0.00},{28.00, 1.00, 28.00},
        --{{{13.59, 0.91, -23.23},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{14.70, 0.85, -17.13},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{21.98, 0.85, -2.77},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{-3.07, 0.85, -9.92},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'',
        --{{23.76, 1.06, -6.66},{-1.02, 1.06, 0.33},{-1.08, 1.06, 11.12}},'',{{-1.13, 1.11, 14.45},{5.97, 1.11, 25.49},{27.34, 1.11, 21.73}},'',
        --{{23.60, 1.16, -3.31,1,'Y'},{13.10, 1.16, -24.70,1,'Y'},{17.03, 1.16, -17.56,1,'R'}},'','','', {{-8.31, 1.11, 14.60}},'',''},
        -- Heart of the Empire Missions 2D
        ['Dark Recon'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323386964/60952E2D446E8B1028DB0B6CB2FDCDE91516016F/', {0.63, 0.78, 1.07}, {0.00, 0.00, 180.00},{32.00, 1.00, 32.00},
        {{{-11.35, 0.57, -6.06},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{6.43, 0.57, -5.99},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}}},'',
        {{9.29, 0.78, -21.32},{-4.71, 0.78, -11.17},{16.38, 0.78, 13.49},{-4.68, 0.78, 13.82}},'',{{-18.66, 0.88, 6.41},{-4.54, 0.88, 9.70},{16.45, 0.88, 2.82}},'','','',
        '','','','',''},
        ['Extraction'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323449216/D0354DC6B078258FDD586EDCC981602F9819A60C/', {-0.29, 0.68, -2.75},{0.00, 0.00, 0.00},{22.00, 1.00, 22.00},
        {{{15.92, 0.57, -14.49},{0.00, 0.00, 0.00},{1.75, 1.75, 1.05}}},'',
        {{38.94, 0.78, 3.82},{2.48, 0.78, 0.47},{-32.93, 0.78, 0.71}},'',{{32.11, 0.88, 0.48}},'',{{12.49, 0.88, 17.27,1,'B'},{-26.00, 0.88, 7.22,1,'B'}},'',
        '','',{{29.10, 0.88, 3.91}},''},
        ['Unfinished Business'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323451839/C411587D5483AA377D611720BC0DBA4C3631085C/', {-0.29, 0.68, -2.75},{0.00, 90.00, 0.00},{34.00, 1.00, 34.00},
        {{{-23.82, 0.55, -2.75},{0.00, 0.00, 0.00},{1.92, 1.92, 1.15}},{{-14.39, 0.55, 11.32},{0.00, 270.00, 0.00},{1.92, 1.92, 1.15}},{{1.92, 0.55, 11.28},{0.00, 270.00, 0.00},{1.92, 1.92, 1.15}}},4,
        {{27.26, 0.78, -4.76},{-32.11, 0.78, -12.26},{-27.73, 0.78, 10.91}},'',{{31.27, 0.88, -12.73},{31.10, 0.88, -16.26},{-4.55, 0.88, -28.42},{-4.52, 0.88, -24.61},{-8.27, 0.88, -28.25},{-8.21, 0.88, -24.61},{-20.17, 0.88, -20.53},{-24.17, 0.88, -20.61},{-28.10, 0.88, -20.75},{-32.16, 0.88, -20.57},{-32.28, 0.88, -16.33},{-28.31, 0.88, -16.25}},'','','',
        {{18.94, 0.77, 3.16},{18.95, 0.77, 14.72}},3,{{23.20, 0.83, -16.37}},''},
        ['Test of Metal'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323455469/9E15059B7CDAF4066EB7D0FC15712BCFD669A0FD/', {-0.29, 0.68, -0.22},{0.00, 90.00, 0.00},{22.00, 1.00, 22.00},
        {{{16.86, 0.60, 9.01},{0.00, 0.00, 359.99},{1.46, 1.46, 0.88}}},'',
        {{-8.16, 0.78, 10.63},{-1.62, 0.78, 1.23},{7.60, 0.78, -29.57}},'','','',{{16.43, 0.78, 10.96,0,'B'},{13.44, 0.78, 10.87,0,'B'},{7.44, 0.78, 16.83,0,'Y'},{7.46, 0.78, 14.02,0,'Y'},{-14.20, 0.78, 14.03,0,'G'},{-20.71, 0.78, 16.70,0,'G'}},'tl',
        {{10.46, 0.77, -11.39,3,'B'},{10.80, 0.77, -20.40,3,'R'},{10.67, 0.76, -29.64,3,'R'}},'tl',{{-8.21, 0.83, 20.00}},''},
        ['Civil Unrest'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323457939/9D053308E238383A0E9C2CC2CC133EA1C4F25EF5/', {0.00, 0.68, 0.07},{0.00, 180.00, 0.00},{25.00, 1.00, 26.00},'','',
        {{-27.94, 0.78, 7.69},{-9.04, 0.78, -4.74},{17.16, 0.78, 19.21}},'',{{-24.33, 0.83, 7.83},{-20.54, 0.83, 15.64},{-16.77, 0.83, 11.75},{-9.36, 0.83, 15.87},{-9.16, 0.83, 3.74},{-1.70, 0.83, 11.77},{5.99, 0.83, 7.51},{13.60, 0.83, 15.41},{17.35, 0.83, 11.50}},{0.76, 1.00, 0.76,4},'','',
        '','',{{1.93, 0.83, 19.63}},''},
        ['On the Trail'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323462015/86B6FB7994BEE6EA660F4911B859E8F164548A80/', {0.00, 0.68, 0.07},{0.00, 270.00, 0.00},{25.00, 1.00, 26.00},
        {{{-21.64, 0.57, -12.23},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}},{{-9.67, 0.57, 11.44},{0.00, 270.00, 0.00},{1.75, 1.75, 1.05}}},'',
        {{1.98, 0.78, 13.97},{-14.57, 0.78, -1.86},{4.88, 0.78, -4.39},{17.77, 0.78, -16.80}},'','','',{{-20.71, 0.78, -26.01,0,'R'}},'',
        '','',{{14.64, 0.88, 26.07}},''},
        ['Inside Man'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323465392/CF4DB7FA86D3A4C95035DFCF5BCCA33494F1C53B/', {0.00, 0.68, 0.07},{0.00, 270.00, 0.00},{25.00, 1.00, 24.00},
        {{{-7.62, 0.57, -5.43},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}},{{9.13, 0.57, -7.35},{0.00, 270.00, 0.00},{1.75, 1.75, 1.05}},{{13.98, 0.57, 9.79},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}}},'',
        {{21.77, 0.78, 22.59},{-3.51, 0.78, 10.78},{-14.53, 0.78, -0.23},{-3.79, 0.78, -26.04}},'',{{-7.27, 0.88, -18.95}},'','','',
        {{17.80, 0.76, 25.78}},'',{{0.14, 0.88, 11.43}},''},
        ['Double Agent'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323475301/2A499F5EF2823DB8DF5C6A2F5863E8F719D3AB4C/', {0.60, 0.66, 1.39},{0.00, 90.00, 0.00},{27.00, 1.00, 28.00},
        '','',{{19.45, 0.78, -20.33},{-11.31, 0.78, -10.68},{-14.66, 0.78, -7.00},{22.78, 0.78, -0.42}},'','','',{{5.44, 0.86, -3.71,1,'L'},{2.09, 0.86, -3.72,1,'L'}},'',
        '','',{{2.44, 0.86, -13.42},{2.21, 0.86, 13.17}},''},
        ['Into a Corner'] = {'HE3D', {-29.50, 0.42, -10.50},{359.92, 270.00, 180.02},{3.00, 3.00, 3.00},'','','','','','','','','','','',''}, --Because of the mission's random nature this is a special map
        ['On the Run'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323418185/C781F6D07CD4F17FC94DC62D97C0A38EBBB0B63A/', {0.00, 0.68, 0.07},{0.00, 0.00, 0.00},{32.00, 1.00, 32.00},
        {{{-2.09, 0.57, -4.86},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}},{{-11.22, 0.57, 10.92},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}},{{14.47, 0.57, 14.45},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}}},'9',
        {{-1.44, 0.78, 23.25},{-18.05, 0.78, -6.79},{-1.65, 0.78, 6.48},{-4.86, 0.78, -16.63}},'','','','','',
        {{-5.41, 0.69, -3.23},{1.00, 0.69, 0.39},{7.80, 0.69, -3.13}},'',{{4.68, 0.83, 10.31}},''},
        ['Disruption'] = {'https://steamusercontent-a.akamaihd.net/ugc/769484085130390651/EBA46463732749D38B5691ADC7B6C413EB6125F1/', {-0.01, 0.68, 0.22},{0.00, 180.00, 0.00},{34.00, 1.00, 34.00},
        {{{8.40, 0.61, -19.43},{0.00, 270.00, 0.00},{1.40, 1.40, 0.84}},{{21.82, 0.61, -22.01},{0.00, 270.00, 0.00},{1.40, 1.40, 0.84}}},'',
        {{-27.73, 0.78, 26.30},{17.63, 0.78, 1.81},{20.42, 0.78, -19.83},{9.58, 0.78, -16.66}},'',{{-35.97, 0.83, 10.26},{-25.05, 0.83, 23.73},{-22.40, 0.83, 15.46},{-19.62, 0.83, 20.85},{-17.30, 0.83, 28.81},{-9.06, 0.83, 21.01}},{0.76,0.76,0.76,5},
        {{-6.74, 0.88, -3.36,1,'B'}, {1.38, 0.88, 1.58, 1, 'B'}, {4.17, 0.78, 1.85, 0, 'R'}, {33.69, 0.88, -3.61, 1, 'R'}, {-1.07, 0.88, -14.50, 1, 'Y'}, {28.30, 0.88, -25.07, 1, 'Y'}, {7.09, 0.88, -16.87, 1, 'G'}, {20.25, 0.88, -16.89, 1, 'G'}, {14.80, 0.83, -3.86, 1, 'L'}, {17.52, 0.83, -3.67,1, 'L'},{17.51, 0.83, -6.42,1, 'L'}},'',
        {{17.14, 0.69, -20.03}},'',{{-38.43, 0.88, 12.97}},''},
        ['From Dark Clutches'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323472861/E4B45D77B5272DE1FFD6505DDF723378965153F3/', {-0.01, 0.68, 0.22},{0.00, 0.00, 0.00},{32.00, 1.00, 34.00},
        {{{10.37, 0.57, -22.11},{0.00, 270.00, 0.00},{1.75, 1.75, 1.05}}},'',
        {{-11.55, 0.78, 19.24},{8.28, 0.78, 2.35},{19.76, 0.78, -1.59},{-38.72, 0.78, -9.58}},'',{{15.88, 0.83, -26.34},{12.20, 0.83, -26.42},{16.09, 0.83, -22.39},{12.30, 0.83, -22.36}},'','','',
        {{38.41, 0.69, 15.42},{22.94, 0.69, -13.49},{-11.49, 0.69, -13.90},{-38.78, 0.69, -30.27},{-15.55, 0.69, 2.26}},'',{{-7.54, 0.83, 31.17}},''},
        ['History Repeats'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323379559/E2878CC06F07A0FD52B1C1B2342FBDDA10725B40/', {-0.84, 0.78, -0.85},{0.00, 0.00, 180.00},{32.00, 1.00, 32.00},'','',
        {{-10.05, 0.78, -26.51},{27.01, 0.78, -22.83},{30.60, 0.78, 14.33},{-13.66, 0.78, 21.69}},'',{{12.25, 0.88, -30.05},{-21.13, 0.88, -15.47},{-32.47, 0.88, 10.76}},'',
        {{12.38, 0.88, -23.00,1,'B'}, {-13.80, 0.88, -23.08, 1, 'G'}, {-28.80, 0.88, 3.31, 1, 'R'}, {15.90, 0.78, 21.72, 0, 'G'}},'',
        {{19.57, 0.76, -30.03},{-17.34, 0.76, -7.65},{-32.01, 0.76, 18.14},{16.34, 0.76, 28.94}},'',{{19.75, 0.88, 21.73}},''},
        ['Enemies Closer'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323415804/2947A3DA8577715FCB7743EA4F94BB48B165C305/', {0.00, 0.68, 0.07},{0.00, 270.00, 0.00},{27.00, 1.00, 27.00},
        {{{-2.32, 0.57, -5.36},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}},{{-17.59, 0.57, -5.47},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}}},'',
        {{-5.54, 0.78, -22.42},{20.11, 0.78, 0.26},{-24.56, 0.78, 7.76},{20.53, 0.78, 18.50}},'',{{9.11, 0.83, -18.70},{5.67, 0.83, -0.01},{24.42, 0.83, 18.59},{-13.39, 0.83, 18.78}},'','','',
        '','',{{1.70, 0.83, 22.74}},''},
        ['Capital Escape'] = {'https://steamusercontent-a.akamaihd.net/ugc/769484085132961216/D1AC0DDA82F5829CCE3C39898EBB67264D9FECCA/', {-0.01, 0.68, 0.22},{0.00, 0.00, 0.00},{30.00, 1.00, 30.00},
        {{{-29.05, 0.57, -7.71},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}}},'',
        {{-9.97, 0.78, -8.25},{-9.94, 0.78, -4.94},{-17.96, 0.78, -9.88}},'','','',{{-14.83, 0.88, 1.04, 1, 'E'},{-17.80, 0.88, 1.01, 1, 'E'},{-32.32, 0.88, 0.95, 1, 'E'},{-35.39, 0.88, 1.01, 1, 'E'}},'',
        {{3.68, 0.69, 9.25},{3.48, 0.69, -22.45},{-21.74, 0.69, -23.97,3,'R'},{-32.36, 0.69, -24.05,3,'R'}},'8',{{-28.58, 0.83, 25.43},{32.45, 0.83, 19.72}},''},
        ['The Realm of the Dark Side'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323391028/50F7B46FBB1185EF653C4F77B53C0B28D80E5B2C/', {-1.91, 0.78, 0.22},{0.00, 270.00, 0.00},{42.00, 1.00, 42.00},
        {{{9.04, 0.57, 3.10},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}},{{-9.02, 0.57, -7.75},{0.00, 90.00, 0.00},{1.75, 1.75, 1.05}},{{-13.69, 0.57, 5.81},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}},{{-14.11, 0.57, -17.21},{0.00, 180.00, 0.00},{1.75, 1.75, 1.05}}},'',
        {{17.99, 0.78, 18.77},{15.42, 0.88, -12.74},{6.68, 0.78, -27.21}},'',{{-19.38, 0.88, -7.00}},'','','',
        {{17.79, 0.69, 27.71},{-2.36, 0.69, 1.69}},'',{{-13.38, 0.88, 21.67}},''},
        ['Home Invasion'] = {'https://steamusercontent-a.akamaihd.net/ugc/1007058936101013009/9F77BF446D333CA4F036B437BBE6AD6E8752767A/', {-1.02, 0.78, -0.13}, {0.00, 270.00, 180.00},{24.00, 1.00, 24.00},
        {{{0.94, 0.57, 5.77},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{6.70, 0.57, -15.01},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{-4.15, 0.57, -14.95},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}}},'',
        {{-1.10, 0.78, -27.91},{17.12, 0.78, -5.99},{-18.88, 0.78, 12.63}},'','','','','',
        {{-4.52, 0.78, -9.25}},'',{{-4.60, 0.83, 24.03}},''},
        ['Dubious Disposition'] = {'https://steamusercontent-a.akamaihd.net/ugc/1007058936101144383/D9196DEC9D4EE1A2AA1ED623CBA2F88B0FD5C21C/', {0.63, 0.78, 1.07}, {0.00, 180.00, 180.00},{32.00, 1.00, 32.00},
        {{{3.34, 0.52, 3.05},{0.00, 0.00, 0.00},{2.20, 2.20, 2.20}},{{-7.49, 0.53, -2.89},{0.00, 270.00, 0.00},{2.20, 2.20, 2.20}},{{9.66, 0.52, -2.69},{0.00, 270.00, 0.00},{2.20, 2.20, 2.20}}},'',
        {{28.23, 0.78, 13.90},{-18.46, 0.78, 0.70}},'','','',{{24.04, 0.83, 26.67,1,'R'}},'',
        {{-22.86, 0.78, -8.00},{11.42, 0.78, -24.52},{24.37, 0.78, -16.17}},'tl',{{-1.70, 0.83, 26.47}},''},
        ['Insidious'] = {'https://steamusercontent-a.akamaihd.net/ugc/1007058936101193955/9F0DB9107A4CDB13A147DAEF846799909E58DEBF/', {-1.02, 0.78, -0.13}, {0.00, 90.00, 180.00},{23.00, 1.00, 23.00},
        {{{-8.35, 0.57, 2.01},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{7.15, 0.57, 1.90},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'2tl',
        {{12.57, 0.78, 24.01},{-14.41, 0.78, -9.69}},'',{{0.99, 0.88, -21.06}},'','','',
        {{-14.09, 0.69, 12.92},{12.32, 0.69, 12.94}},'',{{-14.04, 0.83, 24.57}},''},
        --Tyrants of Lothal Maps 2d
        --['Call to Action'] = {'https://steamusercontent-a.akamaihd.net/ugc/1002555418839936043/7EE51E1FE93BEB025E7EBA229C4A30479AA01A57/', {-1.02, 0.78, -0.13},{0.00, 180.00, 0.00},{28.00, 1.00, 28.00},
        --'','',{{7.08, 0.78, -25.41},{-10.05, 0.78, -8.56}},'',{{16.95, 0.93, -22.08},{-3.17, 0.93, -22.30}},'',{{17.37, 0.93, -1.86, 1, 'G'},{-10.00, 0.88, 15.00,0,'R'}},'',
        --'','',{{-20.35, 0.93, 22.14}},''},
        --['Sands of Seelos'] = {'https://steamusercontent-a.akamaihd.net/ugc/775122925432717321/CB44025B1054D4AD413CDEF14DF6C7BBDC7D9EDC/', {-0.29, 0.68, -0.22},{0.00, 0.00, 0.00},{28.00, 1.00, 30.00},
        --{{{-15.59, 0.61, 2.66},{0.00, 0.00, 359.99},{1.46, 1.46, 0.88}},{{-15.23, 0.61, -15.29},{0.00, 0.00, 359.99},{1.46, 1.46, 0.88}}},'',
        --{{-18.51, 0.78, 25.08},{-10.09, 0.78, -7.79},{-23.93, 0.78, -20.05}},'','','',{{4.08, 0.78, -19.34,0,'G'},{1.22, 0.83, -16.41,0,'B'},{6.59, 0.83, -10.71,1,'R'}},'9',
        --{{-13.40, 0.69, -25.54,3,'R'},{-21.59, 0.69, -25.73,3,'B'}},'',{{-10.10, 0.83, 22.21}},''},
        --['Duel on Devaron'] = {'https://steamusercontent-a.akamaihd.net/ugc/1002555418840049151/C2D79885E92366672832248EA9C25BF13077A812/', {-0.29, 0.68, -0.22},{0.00, 180.00, 0.00},{28.00, 1.00, 30.00},
        --{{{-4.72, 0.57, 14.22},{0.00, 0.00, 359.99},{1.81, 1.81, 1.81}}},'',
        --{{1.49, 0.78, 19.93},{-12.26, 0.78, 1.54},{-5.42, 0.78, -16.82}},'',{{-8.73, 0.88, 23.53},{-2.18, 0.88, 1.59},{-15.66, 0.88, -1.97},{8.40, 0.88, -5.61},{1.49, 0.88, -9.40},{-8.94, 0.88, -12.86},{-19.20, 0.88, -20.48},{-8.86, 0.88, -27.63}},'',{{-5.41, 0.88, 19.89,1,'B'}},'',
        --'','',{{11.73, 0.83, 16.40}},''},
        --['Siege on Geonosis'] = {'https://steamusercontent-a.akamaihd.net/ugc/1008189224116219558/34B9367CD91D33856323E585C04604BC7963EA68/', {-0.29, 0.68, -0.22},{0.00, 0.00, 0.00},{33.00, 1.00, 33.00},
        --{{{-5.16, 0.56, -8.94},{0.00, 0.00, 359.99},{1.81, 1.81, 1.81}}},'',
        --{{-5.33, 0.78, -21.36},{-5.40, 0.78, -0.76},{18.68, 0.78, -11.03}},'',{{8.22, 0.83, -0.91,1},{-1.95, 0.83, 12.84,1},{-12.18, 0.83, -0.46,1}},{1.12, 1.00, 1.12,"3",0,'R','G','B'},'','',
        --{{8.34, 0.76, -11.14,3,'R'},{4.82, 0.76, 9.68,3,'G'},{-12.12, 0.76, 16.25,3,'B'}},'',{{11.61, 0.83, 22.63}},''}, -- colored terminals
        --['Race on Ryloth'] = {'https://steamusercontent-a.akamaihd.net/ugc/1002555418840863323/15CFDF398536C04110B9A75543D3FBE12711C8BF/', {-0.29, 0.68, -0.22},{0.00, 180.00, 0.00},{14.00, 1.00, 16.00},
        --'','',{{-8.69, 0.78, -3.35},{-23.73, 0.78, -11.51},{-45.73, 0.78, -2.41}},'',{{25.64, 0.83, -0.49},{20.91, 0.83, -8.83},{16.03, 0.83, -0.80},{-4.01, 0.83, -0.34},{-11.34, 0.83, -8.80},{-16.18, 0.83, -5.95},{-18.98, 0.83, -2.87}},'','','',
        --{{-38.75, 0.77, -11.32},{-38.51, 0.77, 2.89}},'',{{43.02, 0.83, -3.10}},''},
        --['The Final Order'] = {'https://steamusercontent-a.akamaihd.net/ugc/1002555418840548948/08CEAB8D95ACFD8D3C9948001C4E30C2EE28B0E7/', {-0.29, 0.68, -0.22},{0.00, 0.00, 0.00},{32.00, 1.00, 32.00},
        --{{{-8.43, 0.52, -7.77},{0.00, 0.00, 359.99},{1.86, 1.86, 1.86}},{{10.53, 0.55, -18.98},{0.00, 270.00, 359.99},{1.86, 1.86, 1.86}}},'',
        --{{-19.48, 0.71, 22.35},{8.41, 0.76, 1.67},{-19.61, 0.73, -12.34},{5.19, 0.76, -9.09}},'',{{21.64, 0.83, -1.77},{21.64, 0.83, 2.02}},'','','',
        --{{-26.12, 0.71, -15.81},{-16.16, 0.72, -25.96},{-2.02, 0.74, -12.23},{8.26, 0.69, -26.29}},'2tl',{{-1.94, 0.78, 25.81}},''}, --tokens by threat level
        --['Executive Overreach'] = {'https://steamusercontent-a.akamaihd.net/ugc/1007058936101752805/299B8D8C4EEDF1436DDFF039D3CB69D67D520586/', {-0.29, 0.68, -0.22},{0.00, 270.00, 0.00},{25.00, 1.00, 25.00},
        --{{{-8.71, 0.56, -5.38},{0.00, 0.00, 359.99},{1.86, 1.86, 1.86}},{{12.51, 0.56, -19.68},{0.00, 0.00, 359.99},{1.86, 1.86, 1.86}}},'',
        --{{-6.01, 0.78, 3.62},{1.39, 0.78, -7.56},{18.86, 0.78, 6.77}},'',{{-16.51, 0.78, -10.88},{-2.18, 0.78, -21.60},{15.35, 0.78, -10.63},{4.92, 0.78, -3.71}},'','','',
        --'','',{{15.43, 0.83, 24.69}},''},
        --['Intimidation Factor'] = {'https://steamusercontent-a.akamaihd.net/ugc/1007058936101805969/44C6BB255BD809391EFED18F38F69DC317B43C5B/', {-0.29, 0.68, -0.22},{0.00, 270.00, 0.00},{28.00, 1.00, 28.00},
        --'','',{{21.88, 0.78, 19.69},{0.07, 0.78, -1.42},{11.01, 0.78, -16.12}},'',{{7.05, 0.83, -12.35},{3.64, 0.83, -12.40},{-7.35, 0.83, 2.19},{-7.41, 0.83, 5.63}},'',{{-10.65, 0.83, -5.31, 1, 'G'},{-17.91, 0.83, -12.61,1,'G'},{-0.18, 0.83, -26.82,1,'R'},{11.07, 0.83, -26.80,1,'R'}},'',
        --'','',{{7.11, 0.83, 23.28}},''},
        --['The Pirate\'s Ploy'] = {'https://steamusercontent-a.akamaihd.net/ugc/1002555418839810001/9BC2CFC496B4DF18CAE75F40D1AF1D181949C9C8/', {-0.29, 0.68, -0.22},{0.00, 270.00, 0.00},{20.00, 1.00, 20.00},
        --{{{-6.73, 0.56, 4.71},{0.00, 0.00, 359.99},{1.86, 1.86, 1.86}}},'',
        --{{-10.27, 0.78, -20.90},{14.16, 0.78, -10.50},{7.11, 0.78, 6.61}},'','','',{{-0.17, 0.83, 20.81,0,'Y'}},'5+2tl',
        --'','',{{6.66, 0.83, 10.84}},''},
        --['The Admiral\'s Grip'] = {'https://steamusercontent-a.akamaihd.net/ugc/1002555418839871070/77CB0403767790D54C6F854018E77382A99DC425/', {-0.29, 0.68, -0.22},{0.00, 180.00, 0.00},{28.00, 1.00, 28.00},
        --{{{-12.48, 0.56, -10.45},{0.00, 0.00, 359.99},{1.86, 1.86, 1.86}},{{5.04, 0.56, -7.05},{0.00, 0.00, 359.99},{1.86, 1.86, 1.86}}},'',
        --{{-5.89, 0.78, -8.88},{4.53, 0.78, 19.07}},'','','',{{8.06, 0.78, 5.32,0,'B'},{-5.70, 0.78, -5.20,0,'R'},{-22.95, 0.78, 1.87,0,'G'}},'2+tl',
        --{{-16.03, 0.77, -19.00},{-5.91, 0.77, -19.28},{18.71, 0.77, -15.90},{21.83, 0.77, -5.56},{7.97, 0.77, -19.39},{15.36, 0.77, 8.26}},'',{{-16.04, 0.83, 22.43}},''},
        --Lothal 3D
        ['Call to Action'] = {'L3D', {-12.00, 1.01, 17.03},{0.00, 270.00, 180.01},{3.00, 3.00, 3.00},'Forest','','','','','','','','','','',''},
        ['Sands of Seelos'] = {'L3D', {12.28, 3.64, 7.04},{0.00, 180.00, 0.00},{3.25, 3.25, 3.25},'Desert','','','','','','','','','','',''},
        ['Duel on Devaron'] = {'L3D', {-7.31, 0.94, 11.94},{359.91, 90.28, 180.00},{4.81, 4.81, 4.81},'Forest','','','','','','','','','','',''},
        ['Siege on Geonosis'] = {'L3D', {9.10, 1.42, -1.21},{359.82, 179.82, 359.76},{1.20, 1.20, 1.20},'Desert','','','','','','','','','','',''},
        ['Race on Ryloth'] = {'L3D', {38.22, 0.84, -0.24},{0.00, 0.00, 180.00},{2.50, 2.50, 2.50},'Desert','','','','','','','','','','',''},
        ['The Final Order'] = {'L3D', {0.50, 0.88, -18.53},{0.07, 180.01, 0.39},{3.60, 3.60, 3.60},'Desert','','','','','','','','','','',''},
        ['Executive Overreach'] = {'L3D', {-10.97, 0.92, 2.00},{0.00, 269.99, 180.00},{4.75, 4.75, 4.75},'Forest','','','','','','','','','','',''},
        ['Intimidation Factor'] = {'L3D', {-3.00, 0.94, -2.00},{0.07, 180.00, 359.94},{0.43, 0.43, 0.43},'Forest','','','','','','','','','','',''},
        ['The Pirate\'s Ploy'] = {'L3D', {0.02, 0.91, 2.03},{359.66, 0.00, 180.49},{5.00, 5.00, 5.00},'Desert','','','','','','','','','','',''},
        ['The Admiral\'s Grip'] = {'L3D', {-1.12, 0.79, 6.83},{359.54, 90.16, 0.19},{4.55, 4.55, 4.55},'Imperial','','','','','','','','','','',''},
        -- Raid Maps 3D
        ['The Malastarian Outpost'] = {'R1', {4.01, 4.35, 4.63},{0.00, 0.00, 0.00},{3.82, 2.86, 3.82},'Imperial','','','','','','','','','','',''},
        -- The Bespin Gambit Maps 2D
        --['Reclamation'] = {'https://steamusercontent-a.akamaihd.net/ugc/1008188088486924102/CC4E46A4A897E49FAD6B485207BCFA4F9FCA8F04/',{-1.76, 0.96, -0.75}, {0.01, 180.00, 0.04}, {28.00, 1.00, 28.00},
        --{{{16.42, 1.15, -17.70},{0.00, 270.01, 0.00},{1.60, 1.60, 1.60}},{{-5.81, 1.15, -6.35},{0.00, 270.01, 0.00},{1.60, 1.60, 1.60}}},'',
        --{{7.25, 1.06, 8.87},{-30.77, 1.06, 5.38}},'',{{25.37, 1.06, -9.92},{17.80, 1.06, 5.40},{18.25, 1.06, -13.79},{-0.81, 1.06, -20.95},{-15.52, 1.06, -9.64},{-30.46, 1.06, 20.37}},'','','',
        --'','',{{10.85, 1.13, 23.82}},''},
        --['Reclassified'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462638752/EA6CF6790337A48FD3FF46AB41529D524BCFC5B8/', {-1.68, 0.96, 0.07}, {0.00, 180.00, 0.00}, {28.00, 1.00, 28.00},
        --{{{10.14, 1.15, -6.01},{0.00, 270.01, 0.00},{1.60, 1.60, 1.60}}},'', {{15.74, 1.06, -13.24},{-7.11, 1.06, 20.60},{-3.48, 1.06, 5.86}},'',
        --{{23.18, 1.16, -9.20},{-3.26, 1.16, 1.93}, {0.29, 1.16, 5.87},{-11.01, 1.16, 2.04},{-26.05, 1.16, 13.09},{15.42, 1.16, 5.17}},'',{{23.00, 1.11, -6.00,0,'R'}},'',
        --{{-22.47, 0.97, -9.03},{-18.58, 0.97, 24.92}},'', {{4.15, 1.16, 24.46}},''},
        --['Panic in the Streets'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462638163/F8AAF2EBAD29AF34563E8D89524E5958FC83C12C/',{-1.68, 0.96, 0.07},{0.00, 90.00, 0.00},{34.00, 1.00, 34.00},
        --{{{19.15, 1.15, -9.96},{0.00, 180.00, 0.00},{1.60, 1.60, 1.60}},{{19.27, 1.15, 10.62},{0.00, 180.00, 0.00},{1.60, 1.60, 1.60}},{{7.58, 1.15, 1.79},{0.00, 270.00, 0.00},{1.60, 1.60, 1.60}}},'',
        --{{16.28, 1.06, -22.22},{-1.07, 1.06, -18.54},{-0.84, 1.06, 18.85}},'',{{12.26, 1.16, -15.71},{-4.63, 1.16, -1.77},{-14.73, 1.16, -1.67},{-21.86, 1.16, -8.27},{-1.03, 1.16, 22.10}},'',
        --'','','','',{{-31.60, 1.11, 15.78}},''},
        --['Freedom Fighters'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462637526/0BE31E10C1878426EDF6328760EB616C9E6BDD24/', {0.00, 0.96, 0.07},{0.00, 180.00, 0.00},{28.00, 1.00, 28.00},
        --{{{-29.22, 1.15, -18.60},{0.00, 180.01, 0.00},{1.60, 1.60, 1.60}},{{5.50, 1.15, -15.03},{0.00, 180.01, 0.00},{1.60, 1.60, 1.60}},{{26.29, 1.15, 1.99},{0.00, 90.00, 0.00},{1.60, 1.60, 1.60}},{{-23.68, 1.15, 21.71},{0.00, 90.00, 0.00},{1.60, 1.60, 1.60}}},'tl',
        --{{1.28, 1.06, -24.87},{5.67, 1.06, 1.70},{-14.00, 1.06, 25.30}},'',{{9.03, 1.16, -17.75},{-25.45, 1.16, -21.31},{-25.81, 1.16, 25.39},{28.93, 1.16, 5.72}},{1.17, 1.00, 1.17,'',4,'B','B','B','R'},'','','','',{{-2.36, 1.16, 24.81}},''},
        --['Hostile Takeover'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462637029/660D595CC383579BE6AACB900E50333A480966C3/', {0.00, 0.96, 0.07},{0.00, 180.00, 0.00},{28.00, 1.00, 28.00},
        --{{{14.14, 1.15, 6.61},{0.00, 90.01, 0.00},{1.60, 1.60, 1.60}},{{-8.61, 1.15, -11.28},{0.00, 180.01, 0.00},{1.60, 1.60, 1.60}},{{-3.69, 1.15, 3.24},{0.00, 90.00, 0.00},{1.60, 1.60, 1.60}}},'',
        --{{-4.89, 1.06, -3.62},{5.67, 1.06, 17.68},{-1.23, 1.06, -0.44}},'','','','','','','',{{-1.30, 1.16, 25.14}},''},
        --['Cloud City\'s Secret'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300299047/D8A4FB57E2E7853E4DF153A0BAF0AB082822D0E7/', {-1.76, 0.96, -0.75}, {0.00, 270.00, 0.00}, {28.00, 1.00, 28.00},
        --{{{-20.76, 1.14, -10.37},{0.00, 0.00, 0.00},{1.40, 1.40, 1.40}},{{9.62, 1.14, 4.13},{0.00, 270.00, 0.00},{1.40, 1.40, 1.40}}},'',
        --{{-14.47, 1.05, -1.79},{-4.65, 1.05, 23.16},{-4.83, 1.05, 1.11}},'',{{4.63, 1.06, -5.25},{1.52, 1.06, -5.30}},'',{{-4.87, 1.11, 7.68,0,'R'},{-23.72, 1.13, 7.48,1,'B'}},'','','',{{23.65, 1.13, -8.76}},'',''},
        --Twin shadows
        --['Canyon Run'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462639815/7CED003048ECBFD8881E153461D243DE30213D30/', {-1.76, 0.96, -0.75}, {0.00, 180.00, 0.00}, {28.00, 1.00, 28.00},
        --{{{-6.62, 1.14, 10.84},{0.00, 0.00, 0.00},{1.40, 1.40, 1.40}}},'tl',{{3.35, 1.06, -10.32},{9.72, 1.06, 6.01},{-19.21, 1.06, 2.58}},'','','',{{-3.07, 1.11, -16.77,0,'Y'},{0.07, 1.11, -16.64,0,'Y'},{16.17, 1.11, 2.73,0,'G'},{0.02, 1.11, 22.05,0,'R'},{-16.40, 1.11, 19.15,0,'R'}},'',
        --{{-12.86, 1.06, 15.45}},'',{{-6.24, 1.16, -3.62}},'',''},
        --['Hunted Down'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462640505/8011B7AC10A252004094B0128E3A718BDA5D2542/', {-1.02, 0.78, -0.13}, {0.00, 90.00, 180.00},{20.00, 1.00, 20.00},
        --{{{-8.25, 0.57, 20.79},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{-7.03, 0.57, -9.17},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'8',
        --{{16.89, 0.78, 9.66},{-18.35, 0.78, 6.23},{-5.36, 0.78, -3.42}},'','','',{{-8.96, 0.88, 22.67,1,'G'}},'',
        --{{10.12, 0.69, -3.14}},'',{{4.00, 0.83, 19.48}},''},
        --['Fire in the Sky'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462640192/189B19F68B9ED80F148C03AF939DF5BBFF83EEE8/', {-1.02, 0.78, -0.13}, {0.00, 270.00, 180.00},{23.00, 1.00, 23.00},
        --{{{-9.53, 0.57, 2.69},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{-11.67, 0.57, -9.86},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{14.35, 0.57, -3.68},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}}},'',
        --{{5.33, 0.78, 0.93},{1.69, 0.78, -19.80}},'','','',{{-13.40, 0.78, -13.65,0,'R'}},'',
        --{{1.54, 0.69, 13.03,3,'G'},{16.29, 0.69, -16.63,3,'B'}},'',{{-6.65, 0.83, 30.99}},''}, --colored terminals green blue
        --['Infiltrated'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462640192/189B19F68B9ED80F148C03AF939DF5BBFF83EEE8/', {-1.02, 0.78, -0.13}, {0.00, 90.00, 180.00},{23.00, 1.00, 23.00},
        --{{{-11.88, 0.57, 3.05},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{6.64, 0.57, 2.30},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{11.55, 0.57, -14.64},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{0.56, 0.57, -21.48},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'2tl',
        --{{16.81, 0.78, -31.21},{-12.72, 0.78, 7.74}},'','','','','',
        --{{19.41, 0.69, -22.55},{-22.26, 0.69, 16.71,3,'G'},{10.68, 0.69, 13.30,3,'B'},{-13.42, 0.69, -7.12,3,'Y'},{7.57, 0.69, -10.37,3,'R'}},'',{{-6.65, 0.83, 30.99}},''}, -- colored terminals green, blue, yellow, red, none
        --['Past Life Enemies'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462641123/38DF062979669CA0857AE68C6703D9F0EF17CDA6/', {-1.02, 0.78, -0.13}, {0.00, 0.00, 180.00},{30.00, 1.00, 30.00},
        --{{{-7.01, 0.57, -6.46},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{6.08, 0.57, -16.08},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}}},'tl',
        --{{2.54, 0.78, 8.16},{2.22, 0.78, -7.85},{-4.29, 0.78, -11.30}},'','','','','',
        --{{1.92, 0.69, 21.20},{-10.94, 0.69, -14.16},{-1.23, 0.69, -10.79}},'tl',{{-0.82, 0.83, 27.80}},''},
        --['Shady Dealings'] = {'https://steamusercontent-a.akamaihd.net/ugc/755969254323369250/A93EAC1D3E3CCA2DF95E47CF269D4D9C7440CFE7/', {-1.02, 0.78, -0.13}, {0.00, 0.00, 180.00},{20.00, 1.00, 20.00},
        --{{{-13.75, 0.57, 14.43},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{4.40, 0.57, -3.75},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{-2.93, 0.57, 10.77},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{-16.89, 0.57, -3.70},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'5',
        --{{-25.85, 0.78, 10.23},{-4.66, 0.78, -0.45},{27.25, 0.78, -4.21}},'','','',{{12.97, 0.88, 13.63,1,'B'},{16.50, 0.88, -7.38,1,'B'}},'',
        --{{-32.90, 0.69, 3.13},{-22.73, 0.69, -17.82}},'',{{-8.31, 0.83, 13.74}},''},
        --Other Maps
        --['Deadly Transsmission'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462661447/6168ECD75EA3363305FD21742D42EAEBFAB782DB/', {-1.76, 0.96, -0.75}, {0.00, 180.00, 0.00}, {20.00, 1.00, 20.00},
        --{{{20.52, 1.13, -10.87},{0.00, 0.00, 0.00},{1.35, 1.35, 1.35}},{{12.80, 1.13, -5.76},{0.00, 90.00, 0.00},{1.35, 1.35, 1.35}},{{11.15, 1.13, 7.71},{0.00, 0.00, 0.00},{1.35, 1.35, 1.35}},{{6.31, 1.13, 9.97},{0.00, 90.00, 0.00},{1.35, 1.35, 1.35}}},'',
        --{{23.76, 1.06, -5.91},{-3.91, 1.06, 6.85},{-3.98, 1.06, -8.56}},'',{{17.77, 1.11, -12.37},{11.11, 1.11, 3.56},{23.57, 1.11, 12.84}},{0.63, 1.00, 0.63,'tl'},'','',
        --{{-1.45, 0.97, -2.41},{-7.78, 0.97, -18.28},{-10.78, 0.97, 13.19}},'',{{-23.09, 1.16, -8.66}},''},--needs mtoken health tl
        --['Communication Breakdown'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462664287/411B1A1B9C7985F8133209EC374A1B54FD548210/', {-1.76, 0.96, -0.75}, {0.00,180.00, 0.00}, {26.00, 1.00, 26.00},
        --'','',{{26.01, 1.06, -19.33},{1.59, 1.06, -7.64},{-23.06, 1.06, -7.02}},'',{{5.23, 1.16, 17.20},{1.54, 1.16, 17.42},{-2.39, 1.16, 17.26}},'','','',{{-30.90, 1.06, -2.89}},'',{{21.75, 1.16, 5.27}},''},
        --['Snowcrash'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462670755/87AC22B0A8A1256EDF985B96D6BAA7A8B168398F/', {-1.76, 0.96, -0.75}, {0.00, 180.00, 0.00}, {24.00, 1.00, 24.00},
        --{{{6.67, 1.13, -4.70},{0.00, 90.00, 0.00},{1.35, 1.35, 1.35}},{{-17.77, 1.13, -10.57},{0.00, 90.00, 0.00},{1.35, 1.35, 1.35}}},'',
        --{{-24.80, 1.06, -10.55},{-6.88, 1.06, -7.80},{20.38, 1.06, -8.08}},'',{{20.48, 1.16, 7.20},{26.28, 1.16, -4.80},{11.34, 1.16, -22.78}},'','','',
        --'','',{{-9.53, 1.16, 19.34}},''},
        --['A Light in the Darkness'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462668773/3CA786C28C470FE358D9624B82C15186B824C214/', {-1.02, 0.78, -0.13}, {0.00, 270.00, 180.00},{20.00, 1.00, 20.00},
        --{{{0.77, 0.57, -3.19},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'',
        --{{15.60, 0.78, -3.97},{12.35, 0.78, -27.22},{-14.59, 0.78, -17.25}},'','','','','',
        --{{5.17, 0.69, -3.57}},'',{{-7.98, 0.83, 30.62}},''},
        --['Generous Donations'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300257825/F4558FB038958B1423DCA72A518FE2C565702A9E/', {-1.02, 0.78, -0.13}, {0.00, 180.00, 180.00},{24.00, 1.00, 24.00},
        --{{{-10.44, 0.57, 1.89},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{4.10, 0.57, -13.27},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}}},'5',
        --{{23.35, 0.78, -8.71},{4.00, 0.78, 4.56},{-15.39, 0.78, 1.37},{-21.95, 0.78, -21.56}},'','','','','',
        --{{-19.06, 0.69, -1.96},{-22.30, 0.69, -18.28},{-12.50, 0.69, -12.12}},'',{{-5.89, 0.83, 17.62}},''},
        --['The Spice Job'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300253816/57C525A8E426156EC964B641C3F728137F4FD937/', {-1.76, 0.96, -0.75}, {0.00, 180.00, 0.00}, {20.00, 1.00, 20.00},
        --{{{-19.51, 0.89, -2.18},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{-10.56, 0.89, -11.08},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'',
        --{{-8.40, 1.06, 13.01},{19.42, 1.06, 2.62},{-15.45, 1.06, -11.46},{-1.90, 1.06, -18.16}},'','','',{{-15.89, 1.06, -4.24,0,'Y'},{-12.30, 1.06, -7.46,0,'Y'},{-19.12, 1.06, 6.24,0,'R'},{-22.90, 1.06, 3.14,0,'R'},{-19.23, 1.06, -14.82,0,'B'},{-15.80, 1.06, -14.75,0,'B'}},'',
        --'','',{{12.55, 1.11, 16.97}},'',''},
        --['Sorry About the Mess'] = {'https://steamusercontent-a.akamaihd.net/ugc/859479555300252133/11575FC3D876E6BC50D3D53A06FA59372EC0541B/', {-1.02, 0.78, -0.13}, {0.00, 90.00, 180.00},{20.00, 1.00, 20.00},
        --{{{4.05, 0.57, -12.34},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}}},'',
        --{{2.19, 0.78, 8.39},{16.20, 0.78, 8.05},{12.86, 0.78, -12.96},{-15.00, 0.78, -23.12}},'','','','','',
        --'','',{{-1.18, 0.83, 22.40}},''},
        --['Open to Interpretation'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462675870/433D7191EDDCBB1FD457CB99E08594853B0F98E4/', {-1.02, 0.78, -0.13}, {0.00, 270.00, 180.00},{24.00, 1.00, 24.00},
        --{{{0.99, 0.57, 14.79},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{-4.56, 0.57, 10.05},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{-4.37, 0.57, -8.77},{0.00, 270.00, 0.00},{1.80, 1.80, 1.80}},{{1.11, 0.57, -22.49},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}}},'',
        --{{7.78, 0.78, -27.36},{11.67, 0.78, -12.80},{-17.55, 0.78, -16.01}},'',{{-2.92, 0.88, -30.83}},'',{{-14.05, 0.88, 2.31,1,'B'},{-13.85, 0.88, -1.75,1,'B'},{4.85, 0.88, -12.81,1,'G'},{0.70, 0.88, -12.86,1,'G'},{4.45, 0.88, 9.12,1,'R'},{0.63, 0.88, 9.35,1,'R'}},'',
        --{{19.06, 0.76, -1.66},{-10.69, 0.76, -16.03},{-14.18, 0.76, 13.23}},'',{{15.40, 0.83, 31.01}},''},
      --['Phantom Extraction'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462667735/718C303325F04CF452435DA1210E0FD88C0ED66C/', {-1.02, 0.78, -0.13}, {0.00, 90.00, 180.00},{18.00, 1.00, 18.00},
        --{{{6.97, 0.57, -9.18},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}},{{7.05, 0.57, -23.40},{0.00, 0.00, 0.00},{1.80, 1.80, 1.80}}},'',
        --{{-7.67, 0.78, 6.68},{-7.72, 0.78, -7.19},{3.10, 0.78, -25.13}},'','','','','',
        --{{10.10, 0.76, -14.29},{-0.23, 0.76, 24.72,3,'R'},{-14.88, 0.69, 3.07,3,'R'},{-14.83, 0.76, 17.60,3,'G'},{-0.46, 0.76, 3.26,3,'G'}},'',{{10.15, 0.83, 21.25}},''}, -- colored terminals red red green green none
        --['Celebration'] = {'https://steamusercontent-a.akamaihd.net/ugc/859478214462665263/B505EF0C1FC2ACD1BAD4C0398757315EFA68B0E9/', {-1.76, 0.96, -0.75}, {0.00, 180.00, 0.00}, {20.00, 1.00, 20.00},
        --'','',{{-23.50, 1.06, -10.50},{0.00, 1.06, -7.00},{11.00, 1.06, 5.00}},'','','',{{22.50, 1.16, 12.50,1,'Y'},{4.00, 1.16, 1.00,1,'Y'},{-12.00, 1.16, -14.00,1,'R'},{-31.00, 1.16, -10.00,1,'R'},{-19.50, 1.16, 4.50,1,'B'},{-4.23, 1.06, 12.50,1,'B'},{15.50, 1.16, -6.50,1,'G'},{27.00, 1.16, 1.00,1,'G'}},'',
        --'','',{{-11.50, 1.11, 8.50}},'',''},
    }

    Core_Tiles = {
        [1] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241973651/C3C15C0E2AD80AE87B01C5B4869793F571DD7B31/","https://steamusercontent-a.akamaihd.net/ugc/923667919241973734/D51159356E9838C1243141FED538190E5597223C/",},
        [2] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241973409/76452EE23D4F2688BABCBE3E18F9E8C840394E1A/","https://steamusercontent-a.akamaihd.net/ugc/923667919241973491/28CAF2B75A655119ABD9E424546EB7DCAAD8B3EA/",},
        [3] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241973139/EA10C032EC9D26234D29292006C9817D5324D061/","https://steamusercontent-a.akamaihd.net/ugc/923667919241973226/3750C31A6DDA58F50D119C030B15655AF95B559C/",},
        [4] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314723254/1AD33FA8D2842D9B6C9A58B2C8B1D9DB20E7BAD6/","https://steamusercontent-a.akamaihd.net/ugc/779622679478246272/1A757FC1DC551E1A1854393599998A9D044E91C5/",},
        [5] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241972874/1AD33FA8D2842D9B6C9A58B2C8B1D9DB20E7BAD6/","https://steamusercontent-a.akamaihd.net/ugc/923667919241972960/CC6A92BAE630751D424D439222E050CBB957A810/",},
        [6] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241972587/7ACB4E9D1A93F9A0CD4A74B1317FFD09D4441488/","https://steamusercontent-a.akamaihd.net/ugc/957472492314723978/A98E2B8E0B61E46B5DC0168FA2678E1EE5797AD8/",},
        [7] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241972302/55118AF4BC2C8344922F97E0DD5E1E7D852B64FC/","https://steamusercontent-a.akamaihd.net/ugc/923667919241972413/F7A088B8FE8BE8659520DF056DA53DB9B1B39B9A/",},
        [8] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241971934/F8E88DF5A81AAD17C49D02D03ED2ADDECA8EF3FA/","https://steamusercontent-a.akamaihd.net/ugc/779622679478299067/D7C6104A443B105CF40F018B2AA4BBC4E357E13F/",},
        [9] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241971660/D70FB9E808F91F596FFCFCCC0C58344A01678429/","https://steamusercontent-a.akamaihd.net/ugc/923667919241971745/434FADCCE565A4D02F40A63D7A90CDF5CD74914F/",},
        [10] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241971439/6DC626F7976E7C406F626F90FF13CF66F7CDDB42/","https://steamusercontent-a.akamaihd.net/ugc/923667919241971518/D3220D9D07DB32FF69B5D4DA23C4C85B5C95CB22/",},
        [11] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241971168/ACF72F6F8129844C8F3B5F024BA483CDE9E9A4A5/","https://steamusercontent-a.akamaihd.net/ugc/779622679478335388/D6317136D1C52C8F1E3F4B67ADC87F45037DA864/",},
        [12] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314725585/ACF72F6F8129844C8F3B5F024BA483CDE9E9A4A5/","https://steamusercontent-a.akamaihd.net/ugc/779622679478392686/976CD2B15055C3229716ECAF4CED0C1F3E5A986C/",},
        [13] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970986/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314726110/5EAA26C141FF70CAD3E84C4CF57ECADE5DD2219B/",},
        [14] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970795/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314726474/F0F870E14C84B6A3BE60E158AA9FBB6ACC4C786B/",},
        [15] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970795/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314726766/3E009CE1A8156A97F7FEBAB40FED708153CDEEDC/",},
        [16] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970795/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314726928/3B880C34248C32C609788F302F21248011AB59B0/",},
        [17] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970618/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/957472492314727151/5D8A0813BECFFD7280A555A0765D81F9BC55A5CF/",},
        [18] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970429/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/923667919241970529/2AADED0401A1EF03C61A89044C22A93C9DD03004/",},
        [19] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970236/C3C15C0E2AD80AE87B01C5B4869793F571DD7B31/","https://steamusercontent-a.akamaihd.net/ugc/923667919241970325/427A4830A2856024FD7BC59F54BDBBA877940235/",},
        [20] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970046/76452EE23D4F2688BABCBE3E18F9E8C840394E1A/","https://steamusercontent-a.akamaihd.net/ugc/923667919241970135/ABC1AF557E4A325BD0BB8AA888FA64C9CB103CA3/",},
        [21] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241969845/A0392DE2BCD1431F11FC7A8AFB5C8CB1887089E1/","https://steamusercontent-a.akamaihd.net/ugc/923667919241969933/07AD7A1571492EEEEE8D8D48EB6D178E89738033/",},
        [22] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241969583/1AD33FA8D2842D9B6C9A58B2C8B1D9DB20E7BAD6/","https://steamusercontent-a.akamaihd.net/ugc/779622679478439538/6D367D66EB9943ACC7B92C56937FFB6859CBE3F4/",},
        [23] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241969314/1AD33FA8D2842D9B6C9A58B2C8B1D9DB20E7BAD6/","https://steamusercontent-a.akamaihd.net/ugc/923667919241969399/608955CE39E2C412BF9ACAC2CFA93ACC704C58CA/",},
        [24] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241968962/55118AF4BC2C8344922F97E0DD5E1E7D852B64FC/","https://steamusercontent-a.akamaihd.net/ugc/923667919241969040/898DD98C836661C4A6A3D64F03936C502A78BA81/",},
        [25] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241968640/71A5C4611CD14CBDCAEA6E624A525FAB07223ADD/","https://steamusercontent-a.akamaihd.net/ugc/923667919241968723/8363841A317E604879536D7BD81B44E1AFAD2EF0/",},
        [26] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241968337/F8E88DF5A81AAD17C49D02D03ED2ADDECA8EF3FA/","https://steamusercontent-a.akamaihd.net/ugc/779622679478111032/EDE5552B34DD58CDC314E18FF56608D6210563EA/",},
        [27] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241968061/AD281765FF63589B1B80035BDAAF9F7F7BD222BF/","https://steamusercontent-a.akamaihd.net/ugc/779622679478487364/4C60AFF1827704A2BBB896A54E96A89F56478EA5/",},
        [28] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241967857/6DC626F7976E7C406F626F90FF13CF66F7CDDB42/","https://steamusercontent-a.akamaihd.net/ugc/957472492314729567/AD83ED192F13E97D9B706CBF3993A0F9D18AA3CC/",},
        [29] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241967622/ACF72F6F8129844C8F3B5F024BA483CDE9E9A4A5/","https://steamusercontent-a.akamaihd.net/ugc/779622679478113125/369BF35BAE23724FA4B62243201CE4785734B1DA/",},
        [30] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241967622/ACF72F6F8129844C8F3B5F024BA483CDE9E9A4A5/", "https://steamusercontent-a.akamaihd.net/ugc/779622679478189654/C46B171726CB1C996021D154D003DDF81B5987E6/"},
        [31] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241967361/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314730187/75E37BC6554231412108E0B77BC715DAB9203C6C/",},
        [32] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241967181/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314730545/E2897779610D7FE3BA54EB7DFFF9170B604E6749/",},
        [33] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241967001/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314730883/42841B7F2DAE5D47CEEEF8FBC775C39568A5BA0B/",},
        [34] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314731157/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314731273/C444AE4CB4886B1862531E385E990F7AF9B2E242/",},
        [35] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966826/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/957472492314731598/6E294026F22A2CC67F7CEB26C64812E88B8F37B1/",},
        [36] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966625/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/923667919241966732/51F913692336043213A2A34C0077E1ECEE687580/",},
        [37] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970795/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/779622679478719599/4EDE8D5BCC94F92E73005E9354EC6428BF567BC0/"},
        [38] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966389/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/923667919241966473/14856E0C32ED5F95A8B5C0C3EB1CC35C6EEFFAAE/",},
        [39] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966203/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/923667919241966296/77B3D667813C34C5ACB44160030B856291F876C9/",},
    }

    JabbasRealm_Tiles = {
        [1] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314715388/05524839EBD31446754DBE01C124E1C4694B9689/","https://steamusercontent-a.akamaihd.net/ugc/957472492314715507/ADD5BC22ACD050DFEBC4F65EF04DB2219AB67BDD/",},
        [2] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314715871/2A73D6815D36B56470056BCDCA8B9DF62F6014E5/","https://steamusercontent-a.akamaihd.net/ugc/957472492314715990/F2828D851EB0CBC9950CF401037441AC1E3CCEB3/",},
        [3] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314716258/A125244EDF482DB9FD577FA617410D0EB2B4B125/","https://steamusercontent-a.akamaihd.net/ugc/957472492314716370/28E927E92CFAB1B34255CEADF4F5F7F45B5FD3B8/",},
        [4] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314716763/7AC0B3C199239F8DD6C293C66F70FCE9A0FC7CE7/","https://steamusercontent-a.akamaihd.net/ugc/957472492314716890/85843A887F8CE041C59F8EB3231753FBD4FFE9A0/",},
        [5] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314717161/76452EE23D4F2688BABCBE3E18F9E8C840394E1A/","https://steamusercontent-a.akamaihd.net/ugc/957472492314717278/400B82E812D210A4038C2A5192CB5AF9F0B08F94/",},
        [6] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314717561/A0392DE2BCD1431F11FC7A8AFB5C8CB1887089E1/","https://steamusercontent-a.akamaihd.net/ugc/957472492314717685/43757991C6EB47C8ECF2D528A47893221BED4C04/",},
        [7] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314717960/08B66B36DD8E174D717CB4CC1D5513C6188211AE/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243084041/41C5ED5C5C5030215F53E85D4AC15AE559A942E2/",},
        [8] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314718382/55118AF4BC2C8344922F97E0DD5E1E7D852B64FC/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243091135/99FEA2A313721428D9ACB3DF8A721BA1C15A0A76/",},
        [9] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314718789/71A5C4611CD14CBDCAEA6E624A525FAB07223ADD/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243098502/FB9525358829B6D23DFFC533B13BDE25079390E3/",},
        [10] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314719227/9977270789BF3A9A4459553F074B3F81589F6F20/","https://steamusercontent-a.akamaihd.net/ugc/957472492314719340/3C4498CAE756504D42A5B945CB39C2374F617575/",},
        [11] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314719618/AD281765FF63589B1B80035BDAAF9F7F7BD222BF/","https://steamusercontent-a.akamaihd.net/ugc/957472492314719723/F69FE562FFC1B101DE3E97F641292BB588CA9EDE/",},
        [12] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314720010/ACF72F6F8129844C8F3B5F024BA483CDE9E9A4A5/","https://steamusercontent-a.akamaihd.net/ugc/957472492314720156/D8B5BB22F16807A27E7B12A6554522BBC1F6BD0C/",},
        [13] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314720414/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243104473/90ABFA7FC28E6DABF24F7EF3FC41E78462A000A5/"},
        [14] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314720414/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243110010/1E5F2F9CFA81F8BF2C328E82361D8677E70BA5D4/",},
        [15] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314720807/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/778499716967053311/F971090673E9E04697DAB32B21C2035A0D66460C/",},
        [16] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314721224/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/957472492314721356/D9ACE5BDBB60D689DF274E7F32640D79A65D3628/",},
        [17] = {"https://steamusercontent-a.akamaihd.net/ugc/957472492314721482/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/957472492314721610/FB0218221F24BD3425469A9416210C9FFAD6EE3F/",},
    }

    Hoth_Tiles = {
        [1] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972684049/8240A6BE15B232A5662A61DBF15AD7F612BB8B6D/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242988437/9390B24D2FA223FED0CF4DF4AEDB0F531B57F6FB/",},
        [2] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972702481/4710C4263BA072123DDE86EF94DECAE182223913/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242978319/69E84FCA811BE9306B51130DA6C2962DBDC43530/",},
        [3] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972840061/730FBE2AD1BC0AE428ACA33AA5E614F6C446DFDB/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242959081/73ECAFF105F97C0407216103D62E3E574EEF7015/",},
        [4] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972872791/317DE9C1810DD7820274A3048949A39E2DD67E8C/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242943918/FFE6026A1090440F01A4A1C64556B97E6B87CF46/",},
        [5] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972878567/7A857FF95E04F2319F66807C2C68A1436C48428B/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242800005/27D3D3D82817CD1DEC935D69AD6FB7EB64907F60/",},
        [6] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972883763/A644C9F77E6D537DD626964821053B46651DD89D/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242898611/C2F4BE7FA83A88188F3045600B8D7E07CECDD5E1/",},
        [7] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972892532/E8F317A7B9D543BA395DBEAE672D9F1C4247744B/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242890660/8B2F8A92993FA46DE7AB17C2E511C5FFC47BD7D0/",},
        [8] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972899462/DB29BFE7A66FB299F429B94CE0C220100DF9C870/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242860729/47337B8315FA09EFD73F8451E835B202DCCE0B0F/",},
        [9] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972910558/0A90CB3423331D9D7AE0F67818BF149D68E34B5D/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242867260/F86259CF64FDFE3C3137C92414907D516CBE574F/",},
        [10] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972921577/F1D0D1ED47E094820A5F528A56FB23A7B3FA6660/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242853237/DF51F03F5461576A92112EA68A90C60DF93920DB/",},
        [11] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972928006/56FE7B3568822E1619685D2FAE3E03B4C73E78BC/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242813314/C4BDDC502B572EC94C5331929870B619FCFB9EB1/",},
        [12] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972933999/084AC6DDBC6989CE4BF74A2F2F232F50CFCF0EE5/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242844185/E5BC3D9EE6077E6A9D279BBA985851CAF9F80453/",},
        [13] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972943484/481560907D02C571919C5B383DEADC4EEEACC385/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242838620/7214AF9146F823DA7E21FC92D951660895189E98/",},
        [14] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972945916/C432F5BDC04650CADFF94D436C27E3A497D59DE1/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242880570/FA6979686D23C1207F7658CD8E687116C93E73E0/",},
        [15] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972952083/FD842DFCAFE0B910628CD49709F9509CC0968BA2/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242876832/D19B63665ED3260CE4DB6A912778E2F3C8F792B2/",},
        [16] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972955518/7881CEDE6E192E10961FE5C90F1B36305348056A/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242833915/08B11650635CBA0BE3AED7AAF76606050FE4EF38/",},
        [17] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972966631/ACF2484B37A961A8A218D412887989A3A6424479/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242786637/A516E52C8CD4C9796800871469FA3356131CD1E4/",},
        [18] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972977203/760BDE87505EA7F74462B18C9CF90A90C15027F6/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242782869/56C7B7C24A3683B8B25A6F8BCCEED65A5B522189/",},
        [19] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972984117/FCD5FDAC1C4ED88C6C869E5918E876E07D8D04E9/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242778692/FE9D1592CA35712408206DB193AD93C6620A0ABD/",},
        [20] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972987844/C8B8912EC4B522D815337EBAC82192FEF01AEE05/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242773376/40B4ABE41EB8C47E63E8D6944F6A3FB48A3C0B01/",},
        [21] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972993801/74B11903F7B18FA6351DA6060B8DCAA4B638AC10/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242766161/4A749CC7624DF638679FDFCDDA3E40F1C8A65076/",},
        [22] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799973009358/06710A608C0DCDA94D781AAA58FE07276A305935/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242822203/753AF4F2069F51DA5715B5B14C3BA6AB6C234F3A/",},
        [23] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799973013364/07A5DEF1804B418D90FA47BA6BE96EFCDB038D1D/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242762568/849DD48A2C09667614D8047FA68DA1BC4741C415/",},
        [24] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799973016789/6925CFCCCD138007091FF543EBEA3FE6F8DB8DD6/","https://steamusercontent-a.akamaihd.net/ugc/778498799973017006/3A6AFC4B6E340798D0A5872C4F04C4B9160B6A55/",},
        [25] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970618/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/778498799973098336/B8B76E1A90312F44120EAAB553377D1A4F4CEF6E/",},
        [26] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970429/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/778498799973099241/ECB85655DCF5913FC218CEE9BD6C354596D84484/",},
        [27] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966826/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/778498799973099989/EDC907E46E2D39A9BF3B1544A2719A616BA71F84/",},
        [28] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966625/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/778498799973101033/1D04F4A899C9D9A60A863CF5D7AF2A654F7A0AEF/",},
    }

    HOTE_Tiles = {
        [1] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966594107/7E8775737FDB82CCF196DC4EBC971D101CA4C184/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243224042/4E2D8FB3C9614D4A24F0FE5973EFAF0C8221BCCD/",},
        [2] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966596201/C743C155BFE43E9BC09C91B35D055DB8105C7716/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243213109/E121C1C34EAAA4DE4506EB78C47B13B633BBDD1F/",},
        [3] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966600555/EFAEC362EA6BF039E11BD9771933B0F5CD06DC27/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243204451/EBD858731A1DD6BEF4F46C8C1DA592B55FD4DF41/",},
        [4] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966602975/A9BC5C83212E825FB75A09BEE6DD8C85B8E71A0D/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243192142/A3362C1C81CD2835063EE1ED44B622566188CD24/",},
        [5] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966606247/7269AA22895FC1CE6AFD57D6FE019789B78A9400/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243184503/3D6A54E7A762489CE2FE8FF5C4B06C4299D89074/",},
        [6] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966607991/7AFFEA2A7727FE195D53E3FE65048015ED522DB0/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243176490/481C60290E37A6640217EEE2725AFAEA7A1ACA6C/",},
        [7] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966610135/3D060B650F48B975FC0CD1A50B868E292C5CD2FF/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243166755/7595993AAC48A9B91FFE696A40F0FD78B1E7B5D2/",},
        [8] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966614205/7924CF43D8B6780DC5F5D90A661E8208889C9C6A/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243160287/ABBD05FC07E895978DFED81370FEEB0002BF6FF3/",},
        [9] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966616049/56CE2489A2A6A8223468BB9B95D619D79F58D7EC/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243152918/33AB6E73CD92DE692D77C7531068AA687A392CFE/",},
        [10] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966617767/91838D65DE234AE109F7E5EE61DF8C26959B5933/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243147543/658A9D4BC59FCF4689B5597770BD7F8345B1DBDE/",},
        [11] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966620104/87E9EFEF5F504A540D11740957E0A1FA39ED1302/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243141491/E9B20FAEA34C6E44949D55C5A44D844F4292A162/",},
        [12] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966627918/BFAB343C160AB0C6DCC2D8C878DB3243F2BCD71D/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243136638/C8CCBAC76B2C07D4DD7DB7144F5B6A8FFA3F99CA/",},
        [13] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966629223/5EB558983E6F7962817A556820202ACB25076144/","https://steamusercontent-a.akamaihd.net/ugc/778499716966629478/9EFB714D082B05D9E936E830EE3DD16B9E410A96/",},
        [14] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966633593/D564C090F3D7E74E9758394424FB8CC3EE90C62E/","https://steamusercontent-a.akamaihd.net/ugc/778499716966633862/2FE900ACB50B60BBFDB7C5BD167902B3F5BAD33B/",},
        [15] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966636628/D564C090F3D7E74E9758394424FB8CC3EE90C62E/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243129911/BE6165369FD40CD646B4D00564947B7264C05E5B/",},
        [16] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966638786/1370F81C18A90730DB105015DF5FF2C2C10A71BF/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243122575/E1CFA21C313D6FC601DC186B7A53462AD8DA5F22/",},
        [17] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966640373/2F0AE48D3438808CFE2D80E0E6311CE8DC756379/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243119453/3FC4E92DBB6963AC4C1B45AF85121416A9EF8C2C/",},
        [18] = {"https://steamusercontent-a.akamaihd.net/ugc/778499716966642433/C4F59FD4B9F3E096F53CD81D10A0871AA4D2B47E/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243116770/E44E0FCF32E939A2762963F49E45B11487748B13/",},
    }

    Twin_Tiles = {
        [1] = {"https://steamusercontent-a.akamaihd.net/ugc/777371458981373639/D501C4FEB5D57C76E387AE435C4FCCAEAB895A2D/","https://steamusercontent-a.akamaihd.net/ugc/1005933590986294873/06AC891F13AE10CBA0DDE81FC192B7BCB033A03D/",},
        [2] = {"https://steamusercontent-a.akamaihd.net/ugc/777371458981497656/3DF1EE10E5F6F80DE487DD54A0E2858708CB4B09/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242753654/FAB40D2DFE3EF757349F36EE98116B75724A4B2D/",},
        [3] = {"https://steamusercontent-a.akamaihd.net/ugc/777371458981592473/331FDE687BAB2D14D69B1F3B65790A8C290FDF25/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242744731/F87167D2BA67CF1DD6993026D2638CF2B904113A/",},
        [4] = {"https://steamusercontent-a.akamaihd.net/ugc/777371458981738958/DCE6471CDDF8BB911D903B49C81918597373D7C7/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242738291/6E8E2E0156D7FBC76DF0F815CBDBC230D556EEF1/",},
        [5] = {"https://steamusercontent-a.akamaihd.net/ugc/777371458981884545/5FB364EEAAE5937612A5027B58570EC17F7F1387/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242726902/DBA5D39580A7DF24093C7F55094BBF2881E41669/",},
        [6] = {"https://steamusercontent-a.akamaihd.net/ugc/777371458981944946/27BBDDCD1BAF7CC4385B3A851C75FA517E09246F/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242708084/F5C465BA1DD9464667AA4851E99629FF584EFE9A/",},
        [7] = {"https://steamusercontent-a.akamaihd.net/ugc/777371458985547216/68F2D902A3DBC8210D380F25159E24E9112D6B65/","https://steamusercontent-a.akamaihd.net/ugc/1004808486242717429/8546ACA6860B81FEC2454E903C4982BC8A8026A8/",},
        [8] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970618/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/777371458985805422/DC72A1A84CAAA78BAB3B7DD43C2EAECB632E69E3/",},
        [9] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970429/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/777371458985819912/174E75CA998CDD9760A29295CBAB1F2D1EBD239F/",},
        [10] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966826/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/777371273276812279/A1CF04E8CDC1B30DC1B2772BB1937F97B8BB46CC/",},
        [11] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966625/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/777371458985914566/0E0AC1300FF57376E1C36B4967A35A6D92E4B9AC/",},
        [12] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970795/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/777371458985839032/B327C2874508500854065D4EB86AB01181E27109/",},
    }

    Bespin_Tiles = {
        [1] = {"https://steamusercontent-a.akamaihd.net/ugc/778499078304696116/C90839E3EFD69FF17E40CE89A5C338A216FDE6C6/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243074776/B54AC2B0F9FBDA9E061B8A866BED82A3D07927D1/",},
        [2] = {"https://steamusercontent-a.akamaihd.net/ugc/778499078304701244/8E88AD4581B80F8A64263763373A0A3B042339FF/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243058883/9D91B537F75A16EEEA08654D3EECD09DDDBA6F8E/",},
        [3] = {"https://steamusercontent-a.akamaihd.net/ugc/778499078304707220/A31F503F43151D96A63D7E2E7C63A417A0B12048/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243048338/2555174419DEF86E3FBAAFA31B03F2AF360324BD/",},
        [4] = {"https://steamusercontent-a.akamaihd.net/ugc/778499078304708316/375FD0694133369539A0369D27BEA6852174169B/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243030578/65D702DC258A94F06F49F21F7422B72B41549DE7/",},
        [5] = {"https://steamusercontent-a.akamaihd.net/ugc/778499078304711663/C507AFBA2DED8C6F0AE5B84050E7180E9EEFF401/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243018990/356F1825F6D771736D33D97CB7CA6ACEC62E51F8/",},
        [6] = {"https://steamusercontent-a.akamaihd.net/ugc/778499078304713794/510705DDE193952FC4371984D90457638E5670CD/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243064722/5F8D5868262362A5CB7160192A61417F1440EF23/",},
        [7] = {"https://steamusercontent-a.akamaihd.net/ugc/778499078304715822/46DC1361DDDB1F82B2C8FF3E54E559223A6E4FE9/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243038700/777D313EEC592776D0EAF55A27289B26041AD8CF/",},
        [8] = {"https://steamusercontent-a.akamaihd.net/ugc/778499078304719031/8F5785531E713FD3340878B71CB933498417A954/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243006869/AFE61E35BFF9DE8DE13736E84447FD82B26B4C0E/",},
        [9] = {"https://steamusercontent-a.akamaihd.net/ugc/778499078304729085/5345502F02B21E01B1E27DA4C6EB4F9C1745FB61/","https://steamusercontent-a.akamaihd.net/ugc/1004808486243001739/D19ECB4BA6ED3CBC0E4EEA577E12BDA358C7D7C8/",},
        [10] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966625/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/778499078304690060/CF58444F76F8496174C94CF523AA4A9E32DE4609/",},
        [11] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966389/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/778499078304666366/28E9926AE85B5BA911B821E9884AA43A1C7E3709/",},
        [12] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970795/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/778499078304667823/A46493B03A7A646CF61EDDF77EBF5FE157F9EE04/",},
    }

    Lothal_Tiles = {
        [1] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972883763/A644C9F77E6D537DD626964821053B46651DD89D/","https://steamusercontent-a.akamaihd.net/ugc/1001431356119648641/CA8AF1622A244EF8B43D30D17FC86FFDDCC04D50/",},
        [2] = {"https://steamusercontent-a.akamaihd.net/ugc/1001431356119985904/6727732925E5FDB34F8492039852EC7A445FDFB9/","https://steamusercontent-a.akamaihd.net/ugc/1001431356120044817/1D3621E1CA3FB73E6A7FA2DA0F516B3E719A7778/",},
        [3] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241973409/76452EE23D4F2688BABCBE3E18F9E8C840394E1A/","https://steamusercontent-a.akamaihd.net/ugc/1001431356119698228/584281C5FF62C0C27CAFD689E34814C4BEBD4D3D/",},
        [4] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241972874/1AD33FA8D2842D9B6C9A58B2C8B1D9DB20E7BAD6/","https://steamusercontent-a.akamaihd.net/ugc/1001431356119726004/B3B4DA8A9909C7F281C72768DD7C2C177FADC458/",},
        [5] = {"https://steamusercontent-a.akamaihd.net/ugc/778498799972928006/56FE7B3568822E1619685D2FAE3E03B4C73E78BC/","https://steamusercontent-a.akamaihd.net/ugc/1001431356119779553/8098CF3E7EA87279255E6041A991301101BC1084/",},
        [6] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241971439/6DC626F7976E7C406F626F90FF13CF66F7CDDB42/","https://steamusercontent-a.akamaihd.net/ugc/1001431356119841235/1C9AF0D2B2E6509B7E231466F297D277E3CF6C45/",},
        [7] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241971439/6DC626F7976E7C406F626F90FF13CF66F7CDDB42/","https://steamusercontent-a.akamaihd.net/ugc/1001431356119841665/A11B50B6D656FAF257A56A6C65B1BE0D77458CFC/",},
        [8] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241967181/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/1001431356119880032/0C923B6E17C4016A2F0FF68458E48DCEA0D9A795/",},
        [9] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241967181/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/1001431356119901776/9687FCCF5B3178976AEED0E2476E2D7F5E35D374/",},
        [10] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241970986/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314726110/5EAA26C141FF70CAD3E84C4CF57ECADE5DD2219B/",},
        [11] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241967361/4AC0689764F6376030206A6A6565E01FE56A3135/","https://steamusercontent-a.akamaihd.net/ugc/957472492314730187/75E37BC6554231412108E0B77BC715DAB9203C6C/",},
        [12] = {"https://steamusercontent-a.akamaihd.net/ugc/923667919241966625/C7B03FFA57F50701C1061EA9F9170F887E20E39D/","https://steamusercontent-a.akamaihd.net/ugc/1001431356119925234/4DAEAF4BA13DC7776B1BAE7D59E3083A4E709A48/",},
    }

    printToAll('Hope you enjoy Imperial Assault 3D by drod', {1,1,0})
    guid_to_save = {}
    if save_state ~= nil and save_state ~= "" then
        loaded_data = JSON.decode(save_state)
        for i, item in ipairs(loaded_data) do
            if item[12] == "a00dce" then
              item[12] = "e4020d"
            end
            if item[12] == "ad3ccd" then
              item[12] = "c768e8"
            end
            if item[12] == "1a8667" then
              item[12] = "47ec73"
            end
            if getObjectFromGUID(item[12]) != nil then --card removed
              --if(item[1] == 'Hero') then
                getObjectFromGUID(item[12]).setTable('Details', item)
                for t, token in ipairs(item[13]) do
                  prefix = item[13][t][3]
                  if string.sub(prefix,1,1) == "G" or tonumber(string.sub(prefix,2,2)) > 4 then
                    self.UI.setAttributes(string.sub(prefix,1,2).."_cobject", {text = item[13][t][2]})
                    self.UI.setAttributes(string.sub(prefix,1,2).."_units", {text = item[6]})
                    self.UI.setAttributes(string.sub(prefix,1,2).."_selector", {text = "1"})
                    self.UI.setAttributes(prefix.."_tobject", {text = item[13][t][1]})
                  else
                    self.UI.setAttributes(string.sub(prefix,1,2).."_cobject", {text = item[13][1][2]})
                    self.UI.setAttributes(string.sub(prefix,1,2).."_tobject", {text = item[13][1][1]})
                    if getObjectFromGUID(item[13][1][2]).getRotation().z > 170 then
                      self.UI.setAttributes(self.UI.setAttributes(string.sub(prefix,1,2).."_W", {active="true"}))
                    end
                  end
                end

                Name = getObjectFromGUID(item[12]).getName()
                color = item[13][1][4]
                prepUIbars(Name,item[4],0,rev_whatcolor(color),prefix,item[6])
                table.insert(guid_to_save, item[12])
              --end

              --for t, token in ipairs(item[13]) do
                --  if getObjectFromGUID(token[1]) != nil then
                      --getObjectFromGUID(token[2]).setVar('Token', token[1])
                    --  getObjectFromGUID(token[1]).setVar('BB', token[2])
                      --getObjectFromGUID(token[1]).setVar('RB', token[3])
                      --getObjectFromGUID(token[1]).setVar('Speed', item[5])
                      --getObjectFromGUID(token[1]).setVar('Card', item[12])
                  --end
              --end

                Spawn(getObjectFromGUID(item[12]), rev_whatcolor(color), true)
            else
                --print('Not Found remove from table?')
            end
        end

    else
        --print("No table found.")
    end

    if options.hideText then
      self.UI.setAttribute("hideText", "value", "true")
      self.UI.setAttribute("hideText", "text", "✘")
      self.UI.setAttribute("hideText", "textColor", "#FFFFFF")
      Wait.frames(function() loadToggle("hideText") end, 1)
    end
    if options.editText then
      self.UI.setAttribute("editText", "value", "true")
      self.UI.setAttribute("editText", "text", "✘")
      self.UI.setAttribute("editText", "textColor", "#FFFFFF")
      Wait.frames(function() loadToggle("editText") end, 1)
    end
    if options.hideBar then
      self.UI.setAttribute("hideBar", "value", "true")
      self.UI.setAttribute("hideBar", "text", "✘")
      self.UI.setAttribute("hideBar", "textColor", "#FFFFFF")
      Wait.frames(function() loadToggle("hideBar") end, 1)
    end

    self.UI.setAttribute("hp", "text", options.hp)
    self.UI.setAttribute("Strain", "text", options.Strain)

    if not options.showAll then
      self.UI.setAttribute("showAll", "value", "false")
      Wait.frames(allOff, 1)
    end
end

function loadToggle(id)
  local toChange = ""
  if id == "hideText" then
    toChange = "editButton"
  elseif id == "editText" then
    toChange = "addSub"
  elseif id == "hideBar" then
    toChange = "progressBar"
  end
  for i,j in pairs(getAllObjects()) do
    if j ~= self then
      if j.getLuaScript():find("StartXML") then
        if not j.getVar("player") then
          j.UI.setAttribute(toChange, "visibility", "Black")
          if id == "hideText" then
            j.UI.setAttribute("StrainText", "visibility", "Black")
          elseif id == "hideBar" then
            j.UI.setAttribute("progressBarS", "visibility", "Black")
          elseif id == "editText" then
            j.UI.setAttribute("addSubS", "visibility", "Black")
            j.UI.setAttribute("editPanel", "visibility", "Black")
            j.UI.setAttribute("editPanel", "active", "false")
          end
        end
      end
    end
  end
end

function allOff()
  for i,j in pairs(getAllObjects()) do
    if j ~= self then
      if j.getLuaScript():find("StartXML") then
        j.UI.setAttribute("panel", "active", "false")
      end
    end
  end
end

function update ()
    --Will Delete if not needed
end


function onSave()
    if guid_to_save then
        data_to_save = {}
        for i, item in ipairs(guid_to_save) do
            if getObjectFromGUID(item) != nil then
                local data = getObjectFromGUID(item).getTable('Details')
                data[12] = item
                for j=1,16 do
                  if self.UI.getAttribute("G"..j.."_cobject", "text") == item then
                    if self.UI.getAttribute("G"..j.."_table", "active") == "false" then
                    else
                      table.insert(data_to_save, data)
                    end
                  end
                end
                for k=1,9 do
                  if self.UI.getAttribute("P"..k.."_cobject", "text") == item then
                    if self.UI.getAttribute("P"..k.."_table", "active") == "false" then
                    else
                      table.insert(data_to_save, data)
                    end
                  end
                end
            end
        end
        local save_state = JSON.encode(data_to_save)
        self.script_state = save_state
        return save_state
    else
      printToAll("nothing to save?", "Red")
    end
end

function toggleCheckBox(player, value, id)
  if self.UI.getAttribute(id, "value") == "false" then
    self.UI.setAttribute(id, "value", "true")
    self.UI.setAttribute(id, "text", "✘")
    options[id] = true
  else
    self.UI.setAttribute(id, "value", "false")
    self.UI.setAttribute(id, "text", "")
    options[id] = false
  end
  self.UI.setAttribute(id, "textColor", "#FFFFFF")
  local toChange = ""
  if id == "hideText" then
    toChange = "editButton"
  elseif id == "editText" then
    toChange = "addSub"
  elseif id == "hideBar" then
    toChange = "progressBar"
  end
  for i,j in pairs(getAllObjects()) do
    if j ~= self then
      if j.getLuaScript():find("StartXML") then
        if not j.getVar("player") then
          j.UI.setAttribute(toChange, "visibility", options[id] == true and "Black" or "")
          if id == "hideText" then
            j.UI.setAttribute("StrainText", "visibility", options[id] == true and "Black" or "")
          elseif id == "hideBar" then
            j.UI.setAttribute("progressBarS", "visibility", options[id] == true and "Black" or "")
          elseif id == "editText" then
            j.UI.setAttribute("addSubS", "visibility", options[id] == true and "Black" or "")
            j.UI.setAttribute("editPanel", "visibility", options[id] == true and "Black" or "")
            j.UI.setAttribute("editPanel", "active", "false")
          end
        end
      end
    end
  end
end

function toggleOnOff(player, value, id)
  if self.UI.getAttribute(id, "value") == "false" then
    self.UI.setAttribute(id, "value", "true")
    options[id] = true
  else
    self.UI.setAttribute(id, "value", "false")
    options[id] = false
  end
  for i,j in pairs(getAllObjects()) do
    if j ~= self then
      if j.getLuaScript():find("StartXML") then
        j.UI.setAttribute("panel", "active", options[id] == true and "true" or "false")
      end
    end
  end
end

function onEndEdit(player, value, id)
  options[id] = tonumber(value)
  self.UI.setAttribute(id, "text", value)
end

function Start(data)
    ---Called from the Menu with the data selected
    for i, Sets in ipairs(data) do
        if Sets[2] == true then
            for t, Contents in ipairs(Sets[3].getObjects()) do
                local params = {}
                params.position = {-35 + t*3,-10, -20 + i*5}
                params.callback = 'Sort'
                params.guid = Contents.guid
                params.params = {Sets[1]}
                params.callback_owner = Global
                Sets[3].takeObject(params)
            end
        end
        Sets[3].destruct()
    end

end


function Sort(object, params)
    --Called from The Start function to position the cards
    local DoFlip = true
    object.setLock(true)
    object.interactable = false
    object.setRotation({0,180,0})
    object.setScale({1.6,1,1.6})
    object.setPositionSmooth(Bag_Items[object.getDescription()],false,true)
    if object.getDescription() == 'Agenda Cards' then
        table.insert(Highlight[4], object)
        Menu.setTable('4', Highlight[4])
        Bag_Items[object.getDescription()][1] = Bag_Items[object.getDescription()][1] + 5
        if Bag_Items[object.getDescription()][1] >= 35 then
            Bag_Items[object.getDescription()][1] = -35
            Bag_Items[object.getDescription()][3] = Bag_Items[object.getDescription()][3] - 8
        end
        object.setDescription(params[1])
        object.setScale({2,2,2})
        DoFlip = false
    end

    if object.getDescription() == 'Imperial Class Cards' then
        table.insert(Highlight[3], object)
        Menu.setTable('3', Highlight[3])
        Bag_Items[object.getDescription()][1] = Bag_Items[object.getDescription()][1] + 5
        object.setDescription(params[1])
        DoFlip = false
    end
    if object.getDescription() == 'Hero Cards' then
        table.insert(Highlight[2], object)
        Menu.setTable('2', Highlight[2])
        object.setScale({4,4,4})
        Bag_Items[object.getDescription()][1] = Bag_Items[object.getDescription()][1] + 12.5
        if Bag_Items[object.getDescription()][1] >= 45 then
            Bag_Items[object.getDescription()][1] = -45
            Bag_Items[object.getDescription()][3] = Bag_Items[object.getDescription()][3] - 8.5
        end
        object.setDescription(params[1])
     object.setRotation({180,180,180})
   DoFlip = false
    end
    if object.getDescription() == 'Story Cards' then
        Bag_Items[object.getDescription()][1] = Bag_Items[object.getDescription()][1] - 5
        table.insert(Highlight[5], object)
        Menu.setTable('5', Highlight[5])
        DoFlip = false
        object.setScale({2,2,2})
    end
    if object.getDescription() == 'Red Side Missions' or object.getDescription() == 'Green Side Missions' then
        DoFlip = false
        object.setScale({2,2,2})
    end
    if object.getDescription() == 'Grey Side Missions' then
        DoFlip = true
        object.setScale({2,2,2})
    end

    if DoFlip == true then
       if object.getDescription() == 'Grey Side Missions' then
         object.setRotation({0,180,180})
         object.setScale({2,2,2})
       else
         object.setRotation({180,180,0})
         object.setScale({2,2,2})
       end
    end

   if object.getDescription() == 'Mercenary Deployment Cards' or object.getDescription() == 'Imperial Deployment Cards' then
        object.setRotation({180,0,0})
        object.setScale({2,2,2})
   end
   if object.getDescription() == 'Rebel Deployment Cards' or object.getDescription() == 'Companion Deployment Cards' then
         object.setScale({2,2,2})
   end
   if object.getDescription() == 'Supply Cards' or object.getDescription() == 'Rewards' or string.match(object.getDescription(), "Tier") then
         object.setScale({1.6,1,1.6})
   end
   object.setLock(false)
   object.interactable = true
end

function onObjectLeaveContainer(Container, object)
    --Create a Button on the card for leaving a container
    if Cards[object.getName()] != nil and object.getDescription() != '' and object.getDescription() != 'Class Deck' then
        object.createButton({label = object.getName(), click_function = 'Spawn', rotation = {0, 0, 0},
        position = {0, 0.2, 0}, width = (40 * string.len(object.getName())), color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, height = 100, font_size = 75,  function_owner = self})
        local data = Cards[object.getName()]
        data[12] = object.getGUID()
        data[13] = {}
        object.setTable('Details', data)
    end

    if Maps[object.getName()] != nil and (object.getDescription() == 'Story Card' or string.find(object.getDescription(),"Side")) then
        object.createButton({label = object.getName(), click_function = 'LoadMap', rotation = {0, 0, 0},
        position = {0, 0.2, 0}, width = (40 * string.len(object.getName())), height = 100, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
    end
end

function clearmap()
    local Data = getAllObjects()
    for t, item in ipairs(Data) do
        if item.getDescription() == 'Current Map' then
            item.destruct()
        end
        if item.getDescription() == 'GM Only Objects' then
            bag = getObjectFromGUID('0cd670')
            bag.putObject(item)
        end
        if item.getDescription() == 'Raid 1' then
            bag = getObjectFromGUID('41c39e')
            bag.putObject(item)
        end
    end
    resetmission()
end

function LoadMap(object, playerColor, Reloaded, Flip, Rotation)
    local mapdata = Maps[object.getName()]

    if mapdata[1] == "C3D" or mapdata[1] == "H3D" or mapdata[1] == "AV3D" or mapdata[1] == "L3D" or mapdata[1] == "TS3D" or mapdata[1] == "BG3D" or mapdata[1] == "JR3D" or mapdata[1] == "HE3D" or mapdata[1] == "IACP3D" or mapdata[1] == "R1" then
      if mapdata[1] == "C3D" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        getFromBag('60e8b6', object.getName(), params)
      end
      if mapdata[1] == "H3D" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        getFromBag('a7d880', object.getName(), params)
        getObjectFromGUID('7a310a').AssetBundle.playLoopingEffect(1)
      end
      if mapdata[1] == "AV3D" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        getFromBag('1ffb5d', object.getName(), params)
      end
      if mapdata[1] == "TS3D" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        getFromBag('e5458b', object.getName(), params)
      end
      if mapdata[1] == "BG3D" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        getFromBag('928c1c', object.getName(), params)
      end
      if mapdata[1] == "JR3D" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        getFromBag('6da267', object.getName(), params)
      end
      if mapdata[1] == "HE3D" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        getFromBag('0cd670', object.getName(), params)
      end
      if mapdata[1] == "L3D" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        getFromBag('22789e', object.getName(), params)
      end
      if mapdata[1] == "IACP3D" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        getFromBag('4c337c', object.getName(), params)
      end
      if mapdata[1] == "R1" then
        local params = {}
        params.position = mapdata[2]
        params.rotation = mapdata[3]
        params.scale = mapdata[4]
        params.smooth = false
        getFromBag('41c39e', object.getName(), params)
      end
      update_surface(mapdata[5])
    else
      --load map
      local Map_Parameters = {}
      Map_Parameters.position = mapdata[2]
      Map_Parameters.type = 'Custom_Tile'
      Map_Parameters.rotation = mapdata[3]
      Map_Parameters.image = mapdata[1]
      Map_Parameters.scale = mapdata[4]
      Map_Parameters.thickness = 0.1

      local playmap = spawnObject(Map_Parameters)
      playmap.setCustomObject(Map_Parameters)
      playmap.setName(object.getName())
      playmap.setDescription('Current Map')
      playmap.setLock(true)

      --Load Doors
      if(mapdata[5] != '') then
          LoadDoors(mapdata[5],mapdata[6])
      end
    end

    if object.getName() == 'Disruption' then
      local params = {}
      params.type = "FogOfWar"
      params.position = {15.20, 3.51, -9.17}
      params.scale = {51.20, 5.1, 47.94}
      local Spawned_Fog = spawnObject(params)
      local zoneinfo = {}
      zoneinfo.ignore_fog_of_war = false
      Spawned_Fog.setCustomObject(zoneinfo)
      Spawned_Fog.setDescription("Current Map")
    end
    if object.getName() == 'Capital Escape' then
      local params = {}
      params.type = "FogOfWar"
      params.position = {-28.82, 3.51, -1.06}
      params.scale = {32.85, 5.10, 58.42}
      local Spawned_Fog = spawnObject(params)
      local zoneinfo = {}
      zoneinfo.ignore_fog_of_war = false
      Spawned_Fog.setCustomObject(zoneinfo)
      Spawned_Fog.setDescription("Current Map")
    end
    if object.getName() == 'Into a Corner' then
      broadcastToColor("Other pieces are in the GM only Bag in the hidden area", "Black", "Red")
    end
    if object.getName() == 'From Dark Clutches' then
      local params = {}
      params.type = "FogOfWar"
      params.position = {-12.01, 3.51, -16.92}
      params.rotation = {0.00, 179.93, 0.00}
      params.scale = {60.64, 5.10, 34.34}
      local Spawned_Fog = spawnObject(params)
      local zoneinfo = {}
      zoneinfo.ignore_fog_of_war = false
      Spawned_Fog.setCustomObject(zoneinfo)
      Spawned_Fog.setDescription("Current Map")

      local params = {}
      params.type = "FogOfWar"
      params.position = {-35.72, 3.51, 7.82}
      params.rotation = {0.00, 179.93, 0.00}
      params.scale = {11.40, 5.10, 11.72}
      local Spawned_Fog = spawnObject(params)
      local zoneinfo = {}
      zoneinfo.ignore_fog_of_war = false
      Spawned_Fog.setCustomObject(zoneinfo)
      Spawned_Fog.setDescription("Current Map")

      local params = {}
      params.type = "FogOfWar"
      params.position = {-33.91, 3.51, 1.35}
      params.rotation = {0.00, 179.93, 0.00}
      params.scale = {17.18, 5.10, 6.47}
      local Spawned_Fog = spawnObject(params)
      local zoneinfo = {}
      zoneinfo.ignore_fog_of_war = false
      Spawned_Fog.setCustomObject(zoneinfo)
      Spawned_Fog.setDescription("Current Map")

      local params = {}
      params.type = "FogOfWar"
      params.position ={-17.93, 3.51, 1.64}
      params.rotation = {0.00, 179.93, 0.00}
      params.scale = {9.33, 5.10, 6.22}
      local Spawned_Fog = spawnObject(params)
      local zoneinfo = {}
      zoneinfo.ignore_fog_of_war = false
      Spawned_Fog.setCustomObject(zoneinfo)
      Spawned_Fog.setDescription("Current Map")

      local params = {}
      params.type = "FogOfWar"
      params.position = {8.85, 3.51, 1.70}
      params.rotation = {0.00, 179.93, 0.00}
      params.scale = {5.75, 5.10, 5.69}
      local Spawned_Fog = spawnObject(params)
      local zoneinfo = {}
      zoneinfo.ignore_fog_of_war = false
      Spawned_Fog.setCustomObject(zoneinfo)
      Spawned_Fog.setDescription("Current Map")

      local params = {}
      params.type = "FogOfWar"
      params.position = {26.70, 3.51, 4.01}
      params.rotation = {0.00, 179.93, 0.00}
      params.scale = {31.76, 5.10, 42.09}
      local Spawned_Fog = spawnObject(params)
      local zoneinfo = {}
      zoneinfo.ignore_fog_of_war = false
      Spawned_Fog.setCustomObject(zoneinfo)
      Spawned_Fog.setDescription("Current Map")
    end

    --printToAll('Loaded Doors','Blue')
    --Load Crates
    if(mapdata[7] != '') then
        LoadCustomModel(mapdata[7], {1.35, 1.35, 1.35}, {0.0,90.0,0.0}, 'https://steamusercontent-a.akamaihd.net/ugc/755969254323594962/2F5F226A94AF22DA95182A1BA45337B4A2B35DFF/','https://steamusercontent-a.akamaihd.net/ugc/755969254323598194/6B41EBE3382420EF6C8B99FDC5DC5326C4B11760/', '')
    end
    --printToAll('Loaded Crates','Blue')
    --Load Mission Tokens (get different Colors working)
    if(mapdata[9] != '') then
        LoadCustomToken(mapdata[9], mapdata[10], {0.00, 180.00, 0.00}, 'https://steamusercontent-a.akamaihd.net/ugc/973235725989016827/E2388ED983D8CFBCC886B201735EB1962FF4CCAA/', '')
    end
    --printToAll('Loaded MTs','Blue')
    --Load Faction Tokens (Get different Colors working somehow)
    if(mapdata[11] != '') then
        LoadCustomTile(mapdata[11],{1.23,1.0,1.23}, {0.00, 180.00, 0.00}, mapdata[12])
    end
    --printToAll('Loaded FTs','Blue')
    --Load Terminals
    if(mapdata[13] != '') then
        LoadCustomModel(mapdata[13], {1.40,1.40,1.40}, {0.0,90.0,0.0}, 'https://steamusercontent-a.akamaihd.net/ugc/755969254323601143/D162744FED76CB6D03211C71AA135A2D64D54783/','https://steamusercontent-a.akamaihd.net/ugc/755969254323602786/9765349124829F7F25BD0E0EA22B8DB64460E292/' , mapdata[14])
    end
    --printToAll('Loaded Terminals','Blue')
    --Load Entrance Tile
    if(mapdata[15] != '') then
        LoadCustomToken(mapdata[15], {0.63,1.00,0.63}, {0.0,0.0,0.0}, 'https://steamusercontent-a.akamaihd.net/ugc/859478214460663783/9E8261252170DF7CAD8B4D7471A8F114BFF8777D/', mapdata[16] )
    end
    --printToAll('Loaded Entrance','Blue')
    printToAll('Mission: ' .. object.getName() .. ' loaded', "Green")
    --MusicPlayer.play()
end
function updateColor(params)
  prefix = string.sub(params.pf,1,string.find(params.pf, "U")-1)
  --for i=1,tonumber(UI.getAttribute(prefix.."_units", "text")) do
    if params.pf ~= prefix.."U"..self.UI.getAttribute(prefix.."_selector", "text") then
      self.UI.setAttribute(params.pf.."_hp_bar", "fillImageColor", whatcolor(params.c))
      --getObjectFromGUID(UI.getAttribute(prefix.."U"..i.."_tobject", "text")).call('setBaseColor', params.c)
    else
      if self.UI.getAttribute(prefix.."_units", "text") == '1' then
        self.UI.setAttribute(params.pf.."_hp_bar", "fillImageColor", whatcolor(params.c))
      end
    end
  --end
end
function update_surface(surface)
  local obj_surface = getObjectFromGUID('4ee1f2')
  local customInfo = obj_surface.getCustomObject()
  if surface == 'Forest' then
    customInfo.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1043093746445966902/2C5731E40F4EBF5E2D0C853818CFB93CE75941F9/'
  end
  if surface == 'Hoth' then
    customInfo.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1043093746445996709/03CA12FF258E8E7AB6F5037F060142CA6F4B67B9/'
  end
  if surface == 'Imperial' then
    customInfo.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1043093746445966009/17627D39B4ECA43259F47177B2665EF213931D3B/'
  end
  if surface == 'Desert' then
    customInfo.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1043093746445948591/F7259858BFF48864B6FE4FE1D8448B9442CE3AC1/'
  end
  if surface == 'Clouds' then
    customInfo.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1771580626401391077/32B20D428E05AE207142059C16E9D253C726489C/'
  end
  if surface == 'Map' then
    customInfo.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1747940339016078704/8FD0278D01B26A8608CBEEFC1EFD5A8D7D657C99/'
  end
  obj_surface.setCustomObject(customInfo)
  obj_surface = obj_surface.reload()
end
function resetmission()
  for i=5,9 do
    self.UI.setAttributes("P"..i.."_Table",{active = "false"})
    for j=1,3 do
      self.UI.setAttributes("P"..i.."U"..j.."_hp_bar",{active = "false"})
      if j == 1 then
        self.UI.setAttributes("P"..i.."_Status",{active = "false"})
      end
    end
  end
  for i=1,16 do
    self.UI.setAttributes("G"..i.."_Table",{active = "false"})
    for j=1,3 do
      self.UI.setAttributes("G"..i.."U"..j.."_hp_bar",{active = "false"})
      if j == 1 then
        self.UI.setAttributes("G"..i.."_Status",{active = "false"})
      end
    end
  end
  Round = 1
  Threat = 0
  setRound(Round)
  updateThreat()
  playsound(107)
  getObjectFromGUID('7a310a').AssetBundle.playLoopingEffect(0)
  local oData = getAllObjects()
  local token = ''
  local pos
  local item_pos = {
    ["Imperial Deployment Cards"] = {-71.24, 0.54, -19.42},
    ["Companion Deployment Cards"] = {-61.76, 0.36, -19.42},
    ["Mercenary Deployment Cards"] = {-66.51, 0.51, -19.42},
    ["Rebel Deployment Cards"] = {-70.09, 0.49, 30.40},
    ["Supply Cards"] = {-70.14, 0.49, 22.93},
  }
  for t, item in ipairs(oData) do
      if item.getDescription() == 'Token' then
        --item.call("reset")
        local cardobject = getObjectFromGUID(self.UI.getAttribute(string.sub(item.call("getPrefix"),1,2).."_cobject", "text"))
        if self.UI.getAttribute(string.sub(item.call("getPrefix"),1,2).."_W", "active") == "true" then
          Hero_Flip(cardobject)
          self.UI.setAttributes(string.sub(item.call("getPrefix"),1,2).."_W", {active="false"})
          self.UI.setAttributes(string.sub(item.call("getPrefix"),1,2).."_name", {color="#FFFFFF"})
          item.call("likenew")
        else
          item.call("likenew")
        end
        item.call("clearstats")
        pos = {
          x = cardobject.getPosition().x,
          y = cardobject.getPosition().y + 0.5,
          z = cardobject.getPosition().z
          }
        item.setPosition(pos)
      end
      if(item_pos[item.getDescription()] ~= nil) then
        if item.is_face_down then
        else
          item.flip()
        end
        item.setPosition(item_pos[item.getDescription()])
      end
  end
  update_surface('Map')
end

function CreateOneshotTimer(fcnName, delay)
    Timer.create({
        identifier = tostring('hlboiuyoiuyoiyu'), -- unique name
        function_name = fcnName,    -- what it triggers
        function_owner = self,
        delay = delay,              -- delay in seconds
        repetitions = 1,            -- oneshot
    })
end

function getFromBag(bag_guid, iname, params)
    local bag = getObjectFromGUID(bag_guid)
    local bagitems = bag.getObjects()

--search it in a loop, compares name to string pattern, adds to a table if it finds
    if bagitems != nil then
        for k, v in pairs(bagitems) do
            if v.name == iname then
                params.guid = v.guid
                params.smooth = false
                --params.callback_function = function(v) ExtraSetup(v) end
                c = bag.takeObject(params)
                params.position = {120,50,0}
                c1 = c.clone(params)
                Wait.frames(function() bag.putObject(c1) end, 60)
            end
        end
    end
    return o
end

function ExtraSetup(v)
  if v.getName() != "Storming the Palace - Rancor Pit" then
    v.removeAttachments()
  end
end

function LoadDoors(Doordata,DoorHealth)
    for i, door in ipairs(Doordata) do
        local Door_Parameters = {}
        Door_Parameters.type = 'Custom_Model'
        Door_Parameters.rotation = door[2]
        Door_Parameters.position = door[1]
        Door_Parameters.scale = door[3]

        local Door_Info = {}
        Door_Info.type = 1
        Door_Info.mesh = 'https://steamusercontent-a.akamaihd.net/ugc/937210191360146808/D851936C31D7D04D698A332449B5AB557E46B4C4/'
        Door_Info.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/973235725993311872/CC7EE73E627D23F74EFE7BF63CBEA5A7E80BD075/'
        Door_Info.material = 3
        local Spawned_Door = spawnObject(Door_Parameters)
        Spawned_Door.setCustomObject(Door_Info)
        Spawned_Door.setDescription('Current Map')
        Spawned_Door.setLock(true)
        Spawned_Door.setName('Door '.. i) --if the add bar requires unique door names
        if DoorHealth != '' then
          AddBarObject(Spawned_Door, DoorHealth)
        else
          newScript = "function onLoad() end function onPickUp() if string.match(self.getName(), 'Door') then Global.call('playsound',116) end end"
          Spawned_Door.setLuaScript(newScript)
        end
    end
end

function LoadCustomTile(oData, oscale, orot, oHealth)
  local oParameters = {}
    for i, thing in ipairs(oData) do

      oParameters.type = 'Custom_Tile'
      --if thing[4] != 0 then
          --oParameters.rotation = {0.0,180.0,180.0}
      --else
          --oParameters.rotation = orot
      --end
      if thing[4] != nil then
          if thing[5] == 'Y' then
            oParameters.image = 'https://steamusercontent-a.akamaihd.net/ugc/973235725992413522/3E91DAEF98F1C121ED1AF1B9B0B890BD2955A8A7/'
            oParameters.image_bottom = 'https://steamusercontent-a.akamaihd.net/ugc/973235725992413931/F4013D3262B429217824940111D2A3ADBF531CAA/'
          end
          if thing[5] == 'B' then
            oParameters.image = 'https://steamusercontent-a.akamaihd.net/ugc/973235725992409613/B4A0EBEBBCF0283D3528C79DCC3DD71304FDEF93/'
            oParameters.image_bottom = 'https://steamusercontent-a.akamaihd.net/ugc/973235725992410072/62A07CDB2CDC1C16FABC07A24C8721EB26F5083C/'
          end
          if thing[5] == 'R' then
            oParameters.image = 'https://steamusercontent-a.akamaihd.net/ugc/973235725992422129/ACAC59A34A1AFCD136BED7947694B50A3DA96387/'
            oParameters.image_bottom = 'https://steamusercontent-a.akamaihd.net/ugc/973235725992453785/60C5F411552E18EA570DF465DF5EE4F69C51D6FF/'
          end
          if thing[5] == 'G' then
            oParameters.image = 'https://steamusercontent-a.akamaihd.net/ugc/973235725992411937/0752FF8888DA6132B1D5743EE0B1C3F11D63F528/'
            oParameters.image_bottom = 'https://steamusercontent-a.akamaihd.net/ugc/973235725992412290/309AF806871DC11F9B7D93879B5E0CC64604863D/'
          end
          if thing[5] == 'L' then
              oParameters.image = 'https://steamusercontent-a.akamaihd.net/ugc/973235725991634344/B85D2C63183CF68B86FA45A80824E465ED13B189/'
              oParameters.image_bottom = 'https://steamusercontent-a.akamaihd.net/ugc/973235725991634344/B85D2C63183CF68B86FA45A80824E465ED13B189/'
          end
          if thing[5] == 'E' then
              oParameters.image = 'https://steamusercontent-a.akamaihd.net/ugc/973235725991415783/C372EDC78FF0DCC5C7C43A3D181F23EDC540B2C9/'
              oParameters.image_bottom = 'https://steamusercontent-a.akamaihd.net/ugc/973235725991415783/C372EDC78FF0DCC5C7C43A3D181F23EDC540B2C9/'
          end
      end
      if thing[4] != 0 then
          local temp = oParameters.image
          oParameters.image = oParameters.image_bottom
           oParameters.image_bottom = temp
      end
      oParameters.scale = oscale
      oParameters.thickness = 0.1
      oParameters.position = {thing[1],thing[2],thing[3]}

      local Spawned_o = spawnObject(oParameters)
      if  thing[4] != nil then
        if thing[5] == 'L' or thing[5] == 'E' then
          oParameters.type = 3
        else
          oParameters.type = 2
        end
      else
        oParameters.type = 2
      end
      Spawned_o.setCustomObject(oParameters)
      Spawned_o.setDescription('Current Map')
      Spawned_o.setLock(true)
      if oHealth != '' then
        AddBarObject(Spawned_o, oHealth)
      end
    end
end

function LoadCustomModel(oData, oscale, orot, omesh, odiffuse, oHealth)
    for i, thing in ipairs(oData) do
        local oParameters = {}
        local cterminal = false
        oParameters.type = 'Custom_Model'
        if thing[4] != nil then
            if thing[4] == 1 then
                oParameters.rotation = {0.0,180.0,180.0}
            elseif thing[4] == 3 then
              cterminal = true
            else
                oParameters.rotation = orot
            end
            oParameters.position = {thing[1],thing[2],thing[3]}
        else
            oParameters.rotation = orot
            oParameters.position = thing
        end
        oParameters.scale = oscale

        local oInfo = {}
        oInfo.type = 1
        oInfo.mesh = omesh

        if thing[4] != nil then
            if cterminal == false then
            if thing[5] == 'Y' then
                odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/859478214460666170/9926E901B75051A5602927EFC20A4D6187F62ECD/'
            end
            if thing[5] == 'B' then
                odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/859478214460665776/1A5612F805E119A2D141F36B8FB088678055162F/'
            end
            if thing[5] == 'R' then
                odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/859478214460665911/D09E1E0C5C0745E1943F6E75E888F11642D48C2F/'
            end
            if thing[5] == 'G' then
                odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/859478214460666023/5152BA184FDE43D4209B5FA2F85447AF337A118F/'
            end
            if thing[5] == 'L' then
                odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/973235725991634344/B85D2C63183CF68B86FA45A80824E465ED13B189/'
                omesh = 'https://steamusercontent-a.akamaihd.net/ugc/957461452970678802/68B20205D3C3DA06DBB56EE863041A9D4A37ECD1/'
            end
            if thing[5] == 'E' then
                odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/973235725991415783/C372EDC78FF0DCC5C7C43A3D181F23EDC540B2C9/'
                omesh = 'https://steamusercontent-a.akamaihd.net/ugc/957461452970678802/68B20205D3C3DA06DBB56EE863041A9D4A37ECD1/'
            end
            else
              if thing[5] == 'Y' then
                  odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1002556022160674172/FCCDCD9577DF95CBF834896DEA69586AAA510345/'
              end
              if thing[5] == 'B' then
                  odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1002556022160674698/05F31CB6BB54B06C7C006CBF7C20661EDC8B2455/'
              end
              if thing[5] == 'R' then
                  odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1002556022160675769/F6010C9B460FEEEA2F20FBBE974B110A4AECA656/'
              end
              if thing[5] == 'G' then
                  odiffuse = 'https://steamusercontent-a.akamaihd.net/ugc/1002556022160675251/8D2F5302A9F84CC5BF5B62762F9559B88AB8491C/'
              end
            end
        end
        oInfo.diffuse = odiffuse
        oInfo.material = 3
        local Spawned_o = spawnObject(oParameters)
        Spawned_o.setCustomObject(oInfo)
        Spawned_o.setDescription('Current Map')
        Spawned_o.setLock(true)
        if oHealth != '' then
          AddBarObject(Spawned_o, oHealth)
        end
    end
end

function FYShuffle( tInput )
    math.randomseed(os.time()) -- so that the results are always different
    local tReturn = {}
    for i = #tInput, 1, -1 do
        local j = math.random(i)
        tInput[i], tInput[j] = tInput[j], tInput[i]
        --printToAll(tInput[i], "Purple")
        table.insert(tReturn, tInput[i])
    end
    return tReturn
end

function LoadCustomToken(oData, oscale, orot, oskin, effect)
    if effect != nil and effect == 'Snow' then
      getObjectFromGUID('7a310a').AssetBundle.playLoopingEffect(1)
    end
    if oscale[5] != nil then
        local newarray = {}
        for j, tcolors in ipairs(oscale) do
            if j > 5 then
                table.insert(newarray, tcolors)
            end
        end
        if oscale[5] == 0 then --if 0 do not shuffle
          carray = newarray
        else
          carray = FYShuffle(newarray)
        end
    end
    if oscale == '' then
      oscale = {0.76,0.76,0.76}
    end
    for i, thing in ipairs(oData) do
        local oParameters = {}

        oParameters.rotation = orot
        oParameters.position = thing
        if oscale[5] != nil then
            oParameters.type = 'Custom_Tile'
            oParameters.scale = {oscale[1],oscale[2],oscale[3]}
            oParameters.image = 'https://steamusercontent-a.akamaihd.net/ugc/973235725989016827/E2388ED983D8CFBCC886B201735EB1962FF4CCAA/'
            tcolor = carray[i]
            if tcolor == 'B' then
                oskin = 'https://steamusercontent-a.akamaihd.net/ugc/973235725989017661/EA5484F342B0EE83188FB6BB89BA1A63B0D163DE/'
            end
            if tcolor == 'R' then
                oskin = 'https://steamusercontent-a.akamaihd.net/ugc/973235725989022124/7DAA5FCE3C5587B76527B151440B3BB3AD0FF23D/'
            end
            if tcolor == 'G' then
                oskin = 'https://steamusercontent-a.akamaihd.net/ugc/973235725989020343/072AE187E06423B7BC6959946A069B24B4C5AFCE/'
            end
            if tcolor == 'Y' then
                oskin = 'https://steamusercontent-a.akamaihd.net/ugc/973235725989021085/4CC70DA9EE85A684EC9526C0AC54E4F7FB64DB53/'
            end
            oParameters.image_bottom = oskin
            if thing[4] != nil then
              oParameters.image = oskin
            else
              oParameters.image_bottom = oskin
            end
        else
        oParameters.type = 'Custom_Token'
            oParameters.scale = oscale
            oParameters.image = oskin

            oParameters.thickness = 0.1
        end

        local Spawned_o = spawnObject(oParameters)
        if oscale[5] != nil then
            oParameters.type = 2
        end
        Spawned_o.setCustomObject(oParameters)
        Spawned_o.setDescription('Current Map')
        Spawned_o.setLock(true)
        if oscale[4] != nil then
            if oscale[4] != '' then
              AddBarObject(Spawned_o,oscale[4])
            end
        end
    end
end

function Spawn(object, playerColor, Reloaded, Flip, Rotation)
  if playerColor != "White" then
    local Flipped, Flip, Rotation = isFlipped(object)
    --if playerColor != 'Black' and object.getDescription() == 'Imperial Deployment Cards' then
      --broadcastToAll("You must change your color to Black to spawn Imperial Cards", "White")
    --end
    --if playerColor == 'Black' and  object.getDescription() != 'Imperial Deployment Cards' and playerColor == 'Black' and  object.getDescription() != 'Mercenary Deployment Cards' and  object.getDescription() != 'Companion Deployment Cards' then
      --broadcastToAll("Black player can't spawn Rebel Cards", Table)
    --end
    --if playerColor != 'Black' and object.getDescription() != 'Imperial Deployment Cards' or playerColor == 'Black' and string.find(object.getDescription(), 'Deployment Cards') and  object.getDescription() != 'Rebel Deployment Cards' then
    data = object.getTable('Details')
    object.clearButtons()
    if Reloaded == false then
        --SpawnActivation(object)
        --AddBar is inside the SpawnToken
        if data[6] != 1 then
            for i=1, data[6] do
                SpawnToken(object, playerColor, data, i-2)
            end
        else
            SpawnToken(object, playerColor, data, 0)
        end

        if data[18] != nil then
          playsound(data[18])
        end

        table.insert(guid_to_save, object.getGUID())
    end
    if data[1] == 'Hero' then
        Hero_Buttons =
        {
            [1] = {'Attack',1,4,7},
            [2] = {'Defense',5,6,7},
            [3] = {'Strength',1,4,8},
            [4] = {'Insight',1,4,9},
            [5] = {'Tech',1,4,10},
        }
       for i=1, 5 do
            _G['Hero' .. i .. 'Pressed'] = function (object, sPlayer)
                Hero_DiceRoller(object, Hero_Buttons[i], playerColor)
            end
            local params = {
                label = Hero_Buttons[i][1], click_function = 'Hero' .. i .. 'Pressed', width = string.len(Hero_Buttons[i][1]) *42, height=125, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 50, function_owner = nil
            }

            params.index = i
            if i < 5 then
                params.position = {(-1.7 + i * 0.55) * Flip,0.1 * Flip,1.2}
            else
                params.position = {(-1.5 + i * 0.49) * Flip,0.1 * Flip,1.2}
            end
            params.rotation = {0,0, Rotation}
            object.createButton(params)
        end
     object.createButton({label = '?', click_function = 'Hero_Help', rotation = {0, 0, Rotation},
        position = {1.25 * Flip, 0.1 * Flip, -1.2}, width = 55, height = 125, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
        object.createButton({label = 'W', click_function = 'Hero_Flip', rotation = {0, 0, Rotation},
        position = {1.1 * Flip, 0.1 * Flip, -1.2}, width = 55, height = 125, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 65, function_owner = self, tooltip="Wound/Unwound"})
        --object.createButton({label = 'Strain', click_function = 'Hero_Strain', rotation = {0, 0, Rotation},
        --position = {-1 * Flip, 0.1 * Flip, -0.9}, width = 300, height = 125, font_size = 75, function_owner = self})
        object.createButton({label = '>', click_function = 'Hero_Extra', rotation = {0, 0, Rotation},
        position = {1.2 * Flip, 0.1 * Flip, 1.2}, width = 55, height = 125, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, tooltip="Extra Dice"})
        HeroHealth_Buttons(object, playerColor, Flip, Rotation)
        Strain_Buttons(object, playerColor, Flip, Rotation)
        object.setLock(true)
        if data[2] == 'IACP' then
          IACP = true
        end
    else
        --Villan or Rebel Card
        object.createButton({label = 'Attack', click_function = 'Attack', rotation = {0, 0, 0},
        position = {0.6, 1, 1.8}, width = 400, height = 200, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
        object.createButton({label = 'V', click_function = 'Options', rotation = {0, 0, 0},
        position = {0, 1, 1.8}, width = 100, height = 200, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
        object.createButton({label = 'Defense', click_function = 'Defense', rotation = {0, 0, 0},
        position = {-0.6, 1, 1.8}, width = 400, height = 200, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
        if data[6] == 1 then
            Health_Buttons(object, playerColor, Flip, Rotation)
        end
    end
  --end
else
  broadcastToAll("Please choose a color.", "Red")
end
end

function Hero_Flip_t(player, option, id)
  if option == '-2' then
    Hero_Flip(getObjectFromGUID(self.UI.getAttribute(string.sub(id,1,2).."_cobject", "text")),rev_whatcolor(self.UI.getAttribute(string.sub(id,1,2).."_hp_bar", "fillImageColor")))
  end
end

function Hero_Flip(object, playerColor)
    object.setRotation({object.getRotation().x,object.getRotation().y, object.getRotation().z + 180})
    Spawn(object, playerColor, true)
    to = getObjectFromGUID(object.getTable('Details')[13][1][1])
    to.call("reset")
    if self.UI.getAttribute(string.sub(to.call("getPrefix"),1,2).."_W", "active") == "true" then
      self.UI.setAttributes(string.sub(to.call("getPrefix"),1,2).."_W", {active="false"})
      self.UI.setAttributes(string.sub(to.call("getPrefix"),1,2).."_name", {color="#FFFFFF"})
    else
      self.UI.setAttributes(string.sub(to.call("getPrefix"),1,2).."_W", {active="true"})
    end
end

function HeroHealth_Buttons(object, playerColor, Flip, Rotation)
    local w,h,z = 0
        z = -1.2
        w = 300
        h = 100
    object.createButton({label = 'Health', click_function = 'HighLight', rotation = {0, 0, Rotation},
    position = {0.4 * Flip, 0.1 * Flip, z}, width = w, height = h, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
    object.createButton({label = '-', click_function = 'Health_Left', rotation = {0, 0, Rotation},
    position = {0 * Flip , 0.1 * Flip, z}, width = h, height = h, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
    object.createButton({label = '+', click_function = 'Health_Right', rotation = {0, 0, Rotation},
    position = {0.8 * Flip, 0.1 * Flip, z}, width = h, height = h, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
end
function Health_Buttons(object, playerColor, Flip, Rotation)
    local w,h,z = 0
        z = -1.8
        w = 400
        h = 200
        Flip = 2
    object.createButton({label = 'Health', click_function = 'HighLight', rotation = {0, 0, Rotation},
    position = {0 * Flip, 0.1 * Flip, z}, width = w, height = h, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
    object.createButton({label = '-', click_function = 'Health_Left', rotation = {0, 0, Rotation},
    position = {-0.4 * Flip , 0.1 * Flip, z}, width = h, height = h, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
    object.createButton({label = '+', click_function = 'Health_Right', rotation = {0, 0, Rotation},
    position = {0.4 * Flip, 0.1 * Flip, z}, width = h, height = h, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
end

function Strain_Buttons(object, playerColor, Flip, Rotation)
  local w,h,z = 0
      if string.match(object.getDescription(),'Deployment') then
      z = -1.8
      w = 400
      h = 200
      Flip = 2
  else
      z = -1.2
      w = 300
      h = 100
  end
    object.createButton({label = 'Strain', click_function = 'HighLight', rotation = {0, 0, Rotation},
    position = {-0.8 * Flip, 0.1 * Flip, z}, width = w, height = h, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
    object.createButton({label = '-', click_function = 'Strain_Left', rotation = {0, 0, Rotation},
    position = {-1.2 * Flip , 0.1 * Flip, z}, width = h, height = h, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
    object.createButton({label = '+', click_function = 'Strain_Right', rotation = {0, 0, Rotation},
    position = {-0.4 * Flip, 0.1 * Flip, z}, width = h, height = h, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
end

function Health_Left(object, playerColor, unit_id)
    local hp, tokenobject
    if unit_id == true or unit_id == false then
      tokenobject = getObjectFromGUID(object.getTable('Details')[13][1][1])
      if tokenobject != nil then
        unit_id = tokenobject.call('getPrefix')
      else
        unit_id = getObjectFromGUID(object.getTable('Details')[13][1][1])
      end
    else
      tokenobject = getObjectFromGUID(self.UI.getAttribute(unit_id.."_tobject", "text"))
      if string.len(unit_id) > 2 then
        unit_id = string.sub(unit_id,1,string.find(unit_id,'U')-1)
      end
      object = getObjectFromGUID(self.UI.getAttribute(unit_id.."_cobject", "text"))
    end
    if tokenobject != nil then
      hp = tokenobject.call('getHP') - 1
      tokenobject.call("sub")
      if hp < 0 then
        hp = 0
      end
      if unit_id == true or unit_id == false or unit_id == 1 or string.sub(unit_id,1,1) == "P"  then
        if hp == 0 and string.sub(unit_id,1,1) == "P" and tonumber(string.sub(unit_id,2,2)) < 5 then
          if self.UI.getAttribute(string.sub(tokenobject.call("getPrefix"),1,2).."_W", "active") == "true" then
            broadcastToAll(object.getName().. ' has been withdrawn! ', playerColor)
            self.UI.setAttributes(unit_id.."_name", {color="#FF0000"})
            self.UI.setAttributes(unit_id.."_AT", {image="Activation_End"})
            self.UI.setAttributes(unit_id.."_AT2", {image="Activation_End"})
          else
            --TokenWounded(object.getGUID())
          end
        end
      elseif hp == 0 then
        tokenobject.call("clearstats")
      end
    else
      --token has been deleted
      if unit_id != nil then
        self.UI.setAttributes(unit_id.."_Table",{active = "false"})
        if self.UI.getAttribute(unit_id.."_W","active") == "true" then
          object.setLock(false)
          object.flip()
          self.UI.setAttributes(unit_id.."_W",{active = "false"})
        end
      else
        for i=1,16 do
          if self.UI.getAttribute("G"..i.."_Name","text") == object.getName() then
            self.UI.setAttributes("G"..i.."_Table",{active = "false"})
          end
        end
        for i=1,9 do
          if self.UI.getAttribute("P"..i.."_Name","text") == object.getName() then
            self.UI.setAttributes("P"..i.."_Table",{active = "false"})
            if self.UI.getAttribute("P"..i.."_W","active") == "true" then
              object.setLock(false)
              object.flip()
              self.UI.setAttributes("P"..i.."_W",{active = "false"})
            end
          end
        end
      end

      object.clearButtons()
      if Cards[object.getName()] != nil and object.getDescription() != '' then
          object.createButton({label = object.getName(), click_function = 'Spawn', rotation = {0, 0, 0},
          position = {0, 0.2, 0}, width = (40 * string.len(object.getName())), height = 100, font_size = 75, function_owner = self})
          local data = Cards[object.getName()]
          data[12] = object.getGUID()
          data[13] = {}
          object.setTable('Details', data)
          local AllObj = getAllObjects()
          if data[1] == 'Hero' then
            for t, item in ipairs(AllObj) do
                if item.getName() == object.getName() and item.getDescription() == 'Class Deck' then
                    local AllObj1 = getAllObjects()
                    for t1, item1 in ipairs(AllObj1) do
                        if object.getName()..' Class Card' == item1.getDescription() then
                          item.putObject(item1)
                        end
                    end
                    HeroClass.putObject(item)
                end
                if item.getDescription() == object.getName() and string.match(item.getName(),"Token") then
                    local AllObj2 = getAllObjects()
                    for t2, item2 in ipairs(AllObj2) do
                        if item2.getName() == item.getName() then
                          item2.destroy()
                        end
                    end
                    temp = item.getName()
                    item.setName(item.getDescription())
                    item.setDescription(temp)
                    HeroObjects.putObject(item)
                end
            end
          end
      end
    end
end
function Health_Right(object, playerColor, unit_id)
  if unit_id == true or unit_id == false then
    tokenobject = getObjectFromGUID(object.getTable('Details')[13][1][1])
  else
    tokenobject = getObjectFromGUID(self.UI.getAttribute(unit_id.."_tobject", "text"))
  end
    if tokenobject != nil then
      tokenobject.call('add')
    end
end

function Strain_Left(object, playerColor)
    getObjectFromGUID(object.getTable('Details')[13][1][1]).call("subS")
end

function Strain_Right(object, playerColor)
    getObjectFromGUID(object.getTable('Details')[13][1][1]).call('addS')
end

function HighLight(object, playerColor)
    getObjectFromGUID(object.getTable('Details')[13][1][1]).highlightOn(stringColorToRGB(playerColor), 5)
    Player[playerColor].lookAt({
        position = getObjectFromGUID(object.getTable('Details')[13][1][1]).getPosition(),
        pitch    = 45,
        yaw      = 0,
        distance = 25,
    })
end

function TokenHighLight(tobject, playerColor)
    tobject.highlightOn(stringColorToRGB(playerColor), 5)
    Player[playerColor].lookAt({
        position = tobject.getPosition(),
        pitch    = 45,
        yaw      = 0,
        distance = 25,
    })
end

function CardHighLight(cardguid, playerColor)
    cobject = getObjectFromGUID(cardguid)
    cobject.highlightOn(stringColorToRGB(playerColor), 5)
    if playerColor != "Black" then
      Player[playerColor].lookAt({
          position = cobject.getPosition(),
          pitch    = 45,
          yaw      = 180,
          distance = 25,
      })
    else
      Player[playerColor].lookAt({
          position = cobject.getPosition(),
          pitch    = 45,
          yaw      = 0,
          distance = 25,
      })
    end
end

function Hero_Strain(object, playerColor)
    local Counter = object.getVar('Strain')
    if Counter == nil or Counter == 4 then
        Counter = 0
  printToAll(object.getName() ..' is straining! Here it comes!' , {0,1,1})  else
        Counter = Counter + 1
  printToAll(object.getName() ..' is straining! Watch out!' , {0,1,1})  end
    Flip = 1
    if object.getRotation()[3] > 90 then
        Flip = -1
    end
    local Strain_Parameters = {}
    Strain_Parameters.type = 'Custom_Token'
    Strain_Parameters.rotation = object.getRotation()
    Strain_Parameters.position = Location(object,  1.7 * Flip,   1 - (Counter / 3))
    Strain_Parameters.image = 'http://i.imgur.com/LNfl3IT.png'

    object.setVar('Strain', Counter)
    local Strain = spawnObject(Strain_Parameters)
    Strain.setCustomObject(Strain_Parameters)
    Strain.setName('Strain')
    Strain.scale({object.getScale().x /15, object.getScale().y /15, object.getScale().z /15})

end

function Hero_Help(object, playerColor)
    printToColor('You can change which dice are rolled for each button. Simply drag any combination of dice on top of this card and hit the corresponding button.', playerColor,  {1,1,1})
end

function Attack(o, playerColor)
    data = o.getTable('Details')
    tokenobject = getObjectFromGUID(o.getTable('Details')[13][1][1])
    if tokenobject == nil then
      for i=1,16 do
        if UI.getAttribute("G"..i.."_cobject", "text") == object.guid then
          tokenobject = getObjectFromGUID(UI.getAttribute("G"..i.."U1_tobject", "text"))
          for j=1, tonumber(UI.getAttribute("G"..i.."_units", "text")) do
            data[13][j][1] = UI.getAttribute("G"..i.."U"..j.."_tobject", "text")
          end
          table.insert(data[13], AdditonalData)
          cardobject.setTable('Details', data)
        end
      end
    end
    pf = tokenobject.call('getPrefix')
    if UI.getAttribute(string.sub(pf,1,2).."_units", "text") != "1" then
      pf = string.sub(pf,1,3)..UI.getAttribute(string.sub(pf,1,2).."_selector", "text")
      tokenobject = getObjectFromGUID(UI.getAttribute(pf.."_tobject", "text"))
    end
    if UI.getAttribute(pf.."Stunned", "active") != "true" then
      if attackerRolled == false then
          CardRoller(o, playerColor, 'attack', 1, 4)
          attackerRolled = true
          if data[7][1] == 0 and data[7][2] == 0 and data[7][3] == 0 and data[7][4] == 0 then
            printToAll( 'Please choose Attack dice for '..o.getName()..'. Put them on the card and click attack.', {1,0,1})
            attackerRolled = false
          end
      elseif defenderRolled == true then
          if cleardicenow == false then
              printToAll('There are still dice in the tray. Press again to Clear', {1,0,1})
              cleardicenow = true
          else
              ClearDice()
          end
      end
      if data[19] != nil and clips == false then
        playsound(data[19])
      else
        playsound(data[18])
      end
    else
      broadcastToAll("Discard Stun first", "Yellow")
    end
end

function Defense(object, playerColor)
    data = object.getTable('Details')
    if defenderRolled == false then
        CardRoller(object, playerColor, 'defense', 5, 6)
        if data[19] != nil and clips == false then
          playsound(data[19])
        else
          playsound(data[18])
        end
        defenderRolled = true
        elseif attackerRolled == true then
        if cleardicenow == false then
            printToAll('There are still dice in the tray. Press again to Clear', {1,0,1})
            cleardicenow = true
        else
            ClearDice()
        end
    end
end

function AttackerInfo(tobject, Group)
  pf = tobject.call('getPrefix')
  UI.setAttribute("AName", "text", tobject.getName())
  UI.setAttribute("AToken", "text", tobject.getGUID())
  UI.setAttribute("AName", "active", "true")
  UI.setAttribute("A_totalhp", "text", UI.getAttribute(pf.."_totalhp", "text"))
  UI.setAttribute("A_totalhp", "active", "true")
  UI.setAttribute("A_hp_bar", "percentage", UI.getAttribute(pf.."_hp_bar", "percentage"))
  UI.setAttribute("A_hp_bar", "fillImageColor", UI.getAttribute(pf.."_hp_bar", "fillImageColor"))
  UI.setAttribute("A_hp_bar", "active", "true")
  stats = {"Weakened", "Hidden", "Damage", "Surge"}
  for i=1,4 do
    if UI.getAttribute(pf..stats[i], "active") == "true" then
      UI.setAttribute("A"..stats[i], "active", "true")
    end
  end
end

function DefenderInfo(tobject, Group)
  pf = tobject.call('getPrefix')
  UI.setAttribute("DName", "text", tobject.getName())
  UI.setAttribute("DToken", "text", tobject.getGUID())
  UI.setAttribute("DName", "active", "true")
  UI.setAttribute("D_totalhp", "active", "true")
  UI.setAttribute("D_totalhp", "text", UI.getAttribute(pf.."_totalhp", "text"))
  UI.setAttribute("D_hp_bar", "percentage", UI.getAttribute(pf.."_hp_bar", "percentage"))
  UI.setAttribute("D_hp_bar", "fillImageColor", UI.getAttribute(pf.."_hp_bar", "fillImageColor"))
  UI.setAttribute("D_hp_bar", "active", "true")
  stats = {"Weakened", "Hidden", "Block", "Evade"}
  for i=1,4 do
    if UI.getAttribute(pf..stats[i], "active") == "true" then
      UI.setAttribute("D"..stats[i], "active", "true")
    end
  end
end

function CardRoller(object, playerColor, Group, Start, Stop)
    --WORKING
    local cast = {}
    local tokenobject

    cast.origin = object.getPosition()
    cast.direction = {0,-1,0}
    cast.type = 3
    cast.size = {2.5,1,6}

    cast.orientation = object.getRotation()
    cast.max_distance = 1

    hits = Physics.cast(cast)

    local Save = false
    local Reset = false

    Data = object.getTable('Details')

    tokenobject = getObjectFromGUID(object.getTable('Details')[13][1][1])
    if tokenobject == nil then
      for i=1,16 do
        if UI.getAttribute("G"..i.."_cobject", "text") == object.guid then
          tokenobject = getObjectFromGUID(UI.getAttribute("G"..i.."U1_tobject", "text"))
          for j=1, tonumber(UI.getAttribute("G"..i.."_units", "text")) do
            data[13][j][1] = UI.getAttribute("G"..i.."U"..j.."_tobject", "text")
          end
          table.insert(data[13], AdditonalData)
          cardobject.setTable('Details', data)
        end
      end
    end
    pf = tokenobject.call('getPrefix')
    --if data[1] != 'Hero' then

    --else
      --tokenobject = getObjectFromGUID(UI.getAttribute(pf.."_tobject", "text"))
    --end
    if UI.getAttribute(string.sub(pf,1,2).."_units", "text") != "1" then
      pf = string.sub(pf,1,3)..UI.getAttribute(string.sub(pf,1,2).."_selector", "text")
      tokenobject = getObjectFromGUID(UI.getAttribute(pf.."_tobject", "text"))
    end
    if UI.getAttribute(pf.."Focused", "active") == "true" and Group != "defense" then
      SpawnDice(Dice_Status[3][1], false)
      printToAll(object.getName() .. ' is focused! This is gonna hurt', {0,1,1})
      Dice_Status['Extra'][1] = true
      --Spawn(object, playerColor, true)
      tokenobject.call('onClickEx',{id = "Focused"})
    end
    if UI.getAttribute(pf.."Bleeding", "active") == "true" and Group != "defense" then
      printToAll(object.getName() .. ' is bleeding and takes 1 strain.', {0,1,1})
      if string.sub(pf,1,1) == 'P' and tonumber(string.sub(pf,2,2)) < 5 and tokenobject.call('getSPer') != 100 then
        tokenobject.call('addS')
      else
        tokenobject.call('sub')
      end
    end

    if Group == "defense" then
      DefenderInfo(tokenobject, Group)
    end
    if Group == "attack" then
      AttackerInfo(tokenobject, Group)
    end

    hits = Physics.cast(cast)
    for t, entry in ipairs(hits) do
      if entry.hit_object.tag == 'Dice' then
        if Reset == false then
            if Group == "defense" then
              for i=5, 6 do
                  Data[7][i] = 0
              end
            else
              for i=1, 4 do
                  Data[7][i] = 0
              end
            end
            Reset = true
        end
        Save = true
        Data[7][Dice_Status[entry.hit_object.getName()][1]] = Data[7][Dice_Status[entry.hit_object.getName()][1]] + 1
        entry.hit_object.setRotation(object.getRotation())
        --entry.hit_object.setPositionSmooth({object.getPosition().x - 5.8 + (t* 1.2), object.getPosition().y + 2, object.getPosition().z + 5}, false, true)
        entry.hit_object.setPositionSmooth(Location(object, 1.5 + (-t * 0.3), -2), false, true)
        printToAll('Changed '..Group..' dice of ' .. object.getName(), {1,0,1})
        object.setTable('Details', Data)
      else
        if entry.hit_object.name == 'Custom_Token' then
            if entry.hit_object.getName() == 'Focused' and Group != 'defense' then
                --SpawnDice(Dice_Status[3][1], false)
                printToAll(object.getName() .. ' is focused! This is gonna hurt', {0,1,1})
                --Dice_Status['Extra'][1] = true
                --Spawn(object, playerColor, true)
                --entry.hit_object.destruct()
            elseif entry.hit_object.getName() == 'Bleeding' and Group != 'defense' then
                printToAll(object.getName()..' is bleeding and takes 1 strain.', {0,1,1})
            elseif entry.hit_object.getName() == 'Stunned' and Group != 'defense' then
                printToAll(object.getName()..' is stunned and cannot attack or move.', {0,1,1})
            elseif entry.hit_object.getName() == 'Weakened' and Group == 'attack' then
                printToAll(object.getName()..' is weakened. Apply -1 Surge to the Attack results', {0,1,1})
            elseif entry.hit_object.getName() == 'Weakened' and Group == 'defense' then
                printToAll(object.getName()..' is weakened. Apply -1 Cancel to the Defense results', {0,1,1})
            elseif entry.hit_object.getName() == 'Hidden' and Group == 'attack' then
                printToAll(object.getName()..' is hidden. Apply +1 Surge to the Attack results', {0,1,1})
            elseif entry.hit_object.getName() == 'Hidden' and Group == 'defense' then
                printToAll(object.getName()..' is hidden. Apply -2 Accuracy to the Attack results', {0,1,1})
            end
        end
      end
    end
      --if Dice_Status['Roll'][1] == true then return end
     local Side = 180
     local Who = 0
     local Type = 'Villain'
     data = object.getTable('Details')
     if IACP == true and data[1] == 'Hero1' then
       Type = 'Villain'
     end
     if IACP == true and data[1] != 'Hero1' then
       Side = 0
       Who = 1
       Type = 'Hero'
     end
     if data[1] != 'Villain' and IACP == false then
         Side = 0
         Who = 1
         Type = 'Hero'
     end
     printToAll(Type, "Red")
     if Dice_Status[Type][1] == true then
         return
     end
     for i=Start, Stop do
       for t=1, data[7][i] do
           SpawnDice(Dice_Status[i][1],true,Side,Who)
       end
     end
     printToAll(object.getName() .. ' is rolling ' .. Group .. ' dice.', {1,0,1})
end

function Options(object, playerColor)
   Add_Extra_Dice(object, playerColor, 3)
end

function SpawnToken(object, playerColor, data, pos)
    --Spawns a Token data = all data and pos is for offset of placement

    local Token_Parameters = {}

    if data[14] == '' then
        Token_Parameters.type = 'Figurine_Custom'
        Token_Parameters.rotation = object.getRotation()
        Token_Parameters.position = Location(object, (pos * 1.5), 0)
        Token_Parameters.position.y = Token_Parameters.position.y + 5
        Token_Parameters.image = data[11] --Image Location
        Token_Parameters.scale = {1.75,1.75,1.75}
        Token_Parameters.callback_function = function(obj) cbBar(obj, object, "", whatcolor(playerColor)) end


        local Token = spawnObject(Token_Parameters)
        Token.setCustomObject(Token_Parameters)
        Token.setName(object.getName()) --NAME
        Token.setDescription("Token")
        Token.ignore_fog_of_war = true
        if data[1] ~= 'Hero' then
          Token.setDescription("Current Map")
        else
          local fov = {
            reveal = true,
            color = "All",
            range = 10
          }
          Token.setFogOfWarReveal(fov)
        end
        if data[3] == 'Elite' then
            Token.setColorTint({1,0,0}) --Red Color Tint
        elseif data[3] == 'No' then
        --Unused Maybe later
        elseif data[3] == 'Color' then
            Token.setColorTint(stringColorToRGB(playerColor)) --PlayerColor
        end

        AddBar(Token, data[4], data[5], object, playerColor,1,data[6],pos)

    else

        local Model_Parameters = {}
        Model_Parameters.type = 'Custom_Model'
        Model_Parameters.rotation = object.getRotation()
        Model_Parameters.position = Location(object, 0, (pos * 1.5))
        Model_Parameters.position.y = Model_Parameters.position.y + 5
        Model_Parameters.callback_function = function(obj) cbBar(obj, object, "", whatcolor(playerColor)) end
        Model_Parameters.scale = {0.8,0.8,0.8}

        local Model_Info = {}
        Model_Info.type = 1
        Model_Info.mesh = data[14]
        Model_Info.diffuse = data[15]
        Model_Info.material = 3
        if data[16] ~= nil or string.find(object.getName(), ")") then
            Model_Info.collider = data[16]
        else
		        Model_Info.collider = "https://steamusercontent-a.akamaihd.net/ugc/1749057862502862307/0D15413F88D99FECF7D3054E7F1DB2380725D479/"
        end
        local Spawned_Model = spawnObject(Model_Parameters)
        Spawned_Model.setCustomObject(Model_Info)
        Spawned_Model.setRotationValues(RotationValues)
        Spawned_Model.setName(object.getName())
        Spawned_Model.setDescription("Token")
        Spawned_Model.ignore_fog_of_war = true
        if data[1] ~= 'Hero' then
          Spawned_Model.setDescription("Current Map")
        else
          local fov = {
            reveal = true,
            color = "All",
            range = 10
          }
          Spawned_Model.setFogOfWarReveal(fov)
        end
        if object.getName() == "E-XD" then
          data[4] = 5 + (ThreatLevel * 2)
        end
        AddBar(Spawned_Model, data[4], data[5], object, playerColor,2,data[6],pos)
    end

    if data[1] == 'Hero' then
        for _, item in ipairs(HeroClass.getObjects()) do
            if item.name == object.getName() then
              local pos = Location(object, -2.1, -0.65)
              pos.y = pos.y + 3
                --SpawnCounter(object)
                HeroClass.takeObject({rotation = {object.getRotation().x + 180 , object.getRotation().y + 180, object.getRotation().z},
                position = pos, guid = item.guid}).setScale({object.getScale().x /2.5, object.getScale().y /2.5, object.getScale().z /2.5})
            end
        end
        for _, item in ipairs(HeroObjects.getObjects()) do
            if item.name == object.getName() then
              local pos = Location(object, -2.1, 1.65)
              pos.y = pos.y + 3
                --SpawnCounter(object)
                if data[1] == 'Hero' then
                  HeroObjects.takeObject({rotation = {object.getRotation().x , object.getRotation().y, object.getRotation().z},
                  position = pos, guid = item.guid, callback_function = function(obj) take_callback(obj, futureName) end})
                end
            end
        end
    end
    if object.getName() == 'Clawdite Shapeshifter' or object.getName() == 'Clawdite Shapeshifter Elite' then
      local pos = Location(object, -2.1, 1.65)
      pos.y = pos.y + 3
      ClawditeForms.takeObject({rotation = {object.getRotation().x, object.getRotation().y -90, object.getRotation().z},
      position = pos, guid = '7f3cf9', callback_function = function(obj) take_callback(obj, 'Shapes') end})
    end
end

function take_callback(object_spawned, name)
    temp = object_spawned.getName()
    object_spawned.setName(object_spawned.getDescription())
    object_spawned.setDescription(temp)
    object_spawned.clearButtons()
end

function SpawnCounter(object)
    local Counter_Parameters = {}
    Counter_Parameters.type = 'Counter'
    Counter_Parameters.position = Location(object, 0.9, -1.4)
    Counter_Parameters.rotation = {object.getRotation().x , object.getRotation().y + 180, object.getRotation().z}
    spawnObject(Counter_Parameters).setName(object.getName() .. ' Experience.')
end


function Location(object, posx, posz)
    --Return Position with Rotation given offset.
    Flip = 1
    if object.getRotation()[3] > 90 then
        Flip = -1
    end
    return object.positionToWorld({posx, Flip, posz})
end

function getATSfUI(pf)
  if string.len(pf) > 2 then
    pf = string.sub(pf,1,string.find(pf, "U")-1)
  end
  return UI.getAttribute(pf.."_AT", "image")
end

function toggleAT(player, option, idValue)
  if option == '-2' then
    if UI.getAttribute(idValue.."2", "active") == "true" then
      UI.setAttributes(idValue.."2", {active='false'})
    else
      UI.setAttributes(idValue.."2", {active='true'})
    end
  else
    local img
    img = UI.getAttribute(idValue, 'image')
    if img == 'Activation_Start' then
      UI.setAttributes(idValue, {image='Activation_End', tooltip="Turn Exhausted", tooltipPosition="Below"})
    else
      UI.setAttributes(idValue, {image='Activation_Start', tooltip="Start Turn", tooltipPosition="Below"})
    end

    if string.sub(idValue,1,1) == 'G' or string.sub(idValue,1,1) == 'P' and string.sub(idValue,2,2) > '4' then
      local i = UI.getAttribute(string.sub(idValue,1,string.find(idValue, "_")-1)..'_selector', "text")
      for t=1, i do
        getObjectFromGUID(UI.getAttribute(string.sub(idValue,1,string.find(idValue, "_")-1)..'U'..t..'_tobject', "text")).call('setATS')
      end
    else
      getObjectFromGUID(UI.getAttribute(string.sub(idValue,1,string.find(idValue, "_")-1)..'_tobject', "text")).call('setATS')
    end

    if timerstatus == true then
      Timer.destroy("Turn Timer")
      time = timer_length
      Timer.Create({
        identifier = "Turn Timer",
        function_name = "turntimer",
        delay = 1,
        repetitions = time,
      })
    end
  end
end



function SpawnActivation(object)
    --Spawns Activation Token on Selected Card object
    local Tile_Parameters = {}
    local data = Cards[object.getName()]
    if data[1] == 'Hero' then
        Tile_Parameters.position = Location(object, 0, 1.4)
    else
        Tile_Parameters.position = Location(object, 0, 2.5)
    end
    Tile_Parameters.type = 'Custom_Tile'
    Tile_Parameters.rotation = object.getRotation()

    Tile_Parameters.image = 'https://steamusercontent-a.akamaihd.net/ugc/755968752079471141/1525F26F7E789B761719550EEFE20FE55C3D470C/'
    Tile_Parameters.image_bottom = 'https://steamusercontent-a.akamaihd.net/ugc/755968752079467817/C014291D635E6698701E130D6C8622B067663FEB/'
    Tile_Parameters.scale = {object.getScale().x / 2.9 ,object.getScale().y / 2.9 ,object.getScale().z / 2.9 }
    Tile_Parameters.thickness = 0.1

    local actitoken = spawnObject(Tile_Parameters)
    actitoken.setCustomObject(Tile_Parameters)
    actitoken.setDescription('Activation Token')
end


function isFlipped(object)
    -- Hits didn't quite work they way I wanted.
    -- local Hits = 0
    -- local cast = {}
    -- cast.direction = object.getTransformUp()
    -- cast.type = 1
    -- cast.max_distance = 7
    -- --cast.debug = true
    -- for i=1, 10 do
    --     for t=1, 9 do
    --         cast.origin = object.positionToWorld({1.55 - (i * 0.282), 0, 1.25 - (t * 0.25)})
    --         hits = Physics.cast(cast)
    --         Hits = Hits + #hits
    --     end
    -- end
    -- if Hits < 70 then
    --      return false, 1, 0
    -- else
    --      return true, -1, 180
    -- end
    local rot = object.getRotation()

    if rot[3] >= 175 and rot[3] <= 185 then
        return true, -1, 180
    end
    if rot[3] >= 355 or rot[3] <= 5 then
        return false, 1, 0
    end
end




function Hero_DiceRoller(object, dicetype, playerColor)
    Data = object.getTable('Details')
    tokenobject = getObjectFromGUID(object.getTable('Details')[13][1][1])
    pf = tokenobject.call('getPrefix')
    if UI.getAttribute(pf.."Stunned", "active") == "true" and dicetype[1] != "Attack" or UI.getAttribute(pf.."Stunned", "active") != "true" then
      if UI.getAttribute(string.sub(pf,1,2).."_units", "text") != "1" then
        pf = string.sub(pf,1,3)..UI.getAttribute(string.sub(pf,1,2).."_selector", "text")
        tokenobject = getObjectFromGUID(UI.getAttribute(pf.."_tobject", "text"))
      end
      if UI.getAttribute(pf.."Focused", "active") == "true" and dicetype[1] != 'Defense' then
        SpawnDice(Dice_Status[3][1], false)
        printToAll(object.getName() .. ' is focused! This is gonna hurt', {0,1,1})
        Dice_Status['Extra'][1] = true
        --Spawn(object, playerColor, true)
        tokenobject.call('onClickEx',{id = "Focused"})
      end
      if UI.getAttribute(pf.."Bleeding", "active") == "true" and dicetype[1] != 'Defense' then
        printToAll(object.getName() .. ' is bleeding and takes 1 strain.', {0,1,1})
        if string.sub(pf,1,1) == 'P' and tonumber(string.sub(pf,2,2)) < 5 and tokenobject.call('getSPer') != 100 then
          tokenobject.call('addS')
        else
          tokenobject.call('sub')
        end
      end

      if Data[19] != nil and clips == false then
        playsound(Data[19])
      else
        playsound(Data[18])
      end
      if dicetype[1] == "Defense" then
        DefenderInfo(tokenobject, string.lower(dicetype[1]))
      end
      if dicetype[1] == "Attack" then
        AttackerInfo(tokenobject, string.lower(dicetype[1]))
      end
      --WORKING
      local cast = {}

      cast.origin = object.getPosition()
      cast.direction = {0,-1,0}
      cast.type = 3
      cast.size = {10.3,3,8.1}

      cast.orientation = object.getRotation()
      cast.max_distance = 1
  --        cast.debug = true

      hits = Physics.cast(cast)

      local Save = false
      local Reset = false

      for t, entry in ipairs(hits) do
          if entry.hit_object.tag == 'Dice' then
              Save = true
              if Reset == false then
                  for i=dicetype[2], dicetype[3] do
                      Data[dicetype[4]][i] = 0
                  end
                  Reset = true
              end
              Data[dicetype[4]][Dice_Status[entry.hit_object.getName()][1]] = Data[dicetype[4]][Dice_Status[entry.hit_object.getName()][1]] + 1
              entry.hit_object.setRotation(object.getRotation())
              --entry.hit_object.setPositionSmooth({object.getPosition().x - 5.8 + (t* 1.2), object.getPosition().y + 2, object.getPosition().z + 5}, false, true)
              entry.hit_object.setPositionSmooth(Location(object, 1.5 + (-t * 0.3), -2), false, true)
          else
              if entry.hit_object.name == 'Custom_Token' and Dice_Status['Hero'][1] == false and cleardicenow == false then
                  if entry.hit_object.getName() == 'Focused' and dicetype[1] != 'Defense' then
                      SpawnDice(Dice_Status[3][1], false)
                      printToAll(object.getName() .. ' is focused!', {0,1,1})
                      Dice_Status['Extra'][1] = true
                      Spawn(object, playerColor, true)
                      entry.hit_object.destruct()
                      tokenobject = getObjectFromGUID(object.getTable('Details')[13][1][1])
                      tokenobject.call('onClickEx',{id = "Focused"})
                  elseif entry.hit_object.getName() == 'Bleeding' and dicetype[1] != 'Defense' then
                      printToAll(object.getName()..' is bleeding!', {0,1,1})
                      Hero_Strain(object,playerColor)
                  elseif entry.hit_object.getName() == 'Stunned' and dicetype[1] != 'Defense' then
                      printToAll(object.getName()..' is stunned and cannot attack or move.', {0,1,1})
                  elseif entry.hit_object.getName() == 'Inspired' then
                      printToAll(object.getName()..' is inspired and can reroll 1 die. Then discard token', {0,1,1})
                  elseif entry.hit_object.getName() == 'Weakened' and dicetype[1] == 'Attack' then
                      printToAll(object.getName()..' is weakened. Apply -1 Surge to the Attack results', {0,1,1})
                  elseif entry.hit_object.getName() == 'Weakened' and dicetype[1] == 'Defense' then
                      printToAll(object.getName()..' is weakened. Apply -1 Cancel to the Defense results', {0,1,1})
                  elseif entry.hit_object.getName() == 'Hidden' and dicetype[1] == 'Attack' then
                      printToAll(object.getName()..' is hidden. Apply +1 Surge to the Attack results', {0,1,1})
                  elseif entry.hit_object.getName() == 'Hidden' and dicetype[1] == 'Defense' then
                      printToAll(object.getName()..' is hidden. Apply -2 Accuracy to the Attack results', {0,1,1})
                  end
              end
          end
      end

      if Save == false then
          --if Dice_Status['Roll'][1] == true then return end
          if Dice_Status['Hero'][1] == true then
              if cleardicenow == false then
                  printToAll('There are still dice in the tray. Press again to Clear', {1,0,1})
                  cleardicenow = true
              else
                  ClearDice()
              end
              return
          end
          if dicetype[1] == 'Attack' and attackerRolled == true or dicetype[1] == 'Defense' and defenderRolled == true then
              printToAll('There are still dice in the tray. Press again to Clear', {1,0,1})
              cleardicenow = true
          end

      if dicetype[1] == 'Attack' and attackerRolled == false or dicetype[1] == 'Defense' and defenderRolled == false
      or dicetype[1] != 'Attack' and dicetype[1] != 'Defense' and attackerRolled == false and defenderRolled == false then
          printToAll(object.getName() .. ' is rolling ' .. dicetype[1] .. ' dice.', {0,1,1})
          local Flipped, Flip, Rotation = isFlipped(object)
          if Flipped == true and dicetype[4] > 7 then
              dicetype[2] = 5
              dicetype[3] = 8
          else
              if Flipped == false and dicetype[4] > 7 then
                  dicetype[2] = 1
                  dicetype[3] = 4
              end
          end
          for i=dicetype[2], dicetype[3] do
              for t=1, Data[dicetype[4]][i] do
                  if dicetype[3] > 6 then
                      SpawnDice(Dice_Status[i-4][1],true,0,1)
                  else
                      SpawnDice(Dice_Status[i][1],true,0,1)
                  end
              end
          end
          if dicetype[1] == 'Attack' then
              attackerRolled = true
          end
          if dicetype[1] == 'Defense' then
              defenderRolled = true
          end
      end
      else
          printToAll('Changed ' .. dicetype[1] .. ' dice of ' .. object.getName(), {1,0,1})
          object.setTable('Details', Data)
      end
    else
      broadcastToAll("Discard Stun first", "Yellow")
    end
end

function Hero_Extra(object, playerColor)
    Add_Extra_Dice(object, playerColor, 12)
end

function Add_Extra_Yellow()
  SpawnDice(Dice_Status[1][1], false)
  printToAll('Rolling an extra ' .. Dice_Status[1][1] .. ' die.', {0,1,1})
  Dice_Status['Extra'][1] = true
end

function Add_Extra_Blue()
  SpawnDice(Dice_Status[2][1], false)
  printToAll('Rolling an extra ' .. Dice_Status[2][1] .. ' die.', {0,1,1})
  Dice_Status['Extra'][1] = true
end

function Add_Extra_Green()
  SpawnDice(Dice_Status[3][1], false)
  printToAll('Rolling an extra ' .. Dice_Status[3][1] .. ' die.', {0,1,1})
  Dice_Status['Extra'][1] = true
end

function Add_Extra_Red()
  SpawnDice(Dice_Status[4][1], false)
  printToAll('Rolling an extra ' .. Dice_Status[4][1] .. ' die.', {0,1,1})
  Dice_Status['Extra'][1] = true
end

function Add_Extra_Black()
  SpawnDice(Dice_Status[5][1], false)
  printToAll('Rolling an extra ' .. Dice_Status[5][1] .. ' die.', {0,1,1})
  Dice_Status['Extra'][1] = true
end

function Add_Extra_White()
  SpawnDice(Dice_Status[6][1], false)
  printToAll('Rolling an extra ' .. Dice_Status[6][1] .. ' die.', {0,1,1})
  Dice_Status['Extra'][1] = true
end

function Add_Extra_Dice(object, playerColor, Start)
    --START NOT NEEDED FLIP REDO?
    Flip = 1
    if object.getRotation()[3] > 90 then
        Flip = -1
    end
    --if Dice_Status['Roll'][1] == true then return end
    for i=1, 6 do
        _G['Extra' .. i .. 'Pressed'] = function (object, sPlayer)
            --if Dice_Status['Extra'][1] == true then return end
            SpawnDice(Dice_Status[i][1], false)
            printToAll(object.getName() .. ' is rolling an extra ' .. Dice_Status[i][1] .. ' die.', {0,1,1})
            Dice_Status['Extra'][1] = true
            Spawn(object, playerColor, true)
        end
        local params = {
            label = '', click_function = 'Extra' .. i .. 'Pressed', width = 100, height=100, font_size = 100, function_owner = nil
        }
        params.index = i
        params.color = stringColorToRGB(Dice_Status[i][1])
        if Start == 12 then
     if i < 4 then
                params.position = {1.4 * Flip,0.1 * Flip, (0.6 + i * 0.2) }
            else
                params.position = {1.6 * Flip,0.1 * Flip, (0.6 + (i - 3)  * 0.2) }
            end
        else
        params.position = {-0.7 + i * 0.2, 0.1, 2.1}

        end
  if Flip < 0 then params.rotation = {0,0, 180} else params.rotation = {0,0,0} end object.createButton(params)
    end
end



--diecolor = color of die to rollDice
--extra = true = nomral outside post and false = CENTER
--Side  = 0  = hero = ride side, 180 = left
--Type 1 = Hero 0 = Villian
function SpawnDice(DieColor, Extra, Side, Type)
    --DO I NEED TYPE WHEN I SUPPLY SIDE?
    NumberofDice = 1
    for i, die in ipairs(currentDice) do
        if Side == die.getVar('Side') then
            NumberofDice = NumberofDice + 1
        end
    end

    local angleStep = (180 / NumberofDice)

    local Die_Parameters = {}
    Die_Parameters.type = 'Custom_Model'
    Die_Parameters.rotation = randomRotation()

    if Extra == true then
        --right side = 180 here
        Die_Parameters.position = findGlobalPosWithLocalDirection(pad, 180)
    else
        Die_Parameters.position = findGlobalPosWithLocalDirection(pad, 180)
    end
    Die_Parameters.scale = {0.5,0.5,0.5}

    local Die_Info = {}
    Die_Info.mesh = 'https://steamusercontent-a.akamaihd.net/ugc/820128333702548484/63B0143C657B0D87FA13CD01686A53BC06D76080/'
    if DieColor == 'Red' then Die_Info.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/820128333702530310/6D24DACD0A2EDB04E40AF3EC35672438A5FF6087/' end
    if DieColor == 'Green' then Die_Info.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/820128333702528626/43145E5CB8173B477D4B7B1C3E0B1B4F98CD7E6C/' end
    if DieColor == 'Yellow' then Die_Info.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/820128333702529128/1875FA363BE1434FF57F726C1BEA4F30460D0152/' end
    if DieColor == 'Blue' then Die_Info.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/820128333702528266/8A5E3E691E3DB3F050A664573CE4D4A8447EAB3E/' end
    if DieColor == 'Black' then Die_Info.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/820128333702527933/9E773AAD7BF9A5A36AF873F82A022697544D171E/' end
    if DieColor == 'White' then Die_Info.diffuse = 'https://steamusercontent-a.akamaihd.net/ugc/820128333702529520/394BC328943F5C3BE24A40591EA17C9D634E1974/' end
    if DieColor == 'Null' then return nil end

    Die_Info.type = 2
    Die_Info.collider = 'https://steamusercontent-a.akamaihd.net/ugc/973236088945930461/D194C94BD2C04C84E60DCC872F8ADBF99E5B0B8E/'

    if Extra == true then

        NumberofDice = 1
        for i, die in ipairs(currentDice) do
            if Side == die.getVar('Side') then
                local pos = findGlobalPosWithLocalDirection(pad, die.getVar('Side') + angleStep*(NumberofDice))
                die.setPositionSmooth(pos, false, true)
                NumberofDice = NumberofDice + 1
            end
        end
    end

    local Spawned_Die = spawnObject(Die_Parameters)
    Spawned_Die.setCustomObject(Die_Info)
    Spawned_Die.setRotationValues(RotationValues)
    Spawned_Die.sticky = false

    table.insert(currentDice, Spawned_Die)

    Spawned_Die.setLock(true)
    Spawned_Die.setName(DieColor)
    if Extra == false then
        Spawned_Die.setVar('Extra',true)
    end

    if Type == 1 then
        Dice_Status['Hero'][1] = true
    end
    if Type == 0 then
        Dice_Status['Villain'][1] = true
    end

    Spawned_Die.setVar('Roll', true)
    Spawned_Die.setVar('Side',Side)
    Spawned_Die.setDescription('AutoRoller')





    Timer.destroy("Roller_"..pad.getGUID())
    Timer.create({
        identifier="Roller_"..pad.getGUID(), delay=0.5,
        function_name="rollDice", function_owner=self
    })

    return Spawned_Die
end

function ModifyBattle(player, option, id)
  if id == "ADamage" then
    printToAll(player.steam_name .. " has added a damage power token", "Red")
    newDamage = newDamage + 1
    UI.setAttribute("DamageMod", "active", "true")
    UI.setAttribute("ADamage", "active", "false")
    local to = getObjectFromGUID(UI.getAttribute("AToken", "text"))
    to.call('onClick', "Damage")
  end
  if id == "ASurge" then
    printToAll(player.steam_name .. " has added a surge power token", "Red")
    newSurge = newSurge + 1
    UI.setAttribute("SurgeMod", "active", "true")
    UI.setAttribute("ASurge", "active", "false")
    local to = getObjectFromGUID(UI.getAttribute("AToken", "text"))
    to.call('onClick', "Surge")
  end
  if id == "DEvade" then
    printToAll(player.steam_name .. " has added an evade power token", "Red")
    newEvade = newEvade + 1
    UI.setAttribute("EvadeMod", "active", "true")
    UI.setAttribute("DEvade", "active", "false")
    local to = getObjectFromGUID(UI.getAttribute("DToken", "text"))
    to.call('onClick', "Evade")
  end
  if id == "DBlock" then
    printToAll(player.steam_name .. " has added a block power token", "Red")
    newBlock = newBlock + 1
    UI.setAttribute("BlockMod", "active", "true")
    UI.setAttribute("DBlock", "active", "false")
    local to = getObjectFromGUID(UI.getAttribute("DToken", "text"))
    to.call('onClick', "Block")
  end
  if id == "Damage" then
    if option == '-2' then
      newDamage = -1 + newDamage
      printToAll(player.steam_name .. " has removed a damage from the calculations", "Red")
    else
      newDamage = 1 + newDamage
      printToAll(player.steam_name .. " has added a damage to the calculations", "Red")
    end
  end
  if id == "Surge" then
    if option == '-2' then
      newSurge = -1 + newSurge
      printToAll(player.steam_name .. " has removed a surge from the calculations", "Red")
    else
      newSurge = 1 + newSurge
      printToAll(player.steam_name .. " has added a surge to the calculations", "Red")
    end
  end
  if id == "Evade" then
    if option == '-2' then
      newEvade = -1 + newEvade
      printToAll(player.steam_name .. " has removed an evade from the calculations", "Red")
    else
      newEvade = 1 + newEvade
      printToAll(player.steam_name .. " has added an evade to the calculations", "Red")
    end
  end
  if id == "Block" then
    if option == '-2' then
      newBlock = -1 + newBlock
      printToAll(player.steam_name .. " has removed a block from the calculations", "Red")
    else
      newBlock = 1 + newBlock
      printToAll(player.steam_name .. " has added a block to the calculations", "Red")
    end
  end
  displayResults()
end

function displayResults()

    local Range = 0
    local Attack = 0
    local Surge = 0
    local Block = 0
    local Evade = 0
    local DTotal = 0
    local STotal = 0

    for i, die in ipairs(currentDice) do
        if die != nil then
            local ddescriptor = ''
            Range = Range + Die_Reference[die.getName()][die.getValue()][1]
            if Die_Reference[die.getName()][die.getValue()][1] > 0 then
              ddescriptor = 'Range: '.. Die_Reference[die.getName()][die.getValue()][1] .. ', '
            end
            Attack = Attack + Die_Reference[die.getName()][die.getValue()][2]
            if Die_Reference[die.getName()][die.getValue()][2] > 0 then
              ddescriptor = ddescriptor .. 'Damage: '.. Die_Reference[die.getName()][die.getValue()][2] .. ', '
            end
            Surge = Surge + Die_Reference[die.getName()][die.getValue()][3]
            if Die_Reference[die.getName()][die.getValue()][3] > 0 then
              ddescriptor = ddescriptor .. 'Surge: '.. Die_Reference[die.getName()][die.getValue()][3]
            end
            Block = Block + Die_Reference[die.getName()][die.getValue()][4]
            if Die_Reference[die.getName()][die.getValue()][4] > 0 then
              if  Die_Reference[die.getName()][die.getValue()][4] > 90 then
                ddescriptor = 'Block: X'
              else
                ddescriptor = 'Block: '.. Die_Reference[die.getName()][die.getValue()][4] .. ', '
              end
            else
              if die.getName() == 'White' and  Die_Reference[die.getName()][die.getValue()][4] == 0 then
                ddescriptor = 'Block: 0'
              end
            end
            Evade = Evade + Die_Reference[die.getName()][die.getValue()][5]
            if Die_Reference[die.getName()][die.getValue()][5] > 0 then
              ddescriptor = ddescriptor .. 'Evade: '.. Die_Reference[die.getName()][die.getValue()][5]
            end
            if string.sub(ddescriptor, string.len(ddescriptor)-1, string.len(ddescriptor)) == ', ' then
              ddescriptor = string.sub(ddescriptor, 1, string.len(ddescriptor)-2)
            end
            printToAll('['..die.getName()..'] '..ddescriptor, {255,255,255})
            self.UI.setAttributes("D"..i, {image = die.getName()..die.getValue()})
            self.UI.setAttributes("D"..i, {active = "true"})
        end
    end
    if Block > 90 then
        Block = '*'
        playsound(105)
    else
      Block = Block + newBlock
      if Block < 0 then Block = 0 newBlock = newBlock + 1 end
    end

    Surge = Surge + newSurge
    Evade = Evade + newEvade
    Attack = Attack + newDamage

    if Surge < 0 then Surge = 0 newSurge = newSurge + 1 end
    if Evade < 0 then Evade = 0 newEvade = newEvade + 1 end
    if Attack < 0 then Attack = 0 newDamage = newDamage + 1 end

    UI.setAttribute("Surge", "color", "#FFFFFF")
    UI.setAttribute("Evade", "color", "#FFFFFF")
    UI.setAttribute("Range", "color", "#FFFFFF")

    if UI.getAttribute("AWeakened", "active") == "true" then
      if Surge > 0 then
        Surge = Surge - 1
        UI.setAttribute("Surge", "color", "#FFA500")
        UI.setAttribute("WeakenedMod2", "active", "true")
      end
    end

    if UI.getAttribute("DWeakened", "active") == "true" then
      if Evade > 0 then
        Evade = Evade - 1
        UI.setAttribute("Evade", "color", "#FFA500")
        UI.setAttribute("WeakenedMod", "active", "true")
      end
    end

    if UI.getAttribute("AHidden", "active") == "true" then
      Surge = Surge + 1
      UI.setAttribute("Surge", "color", "#FFA500")
      UI.setAttribute("HiddenMod", "active", "true")
      local to = getObjectFromGUID(UI.getAttribute("AToken", "text"))
      to.call('onClick', "Hidden")
    end

    if UI.getAttribute("DHidden", "active") == "true" then
      Range = Range - 2
      UI.setAttribute("Range", "color", "#FFA500")
    end

    if Block != '*' then
      if Block > 4 then
        playsound(104)
      end
    end

    self.UI.setAttributes("Range", {text = "Range: "..Range})
    --printToAll('Range: ' .. Range,{255,255,255})
    self.UI.setAttributes("Damage", {text = Attack})
    --printToAll('Attack: ' .. Attack,{255,255,255})
    self.UI.setAttributes("Surge", {text = Surge})
    --printToAll('Surge: ' .. Surge,{255,255,255})
    self.UI.setAttributes("Block", {text = Block})
    --printToAll('Block: ' .. Block,{255,255,255})
    self.UI.setAttributes("Evade", {text = Evade})
    --printToAll('Evade: ' .. Evade,{255,255,255})
    STotal = Surge - Evade
    if STotal < 0 then
      STotal = 0
    end
    self.UI.setAttributes("STotal", {text = STotal})
    if Block == '*' then
      DTotal = 'X'
      playsound(105)
    else
      DTotal = Attack - Block
      if DTotal < 0 then
        DTotal = 0
      end
    end
    self.UI.setAttributes("DTotal", {text = DTotal})

    Pos = pad.getPosition()
    pad.clearButtons()
    pad.createButton({label = 'Range:' .. Range, click_function = 'Null', rotation = {0, 180, 0},
    position = {0, 0.1,-2.5}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {0,1,0}})
    pad.createButton({label = 'Attack:' .. Attack, click_function = 'Null', rotation = {0, 180, 0},
    position = {1, 0.1, -2}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {1,0,0}})
    pad.createButton({label = 'Surge:' .. Surge, click_function = 'Null', rotation = {0, 180, 0},
    position = {1, 0.1, -2.3}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {1,1,0}})
    pad.createButton({label = 'Block:' .. Block, click_function = 'Null', rotation = {0, 180, 0},
    position = {-1, 0.1, -2}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {0,1,1}})
    pad.createButton({label = 'Evade:' .. Evade, click_function = 'Null', rotation = {0, 180, 0},
    position = {-1, 0.1, -2.3}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {1,0,1}})

    pad.createButton({label = 'Range:' .. Range, click_function = 'Null', rotation = {0, 0, 0},
    position = {0, 0.1,2.5}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {0,1,0}})
    pad.createButton({label = 'Attack:' .. Attack, click_function = 'Null', rotation = {0, 0, 0},
    position = {-1, 0.1, 2}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {1,0,0}})
    pad.createButton({label = 'Surge:' .. Surge, click_function = 'Null', rotation = {0, 0, 0},
    position = {-1, 0.1, 2.3}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {1,1,0}})
    pad.createButton({label = 'Block:' .. Block, click_function = 'Null', rotation = {0, 0, 0},
    position = {1, 0.1, 2}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {0,1,1}})
    pad.createButton({label = 'Evade:' .. Evade, click_function = 'Null', rotation = {0, 0, 0},
    position = {1, 0.1, 2.3}, width = 0, height = 0, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self, font_color = {1,0,1}})


    pad.createButton({label = 'Clean Up', click_function = 'ClearDice', rotation = {0, 180, 0},
    position = {0, 0.1, -2.1}, width = 455, height = 125, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 100, function_owner = self})
    pad.createButton({label = 'Clean Up', click_function = 'ClearDice', rotation = {0, 0, 0},
    position = {0, 0.1, 2.1}, width = 455, height = 125, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 100, function_owner = self})
    self.UI.setAttributes("ClearDiceP",{active = "true"})
end

function removeDie(sender,e)
  for i, die in ipairs(currentDice) do
      if "D"..i == e then
          printToAll("A ".. die.getName().." die was removed from the calculations", "Red")
          die.destruct()
          self.UI.setAttributes(e, {active = false})
          monitorDice()
      end
  end
end

function Null()

end

function monitorDice()
    function coroutine_monitorDice()
        repeat
            local allRest = true
            for _, die in ipairs(currentDice) do
                if die ~= nil and die.resting == false then
                    allRest = false
                end
                if die ~= nil and die.getPosition().y > 20 then
                  allRest = false
                end
            end
            coroutine.yield(0)
        until allRest == true

        --Announcement

        displayResults()

        Dice_Status['Roll'][1] = false

                return 1
    end
    startLuaCoroutine(self, "coroutine_monitorDice")
end


function rollDice()
        for _, die in ipairs(currentDice) do
            if die.getVar('Roll') == true then
                die.setLock(false)
                die.randomize()
                die.setVar('Roll', false)
            end
        end
    if Dice_Status['Roll'][1] == false then
        monitorDice()
        Dice_Status['Roll'][1] = true
    end
end

function ClearDice()
    pad.clearButtons()
    self.UI.setAttributes("ClearDiceP",{active = "false"})
    for i, die in ipairs(currentDice) do
        if die != nil then
            die.destruct()
            self.UI.setAttributes("D"..i, {active = false})
        end
    end
    Dice_Status['Hero'][1] = false
    Dice_Status['Villain'][1] = false
    Dice_Status['Extra'][1] = false
    currentDice = {}
    cleardicenow = false
    attackerRolled = false
    UI.setAttribute("AName", "active", "false")
    UI.setAttribute("A_totalhp", "active", "false")
    UI.setAttribute("A_hp_bar", "active", "false")
    stats = {"Weakened", "Hidden", "Damage", "Surge"}
    for i=1,4 do
      UI.setAttribute("A"..stats[i], "active", "false")
    end
    defenderRolled = false
    UI.setAttribute("DName", "active", "false")
    UI.setAttribute("D_totalhp", "active", "false")
    UI.setAttribute("D_hp_bar", "active", "false")
    stats = {"Weakened", "Hidden", "Block", "Evade"}
    for i=1,4 do
      UI.setAttribute("D"..stats[i], "active", "false")
    end
    printToAll('Dice tray is now empty', {1,0,1})
    Timer.destroy("cleanup_"..pad.getGUID())
    UI.setAttribute("BlockMod", "active", "false")
    UI.setAttribute("DamageMod", "active", "false")
    UI.setAttribute("SurgeMod", "active", "false")
    UI.setAttribute("EvadeMod", "active", "false")
    UI.setAttribute("HiddenMod", "active", "false")
    UI.setAttribute("WeakenedMod", "active", "false")
    UI.setAttribute("WeakenedMod2", "active", "false")
    newBlock = 0
    newDamage = 0
    newEvade = 0
    newSurge = 0
end

function onObjectPickUp(playerColor, obj)

end

function onObjectRandomize(obj, player_color)
    if obj.tag == "Dice" then
        local objDesc = obj.getDescription()
        if objDesc == 'AutoRoller' then
            if Dice_Status['Roll'][1] == false then
                pad.clearButtons()
                Timer.destroy("cleanup_"..pad.getGUID())
                monitorDice()
                Dice_Status['Roll'][1] = true
            end
        end
    end
end

function updateThreat()
  if Threat <= 20 then
  else Threat = 20
  end
  self.UI.setAttributes("Threatvalue",{text = Threat})
  printToAll("Threat is now "..tostring(Threat), "White")
end

function ThreatSub(player, option, id)
    if player.color == "Black" then
      if Threat > 0 then
        Threat = Threat-1
        updateThreat()
      else
        printToAll("You don't have enough threat", "White")
      end
    end
end

function ThreatAdd(player, option, id)
    if player.color == "Black" then
      if Threat < 20 then
        Threat = Threat+1
        updateThreat()
      else
        printToAll("You are at maximum threat", "White")
      end
    end
end

function ThreatLevelAdd(player, option, id)
    if player.color == "Black" then
      if ThreatLevel < 6 then
        ThreatLevel = ThreatLevel+1
        playsound(112)
      else
        ThreatLevel = 2
      end
      updateThreatLevel()
    end
end

function updateThreatLevel()
    self.UI.setAttributes("ThreatLevelvalue",{text = ThreatLevel})
    printToAll("Threat Level is now "..tostring(ThreatLevel), "White")
end

function ToggleThreatButtons()
  if self.UI.getAttributes("Threatdown","active") == false then
    self.UI.setAttributes("Threatdown",{active = "true"})
    self.UI.setAttributes("Threatup",{active = "true"})
  else
    self.UI.setAttributes("Threatdown",{active = "true"})
    self.UI.setAttributes("Threatup",{active = "true"})
  end
end

function EndofRound(player, option, id)
  if player.color == "Black" then
    --Flip all activation tokens
    flipATs()
    timeron = false
    time = 300
    --Now add Threat Level to Threat and increase round by 1
    printToAll('End of Round '..tostring(Round), {1,0,0})
    if Round < 20 then
      Round = Round + 1
      Threat = Threat + ThreatLevel
      playsound(106)
    else
      Round = 1
      Threat = 0
    end
    setRound(Round)
    updateThreat()
  end
end

function flipATs()
  for i=1,9 do
    UI.setAttributes("P"..i.."_AT", {image='Activation_Start', tooltip="Start Turn"})
    UI.setAttributes("P"..i.."_AT2", {image='Activation_Start', tooltip="Start Second Turn"})
  end
  for i=1,16 do
    UI.setAttributes("G"..i.."_AT", {image='Activation_Start', tooltip="Start Turn"})
  end
end

function getRound()
  return Round
end

function getThreatLevel()
  return ThreatLevel
end

function getThreat()
  return Threat
end

function getCredits()
  return RebelCredits
end

function getXP()
  return RebelXP
end

function setRound(rnd)
  Round = rnd
  self.UI.setAttributes("Round Value",{text = Round})
end

function setThreatLevel(tl)
  ThreatLevel = tl
  self.UI.setAttributes("ThreatLevelvalue",{text = ThreatLevel})
end

function setThreat(t)
  Threat = t
  self.UI.setAttributes("Threatvalue",{text = Threat})
end

function setCredits(c)
  RebelCredits = c
  self.UI.setAttributes("CreditsUpB",{text = RebelCredits})
end

function setXP(x)
  RebelXP = x
  self.UI.setAttributes("XPUpB",{text = RebelXP})
end

function updateStatus(params)
  local pf
  pf = params.pf
  if params.off == true then
    self.UI.setAttributes(pf..params.ns,{active = "false"})
  else
    self.UI.setAttributes(pf..params.ns,{active = "true"})
  end
end

function RemoveStatus(player, option, id)
  local pf
  if string.sub(id,3,3) == "U" then
    pf = string.sub(id,1,4)
  else
    pf = string.sub(id,1,2)
  end
  local to = getObjectFromGUID(self.UI.getAttribute(pf.."_tobject","text"))
  local stat = string.sub(id,string.len(pf)+1,string.len(id))
  to.call('onClick', stat)
  --self.UI.setAttributes(id,{active = "false"})
end

function ShowStatus(player, option, id)
  local pf
  if string.sub(id,3,3) == "U" then
    pf = string.sub(id,1,4)
  else
    pf = string.sub(id,1,2)
  end
  --local to = getObjectFromGUID(self.UI.getAttribute(pf.."_tobject","text"))
  local statNames = {'Weakened', 'Stunned', 'Focused', 'Hidden', 'Bleeding', 'Block', 'Damage', 'Surge', 'Evade'}
  for i,j in pairs(statNames) do
    if self.UI.getAttribute(pf..j, "active") ==  "true" then
      self.UI.setAttributes(pf..j, {active = "false"})
      Global.call('updateStatus',{ns = j, pf = pf, off = true})
    else
      self.UI.setAttributes(pf..j, {active = "true", onclick = "AddStatus"})
      Global.call('updateStatus',{ns = j, pf = pf, off = false})
    end
  end
  Global.call('updateStatus',{ns = 'AddStatus', pf = pf, off = true})
  --      Global.call('updateStatus',{ns = i, pf = prefix, off = true})
  --local stat = 'Stunned'
  --to.call('addstat', stat)
  --self.UI.setAttributes(id,{active = "false"})
end

function AddStatus(player, option, id)
  local pf
  if string.sub(id,3,3) == "U" then
    pf = string.sub(id,1,4)
  else
    pf = string.sub(id,1,2)
  end
  stat = string.sub(id,string.len(pf)+1,string.len(id))
  Global.call('updateStatus',{ns = stat, pf = pf, off = true})
  local statNames = {'Weakened', 'Stunned', 'Focused', 'Hidden', 'Bleeding', 'Block', 'Damage', 'Surge', 'Evade'}
  for i,j in pairs(statNames) do
    if self.UI.getAttribute(pf..j, "active") ==  "true" then
      self.UI.setAttributes(pf..j, {active = "false", onclick = "RemoveStatus"})
      Global.call('updateStatus',{ns = j, pf = pf, off = true})
    else
      self.UI.setAttributes(pf..j, {active = "true"})
      Global.call('updateStatus',{ns = j, pf = pf, off = false})
    end
  end
  local to = getObjectFromGUID(self.UI.getAttribute(pf.."_tobject","text"))
  to.call('addstat', stat)
  Global.call('updateStatus',{ns = 'AddStatus', pf = pf, off = false})
  --self.UI.setAttributes(id,{active = "false"})
end

function CreditsUp(player, option, id)
    if player.color != "Black" then
      RebelCredits = RebelCredits + 25
      setCredits(RebelCredits)
    else
      --WebRequest.get('https://steamusercontent-a.akamaihd.net/ugc/1322320201365313294/A149731ECA64FB440F5EE841E302FB0AF89CBC57/', function(a) webRequestCallback(a) end)
    end
end

function CreditsDown(player, option, id)
  if player.color != "Black" then
    if RebelCredits > 0 then
      RebelCredits = RebelCredits - 25
      setCredits(RebelCredits)
    end
  end
end

function XPUp(player, option, id)
    if player.color != "Black" then
      if RebelXP == null then
        RebelXP = 0
      end
      RebelXP = RebelXP + 1
      setXP(RebelXP)
    end
end

function XPDown(player, option, id)
    if player.color != "Black" then
      RebelXP = RebelXP - 1
      setXP(RebelXP)
    end
end






















--Utility functions to obtain info



--Finds a position, rotated around the Y axis, using distance you want + angle
--oPos is object pos, oRot=object rotation, distance = how far, angle = angle in degrees
function findGlobalPosWithLocalDirection(object, angle)
    local distance = 1 * object.getScale().x
    local oPos, oRot = object.getPosition(), object.getRotation()
	local posX = (oPos.x + math.sin( math.rad(angle+oRot.y) ) * distance) - 10
	local posY = oPos.y + 35
	local posZ = oPos.z + math.cos( math.rad(angle+oRot.y) ) * distance
	return {x=posX, y=posY, z=posZ}
end


--Gets a random rotation vector
function randomRotation()
    --Credit for this function goes to Revinor (forums)
    --Get 3 random numbers
    local u1 = math.random();
    local u2 = math.random();
    local u3 = math.random();
    --Convert them into quats to avoid gimbal lock
    local u1sqrt = math.sqrt(u1);
    local u1m1sqrt = math.sqrt(1-u1);
    local qx = u1m1sqrt *math.sin(2*math.pi*u2);
    local qy = u1m1sqrt *math.cos(2*math.pi*u2);
    local qz = u1sqrt *math.sin(2*math.pi*u3);
    local qw = u1sqrt *math.cos(2*math.pi*u3);
    --Apply rotation
    local ysqr = qy * qy;
    local t0 = -2.0 * (ysqr + qz * qz) + 1.0;
    local t1 = 2.0 * (qx * qy - qw * qz);
    local t2 = -2.0 * (qx * qz + qw * qy);
    local t3 = 2.0 * (qy * qz - qw * qx);
    local t4 = -2.0 * (qx * qx + ysqr) + 1.0;
    --Correct
    if t2 > 1.0 then t2 = 1.0 end
    if t2 < -1.0 then ts = -1.0 end
    --Convert back to X/Y/Z
    local xr = math.asin(t2);
    local yr = math.atan2(t3, t4);
    local zr = math.atan2(t1, t0);
    --Return result
    return {math.deg(xr),math.deg(yr),math.deg(zr)}
end

function AddBar(tokenobject, HP, Str, cardobject, playerColor, type, units,pos)
    options.hp = HP
    options.Strain = 0
    local prefix
    if playerColor != "Black" then --Rebel
      if string.find(cardobject.getDescription(), 'Deployment') then
        for i=5,9 do
          if self.UI.getAttribute("P"..i.."_Table","active") == 'false' then
            prefix = "P"..i
            break
          end
        end
      else
        for i=1,4 do
          if self.UI.getAttribute("P"..i.."_Table","active") == 'false' then
            prefix = "P"..i
            break
          end
        end
      end
    else --Imperial
      for i=1,16 do
        if self.UI.getAttribute("G"..i.."_Table","active") == 'false' then
          prefix = "G"..i
          break
        end
      end
    end
    if prefix == nil then
      printToAll('no space found in UI', 'Blue')
    end
    prepUIbars(cardobject.getName(),HP,Str,playerColor,prefix,units)
    local assets = self.UI.getCustomAssets()
    local script = self.getLuaScript()
    local xml = script:sub(script:find("XMLStart")+8, script:find("XMLStop")-1)
    local newScript = script:sub(script:find("LUAStart")+8, script:find("LUAStop")-1)
    local stats = "statNames = {"
    local xmlStats = ""
    for j,i in pairs(assets) do
      stats = stats .. i.name .. " = false, "
      xmlStats = xmlStats .. '<Button id="' .. i.name .. '" color="#FFFFFF00" active="false"><Image image="' .. i.name .. '" preserveAspect="true"></Image></Button>\n'
    end
    newScript = "--[[StartXML\n" .. xml:gsub("STATSIMAGE", xmlStats) .. "StopXML--xml]]" .. stats:sub(1, -3) .. "}\n" .. newScript
    xml = xml:gsub("STATSIMAGE", xmlStats)
    if not options.hideText and options.HP2Desc then
      object.setDescription(options.hp .. "/" .. options.hp)
    end
    newScript = newScript:gsub("health = {value = 10, max = 10}", "health = {value = " .. options.hp ..", max = " .. options.hp .. "}")
    newScript = newScript:gsub("Strain = {value = 0, max = 4}", "Strain = {value = " .. options.Strain ..", max = " .. Str .. "}")
    if playerColor != "Black" and playerColor != "White" then
      newScript = newScript:gsub('fillImageColor="#242526"', 'fillImageColor="'..whatcolor(playerColor)..'"')
    end
    newScript = newScript:gsub('cardobjectguid', cardobject.getGUID())
    if Str == 0 then
      newScript = newScript:gsub("hideStrain = false", "hideStrain = true")
    end
    if options.playerChar then
      newScript = newScript:gsub("player = false", "player = true")
      if options.HP2Desc then
        newScript = newScript:gsub("HP2Desc = false,", "HP2Desc = true,")
      end
    else
      if options.hideText then
        newScript = newScript:gsub('id="editButton" visibility=""', 'id="editButton" visibility="Black"')
        newScript = newScript:gsub('id="StrainText" visibility=""', 'id="StrainText" visibility="Black"')
      end
      if options.hideBar then
        newScript = newScript:gsub('id="progressBar" visibility=""', 'id="progressBar" visibility="Black"')
        newScript = newScript:gsub('id="progressBarS" visibility=""', 'id="progressBarS" visibility="Black"')
      end
      if options.editText then
        newScript = newScript:gsub('id="addSub" visibility=""', 'id="addSub" visibility="Black"')
        newScript = newScript:gsub('id="addSubS" visibility=""', 'id="addSubS" visibility="Black"')
        newScript = newScript:gsub('id="editPanel" visibility=""', 'id="editPanel" visibility="Black"')
      end
    end
    if string.match(cardobject.getName(), "Elite") then
      newScript = newScript:gsub('fillImageColor="#242526"', 'fillImageColor="'..whatcolor("Elite")..'"')
      --newScript = newScript:gsub("baseColor = 'Black'","baseColor = 'Purple'")
    end
    if type == 1 then --Rotate bar
      newScript = newScript:gsub("rotation = 180","rotation = 90")
    end
    if units > 1 then
      local myprefix = prefix.."U"..pos+2
      newScript = newScript:gsub("prefix = 'G'","prefix = '"..myprefix.."'")
      newScript = newScript:gsub("showBaseButtons = false","showBaseButtons = true")
      --if string.match(cardobject.getName(), "Jet") then
        --newScript = newScript:gsub("{255,255,255,100}","{0,0,0,100}")
      --end
      if string.match(cardobject.getName(), "Royal Guard") or string.match(cardobject.getName(), "Loth") then
        newScript = newScript:gsub("position = {0.3, 0.30, 0.4}","position = {0.3, 0.30, 1.4}")
      end
      newScript = newScript:gsub("single = true","single = false")
    else
      if playerColor != "Black" and tonumber(string.sub(prefix,2,2)) < 5 then
        newScript = newScript:gsub("prefix = 'G'","prefix = '"..prefix.."'")
      else
        newScript = newScript:gsub("prefix = 'G'","prefix = '"..prefix.."U1'")
      end
    end
    samecard = 0
    for i=1,16 do
      if self.UI.getAttribute("G"..i.."_name","text") == cardobject.getName() and self.UI.getAttribute("G"..i.."_cobject", "text") ~= cardobject.guid then
        samecard = samecard + 1
        if self.UI.getAttribute("G"..i.."U1_hp_bar","fillImageColor") == "#FF4500" then
          uc = self.UI.getAttribute("G"..i.."U2_hp_bar","fillImageColor")
        else
          uc = self.UI.getAttribute("G"..i.."U1_hp_bar","fillImageColor")
        end

      end
    end
    if samecard > 0 then
      if uc == "#696969" then
        newScript = newScript:gsub("baseColor = 'Black'","baseColor = 'Teal'")
        newScript = newScript:gsub('fillImageColor="#242526"', 'fillImageColor="'..whatcolor("Teal")..'"')
      else
        newScript = newScript:gsub("baseColor = 'Black'","baseColor = 'Grey'")
        newScript = newScript:gsub('fillImageColor="#242526"', 'fillImageColor="'..whatcolor("Grey")..'"')
      end
    end
    if string.match(cardobject.getName(), "Onar") or string.match(cardobject.getName(), "Gaarkhan") then
      newScript = newScript:gsub('heightModifier = 110', 'heightModifier = 150')
    else
      newScript = newScript:gsub('heightModifier = 110', 'heightModifier = 130')
      newScript = newScript:gsub('<Panel id="panel" position="0 0 -220"', '<Panel id="panel" position="0 0 ' .. tokenobject.getBounds().size.y / tokenobject.getScale().y * 110 .. '"')
    end

    tokenobject.setLuaScript(newScript)


    --Function that will be watched until it becomes true
    --local readyYET = function() return tokenobject.spawning end

    --local asdf = function() return cbBar(tokenobject, cardobject, prefix, whatcolor(playerColor)) end

        --Plug those two functions into the Wait function
    --Wait.condition(asdf, readyYET)
    --printToAll(cardobject.getName(), "Red")
    --printToAll(tokenobject.spawning, "Red")
    --Wait.condition(cbBar(tokenobject), ready_yet(tokenobject))
    --printToAll(tokenobject.guid, "Red")


    -- Wait.time(function()
    --   object.UI.setAttribute("panel", "position", "0 0 -" .. object.getBounds().size.y / object.getScale().y * 110)
    -- end, 1)

end

function AddBarObject(object, HP)
  local assets = self.UI.getCustomAssets()
  local script = self.getLuaScript()
  local xml = script:sub(script:find("XMLStart")+8, script:find("XMLStop")-1)
  local newScript = script:sub(script:find("LUAStart")+8, script:find("LUAStop")-1)
  local stats = "statNames = {"
  local xmlStats = ""
  if HP == 'tl' then
    HP = tostring(ThreatLevel)
  end
  if HP == '2tl' then
    HP = tostring(ThreatLevel*2)
  end
  if HP == '5+2tl' then
    HP = tostring(ThreatLevel*2 + 5)
  end
  if HP == '2+tl' then
    HP = tostring(ThreatLevel + 2)
  end
  if HP == '6+tl' then
    HP = tostring(ThreatLevel + 6)
  end
  options.hp = HP
  for j,i in pairs(assets) do
    stats = stats .. i.name .. " = false, "
    xmlStats = xmlStats .. '<Button id="' .. i.name .. '" color="#FFFFFF00" active="false"><Image image="' .. i.name .. '" preserveAspect="true"></Image></Button>\n'
  end
  newScript = "--[[StartXML\n" .. xml:gsub("STATSIMAGE", xmlStats) .. "StopXML--xml]]" .. stats:sub(1, -3) .. "}\n" .. newScript
  xml = xml:gsub("STATSIMAGE", xmlStats)

  newScript = newScript:gsub("health = {value = 10, max = 10}", "health = {value = " .. options.hp ..", max = " .. options.hp .. "}")
  newScript = newScript:gsub("Strain = {value = 0, max = 4}", "Strain = {value = 0, max = 0}")
  newScript = newScript:gsub("hideStrain = false", "hideStrain = true")
  if options.playerChar then
    newScript = newScript:gsub("player = false", "player = true")
    if options.HP2Desc then
      newScript = newScript:gsub("HP2Desc = false,", "HP2Desc = true,")
    end
  else
    if options.hideText then
      newScript = newScript:gsub('id="editButton" visibility=""', 'id="editButton" visibility="Black"')
      newScript = newScript:gsub('id="StrainText" visibility=""', 'id="StrainText" visibility="Black"')
    end
    if options.hideBar then
      newScript = newScript:gsub('id="progressBar" visibility=""', 'id="progressBar" visibility="Black"')
      newScript = newScript:gsub('id="progressBarS" visibility=""', 'id="progressBarS" visibility="Black"')
    end
    if options.editText then
      newScript = newScript:gsub('id="addSub" visibility=""', 'id="addSub" visibility="Black"')
      newScript = newScript:gsub('id="addSubS" visibility=""', 'id="addSubS" visibility="Black"')
      newScript = newScript:gsub('id="editPanel" visibility=""', 'id="editPanel" visibility="Black"')
    end
  end
  newScript = newScript:gsub("rotation = 180","rotation = 90")
  newScript = newScript:gsub("showBarButtons = false","showBarButtons = true")
  newScript = newScript:gsub("single = true","single = false")
  newScript = newScript:gsub('<Panel id="panel" position="0 0 -220"', '<Panel id="panel" position="0 0 ' .. object.getBounds().size.y / object.getScale().y * 110 .. '"')
  if string.match(object.getName(), "Door") then
  else
    newScript = newScript:gsub('scale="0.7 0.7"','scale="0.3 0.3"')
  end
  object.setLuaScript(newScript)
end

function prepUIbars(Name,HP,Strain,playerColor,prefix,units)
  if string.len(prefix) > 3 then
    prefix = string.sub(prefix, 1, string.find(prefix,"U")-1)
  end
  self.UI.setAttributes(prefix.."_Table",{active = "true"})
  self.UI.setAttributes(prefix.."_Name",{text = Name, tooltip="Change to Increase", tooltipPosition="Above"})
  color = whatcolor(playerColor)
  if playerColor != "Black" then
    if tonumber(string.sub(prefix,2,2)) > 4 then
      for i=1,units do
        self.UI.setAttributes(prefix.."U"..i.."_hp_bar",{fillImageColor = color, tooltip="Decrease HP", tooltipPosition="Right"})
        self.UI.setAttributes(prefix.."U"..i.."_totalhp",{text = HP..'/'..HP})
        self.UI.setAttributes(prefix.."U"..i.."_hp_bar",{active = "true"})
        self.UI.setAttributes(prefix.."U"..i.."AddStatus",{active = "true", tooltip="Add Condition", tooltipPosition="Below"})
        self.UI.setAttributes(prefix.."_Name_cell",{columnspan = units+2})
        if i == 1 then
          self.UI.setAttributes(prefix.."U2_hp_bar",{percentage = "0"})
          self.UI.setAttributes(prefix.."U3_hp_bar",{percentage = "0"})
          self.UI.setAttributes(prefix.."U2_hp_bar",{active = "false"})
          self.UI.setAttributes(prefix.."U3_hp_bar",{active = "false"})
          self.UI.setAttributes(prefix.."U2AddStatus",{active = "false"})
          self.UI.setAttributes(prefix.."U3AddStatus",{active = "false"})
        end
        if i == 2 then
          self.UI.setAttributes(prefix.."_selector",{active = "true", tooltip="Select Unit", tooltipPosition="Left"})
          self.UI.setAttributes(prefix.."U1_hp_bar",{fillImageColor = "#FF4500"})
        end
      end
    else
      self.UI.setAttributes(prefix.."_hp_bar",{fillImageColor = color, tooltip="Decrease HP", tooltipPosition="Right"})
      self.UI.setAttributes(prefix.."_totalhp",{text = HP..'/'..HP})
      self.UI.setAttributes(prefix.."_totalstrain",{text = '0/'..Strain, tooltip="Decrease Strain", tooltipPosition="Right"})
      self.UI.setAttributes(prefix.."AddStatus",{active = "true", tooltip="Add Condition", tooltipPosition="Below"})
    end
  else
    for i=1,units do
      self.UI.setAttributes(prefix.."U"..i.."_hp_bar",{fillImageColor = color, tooltip="Decrease HP", tooltipPosition="Right"})
      self.UI.setAttributes(prefix.."U"..i.."_totalhp",{text = HP..'/'..HP, percentage = "100"})
      self.UI.setAttributes(prefix.."U"..i.."_hp_bar",{active = "true"})
      self.UI.setAttributes(prefix.."U"..i.."AddStatus",{active = "true", tooltip="Add Condition", tooltipPosition="Below"})
      self.UI.setAttributes(prefix.."_Name_cell",{columnspan = units+1})
      if i == 1 then
        self.UI.setAttributes(prefix.."U2_hp_bar",{percentage = "0"})
        self.UI.setAttributes(prefix.."U3_hp_bar",{percentage = "0"})
        self.UI.setAttributes(prefix.."U2_hp_bar",{active = "false"})
        self.UI.setAttributes(prefix.."U3_hp_bar",{active = "false"})
        self.UI.setAttributes(prefix.."U2AddStatus",{active = "false"})
        self.UI.setAttributes(prefix.."U3AddStatus",{active = "false"})
      end
      if i == 2 then
        self.UI.setAttributes(prefix.."_selector",{active = "true", tooltip="Select Unit", tooltipPosition="Left"})
        self.UI.setAttributes(prefix.."U1_hp_bar",{fillImageColor = "#FF4500"})
      end
    end
  end
  self.UI.setAttributes(prefix.."_Name_cell",{columnspan = units+2})
end

function SelectUnit(player, option, id)
  local prefix = string.sub(id,1,string.find(id, "_")-1)
  local units = tonumber(self.UI.getAttribute(prefix.."_units", "text"))
  if self.UI.getAttribute(id, "text") == "1" then
    old_color = self.UI.getAttribute(prefix.."U2_hp_bar","fillImageColor")
    if old_color == nil then old_color = "#242526" end
    self.UI.setAttributes(prefix.."U1_hp_bar",{fillImageColor = old_color})
    self.UI.setAttributes(prefix.."U2_hp_bar",{fillImageColor = "#FF4500"})
    self.UI.setAttributes(prefix.."_selector",{text = "2"})
  else
    if self.UI.getAttribute(id, "text") == "2" then
      if units == 2 then
        old_color = self.UI.getAttribute(prefix.."U1_hp_bar","fillImageColor")
        if old_color == nil then old_color = "242526" end
        self.UI.setAttributes(prefix.."U2_hp_bar",{fillImageColor = old_color})
        self.UI.setAttributes(prefix.."U1_hp_bar",{fillImageColor = "#FF4500"})
        self.UI.setAttributes(prefix.."_selector",{text = "1"})
      else
        old_color = self.UI.getAttribute(prefix.."U3_hp_bar","fillImageColor")
        if old_color == nil then old_color = "#242526" end
        self.UI.setAttributes(prefix.."U2_hp_bar",{fillImageColor = old_color})
        self.UI.setAttributes(prefix.."U3_hp_bar",{fillImageColor = "#FF4500"})
        self.UI.setAttributes(prefix.."_selector",{text = "3"})
      end
    else
      old_color = self.UI.getAttribute(prefix.."U1_hp_bar","fillImageColor")
      if old_color == nil then old_color = "#242526" end
      self.UI.setAttributes(prefix.."U3_hp_bar",{fillImageColor = old_color})
      self.UI.setAttributes(prefix.."U1_hp_bar",{fillImageColor = "#FF4500"})
      self.UI.setAttributes(prefix.."_selector",{text = "1"})
    end
  end
end

function whatcolor(playerColor)
  local color
  if playerColor == "Red" then
    color = "#da1918"
  end
  if playerColor == "Blue" then
    color = "#1f87ff"
  end
  if playerColor == "Green" then
    color = "#31b32b"
  end
  if playerColor == "Purple" then
    color = "#a020f0"
  end
  if playerColor == "Black" then
    color = "#242526"
  end
  if playerColor == "Grey" then
    color = "#696969"
  end
  if playerColor == "Teal" then
    color = "#00BFFF"
  end
  if playerColor == "Pink" then
    color = "#8B008B"
  end
  if playerColor == "Elite" then
    color = "#32174d"
  end
  return color
end

function rev_whatcolor(color)
  local pcolor
  if color == "#da1918" then
    pcolor = "Red"
  end
  if color == "#1f87ff" then
    pcolor = "Blue"
  end
  if color == "#31b32b" then
    pcolor = "Green"
  end
  if color == "#a020f0" then
    pcolor = "Purple"
  end
  if color == "#242526" then
    pcolor = "Black"
  end
  if color == "#D4AF37" then
    pcolor = "Black"
  end
  if color == "#696969" then
     pcolor = "Black"
  end
  if color == "#00BFFF" then
    pcolor = "Black"
  end
  if color == "#32174d" then
    pcolor = "Black"
  end
  if color == "#8B008B" then
    pcolor = "Black"
  end
  return pcolor
end

--Below this line is for the auto hp bars
function cbFBar(a, params)
    a.setName(params[2] .. ' / ' .. params[2])
    a.setVar("Token",params[1].getGUID())
    params[1].setVar('BB', a.guid)

    local p = {}  local i = {}
    p.type = "Custom_Token"
    p.position = {2, -35, -4}
    p.rotation = {90, 0, 180}
    p.callback = "cbBar"
    p.params = params
    p.callback_owner = self
    ------CBP is the BLACK BAR GUID
    -- cbp = a.guid
    local o = spawnObject(p)
    i.thickness = 0.08
    i.image = "https://sites.google.com/site/rolesystemssky/hp_bar.png"
    o.setCustomObject(i)

    a.setLuaScript('------------STARTBLACKBAR--------------\nfunction onLoad() tgl = 0 MainBtn() end\nfunction doButtons() tgl = 1 self.interactable = true local btn = {} btn.function_owner = self btn.width = 600 btn.height = 600\nbtn.click_function = \"btnIn\"  btn.label = \"-\"  btn.font_size = 600  btn.position = {5.76, 0, 0}  self.createButton(btn)\nbtn.click_function = \"btnIp\"  btn.label = \"+\"  btn.font_size = 600  btn.position = {-5.76, 0, 0}  self.createButton(btn)\nend\nfunction MainBtn() local btn = {} btn.function_owner = self  btn.width = 500  btn.height = 500 btn.click_function = \"btnTgl\"  btn.position = {0, 0, 0} self.createButton(btn) end\nfunction udoButtons() if tgl == 1 then tgl = 0 self.clearButtons() MainBtn() end end\nfunction btnTgl(d, c) if tgl == 1 then udoButtons() else doButtons() end end\nfunction btnIn() putHP(getHP() - 1) end function btnIp() putHP(getHP() + 1) end\nfunction btnMx() local m = getMax()-1 if m < 1 then m = 1 end local n = getHP() if n > m then n = m end self.setName(n..\" / \"..m) showBar() end\nfunction btnUp() getObjectFromGUID(self.getVar(\"Token\")).call(\"upBar\") showBar() end\nfunction getHP() return(tonumber(string.sub(self.getName(), 1, string.find(self.getName(), \"%/\")-1))) end\nfunction getMax() return(tonumber(string.sub(self.getName(), string.find(self.getName(), \"%/\")+1))) end\nfunction putHP(a) local m = getMax() if type(a) == "table" then a = a[1] if a < 0 then a = 0 end if a > m then a = m end else if a > m then m = a end end self.setName(a.." / "..m) showBar() end\nfunction showBar() getObjectFromGUID(self.getVar(\"Token\")).call(\"bumpHide\") getObjectFromGUID(self.getVar(\"Token\")).call(\"showBar\") end\n------------ENDBLACKBAR--------------\n')

end

function onChat(message, player)
  local number = 0
  local oParameters = {}
  local prefix = 'Core Tile '
  oParameters.type = 'Custom_Model'
  oParameters.scale = {3.00, 3.00, 3.00}

  local oInfo = {}
  oInfo.type = 0


  if string.len(message) > 5 then
    if message == 'ClearMap' then
      clearmap()
    end
    if message == "sounds off" then
      sound_effects = false
      broadcastToAll("Sounds have been turned off", "White")
    end
    if message == "sounds on" then
      sound_effects = true
      broadcastToAll("Sounds have been turned on", "White")
    end
    if message == "clips on" then
      clips = true
      broadcastToAll("Clips have been turned on", "White")
    end
    if message == "clips off" then
      clips = false
      broadcastToAll("Clips have been turned off", "White")
    end
    if string.sub(message,1,5) == 'timer' then
      if string.sub(message,7,9) != "off" then
        if string.sub(message,7,9) == "on" then
          timerstatus = true
          broadcastToAll("Timer on", "White")
        else
          timer_length = tonumber(string.sub(message,7,9))
        end
      else
        if string.sub(message,7,9) == "off" then
          timerstatus = false
          broadcastToAll("Timer off", "White")
          timeron = false
          Timer.destroy("Turn Timer")
          timerStart()
        end
      end
    end
  elseif string.len(message) > 2  or string.len(message) < 4 then
    local box = string.sub(message,1,1)
    if string.len(message) > 2 and string.lower(string.sub(message,3,3)) != 'a' and string.lower(string.sub(message,3,3)) != 'b' then
      number = tonumber(string.sub(message,2,3))
    else
      number = tonumber(string.sub(message,2,2))
    end
  if box == 'h' or box == 'H' then
    if number > 0 and number < 29 then
      oInfo.mesh = Hoth_Tiles[number][1]
      oInfo.diffuse = Hoth_Tiles[number][2]
      prefix = 'Return to Hoth '
      getObjectFromGUID('7a310a').AssetBundle.playLoopingEffect(1)
    end
  elseif box == 'j' or box == 'J' then
      if number > 0 and number < 18 then
        oInfo.mesh = JabbasRealm_Tiles[number][1]
        oInfo.diffuse = JabbasRealm_Tiles[number][2]
        prefix = 'Jabbas Realm '
      end
    elseif box == 'e' or box == 'E' then
      if number > 0 and number < 19 then
        oInfo.mesh = HOTE_Tiles[number][1]
        oInfo.diffuse = HOTE_Tiles[number][2]
        prefix = 'Heart of the Empire '
      end
    elseif box == 'c' or box == 'C' then
      if number > 0 and number < 40 then
        oInfo.mesh = Core_Tiles[number][1]
        oInfo.diffuse = Core_Tiles[number][2]
        prefix = 'Core '
      end
    elseif box == 't' or box == 'T' then
      if number > 0 and number < 13 then
        oInfo.mesh = Twin_Tiles[number][1]
        oInfo.diffuse = Twin_Tiles[number][2]
        prefix = 'Twin Shadows '
      end
    elseif box == 'b' or box == 'B' then
      if number > 0 and number < 13 then
        oInfo.mesh = Bespin_Tiles[number][1]
        oInfo.diffuse = Bespin_Tiles[number][2]
        prefix = 'Bespin Gambit '
      end
    elseif box == 'l' or box == 'L' then
      if number > 0 and number < 13 then
        oInfo.mesh = Lothal_Tiles[number][1]
        oInfo.diffuse = Lothal_Tiles[number][2]
        prefix = 'Tyrants of Lothal '
      end
    end
    if oInfo.mesh ~= null then
      --if string.find(string.lower(message),'b') then
        --oParameters.rotation = {0.0,180.0,180.0}
      --else
        --oParameters.rotation = {0.0,180.0,0.0}
      --end
      oInfo.material = 3
      oParameters.position = {92.5, 3.00, 4.5}
      local Spawned_o = spawnObject(oParameters)
      Spawned_o.setCustomObject(oInfo)
      Spawned_o.setName(prefix..number)
      Spawned_o.setDescription("Current Map")
    end
  end
end

function TokenAtk(cardguid)
  cardobject = getObjectFromGUID(cardguid)
  Attack(cardobject, "Blue")
end

function TokenDef(cardguid)
  cardobject = getObjectFromGUID(cardguid)
  Defense(cardobject, "Blue")
end

function UIButton(player, option, id)
  local pf = ""
  if string.find(id, "_") > 3 then
    if string.find(id, "_") == 4 then
      pf = string.sub(id, 1, 3)
    else
      pf = string.sub(id, 1, string.find(id, "U")-1)
    end
  else
    pf = string.sub(id, 1, string.find(id, "_")-1)
  end
  data = Cards[self.UI.getAttribute(pf.."_Name","text")]

  --cardobject = getObjectFromGUID(data[13][1][2])
  cardobject = getObjectFromGUID(self.UI.getAttribute(pf.."_cobject","text"))
  if option == "-2" then
    if string.match(id, "_name") then
      CardHighLight(self.UI.getAttribute(pf.."_cobject","text"), player.color)
    else
      TokenHighLight(getObjectFromGUID(self.UI.getAttribute(string.sub(id, 1, string.find(id, "_")-1).."_tobject","text")), player.color)
    end
  else

  if string.match(id,"_ATK") then
    Attack(cardobject, "Blue")
  end
  if string.match(id,"_DEF") then
    Defense(cardobject, "Blue")
  end

  local to = getObjectFromGUID(self.UI.getAttribute(pf.."_tobject","text"))
    if string.match(id,"_name") then
      if self.UI.getAttribute(id, "color") == "#FFFF00" then
        self.UI.setAttributes(id,{color = "#FFFFFF", tooltip = "Change to Increase"})
        self.UI.setAttributes(pf.."_hp_bar", {tooltip="Decrease HP"})
        self.UI.setAttributes(pf.."U1_hp_bar", {tooltip="Decrease HP"})
        self.UI.setAttributes(pf.."U2_hp_bar", {tooltip="Decrease HP"})
        self.UI.setAttributes(pf.."U3_hp_bar", {tooltip="Decrease HP"})
        self.UI.setAttributes(pf.."_strain_bar", {tooltip="Decrease Strain"})
      else
        self.UI.setAttributes(id,{color = "#FFFF00", tooltip = "Change to Decrease"})
        self.UI.setAttributes(pf.."_hp_bar", {tooltip="Increase HP"})
        self.UI.setAttributes(pf.."U1_hp_bar", {tooltip="Increase HP"})
        self.UI.setAttributes(pf.."U2_hp_bar", {tooltip="Increase HP"})
        self.UI.setAttributes(pf.."U3_hp_bar", {tooltip="Increase HP"})
        self.UI.setAttributes(pf.."_strain_bar", {tooltip="Increase Strain"})
      end
    end
    if string.match(id,"_totalhp") then
      if self.UI.getAttribute(pf.."_name", "color") == "#FFFF00" then
        if string.find(id, "U") != nil then
          Health_Right(cardobject, "Blue",string.sub(id,1,string.find(id, "_")-1))
        else
          Health_Right(cardobject, "Blue",string.sub(id,1,2))
        end
      else
        if string.find(id, "U") != nil then
          Health_Left(cardobject, "Blue",string.sub(id,1,string.find(id, "_")-1))
        else
          Health_Left(cardobject, "Blue",string.sub(id,1,2))
        end
      end
    end
    if string.match(id,"_totalstrain") then
      if self.UI.getAttribute(pf.."_name", "color") == "#FFFF00" then
        if string.find(id, "U") != nil then
          Strain_Right(cardobject, "Blue",string.sub(id, string.find(id, "U")+1, string.find(id, "U")+1), "Red")
        else
          Strain_Right(cardobject, "Blue",1)
        end
      else
        if string.find(id, "U") != nil then
          Strain_Left(cardobject, "Blue",string.sub(id, string.find(id, "U")+1, string.find(id, "U")+1), "Red")
        else
          Strain_Left(cardobject, "Blue",1)
        end
      end
    end
  end
end

function TokenWounded(cardguid)
  cardobject = getObjectFromGUID(cardguid)
  if self.UI.getAttribute(string.sub(cardobject.getTable('Details')[13][1][3],1,2).."_W", "active") == "false" then
    broadcastToAll(cardobject.getName().. ' has been wounded! ', "Red")
    playsound(114)
    self.UI.setAttributes(string.sub(cardobject.getTable('Details')[13][1][3],1,2).."_W", {active="true"})
    Hero_Flip(cardobject, "Blue")
  end
end

function updateUIbar(tokenguid)
  --local myprefix = cardobject.getTable('Details')[13][1][3]
  --local tokenguid = cardobject.getTable('Details')[13][1][1]
  local hp, hp_per, strain, strain_per, tokenobject, name, ats
  tokenobject = getObjectFromGUID(tokenguid)
  name = tokenobject.getName()
  hp = tokenobject.call("getHPtext")
  strain = tokenobject.call("getStext")
  hp_per = tokenobject.call("getHPPer")
  strain_per = tokenobject.call("getSPer")
  --if cardobject.getTable('Details')[13][1][4] == "#710000" then
  if string.match(name,"Door") or string.match(name,"Terminal") or string.match(name,"Station")  or string.match(name,"Barricade") or string.match(name,"Rodian")
  or string.match(name,"Battle") or string.match(name,"Structural") or string.match(name,"Beacon") or string.match(name,"Malakili") or string.match(name,"Engine") or name == "" then
  else
    ats = tokenobject.call("getATS")
  end
  myprefix = tokenobject.call("getPrefix")
  --end
  --printToAll(tokenobject.getName() .. ' health is ' .. tokenobject.call('getHP'),"White")
  if string.len(myprefix) > 2 then
    self.UI.setAttributes(string.sub(myprefix,1,string.find(myprefix, "U")-1).."_Name",{text = name})
    self.UI.setAttributes(string.sub(myprefix,1,string.find(myprefix, "U")-1).."_AT",{image = ats})
  else
    self.UI.setAttributes(myprefix.."_Name",{text = name})
    self.UI.setAttributes(myprefix.."_strain_bar",{percentage = strain_per})
    self.UI.setAttributes(myprefix.."_totalstrain",{text = strain})
    self.UI.setAttributes(myprefix.."_AT",{image = ats})
  end
  self.UI.setAttributes(myprefix.."_hp_bar",{percentage = hp_per})
  self.UI.setAttributes(myprefix.."_totalhp",{text = hp})
  if string.match(name,"Door") or string.match(name,"Terminal") or string.match(name,"Station") or string.match(name,"Barricade") or name == "" then
    if string.sub(hp,1,1) == "0" then
      explosion(tokenguid)
    end
  else
      cardguid = self.UI.getAttribute(string.sub(myprefix, 0, 2).."_cobject","text")
      units = self.UI.getAttribute(string.sub(myprefix, 0, 2).."_units","text")
      if string.sub(hp, 1, 1) == "0" and string.sub(myprefix, 1, 1) == "G" and cardguid != '' or
      string.sub(hp, 1, 1) == "0" and string.sub(myprefix, 1, 1) == "P" and tonumber(string.sub(myprefix, 2, 2)) > 4 and cardguid != '' then
        if string.match(name,"Tank") or string.match(name,"Droid") or string.match(name,'-') and not string.match(name,'cat') then
            explosion(tokenguid,units)
        else
          playsound(111)
        end
        f = string.sub(myprefix, string.len(myprefix), string.len(myprefix))
        if self.UI.getAttribute(string.sub(myprefix, 0, 2).."_selector","text") == f then
          SelectUnit(player, option, string.sub(myprefix, 0, 2).."_selector")
        end
        cp = getObjectFromGUID(self.UI.getAttribute(string.sub(myprefix, 0, 2).."_cobject","text")).getPosition()
        tokenobject.setPositionSmooth({cp.x, cp.y, cp.z + (tonumber(f)*1.5)},false,false)

        --do something with selector here? maybe change to healthy unit?
        if getObjectFromGUID(self.UI.getAttribute(string.sub(myprefix, 0, 2).."_units","text")) == '1' then
          cardo = getObjectFromGUID(cardguid)
          cardo.clearButtons()
          if string.match(name,'-') or string.match(name,"Tank") or string.match(name,"Droid") then
          else
          getObjectFromGUID(self.UI.getAttribute(string.sub(myprefix, 0, 2).."U1_tobject","text")).destruct()
          end
          self.UI.setAttributes(string.sub(myprefix, 0, 2).."_Table",{active = "false"})
          cardo.createButton({label = cardo.getName(), click_function = 'Spawn', rotation = {0, 0, 0},
          position = {0, 0.2, 0}, width = (40 * string.len(cardo.getName())), height = 100, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
        end
      if string.sub(self.UI.getAttribute(string.sub(myprefix, 0, 2).."U1_totalhp","text"),1,1) == "0" and
        string.sub(self.UI.getAttribute(string.sub(myprefix, 0, 2).."U2_totalhp","text"),1,1) == "0" and
        string.sub(self.UI.getAttribute(string.sub(myprefix, 0, 2).."U3_totalhp","text"),1,1) == "0" and
        self.UI.getAttribute(string.sub(myprefix, 0, 2).."U2_hp_bar","percentage") != "100" and
        self.UI.getAttribute(string.sub(myprefix, 0, 2).."U3_hp_bar","percentage") != "100" then
        self.UI.setAttributes(string.sub(myprefix, 0, 2).."_Table",{active = "false"}) --works
        self.UI.setAttributes(string.sub(myprefix, 0, 2).."_selector",{active = "false"})
        self.UI.setAttributes(string.sub(myprefix, 0, 2).."_selector",{text = "1"})
        units = self.UI.getAttribute(string.sub(myprefix, 0, 2).."_units","text")
        for i=1,units do
          getObjectFromGUID(self.UI.getAttribute(string.sub(myprefix, 0, 2).."U"..i.."_tobject","text")).destruct()
        end
        cardo = getObjectFromGUID(cardguid)
        cardo.clearButtons()
        cardo.createButton({label = cardo.getName(), click_function = 'Spawn', rotation = {0, 0, 0},
        position = {0, 0.2, 0}, width = (40 * string.len(cardo.getName())), height = 100, color = {0.5, 0.5, 0.5}, font_color = {1, 1, 1}, font_size = 75, function_owner = self})
      end
    end
    if string.len(hp) == 1 and string.sub(hp, 1, 1) == "1" and string.sub(myprefix, 1, 1) == "G" and string.sub(self.UI.getAttribute(myprefix.."_totalhp","text"),1,1) == "0" then
      self.UI.setAttributes(string.sub(myprefix, 0, 2).."_Table",{active = "true"}) --works
    end
  end
end

function explosion(tokenguid, units)
  local thing = getObjectFromGUID(tokenguid)
  local pos = Location(thing, 0, 0)
  pos.y = pos.y -3
  local bomb = explosions.takeObject({position = pos, smooth = false})
  bomb.setLock(true)
  bomb.AssetBundle.playTriggerEffect(0)
  playsound(115)
  if string.match(thing.getName(), "Sentry") then
    thing.setPositionSmooth(getObjectFromGUID(self.UI.getAttribute(string.sub(thing.call('getPrefix'), 1, string.find(thing.call('getPrefix'),'U')-1).."_cobject","text")).getPosition(),false,false)
  else
    if string.match(thing.getName(), "Door") or units == "1" or string.match(thing.getName(), "Terminal") or string.match(thing.getName(), "Station") or string.match(thing.getName(), "Barricade") or string.match(thing.getName(), "Holocam") or thing.getName() == "" then
      destroyObject(thing)
    else
      if units ~= 1 then

      else
        self.UI.setAttributes(string.sub(thing.call('getPrefix'), 1, string.find(thing.call('getPrefix'),'U')-1).."_Table",{active = "false"})
      end
    end
  end
end

function cbBar(tokenobject, cardobject, prefix, color)
  local data = Cards[cardobject.getName()]
  --printToAll(cardobject.getName(), "Red")
  prefix = tokenobject.call("getPrefix")
  local pfix = ""
  if string.len(prefix) > 3 then
    pfix = string.sub(prefix, 1, string.find(prefix, "U")-1)
  else
    pfix = string.sub(prefix, 1, 2)
  end

  self.UI.setAttributes(pfix.."_cobject",{text = cardobject.getGUID()})
  if tonumber(string.sub(pfix,2,2)) > 4 or string.sub(pfix, 1,1) == "G" then
    self.UI.setAttributes(prefix.."_tobject",{text = tokenobject.getGUID()})
  else
    self.UI.setAttributes(pfix.."_tobject",{text = tokenobject.getGUID()})
  end
  self.UI.setAttributes(pfix.."_units",{text = data[6]})
  self.UI.setAttributes(pfix.."_selector",{text = "1"})
  AdditonalData = {}
  AdditonalData[1] = tokenobject.getGUID()
  AdditonalData[2] = cardobject.getGUID()
  AdditonalData[3] = prefix
  AdditonalData[4] = color

  if data[17] != nil then
    addEffect(tokenobject, data[17])
  end

  table.insert(data[13], AdditonalData)

  cardobject.setTable('Details', data)
end

function addEffect(to, loffset)
  for i, offset in ipairs(loffset) do
    local pos = Location(to, 0, 0)
    pos.x = pos.x + offset[1]
    pos.y = pos.y + offset[2]
    pos.z = pos.z + offset[3]
    local color
    if offset[4] == "P" then
      color = purplel
      intensity = 8
    end
    if offset[4] == "Y" then
      color = yellowl
      intensity = 7
    end
    if offset[4] == "R" then
      color = redl
      intensity = 6
    end
    if offset[4] == "G" then
      color = greenl
      intensity = 3
    end
    if offset[4] == "B" then
      color = bluel
      intensity = 3
    end
    if offset[4] == "W" then
      color = whitel
      intensity = 1
    end
    local plight = color.takeObject({position = pos, smooth = false})
    plight.AssetBundle.playLoopingEffect(intensity)
    plight.setScale({0.1,0.1,0.1})
    to.addAttachment(plight)
  end
end

function playsound(s)
  if sound_effects == true then
    sounds.AssetBundle.playTriggerEffect(s)
  end
end

function updateTime()
    if timeron == false then
      local hour = tonumber(os.date("%I"))
      local ampm = os.date("%p")
      self.UI.setAttributes("Time", {text=hour..os.date(":%M:%S").." "..ampm})
      timerStart()
    end
end

function timerStart()
    Timer.destroy(self.getGUID())
    Timer.create({identifier=self.getGUID(), function_name='updateTime', delay=1})
end

function turntimer()
  timeron = true
  time = time - 1
  self.UI.setAttributes("Time", {text=math.floor(time/60)..':'..string.format('%02d', time%60)})
  if time == 30 then
    playsound(102)
  end
  if time == 0 then
    timeron = false
    timerStart()
  end
end
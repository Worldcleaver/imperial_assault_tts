firsttime = true
startingsize = 1
deckguid = ''
--Runs when the scripted button inside the button is clicked
function buttonPress()
  if firsttime == nil then
    firsttime = true
  end
  if startingsize == nil then
    startingsize = 1
  end
    if retract == false then
        local Data = getAllObjects()
        for t, item in ipairs(Data) do
            if item.getDescription() == 'Tier 2 Items' and string.sub(item.getPosition().x,1,3) == '-65' then
                deckguid = item.getGUID()
            end
        end
        local deck = getObjectFromGUID(deckguid)
        if firsttime == true then
          local count = #deck.getObjects()
          half = (count / 2)
          if (count % 2) == 1 then
            half = half + 1
          end
          startingsize = half
          firsttime = false
        else
          half = startingsize
        end
        deck.shuffle()
        for i=0, half-1 do
            local params ={}
            params.position = {25-(i*4),1.5, 19}
            params.flip = true
            flipcard = deck.takeObject(params)
        end
        self.AssetBundle.playTriggerEffect(0) --triggers animation/sound
        retract = true --locks out the button
        startLockoutTimer() --Starts up a timer to remove lockout
        broadcastToAll("Click again to Retract cards after selection", "White")
      else
        deck = getObjectFromGUID(deckguid)
        local Data = getAllObjects()
        for t, item in ipairs(Data) do
            if item.getDescription() == 'Tier 2 Item' and item.getPosition().x > -46 and item.getPosition().x < 46 and item.getPosition().z > -31 and item.getPosition().z < 31  then
              deck.putObject(item)
            end
        end
        retract = false
      end
end

--Runs on load, creates button and makes sure the lockout is off
function onload(save_state)
  if save_state ~= nil and save_state ~= "" then
    startingsize = JSON.decode(save_state).st
    firsttime = JSON.decode(save_state).ft
  end
    self.createButton({
        label="Big Red Button\n\nBy: MrStump", click_function = "buttonPress",
        function_owner = self,  position={0,0.25,0}, height=1400, width=1400
    })
    lockout = false
    deck = '3bc886'
end

--Starts a timer that, when it ends, will unlock the button
function startLockoutTimer()
    Timer.create({identifier=self.getGUID(), function_name='unlockLockout', delay=0.5})
end

--Unlocks button
function unlockLockout()
    retract = true
end

--Ends the timer if the object is destroyed before the timer ends, to prevent an error
function onDestroy()
    Timer.destroy(self.getGUID())
end

function onSave()
  return JSON.encode({st = startingsize,ft = firsttime})
end
function onload()
    local campaign = false
    self.clearButtons()
    Menus()
end

function Menus()
    Menu_Buttons = {
        [1] = {'The Bespin Gambit',true,'X'},
        [2] = {'Return to Hoth',true,'X'},
        [3] = {'Jabbas Realm',true,'X'},
        [4] = {'Twin Shadows',true,'X'},
        [5] = {'Ally and Villain Packs',true,'X'},
        [6] = {'Heart of the Empire',true, 'X'},
        [7] = {'Tyrants of Lothal',true, 'X'},
        [8] = {'IACP', true, 'X'},
        [9] = {'The Core Set',true,''},
    }
    for i=1, 8 do
        _G['Menu' .. i .. 'Press'] = function (object, sPlayer)
            local button_parameters = {}
            button_parameters.index = i - 1
            if Menu_Buttons[i][2] == false then
                button_parameters.label = '[X] ' .. Menu_Buttons[i][1]
                Menu_Buttons[i][2] = true
            else
                button_parameters.label = '[ ] ' .. Menu_Buttons[i][1]
                Menu_Buttons[i][2] = false
            end
            object.editButton(button_parameters)
        end
        local params = {
            label = '[X] ' .. Menu_Buttons[i][1], click_function = 'Menu' .. i .. 'Press', width = 1000, height=5, color = {0, 0, 0}, font_color = "Green", font_size = 70, function_owner = self
        }

        params.index = i
        params.position = {0 ,0.2,(i/4)-1}
        self.createButton(params)
    end

    for _, obj in ipairs(getAllObjects()) do
        for i=1, 9 do
            if obj.getName() == Menu_Buttons[i][1] then
                Menu_Buttons[i][3] = obj
                obj.interactable = false
            end
        end
    end



    self.createButton({label = 'Use Which Expansions?', click_function = 'Null', rotation = {0, 0, 0},
    position = {0, 0.2, -1}, width = 0, height = 0, font_size = 80, function_owner = self, font_color = "Green"})

    self.createButton({label = 'Done', click_function = 'Done', rotation = {0, 0, 0},
    position = {1.2, 0.2, 1}, width = 500, height = 50, color = {0, 0, 0}, font_color = "Green", font_size = 80, function_owner = self})
end

function Done(object, playerColor)
    getObjectFromGUID('b0f1b4').destruct()
    Global.call('Start',Menu_Buttons)

    self.clearButtons()
    self.createButton({label = 'Friendly Help Menu', click_function = 'Null', rotation = {0, 0, 0},
    position = {0, 0.2, -1}, width = 0, height = 0, font_size = 80, function_owner = self, font_color = "Green"})

    Help_Buttons = {
        [1] = {'Step 1','Pick Roles.  1 Imperial Player and 1-4 Rebel Players',''},
        [2] = {'Step 2','Rebel Players pick Heroes. Drag Cards to Organizers.',''},
        [3] = {'Step 3','Imperial Player chooses 1 class deck.'},
        [4] = {'Step 4','Imperial Player chooses 6 agenda decks.'},
        [5] = {'Step 5','Group chooses which Campaign To play. (Read Notes)'},
        [6] = {'Step 6','Rebel Players Build Side Mission Deck (Read Notes)'},
    }
    for i=1, 6 do
        _G['Help' .. i .. 'Press'] = function (object, sPlayer)
            local params = {
                label = '' .. Help_Buttons[i][2], click_function = 'Null', width = 0, height=0, font_size = 50, function_owner = self, font_color = "Green"
            }
            params.position = Help_Buttons[i][3]
            if i != 1 and i != 6 then
                for _, item in ipairs(self.getTable(i)) do
                    item.highlightOn({1,0,0}, 20)
                end
            end
            self.createButton(params)
        end
        local params = {
            label = '' .. Help_Buttons[i][1], click_function = 'Help' .. i .. 'Press', width = 300, height=5, color = {0, 0, 0}, font_color = "Green", font_size = 50, function_owner = self
        }
        params.index = i
        params.position = {-1.6 ,0.2,i/4-1}
        Help_Buttons[i][3] = {0 ,0.2,i/4-1}
        self.createButton(params)
        self.createButton({label = 'Done', click_function = 'Done1', rotation = {0, 0, 0},
        position = {1.2, 0.2, 1}, width = 500, height = 50, color = {0, 0, 0}, font_color = "Green", font_size = 80, function_owner = self})
    end

end

function Done1(object, playerColor)
    for _, obj in ipairs(getAllObjects()) do
        if obj.getDescription() == 'Supply Cards'
        or obj.getDescription() == 'Tier 1 Items'
        or obj.getDescription() == 'Tier 2 Items' or obj.getDescription() == 'Tier 2 Item'
        or obj.getDescription() == 'Tier 3 Items'
        or obj.getDescription() == 'Grey Side Missions' then
            obj.shuffle()
        end
    end
    printToAll('Shuffling Decks.  You may delete any unused Hero Cards, Imperial Class Cards, Agenda Cards and Side Mission Cards.', {1,0,1})
    printToAll('You may move the dice tray; however, you must make sure it remains locked after the move.', {0,1,1})
    self.destruct()
end
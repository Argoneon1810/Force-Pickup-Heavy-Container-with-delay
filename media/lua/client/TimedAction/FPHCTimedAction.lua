require "TimedActions/ISBaseTimedAction"

if FPHC == nil then FPHC = {} end
if FPHC.FPHC_TimedAction == nil then FPHC.FPHC_TimedAction = ISBaseTimedAction:derive("FPHC_TimedAction") end

function FPHC.FPHC_TimedAction:isValid(args)    -- Check if the action can be done
    return true
end

function FPHC.FPHC_TimedAction:waitToStart()    -- Wait until return false
    return false
end

function FPHC.FPHC_TimedAction:update()         -- Trigger every game update when the action is perform
    --do something
end

function FPHC.FPHC_TimedAction:start()          -- Trigger when the action start
    --do something
end

function FPHC.FPHC_TimedAction:stop()           -- Trigger if the action is cancel
    --do something

    --must leave this
	ISBaseTimedAction.stop(self);
end

function FPHC.FPHC_TimedAction:perform()        -- Trigger when the action is complete
    --remove from world
    self.isoGridSquare:transmitRemoveItemFromSquare(self.isoWorldInventoryObject)
    self.isoWorldInventoryObject:removeFromWorld()
    self.isoWorldInventoryObject:removeFromSquare()
    self.isoWorldInventoryObject:setSquare(nil)

    self.inventoryItem:setWorldItem(nil)
    self.inventoryItem:setJobDelta(0.0)

    --add to player inventory
    self.pItemContainer:setDrawDirty(true)
    self.pItemContainer:AddItem(self.inventoryItem)
    self.inventoryItem:setContainer(self.pItemContainer)

    --must leave this
    ISBaseTimedAction.perform(self);
end

function FPHC.FPHC_TimedAction:new(character, isoWorldInventoryObject, isoGridSquare, inventoryItem, pItemContainer)   -- What to call in your code
    local o = {};

    setmetatable(o, self);
    self.__index = self;

    o.maxTime = 30; -- Time take by the action
    o.character = character;
	o.stopOnWalk = true
	o.stopOnRun = true

    o.inventoryItem = inventoryItem
    o.isoWorldInventoryObject = isoWorldInventoryObject
    o.isoGridSquare = isoGridSquare
    o.pItemContainer = pItemContainer

    if o.character:isTimedActionInstant() then o.maxTime = 1; end

    return o;
end
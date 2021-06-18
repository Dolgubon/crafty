Crafty = {}
Crafty.name = "Crafty"
Crafty.showSL = true
Crafty.showWL = true
Crafty.ankerSL = true
Crafty.vendorOpen = true
Crafty.showTS = false
Crafty.undoRemove = nil
Crafty.db = true
Crafty.filterTypeSL = 4
Crafty.version = 2
Crafty.watchList1 = {}
Crafty.watchList2 = {}
Crafty.watchList3 = {}
Crafty.activewatchList = Crafty.watchList1
Crafty.activewatchListID = 1
Crafty.masterHeight = 600
Crafty.masterWidth = 300
Crafty.autoHeightWL = 600
Crafty.autoHeightWLOpt = true
Crafty.masterAlpha = 0

function Crafty.OnAddOnLoaded(event, addonName)
  if addonName == Crafty.name then
    Crafty.DB("Crafty: OnAddOnLoaded")
    Crafty:Initialize()
  end
end
 
function Crafty:Initialize()
  Crafty.DB("Crafty: Initialize")
  
  self.savedVariables = ZO_SavedVars:NewCharacterIdSettings("CraftySavedVariables", 1, nil, {})
  
  if Crafty.savedVariables.AnkerSL ~= nil then
    Crafty.ankerSL = Crafty.savedVariables.AnkerSL
  end
  if Crafty.savedVariables.ShowSL ~= nil then
    Crafty.showSL = Crafty.savedVariables.ShowSL
  end
  if Crafty.savedVariables.ShowWL ~= nil then
    Crafty.showWL = Crafty.savedVariables.ShowWL
  end
  
  if Crafty.savedVariables.WatchList1 ~= nil then
    Crafty.watchList1 = Crafty.savedVariables.WatchList1
  end
  if Crafty.savedVariables.WatchList2 ~= nil then
    Crafty.watchList2 = Crafty.savedVariables.WatchList2
  end
  if Crafty.savedVariables.WatchList3 ~= nil then
    Crafty.watchList3 = Crafty.savedVariables.WatchList3
  end
  if Crafty.savedVariables.ActivewatchList ~= nil then
    Crafty.activewatchList = Crafty.savedVariables.ActivewatchList
  end
  if Crafty.savedVariables.ActivewatchListID ~= nil then
    Crafty.activewatchListID = Crafty.savedVariables.ActivewatchListID
  end
  
  if Crafty.savedVariables.VendorOpen ~= nil then
    Crafty.vendorOpen = Crafty.savedVariables.VendorOpen
  end
  
  if Crafty.savedVariables.MasterAlpha ~= nil then
    Crafty.masterAlpha = Crafty.savedVariables.MasterAlpha
  end
  if Crafty.savedVariables.MasterHeight ~= nil then
    Crafty.masterHeight = Crafty.savedVariables.MasterHeight
  end
  if Crafty.savedVariables.AutoHeightWLOpt ~= nil then
    Crafty.autoHeightWLOpt = Crafty.savedVariables.AutoHeightWLOpt
  end
   
  Crafty:RestorePosition()
  Crafty.Check()
  Crafty.ControlSettings()
  
  Crafty.CreateScrollListDataTypeSL()
  local stockSL = Crafty.PopulateSL()
  local typeIdSL = 1
  Crafty.UpdateScrollListSL(CraftyStockListList, stockSL, typeIdSL)
  
  Crafty.CreateScrollListDataTypeWL()
  local stockWL = Crafty.PopulateWL()
  local typeIdWL = 2
  if table.getn(stockWL) ~= 0 then
    Crafty.UpdateScrollListWL(CraftyWatchListList, stockWL, typeIdWL)
  end
  
  Crafty.SetMasterHeight()
  Crafty.SetMasterAlpha()
  Crafty.SetActiveWatchList(Crafty.activewatchListID)
end

function Crafty.SetMasterHeight()
  Crafty.DB("Crafty: SetMasterHeight")
  
  local width = Crafty.masterWidth
  local height = Crafty.masterHeight
  
  CraftyWatchList:SetWidth(width)
  CraftyWatchList:SetHeight(height)
  CraftyStockList:SetWidth(width)
  CraftyStockList:SetHeight(height)
  CraftyStockListType:SetWidth(width-100)
  CraftyStockListType:SetHeight(height)
  
  Crafty.savedVariables.MasterHeight = height
  Crafty.Refresh()
end

function Crafty.SetMasterAlpha()
  Crafty.DB("Crafty: SetMasterAlpha")
  
  CraftyWatchListBG:SetAlpha(Crafty.masterAlpha)
  CraftyStockListBG:SetAlpha(Crafty.masterAlpha)
  CraftyStockListTypeBG:SetAlpha(Crafty.masterAlpha)
  
  Crafty.savedVariables.MasterAlpha = Crafty.masterAlpha
end

function Crafty.OnIndicatorMoveStop()
  Crafty.DB("Crafty: OnIndicatorMoveStop")

  Crafty.savedVariables.leftSL = CraftyStockList:GetLeft()
  Crafty.savedVariables.topSL = CraftyStockList:GetTop()

  Crafty.savedVariables.leftWL = CraftyWatchList:GetLeft()
  Crafty.savedVariables.topWL = CraftyWatchList:GetTop()
  
  if Crafty.ankerSL then
    Crafty.AnkerSL()
  end
end

function Crafty:RestorePosition()
  Crafty.DB("Crafty: RestorePosition")
  if not Crafty.ankerSL then
    local leftSL = Crafty.savedVariables.leftSL
    local topSL = Crafty.savedVariables.topSL
    CraftyStockList:ClearAnchors()
    CraftyStockList:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, leftSL, topSL)
  else
    Crafty.AnkerSL()
  end
  
  local leftWL = Crafty.savedVariables.leftWL
  local topWL = Crafty.savedVariables.topWL
  CraftyWatchList:ClearAnchors()
  CraftyWatchList:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, leftWL, topWL)
end

function Crafty.CreateScrollListDataTypeSL()
  Crafty.DB("Crafty: CreateScrollListDataTypeSL")
  local control = CraftyStockListList
  local typeId = 1
  local templateName = "StockRow"
  local height = 25
  local setupFunction = Crafty.LayoutRow
  local hideCallback = nil
  local dataTypeSelectSound = nil
  local resetControlCallback = nil
  --local selectTemplate = "ZO_ThinListHighlight"
  --local selectCallback = Crafty.OnMouseUp
  
  ZO_ScrollList_AddDataType(control, typeId, templateName, height, setupFunction, hideCallback, dataTypeSelectSound, resetControlCallback)
  --ZO_ScrollList_EnableSelection(control, selectTemplate, selectCallback)
end

function Crafty.CreateScrollListDataTypeWL()
  Crafty.DB("Crafty: CreateScrollListDataTypeWL")
  local control = CraftyWatchListList
  local typeId = 2
  local templateName = "WatchRow"
  local height = 25
  local setupFunction = Crafty.LayoutRow
  local hideCallback = nil
  local dataTypeSelectSound = nil
  local resetControlCallback = nil
  --local selectTemplate = "ZO_ThinListHighlight"
  --local selectCallback = Crafty.OnMouseUp
  
  ZO_ScrollList_AddDataType(control, typeId, templateName, height, setupFunction, hideCallback, dataTypeSelectSound, resetControlCallback)
  --ZO_ScrollList_EnableSelection(control, selectTemplate, selectCallback)
end

function Crafty.SetActiveWatchList(arg)
  Crafty.DB("Crafty: SetActiveWatchList "..arg)
  local mydefcolor = ZO_ColorDef:New("CFDCBD")
  
  CraftyWatchListWatchList1:SetColor(mydefcolor:UnpackRGBA())
  CraftyWatchListWatchList2:SetColor(mydefcolor:UnpackRGBA())
  CraftyWatchListWatchList3:SetColor(mydefcolor:UnpackRGBA())
  CraftyWatchListWatchList1:SetFont("ZoFontWinH4")
  CraftyWatchListWatchList2:SetFont("ZoFontWinH4")
  CraftyWatchListWatchList3:SetFont("ZoFontWinH4")
  
  if arg == 1 then
    CraftyWatchListWatchList1:SetColor(1,1,1)
    CraftyWatchListWatchList1:SetFont("ZoFontWinH4")
    Crafty.activewatchList = Crafty.watchList1
  end
  if arg == 2 then
    CraftyWatchListWatchList2:SetColor(1,1,1)
    CraftyWatchListWatchList2:SetFont("ZoFontWinH4")
    Crafty.activewatchList = Crafty.watchList2
  end
  if arg == 3 then
    CraftyWatchListWatchList3:SetColor(1,1,1)
    CraftyWatchListWatchList3:SetFont("ZoFontWinH4")
    Crafty.activewatchList = Crafty.watchList3
  end
  
  Crafty.savedVariables.ActivewatchList = Crafty.activewatchList
  Crafty.savedVariables.ActivewatchListID = arg
  
  Crafty.Refresh()
end

function Crafty.SetTS(arg)
  Crafty.DB("Crafty: SetTS")
  local myTS = arg
  Crafty.filterTypeSL = myTS
  Crafty.Refresh()
end

function Crafty.PopulateSL()
  Crafty.DB("Crafty: PopulateSL")
  local type = Crafty.filterTypeSL
  local stock = {}
  local stockcounter = 0

  for index, data in pairs(SHARED_INVENTORY.bagCache[BAG_VIRTUAL]) do
    if data ~= nil then
      if GetItemCraftingInfo(BAG_VIRTUAL,data.slotIndex) == type then
        stockcounter = stockcounter + 1
        stock[stockcounter] = {
          link = GetItemLink(BAG_VIRTUAL,data.slotIndex),
          name = GetItemName(BAG_VIRTUAL,data.slotIndex),
          amount = GetSlotStackSize(BAG_VIRTUAL,data.slotIndex),
          cinfo = GetItemCraftingInfo(BAG_VIRTUAL,data.slotIndex)
        }
      end
    end
  end
  return stock
end

function Crafty.PopulateWL()
  local watchList = Crafty.activewatchList
  Crafty.DB("Crafty: PopulateWL "..table.getn(watchList))
  Crafty.RefreshWLAmounts()
  local stock = {}
  --Crafty.DBPrintWatchList()
  for i=1,table.getn(watchList) do
    stock[i] = {
       link = watchList[i].link,
      name = watchList[i].name,
      amount = watchList[i].amount,
      cinfo = watchList[i].cinfo
    }
  end
  Crafty.SetHeightWL()
  return stock
end

function Crafty.UpdateScrollListSL(control, data, rowType)
  Crafty.DB("Crafty: UpdateScrollListSL "..table.getn(data))
  
  local dataCopy = ZO_DeepTableCopy(data)
  local dataList = ZO_ScrollList_GetDataList(control)
  
  ZO_ScrollList_Clear(control)
   
  for key, value in ipairs(dataCopy) do
    local entry = ZO_ScrollList_CreateDataEntry(rowType, value)
    table.insert(dataList, entry)
  end
  
  table.sort(dataList, function(a,b) return a.data.name < b.data.name end)
  ZO_ScrollList_Commit(control)
  
  if Crafty.activewatchList == Crafty.watchList1 then
    Crafty.savedVariables.WatchList1 = Crafty.activewatchList
  end
  if Crafty.activewatchList == Crafty.watchList2 then
    Crafty.savedVariables.WatchList2 = Crafty.activewatchList
  end
  if Crafty.activewatchList == Crafty.watchList3 then
    Crafty.savedVariables.WatchList3 = Crafty.activewatchList
  end
end

function Crafty.UpdateScrollListWL(control, data, rowType)
  Crafty.DB("Crafty: UpdateScrollListWL "..table.getn(data))

  local dataCopyWL = ZO_DeepTableCopy(data)
  local dataListWL  = ZO_ScrollList_GetDataList(control)
  
  ZO_ScrollList_Clear(control)
  
  for key, value in ipairs(dataCopyWL) do
    local entry = ZO_ScrollList_CreateDataEntry(rowType, value)
    table.insert(dataListWL, entry)
  end
   
  table.sort(dataListWL, function(a,b) return a.data.name < b.data.name end)
  ZO_ScrollList_Commit(control)
  
  --Crafty.DBPrintWatchList()
  
  if Crafty.activewatchList == Crafty.watchList1 then
    Crafty.savedVariables.WatchList1 = Crafty.activewatchList
  end
  if Crafty.activewatchList == Crafty.watchList2 then
    Crafty.savedVariables.WatchList2 = Crafty.activewatchList
  end
  if Crafty.activewatchList == Crafty.watchList3 then
    Crafty.savedVariables.WatchList3 = Crafty.activewatchList
  end
end

function Crafty.LayoutRow(rowControl, data, scrollList)
  --d("Crafty: LayoutRow")

  rowControl.data = data
  rowControl.name = GetControl(rowControl, "Name")
  rowControl.amount = GetControl(rowControl, "Amount")
  
  rowControl.name:SetText(data.link)
  rowControl.amount:SetText(data.amount)  
end

function Crafty.CalculateHeightWL()
  Crafty.DB("Crafty: CalculateHeightWL")
  
  local watchList = Crafty.activewatchList
  local watchlistItems = table.getn(watchList)
  
  Crafty.autoHeightWL = 65+watchlistItems*25
end

function Crafty.SetHeightWL()
  if Crafty.autoHeightWLOpt then
    Crafty.DB("Crafty: SetHeightWL")
    Crafty.CalculateHeightWL()
    local width = Crafty.masterWidth
    local height = Crafty.autoHeightWL
    
    CraftyWatchList:SetWidth(width)
    CraftyWatchList:SetHeight(height)
  end
end

function Crafty.CheckAutoHeightWLOpt()
  if Crafty.autoHeightWLOpt then
    Crafty.SetHeightWL()
  else
    Crafty.SetMasterHeight()
  end
end

function Crafty.InvChange()
  Crafty.DB("Crafty: InvChange")
  Crafty.Refresh()
end

function Crafty.Refresh()
  Crafty.DB("Crafty: Refresh")

  local typeIdSL = 1
  local stockSL = Crafty.PopulateSL()
  Crafty.UpdateScrollListSL(CraftyStockListList, stockSL, typeIdSL)
  
  local typeIdWL = 2
  local stockWL = Crafty.PopulateWL()
  Crafty.UpdateScrollListWL(CraftyWatchListList, stockWL, typeIdWL)
end

function Crafty.FullRefresh()
  Crafty.DB("Crafty: FullRefresh")

  Crafty.undoRemove = nil
  Crafty.CheckUndo()

  local typeIdSL = 1
  local stockSL = Crafty.PopulateSL()
  Crafty.UpdateScrollListSL(CraftyStockListList, stockSL, typeIdSL)
  
  local typeIdWL = 2
  local stockWL = Crafty.PopulateWL()
  Crafty.UpdateScrollListWL(CraftyWatchListList, stockWL, typeIdWL)
end

function Crafty.RefreshWLAmounts()
  Crafty.DB("Crafty: RefreshWLAmounts")
  if table.getn(Crafty.activewatchList) ~= 0 then
    for i=1,table.getn(Crafty.activewatchList) do
      local name = Crafty.activewatchList[i].name
      for index, data in pairs(SHARED_INVENTORY.bagCache[BAG_VIRTUAL]) do
        if data ~= nil then
          if GetItemName(BAG_VIRTUAL,data.slotIndex) == name then
            Crafty.activewatchList[i].amount = GetSlotStackSize(BAG_VIRTUAL,data.slotIndex)
          end
        end
      end
    end
  end

end

function Crafty.Check()
  Crafty.DB("Crafty: Check")
  if Crafty.showSL == true then
      Crafty.OpenSL()
  else 
      Crafty.CloseSL()
  end
  if Crafty.showWL == true then
      Crafty.OpenWL()
  else 
      Crafty.CloseWL()
  end
end

function Crafty.CheckVendorOpen()
  if Crafty.vendorOpen then
    Crafty.OpenWL()
  end
end

function Crafty.CheckVendorClose()
  if Crafty.vendorOpen then
    Crafty.CloseWL()
  end
end

function Crafty.ToggleSL()
  Crafty.DB("Crafty: ToggleSL")
  if Crafty.showSL then
    Crafty.CloseSL()
  else
    Crafty.OpenSL()
  end
end

function Crafty.AnkerSL()
  Crafty.DB("Crafty: AnkerSL")
  CraftyStockList:ClearAnchors()
  CraftyStockList:SetAnchor(TOPRIGHT, CraftyWatchList, TOPLEFT, -4 ,0)
end

function Crafty.ToggleAnkerSL()
  Crafty.DB("Crafty: ToggleAnkerSL")
  if Crafty.ankerSL then
    Crafty.ankerSL = false
    Crafty.savedVariables.AnkerSL = false
    
    CraftyStockListButtonToggleAnkerSL:SetNormalTexture("esoui/art/miscellaneous/unlocked_up.dds")
    CraftyStockListButtonToggleAnkerSL:SetMouseOverTexture("esoui/art/miscellaneous/unlocked_over.dds")
    CraftyStockListButtonToggleAnkerSL:SetPressedTexture("esoui/art/miscellaneous/unlocked_down.dds")

  else
    Crafty.ankerSL = true
    Crafty.savedVariables.AnkerSL = true
    
    CraftyStockListButtonToggleAnkerSL:SetNormalTexture("esoui/art/miscellaneous/locked_up.dds")
    CraftyStockListButtonToggleAnkerSL:SetMouseOverTexture("esoui/art/miscellaneous/locked_over.dds")
    CraftyStockListButtonToggleAnkerSL:SetPressedTexture("esoui/art/miscellaneous/locked_down.dds")
    
    Crafty.AnkerSL()
  end
end

function Crafty.ToggleTS()
  Crafty.DB("Crafty: ToggleTS")
  if Crafty.showTS then
    Crafty.CloseTS()
  else
    Crafty.OpenTS()
  end
end

function Crafty.CloseTS()
  Crafty.DB("Crafty: CloseTS")
  CraftyStockListType:SetHidden(true)
  Crafty.showTS = false
end

function Crafty.OpenTS()
  Crafty.DB("Crafty: OpenTS")
  CraftyStockListType:SetHidden(false)
  Crafty.showTS = true
end

function Crafty.CloseSL()
  Crafty.DB("Crafty: CloseSL")
  CraftyStockList:SetHidden(true)
  Crafty.showSL = false
  Crafty.savedVariables.ShowSL = false
  Crafty.CloseTS()
end

function Crafty.OpenSL()
  Crafty.DB("Crafty: OpenSL")
  CraftyStockList:SetHidden(false)
  Crafty.showSL = true
  Crafty.savedVariables.ShowSL = true
  Crafty.OpenTS()
end

function Crafty.CloseWL()
  Crafty.DB("Crafty: CloseWL")
  CraftyWatchList:SetHidden(true)
  Crafty.showWL = false
  Crafty.savedVariables.ShowWL = false
  CraftyStockList:SetHidden(true)
  Crafty.showSL = false
  Crafty.savedVariables.ShowSL = false
  Crafty.CloseSL()
  Crafty.CloseTS()
end

function Crafty.OpenWL()
  Crafty.DB("Crafty: OpenWL")
  CraftyWatchList:SetHidden(false)
  Crafty.showWL = true
  Crafty.savedVariables.ShowWL = true
end

function Crafty.OnMouseEnterSL(control)


end

function Crafty.OnMouseExitSL(control)


end

function Crafty.OnMouseUpSL(control, button, upInside)
  Crafty.AddItemToWatchList(control)
end

function Crafty.OnMouseUpWL(control, button, upInside)
  Crafty.RemoveItemFromWatchList(control)
end

function Crafty.AddItemToWatchList(control)
  Crafty.DB("Crafty: AddItemToWatchList")
  local name = control.data.name
  local watchList = Crafty.activewatchList
  local size = table.getn(watchList)

  local found = Crafty.CheckItemInWatchList(control.data.name)
  
  if not found then
    watchList[size+1] = {
        link = control.data.link,
        name = control.data.name,
        amount = control.data.amount,
        cinfo = control.data.cinfo
      }
      Crafty.undoRemove = nil
      Crafty.CheckUndo()
  end
  
  Crafty.DB("Crafty: Added "..name.." at #"..table.getn(watchList))
  --Crafty.DBPrintWatchList()
  Crafty.Refresh()  
end

function Crafty.RemoveItemFromWatchList(control)
  Crafty.DB("Crafty: RemoveItemFromWatchList")
  local name=control.data.name
  local watchList = Crafty.activewatchList
  for i=1,table.getn(watchList) do
    if watchList[i].name == name then
      Crafty.DB("Crafty: Removed "..name.." at #"..i)
      Crafty.undoRemove = (watchList[i])
      Crafty.CheckUndo()
      table.remove(watchList, i)
      break
    end
  end
  --Crafty.DBPrintWatchList()
  Crafty.Refresh()
end

function Crafty.CheckUndo()
  Crafty.DB("Crafty: CheckUndo")
  if Crafty.undoRemove ~= nil then
    CraftyWatchListButtonUndo:SetHidden(false)
  else
    CraftyWatchListButtonUndo:SetHidden(true)
  end
end

function Crafty.UndoRemove()
  Crafty.DB("Crafty: UndoRemove")
  local found = Crafty.CheckItemInWatchList(Crafty.undoRemove.name)
  if Crafty.undoRemove ~= nil then
    if not found then
      table.insert(Crafty.activewatchList, Crafty.undoRemove)
    else
      return
    end
  end
  Crafty.undoRemove = nil
  Crafty.CheckUndo()
  Crafty.Refresh()
end

function Crafty.CheckItemInWatchList(control)
  Crafty.DB("Crafty: CheckItemInWatchList")
  local found = false
  local watchList = Crafty.activewatchList
  for i=1,table.getn(watchList) do
    if watchList[i].name == control then
      local found = true
      return found
    end
  end
  return found
end

-- DEBUG -------------------------------------------------------------

function Crafty.DB(message)
  if Crafty.db then
    d(message)
  end
end

function Crafty.ToggleDB()
  if Crafty.db then
    d("Crafty: Debugmode off")
    Crafty.db = false
  else
    d("Crafty: Debugmode on")
    Crafty.db = true
  end
end

function Crafty.DBPrintWatchList()
  local watchList = Crafty.watchList1
  if Crafty.db then
    Crafty.DB("Debug WatchList -------------------------")
    for i=1,table.getn(watchList) do
      Crafty.DB(watchList[i].link)
    end
  end
end

EVENT_MANAGER:RegisterForEvent(Crafty.name, EVENT_ADD_ON_LOADED, Crafty.OnAddOnLoaded)

--EVENT_MANAGER:RegisterForEvent(Crafty.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, Crafty.InvChange)

EVENT_MANAGER:RegisterForEvent(Crafty.name, EVENT_OPEN_TRADING_HOUSE, Crafty.CheckVendorOpen)
EVENT_MANAGER:RegisterForEvent(Crafty.name, EVENT_CLOSE_TRADING_HOUSE, Crafty.CheckVendorClose)
EVENT_MANAGER:RegisterForEvent(Crafty.name, EVENT_BUY_RECEIPT, Crafty.InvChange)
EVENT_MANAGER:RegisterForEvent(Crafty.name, EVENT_LOOT_RECEIVED, Crafty.InvChange)
EVENT_MANAGER:RegisterForEvent(Crafty.name, EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS , Crafty.InvChange)

SLASH_COMMANDS["/crafty"] = function()  Crafty.Open() end
SLASH_COMMANDS["/craftydb"] = function()  Crafty.ToggleDB() end
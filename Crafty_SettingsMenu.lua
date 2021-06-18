function Crafty.ShowSettings()
  LibAddonMenu2:OpenToPanel(CraftySettings)
end

function Crafty.ControlSettings()
  Crafty.DB("Crafty: ControlSettings")
  local panelData = {
    type = "panel",
    name = "Crafty",
    displayName = "Crafty Stocklist",
    author = "rp12439",
    version = Crafty.version,
    slashCommand = "/craftysettings", --(optional) will register a keybind to open to this panel
    registerForRefresh = true,  --boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
    registerForDefaults = true, --boolean (optional) (will set all options controls back to default values)
  }
    
  local optionsTable = {

    [1] = {
          type = "checkbox",
          name = "Show watchlist",
          tooltip = "This setting will display or hide the watchlist",
          getFunc = function() return Crafty.showWL end,
          setFunc = function(value) Crafty.showWL = value Crafty.Check() end,
    }, 
    [2] = {
          type = "checkbox",
          name = "Open/Close on vendor",
          tooltip = "This setting will display and hide the stocklist when visiting a guildvendor",
          getFunc = function() return Crafty.vendorOpen end,
          setFunc = function(value) Crafty.vendorOpen = value end,
    }, 
    [3] = {
        type = "slider",
        name = "Background transparency",
        tooltip = "Set background transparency",
        min = 0,
        max = 1,
        step = 0.1, --(optional)
        getFunc = function() return Crafty.masterAlpha end,
        setFunc = function(value) Crafty.masterAlpha = value Crafty.SetMasterAlpha() end,
        width = "full", --or "full" (optional)
        default = 0,  --(optional)
    },
    [4] = {
        type = "slider",
        name = "Window Height",
        tooltip = "Set window height",
        min = 260,
        max = 1000,
        step = 10, --(optional)
        getFunc = function() return Crafty.masterHeight end,
        setFunc = function(value) Crafty.masterHeight = value Crafty.SetMasterHeight() end,
        width = "full", --or "full" (optional)
        default = 600,  --(optional)
    },
  }
  
    ZO_CreateStringId("SI_BINDING_NAME_CRAFTY_STOCKLIST", "Show/Hide Stocklist")
    ZO_CreateStringId("SI_BINDING_NAME_CRAFTY_STOCKLIST2", "Reload Stockamounts") 
    
    LibAddonMenu2:RegisterAddonPanel("CraftySettings", panelData) 
    LibAddonMenu2:RegisterOptionControls("CraftySettings", optionsTable)
    
end
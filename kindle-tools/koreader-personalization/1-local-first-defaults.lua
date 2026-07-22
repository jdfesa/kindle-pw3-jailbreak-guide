-- Early user patches run before KOReader creates G_reader_settings. Open and
-- flush the same file first so device initialization reads these values.
local DataStorage = require("datastorage")
local settings = require("luasettings"):open(
    DataStorage:getDataDir() .. "/settings.reader.lua")

settings:makeTrue("night_mode")

-- SSH is owned by the independent Upstart recovery service. Keeping KOReader's
-- plugin disabled prevents two Dropbear processes from competing for port 2222
-- and prevents KOReader shutdown from stopping the recovery channel.
settings:makeFalse("SSH_allow_no_password")
settings:makeTrue("SSH_key_only_auth")
settings:makeFalse("SSH_autostart")

local disabled_plugins = settings:readSetting("plugins_disabled")
if type(disabled_plugins) ~= "table" then
    disabled_plugins = {}
end
disabled_plugins.SSH = true
settings:saveSetting("plugins_disabled", disabled_plugins)
settings:flush()

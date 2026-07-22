-- KOReader disables its own sleep screen when the stock Kindle reports
-- Special Offers. This user patch keeps the change inside /mnt/us/koreader
-- and is therefore reversible without modifying the Kindle system partition.
local Device = require("device")

Device.supportsScreensaver = function()
    return true
end

-- Reinitialize the wake-up manager after changing screensaver support.
if Device.powerd and Device.powerd.initWakeupMgr then
    Device.powerd:initWakeupMgr()
end

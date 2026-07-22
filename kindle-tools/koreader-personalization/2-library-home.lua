-- Keep KOReader focused on books instead of exposing Kindle system folders.
-- Remove this file to restore KOReader's normal unrestricted file browser.
local library = "/mnt/us/documents/Library"

G_reader_settings:saveSetting("home_dir", library)
G_reader_settings:saveSetting("lastdir", library)
G_reader_settings:makeTrue("lock_home_folder")
G_reader_settings:makeTrue("shorten_home_dir")

local ok, BookInfoManager = pcall(require, "bookinfomanager")
if ok then
    BookInfoManager:saveSetting("filemanager_display_mode", "mosaic_image")
    BookInfoManager:saveSetting("history_display_mode", "mosaic_image")
    BookInfoManager:saveSetting("collection_display_mode", "mosaic_image")
    BookInfoManager:saveSetting("show_progress_in_mosaic", true)
end

-- Keep the on-disk recovery view consistent without waiting for autosave.
G_reader_settings:flush()

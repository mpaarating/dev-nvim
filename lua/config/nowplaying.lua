-- Now Playing: Show current track from Spotify, Apple Music, or Vox
local M = {}

-- AppleScript queries for each player
local players = {
  spotify = {
    name = "Spotify",
    running = 'tell application "System Events" to (name of processes) contains "Spotify"',
    state = 'tell application "Spotify" to player state as string',
    track = 'tell application "Spotify" to name of current track',
    artist = 'tell application "Spotify" to artist of current track',
    album = 'tell application "Spotify" to album of current track',
  },
  music = {
    name = "Apple Music",
    running = 'tell application "System Events" to (name of processes) contains "Music"',
    state = 'tell application "Music" to player state as string',
    track = 'tell application "Music" to name of current track',
    artist = 'tell application "Music" to artist of current track',
    album = 'tell application "Music" to album of current track',
  },
  vox = {
    name = "Vox",
    running = 'tell application "System Events" to (name of processes) contains "Vox"',
    state = 'if application "Vox" is running then tell application "Vox" to if player state is 1 then return "playing" else return "paused"',
    track = 'tell application "Vox" to track',
    artist = 'tell application "Vox" to artist',
    album = 'tell application "Vox" to album',
  },
}

-- Run osascript and return trimmed output
local function osascript(script)
  local handle = io.popen('osascript -e \'' .. script .. '\' 2>/dev/null')
  if not handle then return nil end
  local result = handle:read("*a")
  handle:close()
  if result then
    result = result:gsub("^%s+", ""):gsub("%s+$", "")
    if result == "" then return nil end
    return result
  end
  return nil
end

-- Check if a player is running and playing
local function get_player_info(player)
  local running = osascript(player.running)
  if running ~= "true" then return nil end

  local state = osascript(player.state)
  if not state then return nil end

  local is_playing = state:lower():find("playing") ~= nil

  local track = osascript(player.track)
  if not track then return nil end

  return {
    player = player.name,
    state = is_playing and "playing" or "paused",
    track = track,
    artist = osascript(player.artist) or "Unknown Artist",
    album = osascript(player.album) or "Unknown Album",
  }
end

-- Get now playing info from first active player
local function get_now_playing()
  -- Check players in priority order
  for _, key in ipairs({ "spotify", "music", "vox" }) do
    local info = get_player_info(players[key])
    if info then return info end
  end
  return nil
end

-- Truncate string to max length
local function truncate(str, max_len)
  if #str <= max_len then return str end
  return str:sub(1, max_len - 1) .. "…"
end

-- Show floating window with now playing info
function M.show()
  local info = get_now_playing()

  local lines = {}
  local width = 50

  if info then
    local icon = info.state == "playing" and "▶" or "⏸"
    table.insert(lines, "╭" .. string.rep("─", width - 2) .. "╮")
    table.insert(lines, "│" .. string.format(" %s  NOW PLAYING  (%s)", icon, info.player):sub(1, width - 2) .. string.rep(" ", width - 2 - #string.format(" %s  NOW PLAYING  (%s)", icon, info.player)) .. "│")
    table.insert(lines, "├" .. string.rep("─", width - 2) .. "┤")
    table.insert(lines, "│  ♫  " .. truncate(info.track, width - 8) .. string.rep(" ", math.max(0, width - 8 - #truncate(info.track, width - 8))) .. "│")
    table.insert(lines, "│  ♪  " .. truncate(info.artist, width - 8) .. string.rep(" ", math.max(0, width - 8 - #truncate(info.artist, width - 8))) .. "│")
    table.insert(lines, "│  ◉  " .. truncate(info.album, width - 8) .. string.rep(" ", math.max(0, width - 8 - #truncate(info.album, width - 8))) .. "│")
    table.insert(lines, "╰" .. string.rep("─", width - 2) .. "╯")
  else
    table.insert(lines, "╭" .. string.rep("─", width - 2) .. "╮")
    table.insert(lines, "│  ⏹  Nothing playing" .. string.rep(" ", width - 23) .. "│")
    table.insert(lines, "│     (Spotify / Apple Music / Vox)" .. string.rep(" ", width - 37) .. "│")
    table.insert(lines, "╰" .. string.rep("─", width - 2) .. "╯")
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  local height = #lines
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
  })

  -- Close with q or Esc
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
end

-- For statusline: returns short string or nil
function M.statusline()
  local info = get_now_playing()
  if not info then return nil end
  local icon = info.state == "playing" and "▶" or "⏸"
  return string.format("%s %s - %s", icon, truncate(info.artist, 15), truncate(info.track, 20))
end

-- Set up keybinding
vim.keymap.set('n', '<leader>np', M.show, { desc = 'Now Playing', silent = true })

-- Create command
vim.api.nvim_create_user_command('NowPlaying', M.show, { desc = 'Show now playing' })

return M

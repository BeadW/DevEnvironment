local state = {
  floating = {
    buf = -1, -- Stores the buffer number for the floating terminal
    win = -1, -- Stores the window ID for the floating terminal (-1 if not open/tracked)
  }
}

-- Forward declaration of toggle_terminal so the <Esc><Esc> callback can refer to it
local toggle_terminal

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_config) -- true to enter the window
  vim.api.nvim_win_set_option(win, "winhl", "Normal:TermNormal") 
  vim.api.nvim_win_set_option(win, "winblend", 0)
  
  return { buf = buf, win = win }
end

toggle_terminal = function()
  -- If the window is not valid (e.g., -1 or closed externally), create and show it.
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }

    -- Ensure commands operate on the new floating window
    vim.api.nvim_set_current_win(state.floating.win)

    -- If the buffer in the window is not already a terminal, make it one
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal() -- This command makes the current buffer a terminal buffer
    end

    -- Automatically enter insert mode in the terminal
    vim.cmd("startinsert")

    -- Set a buffer-local keymap for <esc><esc> in this terminal buffer
    vim.api.nvim_buf_set_keymap(
      state.floating.buf, -- Buffer number
      "t",                -- Terminal mode
      "<Esc><Esc>",        -- Keystroke
      "",                 -- RHS (empty as we use a callback)
      {
        noremap = true,
        silent = true,
        callback = function()
          -- First, exit terminal mode (go to Terminal-Normal mode)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "t", false)
          -- Then, call toggle_terminal again. Since the window is open, it will hide it.
          toggle_terminal()
        end,
        desc = "Exit terminal mode and close floating terminal"
      }
    )
  else
    -- Window is valid and presumably open, so hide it
    vim.api.nvim_win_hide(state.floating.win)
    -- Mark that the window is no longer our active tracked floating window
    -- This ensures that the next call to toggle_terminal will re-open it.
    state.floating.win = -1
  end
end

-- Your existing keymap and command:
-- vim.keymap.set("n", "<leader>tf", ":Floaterminal<CR>", { desc = "Open a floating terminal"})
-- vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})

-- Note: If you have a global mapping like vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>"),
-- the buffer-local mapping set above will take precedence for this specific Floaterminal instance.
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})

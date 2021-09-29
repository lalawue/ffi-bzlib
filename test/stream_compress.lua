-- 
-- Example for stream compress
--
-- Initialize:
local bzlib = require 'ffi_bzlib.compress'
--[[
    local bz = bzlib:new(
        compresslevel,  -- Optional, default is 9.
        workfactor      -- Optional, default is 30.
        -- In fact, these two are parameters 'blockSize100k'
        -- and 'workFactor' of the function 'BZ2_bzCompressInit'
    )
]]--
local bz = bzlib:new()

local name = ...
if not name then
	print("usage: luajit stream_compress.lua FILENAME")
	os.exit(0)
end
local fd1 = io.open(name, 'r')
local fd2 = io.open(name .. '.bz2', 'wb')

-- Append data:
while true do
    local ln = fd1:read('*line')
    if not ln then
        break
    end
    --[[
        local part, err = bz:append(text)
        -- Append part of data to this method.
        -- In case of failed to compress, it will return
        -- nil and a string contains error message.
    ]]--
    local part, err = bz:append(ln .. '\n')
    if not part then
        print(err)
        break
    end
    --[[
        The returned string may be '' because libbz2.so may buffer some data.
        In this case, there is no need to write the file.
    ]]--
    if #part > 0 then
        fd2:write(part)
    end
end
fd1:close()

-- Clean up:
--[[
    Use bz:finish() to tell libbz2.so that compress comes to an end.
    This method will return all remaining data the libbz2.so has buffered.
]]--
local part, err = bz:finish()
if not part then
    print(err)
end
fd2:write(part)
fd2:close()

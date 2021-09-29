--
-- Example of stream decompress
--
-- Initialize:
local bzlib = require 'ffi_bzlib.decompress'
--[[
    local bz = bzlib:new(
        reducemem   -- Optional. Default is 0.
        -- In fact, this parameters is 'small'
        -- of the function 'BZ2_bzDecompressInit'
    )
]]--
local bz = bzlib:new()

local name = ...
if not name then
	print("usage: luajit stream_decompress.lua FILENAME.bz2")
	os.exit(0)
end
local fd1 = io.open(name, 'rb')
local fd2 = io.open(name .. '.txt', 'wb')

-- Append data:
while true do
    local bin = fd1:read(4096)
    if not bin then break end
    --[[
        local text, finish, err = bz:append(bin)
        -- Append part of data to this method.
        -- In case of success, 'finish' tells you wheather
        -- the compressed stream comes to an end. That means
        -- you can finish decompress when 'finish' is true.
        -- In case of failed, it will return
        -- nil and a string contains error message.
    ]]--
    local text, finish, err = bz:append(bin)
    if not text then
        print('append no return')
        break
    end
    --[[
        The returned string may be '' because libbz2.so may buffer some data.
        In this case, there is no need to write the file.
    ]]--
    if #text > 0 then
        fd2:write(text)
    end
    if finish then
        print('stream end')
        break
    end
end
fd1:close()
fd2:close()

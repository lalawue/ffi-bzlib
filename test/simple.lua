-- simple test
local bzlib = require 'ffi_bzlib'
--[[
    local bz = bzlib:new(
        dest_buff_size  -- Optional, default is 8192.
        -- The libbz2.so will return BZ_OUTBUFF_FULL(-8)
        -- if this buffer size is not enough to storage
        -- the output data.
    )
]]--
local bz = bzlib:new()
local bin1 = bz:compress('xiaooloong')
local bin2 = bz:compress('foobar')

local text1 = bz:decompress(bin1)
local text2 = bz:decompress(bin2)

print(text1, '\n', text2)

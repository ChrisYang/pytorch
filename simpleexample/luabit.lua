require 'torch'
require 'nn'

local Luabit = torch.class('Luabit')

function Luabit:__init()
end

function Luabit:getOut(inTensor, outSize, kernelSize)
  local inSize = inTensor:size(3)
  local m = nn.TemporalConvolution(inSize, outSize, kernelSize)
  m:float()
  local out = m:forward(inTensor)
  print('out from lua', out)
  return out
end


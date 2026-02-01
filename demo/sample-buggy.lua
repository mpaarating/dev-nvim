-- Sample file with a bug for demo purposes
local M = {}

function M.calculate_average(numbers)
  if #numbers == 0 then
    return nil
  end
  local sum = 0
  for i = 1, #numbers do
    sum = sum + numbers[i]
  end
  return sum / #numbers
end

function M.greet(name)
  return "Hello, " .. name
end

return M

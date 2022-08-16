local counter = 0

local function main()
  counter = 0
end

local function hello()
  counter = counter + 1
  -- print('hello ' .. counter .. ' !!!')
end

return {
  main = main,
  hello = hello
}

-- tools.lua
-- 自定义工具方法

wezterm = require 'wezterm'


-- log调试
function log(...)
  wezterm.log_info(...)
end




-- print调试
function print(...)
  local filePath = wezterm_config_join('debug/print.log')
  local msg = table.concat({...}, "\t")
  local f = io.open(filePath, "a")
  if f ~=nil then
    f:write(msg .. "\n")
    f:close()
  end
end


-- prints调试: 每一次输出都会覆盖原数据。
function prints(...)
  local filePath = wezterm_config_join('debug/prints.log')
  local msg = table.concat({...}, "\t")
  local f = io.open(filePath, "w")
  if f ~=nil then
    f:write(msg .. "\n")
    f:close()
  end
end



-- printf调试: 每一次输出都会覆盖原数据。
function printf(...)
  local msg = {}
  local args = {...} -- 获取所有参数
  local filePath = wezterm_config_join('debug/printf.log')

  for i, v in ipairs(args) do
    if type(v) == "table" then
      msg[i] = wezterm.serde.json_encode_pretty(v)
    else
      msg[i] = tostring(v)
    end
  end

  msg = table.concat(msg, "\t") -- 将所有类型信息用制表符连接成一个字符串
  local f = io.open(filePath, "w")
  if f then
    f:write(msg .. "\n")
    f:close()
  end
end







-- 获取Shell命令的输出并打印
function shell_popen(cmd)
  local output = "null"
  local f = io.popen(cmd)
  if f ~= nil then
    output = f:read("*all")
    f:close()
  end
  return output
end






-- 判断Shell进程是否运行
function is_shell_process(name)
  local ps_shell="ps|grep -v grep|grep $name.sh|wc -l"
  ps_shell=ps_shell:gsub("$name",name)
  local num = shell_popen(ps_shell)
  -- print(ps_shell)
  return tonumber(num)

end




-- 使用Shell命令检查文件是否存在
function shell_file_exists(filename)
  local is_file = string.format('test -f %s && echo "yes" || echo "no"', filename)
  local check = shell_popen(is_file)
  return check:find("yes") ~= nil
end





-- 拼接路径
-- wezterm 配置文件路径
function wezterm_config_join(...)
  local path = table.concat({...}, '/')
  path = string.format('%s/.config/wezterm/%s', wezterm.home_dir, path)
  path = path:gsub("//", "/")
  return path
end

-- wezterm 家文件路径
function wezterm_home(...)
  local path = table.concat({...}, '/')
  path = string.format('%s/%s', wezterm.home_dir, path)
  path = path:gsub("//", "/")
  return path
end








-- 读取文件
function readFile(paths)
  local file = io.open(paths, "r")
  if not file then return nil end
  local content = file:read("*all")
  file:close()
  return content
end


-- 写入文件
function writeFile(paths, content, mode)
  mode = mode or "w"
  local file = io.open(paths, mode)
  if not file then return false end
  file:write(content)
  file:close()
  return true
end



-- 数组反向排序
function array_sort(arr)
  local i = #arr
  local array = {}

  while i > 0 do
    table.insert(array, arr[i])
    i = i - 1
  end

  return array

end




-- 获取数组位置
function array_index(arr,name)
  local index = 1
  for i, v in ipairs(arr) do
    if v == name then
      index = i
      break
    end
  end
  return index
end





















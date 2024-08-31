-- shell.lua
-- Author: wangming
-- Date: 2023-02-16
-- 描述: 通过服务端和客户端实现进程间通信，实现Shell命令和脚本的运行



local server = wezterm_config_join('shell/server.sh&')
local client = wezterm_config_join('shell/client.sh')



-- 默认启动服务端，等待客服端发送过来Shell命令或者脚本运行
-- 参数 option: -b 启动后台进程，-c 使用超时机制执行字符串命令
local server_lock = false
local child_process_started = {}
function server_exec_shell(option, child_process, callback)
    local is_process = is_shell_process
    
    -- 发送Shell命令到服务器执行
    local function send_commd_server(option, cmd)
        local cmd_string = string.format("bash %s %s '%s'", client, option, cmd)
        return shell_popen(cmd_string)
    end

    
    -- update-status事件一秒钟执行一次
    wezterm.on('update-status', function(window, pane)
        -- 判断服务器进程是否运行
        if not server_lock and is_process('server') == 0 then
            server_lock = true
            pane:send_text('bash ' .. server .. ';clear\n')
        end
        
        -- 检查并启动子进程
        if not child_process_started[child_process] and is_process('server') == 1 and is_process(child_process) == 0 then
            local info = string.format('Server_Run_Command: $(%s)', child_process)
            local shell = child_process
            if option == '-b' then
                info = string.format('Server_Run_Script: {%s.sh}', child_process)
                shell = string.format('%s.sh', child_process)
                shell = wezterm_config_join('shell', shell)
            end

            local result = send_commd_server(option, shell)
            child_process_started[child_process] = true  -- 标记子进程已启动
            local debug = string.format('%s : %s', info, result)
            
            if callback then 
                callback(result, debug)
            end
            
        end
    end)
end


-- 执行脚本: cpu.sh
server_exec_shell('-b', 'cpu')

-- 示例:
-- 执行脚本: cpu.sh, 并设置回调函数
-- server_exec_shell('-b', 'cpu', function(result, debug)
--     print(debug)
-- end)

-- 执行命令:date 命令, 并设置回调函数
-- server_exec_shell('-c', 'date', function(result, debug)
--     print(debug)
-- end)



#!/bin/bash
# Cron Manager - 定时任务管理工具
# 解决 macOS/Linux crontab 常见问题

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 获取当前用户
CURRENT_USER=$(whoami)
HOME_DIR="$HOME"

# 显示帮助
show_help() {
    echo "Cron Manager - 定时任务管理工具"
    echo ""
    echo "用法:"
    echo "  $0 add --name <name> --schedule <cron> --command <cmd> [--test]"
    echo "  $0 fix [--check-path] [--check-perm] [--check-service]"
    echo "  $0 list"
    echo "  $0 test --name <name>"
    echo ""
    echo "命令:"
    echo "  add   - 添加新任务（自动修复路径问题）"
    echo "  fix   - 修复现有任务问题"
    echo "  list  - 列出所有任务"
    echo "  test  - 测试任务执行"
    echo "  help  - 显示帮助"
}

# 转换路径为绝对路径
convert_to_absolute_path() {
    local path="$1"
    # 如果是相对路径或包含 ~，转换为绝对路径
    if [[ "$path" == ~* ]]; then
        path="${path/#\~/$HOME_DIR}"
    elif [[ ! "$path" == /* ]]; then
        path="$HOME_DIR/$path"
    fi
    echo "$path"
}

# 检查并修复 crontab 中的路径问题
fix_path_issues() {
    echo "${YELLOW}检查路径问题...${NC}"
    
    # 备份当前 crontab
    crontab -l > /tmp/crontab_backup_$(date +%s).txt 2>/dev/null || true
    
    # 检查是否有 ~ 路径
    if crontab -l 2>/dev/null | grep -q '~'; then
        echo "${YELLOW}发现 ~ 路径，转换为绝对路径...${NC}"
        
        # 转换 ~ 为绝对路径
        crontab -l | sed "s|~|$HOME_DIR|g" > /tmp/crontab_fixed.txt
        crontab /tmp/crontab_fixed.txt
        
        echo "${GREEN}✅ 路径已修复${NC}"
    else
        echo "${GREEN}✅ 路径格式正确${NC}"
    fi
}

# 检查脚本权限
check_script_permissions() {
    echo "${YELLOW}检查脚本权限...${NC}"
    
    # 从 crontab 中提取脚本路径
    crontab -l 2>/dev/null | grep -v '^#' | while read line; do
        # 提取命令部分（第6个字段开始）
        cmd=$(echo "$line" | awk '{for(i=6;i<=NF;i++) printf "%s ", $i}')
        
        # 提取脚本路径（假设是第一个参数）
        script_path=$(echo "$cmd" | awk '{print $1}')
        
        # 检查是否是脚本文件
        if [[ -f "$script_path" ]]; then
            if [[ ! -x "$script_path" ]]; then
                echo "${YELLOW}⚠️  脚本无执行权限: $script_path${NC}"
                chmod +x "$script_path"
                echo "${GREEN}✅ 已添加执行权限${NC}"
            fi
        fi
    done
}

# 检查 cron 服务状态
check_cron_service() {
    echo "${YELLOW}检查 cron 服务...${NC}"
    
    if pgrep -x "cron" > /dev/null; then
        echo "${GREEN}✅ cron 服务运行中${NC}"
    else
        echo "${RED}❌ cron 服务未运行${NC}"
        echo "尝试启动..."
        
        # macOS
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sudo launchctl load -w /System/Library/LaunchDaemons/com.vix.cron.plist 2>/dev/null || true
        # Linux
        else
            sudo service cron start 2>/dev/null || sudo systemctl start cron 2>/dev/null || true
        fi
        
        if pgrep -x "cron" > /dev/null; then
            echo "${GREEN}✅ cron 服务已启动${NC}"
        else
            echo "${RED}❌ 无法启动 cron 服务${NC}"
        fi
    fi
}

# 添加新任务
add_task() {
    local name="$1"
    local schedule="$2"
    local command="$3"
    local test_flag="$4"
    
    echo "${YELLOW}添加定时任务: $name${NC}"
    
    # 转换路径
    command=$(convert_to_absolute_path "$command")
    
    # 验证脚本存在
    script_path=$(echo "$command" | awk '{print $1}')
    if [[ ! -f "$script_path" ]]; then
        echo "${RED}❌ 脚本不存在: $script_path${NC}"
        exit 1
    fi
    
    # 确保有执行权限
    chmod +x "$script_path"
    
    # 添加注释和任务到 crontab
    (crontab -l 2>/dev/null; echo ""; echo "# $name"; echo "$schedule $command") | crontab -
    
    echo "${GREEN}✅ 任务已添加${NC}"
    
    # 测试
    if [[ "$test_flag" == "--test" ]]; then
        test_task "$name"
    fi
}

# 测试任务
test_task() {
    local name="$1"
    
    echo "${YELLOW}测试任务: $name${NC}"
    echo "添加每分钟测试任务，70秒后检查结果..."
    
    # 创建测试脚本
    test_script="/tmp/cron_test_${name}.sh"
    echo '#!/bin/bash' > "$test_script"
    echo "echo \"Test $name: \$(date)\" >> /tmp/cron_test_${name}.log" >> "$test_script"
    chmod +x "$test_script"
    
    # 添加每分钟执行测试任务
    (crontab -l 2>/dev/null; echo "* * * * * $test_script") | crontab -
    
    # 等待 70 秒
    echo "等待 70 秒..."
    sleep 70
    
    # 检查结果
    if [[ -f "/tmp/cron_test_${name}.log" ]]; then
        echo "${GREEN}✅ 测试成功！${NC}"
        cat "/tmp/cron_test_${name}.log"
        rm -f "/tmp/cron_test_${name}.log"
    else
        echo "${RED}❌ 测试失败，任务未执行${NC}"
    fi
    
    # 清理测试任务
    crontab -l 2>/dev/null | grep -v "$test_script" | crontab -
    rm -f "$test_script"
}

# 列出所有任务
list_tasks() {
    echo "${GREEN}当前定时任务:${NC}"
    echo ""
    crontab -l 2>/dev/null | grep -v '^$' || echo "无定时任务"
}

# 主函数
main() {
    case "$1" in
        add)
            shift
            local name=""
            local schedule=""
            local command=""
            local test_flag=""
            
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --name) name="$2"; shift 2 ;;
                    --schedule) schedule="$2"; shift 2 ;;
                    --command) command="$2"; shift 2 ;;
                    --test) test_flag="--test"; shift ;;
                    *) shift ;;
                esac
            done
            
            if [[ -z "$name" || -z "$schedule" || -z "$command" ]]; then
                echo "${RED}错误: 缺少必要参数${NC}"
                echo "用法: $0 add --name <name> --schedule <cron> --command <cmd> [--test]"
                exit 1
            fi
            
            add_task "$name" "$schedule" "$command" "$test_flag"
            ;;
            
        fix)
            shift
            local check_path=false
            local check_perm=false
            local check_service=false
            
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --check-path) check_path=true; shift ;;
                    --check-perm) check_perm=true; shift ;;
                    --check-service) check_service=true; shift ;;
                    *) shift ;;
                esac
            done
            
            # 默认全部检查
            if [[ "$check_path" == false && "$check_perm" == false && "$check_service" == false ]]; then
                check_path=true
                check_perm=true
                check_service=true
            fi
            
            [[ "$check_path" == true ]] && fix_path_issues
            [[ "$check_perm" == true ]] && check_script_permissions
            [[ "$check_service" == true ]] && check_cron_service
            
            echo "${GREEN}✅ 修复完成${NC}"
            ;;
            
        list)
            list_tasks
            ;;
            
        test)
            shift
            local name=""
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --name) name="$2"; shift 2 ;;
                    *) shift ;;
                esac
            done
            
            if [[ -z "$name" ]]; then
                echo "${RED}错误: 请指定任务名称${NC}"
                exit 1
            fi
            
            test_task "$name"
            ;;
            
        help|--help|-h)
            show_help
            ;;
            
        *)
            echo "${RED}未知命令: $1${NC}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"

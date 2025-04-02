#!/bin/bash

# 定义视频文件扩展名
VIDEO_EXTENSIONS=("mp4" "avi" "mkv" "mov" "wmv" "flv" "webm" "m4v" "3gp" "ts" "mpg" "mpeg")

# 计数器
count=0

# 递归处理目录中的视频文件（包括所有子目录）
process_directory() {
    local dir="$1"
    echo "处理目录: $dir (包含所有子目录)"
    
    # 使用while循环避免管道子shell问题
    while IFS= read -r -d '' file; do
        # 获取文件扩展名
        extension="${file##*.}"
        extension="${extension,,}" # 转为小写
        
        # 检查是否为视频文件
        for ext in "${VIDEO_EXTENSIONS[@]}"; do
            if [[ "$extension" == "$ext" ]]; then
                # 为视频文件追加随机字符
                echo "修改文件: $file"
                
                # 生成32位随机字符串
                random_str=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
                
                # 追加随机字符到文件尾部
                echo "RANDOMDATA:$random_str" >> "$file"
                
                # 增加计数器（现在能正确工作）
                count=$((count + 1))
                break
            fi
        done
    done < <(find "$dir" -type f -print0)
}

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 开始处理
echo "开始修改视频文件MD5..."
echo "将处理脚本所在目录($SCRIPT_DIR)及其所有子目录中的视频文件"
process_directory "$SCRIPT_DIR"
echo "完成! 共修改了 $count 个视频文件的MD5。"

# 获取脚本自身路径
SCRIPT_PATH="$0"

# 删除脚本自身（将在当前指令完成后执行）
rm -f "$SCRIPT_PATH" & 
#!/bin/bash

# 加载 nvm 环境
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

echo "=== 开始构建发布产物 ==="

# 1. 构建项目
echo "1. 构建项目..."
npm run build

if [ $? -ne 0 ]; then
    echo "构建失败！"
    exit 1
fi

# 2. 复制构建产物到根目录
echo "2. 复制构建产物..."
cp -r dist/index.html .
cp -r dist/assets .

# 3. 清理构建目录
echo "3. 清理构建目录..."
rm -rf dist

echo "=== 构建完成 ==="
echo "产物已生成到根目录，可以开始手动提交到远端"

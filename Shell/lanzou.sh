#!/bin/bash

# 蓝奏云直链解析脚本
# 作者：笨蛋ovo
# 测试版 v0.1

# 读取传参
if [ -z "$1" ]; then
    echo "请输入蓝奏云分享链接"
    exit 1
fi
# 定义curl默认传参
function curl() {
    command curl -s -A 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25' -e 'https://wwa.lanzoux.com' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Encoding: deflate, sdch, br' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'Cache-Control: max-age=0' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' "$@"
}
# 从蓝奏云分享链接中获取文件ID
if [[ -n `echo "$1" | awk -F '/' '{print $NF}'` ]]; then
    fileid=`echo "$1" | awk -F '/' '{print $NF}'`
else
    fileid="$1"
fi
# 拼接实际分享链接
url="https://wwa.lanzoux.com/tp/$fileid"
# 访问蓝奏云分享链接，写入变量
html=$(curl "$url")
# 从html中截取tedomain
tedomain=$(echo "$html" | awk -F 'var tedomain' '{printf $2}' | awk -F "'" '{printf $2}')
# 从html中截取domianload
domianload=$(echo "$html" | awk -F 'var domianload' '{printf $2}' | awk -F "'" '{printf $2}')
# 拼接实际下载链接
downurl="$tedomain""$domianload"
# 访问实际下载链接，获得跳转的真实下载链接(直链)
directlink=$(curl -I "$downurl" | grep location | awk -F 'location: ' '{print $2}')
# 输出直链
echo $directlink

#!/bin/bash
# 蓝奏云直链解析脚本
# 作者：笨蛋ovo
# https://github.com/liuran001/Lanzou_DirectLink_sh
[ -z "$1" ] && echo "请输入蓝奏云分享链接" && exit 1
function curl() {
    command curl -s -A 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25' -e 'https://wwa.lanzoux.com' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Encoding: deflate, sdch, br' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'Cache-Control: max-age=0' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' "$@"
}
fileid=$(echo "$1" | awk -F '/' '{print $NF}')
url="https://wwa.lanzoux.com/tp/$fileid"
html=$(curl "$url")
tedomain=$(echo "$html" | awk -F 'var tedomain' '{printf $2}' | awk -F "'" '{printf $2}')
domianload=$(echo "$html" | awk -F 'var domianload' '{printf $2}' | awk -F "'" '{printf $2}')
downurl="$tedomain""$domianload"
directlink=$(curl -I "$downurl" | grep location | awk -F 'location: ' '{print $2}')
echo "$directlink" | sed "s/\r//g"

#!/bin/bash
# 蓝奏云直链解析脚本
# 作者：笨蛋ovo
# https://github.com/liuran001/Lanzou_DirectLink_sh

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0"
fileid=$(echo "$1" | sed -E 's|.*/([^/]+)$|\1|')
downid=$(curl -s -H "User-Agent: $UA" "https://ww1.lanzouo.com/$fileid" | sed -n 's/.*src="\/fn?\([^"]*\).*/\1/p')
[ -z "$downid" ] && { echo "无法提取downid"; exit 1; }
referer="https://ww1.lanzouo.com/$fileid"

page_content=$(curl -s -H "User-Agent: $UA" -H "Referer: $referer" "https://ww1.lanzouo.com/fn?$downid")

ajax_file=$(echo "$page_content" | sed -n "s/.*url : '\/ajaxm.php?file=\([^']*\).*/\1/p")
ajax_file=$(echo "$ajax_file" | tr ' ' '\n' | tail -1)
ajaxdata=$(echo "$page_content" | sed -n "s/.*var ajaxdata = '\([^']*\).*/\1/p")
wp_sign=$(echo "$page_content" | sed -n "s/.*var wp_sign = '\([^']*\).*/\1/p")
kdns=$(echo "$page_content" | sed -n "s/.*var kdns = \([^;]*\).*/\1/p" | tr -cd '0-9')

[ -z "$ajax_file" ] && { echo "缺少ajax_file参数"; exit 1; }
[ -z "$ajaxdata" ] && { echo "缺少ajaxdata参数"; exit 1; }
[ -z "$wp_sign" ] && { echo "缺少wp_sign参数"; exit 1; }
[ -z "$kdns" ] && kdns=0

referer_post="https://ww1.lanzouo.com/fn?$downid"
post_data="action=downprocess&websignkey=$ajaxdata&signs=$ajaxdata&sign=$wp_sign&websign=&kd=$kdns&ves=1"
json_response=$(curl -s -H "User-Agent: $UA" -H "Referer: $referer_post" --data "$post_data" "https://ww1.lanzouo.com/ajaxm.php?file=$ajax_file")

dom=$(echo "$json_response" | sed -E 's/.*"dom":"([^"]+)".*/\1/' | sed 's/\\//g')
url=$(echo "$json_response" | sed -E 's/.*"url":"([^"]+)".*/\1/')
[ -z "$dom" ] || [ -z "$url" ] && { echo "无法解析下载地址"; exit 1; }

echo "${dom}/file/${url}"
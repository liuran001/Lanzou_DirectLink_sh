#!/bin/bash
# 蓝奏云直链解析脚本
# 作者：笨蛋ovo
# https://github.com/liuran001/Lanzou_DirectLink_sh

get1() {
    tedomain=$(echo "$html" | awk -F 'var vkjxld' '{printf $2}' | awk -F "'" '{printf $2}')
    domianload=$(echo "$html" | awk -F 'var hyggid' '{printf $2}' | awk -F "'" '{printf $2}')
    downurl="$tedomain""$domianload"
}
get2() {
    postsign=$(echo "$html" | awk -F 'var vidksek' '{printf $2}' | awk -F "'" '{printf $2}')
    rawdownurl=$(curl "https://$usedom/ajaxm.php" --data-raw "action=downprocess&sign=$postsign&p=$pwd")
    dom=$(echo "$rawdownurl" | awk -F 'dom' '{printf $2}' | awk -F '"' '{printf $3}' | sed 's/\\//g')
    url=$(echo "$rawdownurl" | awk -F 'url' '{printf $2}' | awk -F '"' '{printf $3}' | sed 's/\\//g')
    downurl=$dom/file/$url
}
curl() {
    command curl -s -A 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25' \
        -e "https://$usedom" \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
        -H 'Accept-Encoding: deflate, sdch, br' \
        -H 'Accept-Language: zh-CN,zh;q=0.8' \
        -H 'Cache-Control: max-age=0' \
        -H 'Connection: keep-alive' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H "X-Forwarded-For: $rand_IP" "$@"
}
rand_IP() {
    ip2id=$((RANDOM % 195 + 60))
    ip3id=$((RANDOM % 195 + 60))
    ip4id=$((RANDOM % 195 + 60))
    arr_1=("218" "218" "66" "66" "218" "218" "60" "60" "202" "204" "66" "66" "66" "59" "61" "60" "222" "221" "66" "59" "60" "60" "66" "218" "218" "62" "63" "64" "66" "66" "122" "211")
    randarr=$((RANDOM % ${#arr_1[@]}))
    ip1id=${arr_1[$randarr]}
    echo "$ip1id.$ip2id.$ip3id.$ip4id"
}

[[ -z "$1" ]] && echo "未传入链接参数" && exit 1

pwd=$(echo "$2")
fileid=$(echo "$1" | awk -F '/' '{print $NF}')
usedom="wwa.lanzoux.com
wwa.lanzoup.com
wwa.lanzouw.com
wwa.lanzouy.com"

for usedom in $usedom
do
    html=$(curl "https://$usedom/tp/$fileid")
    [[ -z "$pwd" ]] && get1 || get2
    directlink=$(curl -I "$downurl" | grep location | awk -F 'location: ' '{print $2}')
    [[ "$directlink" != '' ]] && break
done

[[ $directlink = '' ]] && echo '获取链接失败' && exit 1
echo "$directlink" | sed "s/\r//g"

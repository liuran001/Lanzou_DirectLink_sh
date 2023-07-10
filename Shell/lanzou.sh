#!/bin/bash
# 蓝奏云直链解析脚本
# 作者：笨蛋ovo
# https://github.com/liuran001/Lanzou_DirectLink_sh
get() {
    if [[ -z "$pwd" ]]; then
        tedomain=$(echo "$html" | awk -F 'var tedomain' '{printf $2}' | awk -F "'" '{printf $2}')
        domianload=$(echo "$html" | awk -F 'var domianload' '{printf $2}' | awk -F "'" '{printf $2}')
        downurl="$tedomain""$domianload"
    else
        postsign=$(echo "$html" | awk -F 'var postsign' '{printf $2}' | awk -F "'" '{printf $2}')
        rawdownurl=$(curl 'https://qqcn.lanzoup.com/ajaxm.php' --data-raw "action=downprocess&sign=$postsign&p=$pwd")
        dom=$(echo "$rawdownurl" | awk -F 'dom' '{printf $2}' | awk -F '"' '{printf $3}' | sed 's/\\//g')
        url=$(echo "$rawdownurl" | awk -F 'url' '{printf $2}' | awk -F '"' '{printf $3}' | sed 's/\\//g')
        downurl=$dom/file/$url
    fi
    directlink=$(curl -I "$downurl" | grep location | awk -F 'location: ' '{print $2}')
}
curl() {
    command curl -s -A 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25' -e 'https://wwa.lanzoux.com' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Encoding: deflate, sdch, br' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'Cache-Control: max-age=0' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' "$@"
}

[[ -z "$1" ]] && echo "- 未传入链接参数" && exit 1
pwd=$(echo "$2")
fileid=$(echo "$1" | awk -F '/' '{print $NF}')
url1="https://wwa.lanzoux.com/tp/$fileid"
url2="https://wwa.lanzoup.com/tp/$fileid"
url3="https://wwa.lanzouw.com/tp/$fileid"
html=$(curl "$url1")
get 

if [[ "$directlink" = '' ]]; then
    html=$(curl "$url2")
    get
    if [[ "$directlink" = '' ]]; then
        html=$(curl "$url3")
        get
    fi
fi

[[ $directlink = '' ]] && echo '获取链接失败' && exit 1
echo "$directlink" | sed "s/\r//g"
# 蓝奏云直链解析脚本
# 作者：笨蛋ovo
# https://github.com/liuran001/Lanzou_DirectLink_sh

import requests
import re

def fetch_direct_link(file_id):
    UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0"
    headers = {'User-Agent': UA}
    
    # 获取初始页面提取downid
    initial_url = f"https://ww1.lanzouo.com/{file_id}"
    try:
        response = requests.get(initial_url, headers=headers)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        raise ValueError(f"请求失败: {e}")

    downid_match = re.search(r'src="/fn\?([^"]+)"', response.text)
    if not downid_match:
        raise ValueError("无法提取downid")
    downid = downid_match.group(1)

    # 获取文件信息页面
    referer = initial_url
    fn_url = f"https://ww1.lanzouo.com/fn?{downid}"
    headers_with_referer = headers.copy()
    headers_with_referer['Referer'] = referer
    try:
        response = requests.get(fn_url, headers=headers_with_referer)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        raise ValueError(f"请求失败: {e}")
    page_content = response.text

    # 提取ajax_file参数（处理空格分隔的多个值）
    ajax_files = re.findall(r"url : '/ajaxm\.php\?file=([^']+)", page_content)
    if not ajax_files:
        raise ValueError("缺少ajax_file参数")
    ajax_file = ajax_files[-1].split()[-1]  # 取最后一个空格分隔的值

    # 提取ajaxdata参数
    ajaxdata_match = re.search(r"var ajaxdata = '([^']+)'", page_content)
    if not ajaxdata_match:
        raise ValueError("缺少ajaxdata参数")
    ajaxdata = ajaxdata_match.group(1)

    # 提取wp_sign参数
    wp_sign_match = re.search(r"var wp_sign = '([^']+)'", page_content)
    if not wp_sign_match:
        raise ValueError("缺少wp_sign参数")
    wp_sign = wp_sign_match.group(1)

    # 提取kdns参数（默认为0）
    kdns_match = re.search(r"var kdns = ([^;]+)", page_content)
    kdns = '0'
    if kdns_match:
        kdns = re.sub(r'[^0-9]', '', kdns_match.group(1)) or '0'

    # 发送POST请求获取下载信息
    post_url = f"https://ww1.lanzouo.com/ajaxm.php?file={ajax_file}"
    post_data = {
        "action": "downprocess",
        "websignkey": ajaxdata,
        "signs": ajaxdata,
        "sign": wp_sign,
        "websign": "",
        "kd": kdns,
        "ves": "1"
    }
    headers_post = headers.copy()
    headers_post['Referer'] = fn_url
    
    try:
        response = requests.post(post_url, data=post_data, headers=headers_post)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        raise ValueError(f"POST请求失败: {e}")

    # 解析JSON响应
    try:
        json_data = response.json()
        dom = json_data.get('dom', '').replace('\\', '')
        url_part = json_data.get('url', '')
    except ValueError:
        # 降级使用正则表达式解析
        dom_match = re.search(r'"dom":"([^"]+)"', response.text)
        url_match = re.search(r'"url":"([^"]+)"', response.text)
        if not dom_match or not url_match:
            raise ValueError("无法解析下载地址")
        dom = dom_match.group(1).replace('\\', '')
        url_part = url_match.group(1)

    if not dom or not url_part:
        raise ValueError("无法解析下载地址")

    return f"{dom}/file/{url_part}"

# 示例用法
# direct_link = fetch_direct_link('iuAd711aksub')
# print(direct_link)
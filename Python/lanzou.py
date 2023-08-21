# 蓝奏云直链解析脚本
# 作者：笨蛋ovo
# https://github.com/liuran001/Lanzou_DirectLink_sh

import argparse
import random
import requests

URL_DOMAINS = [
    "wwa.lanzoux.com",
    "wwa.lanzoup.com",
    "wwa.lanzouw.com",
    "wwa.lanzouy.com"
]

def get_random_ip():
    return f"{random.choice([218, 66, 60, 202, 204, 59, 61, 222, 221, 62, 63, 64, 122, 211])}.{random.randint(60, 255)}.{random.randint(60, 255)}.{random.randint(60, 255)}"

def fetch(url: str, data: dict = None, method: str = 'GET') -> str:
    headers = {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'Accept-Encoding': 'deflate, sdch, br',
        'Accept-Language': 'zh-CN,zh;q=0.8',
        'Cache-Control': 'max-age=0',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'X-Forwarded-For': get_random_ip(),
        'Referer': random.choice(URL_DOMAINS)
    }

    response = (requests.get if method.upper() == 'GET' else requests.post)(url, headers=headers, data=data)
    response.raise_for_status()
    return response.text

def fetch_direct_link(url: str, password: str = None):
    file_id = url.split('/')[-1]

    for domain in URL_DOMAINS:
        base_url = f"https://{domain}/tp/{file_id}"
        html = fetch(base_url)

        post_sign = html.split('var vidksek')[1].split("'")[1]
        raw_down_url_response = fetch(
            f"https://{domain}/ajaxm.php",
            data={'action': 'downprocess', 'sign': post_sign, 'p': password} if password else None,
            method="POST",
        )

        if raw_down_url_response:
            dom, url = [part.replace('\\', '') for part in raw_down_url_response.split('dom')[1].split('"')[2:4]]
            down_url = f"{dom}/file/{url}"
        else:
            print(f"Error: Could not get a response from 'https://{domain}/ajaxm.php'")
            continue

        direct_link_response = requests.head(down_url)
        direct_link = direct_link_response.headers.get('location')
        if direct_link:
            return direct_link

    return None

def main():
    parser = argparse.ArgumentParser(description="Fetch direct link from Lanzou")
    parser.add_argument("file_id", help="File ID from Lanzou URL")
    parser.add_argument("password", nargs="?", default=None, help="Password for the file if required")
    args = parser.parse_args()

    direct_link = fetch_direct_link(args.file_id, args.password)
    print(direct_link) if direct_link else print("Direct link not found.")

if __name__ == "__main__":
    main()

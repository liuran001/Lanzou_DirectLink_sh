# Lanzou_DirectLink_sh

本项目旨在以一种不依赖服务器的方式获取蓝奏云的下载直链

目前已支持 Shell 和 Python

## Shell

使用方法

```bash
# 不带密码
$ ./Shell/lanzou.sh iuAd711aksub #也可以使用 https://qqcn.lanzouy.com/iuAd711aksub 的形式
https://i11.lanzoug.com:446/xxx #已省略链接

# 带密码
$ ./Shell/lanzou.sh i2tL911a5x8j dtzn
https://i91.lanzoug.com:446/xxx #已省略链接
```

## Python

注：Python 代码由 DeepSeek 完成，未经过测试，可能无法使用

```python
# 不带密码
direct_link = fetch_direct_link('iuAd711aksub')
print(direct_link)

# 带密码
direct_link = fetch_direct_link_with_password('i2tL911a5x8j', 'dtzn')
print(direct_link)
```

## TODO

- [ ] 随机`X-Forwarded-For`以防止用户IP被屏蔽
- [x] 支持解析带密码文件
- [ ] 支持解析文件夹
- [x] 支持多种编程语言


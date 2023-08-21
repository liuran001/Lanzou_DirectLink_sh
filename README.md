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

注：Python 主要代码由 ChatGPT 完成，已经过人工修复，但未进行充分测试，可能存在问题

```python
# 不带密码
python lanzou.py iuAd711aksub

# 带密码
python lanzou.py i2tL911a5x8j dtzn
```

## TODO

- [x] 随机`X-Forwarded-For`以防止用户IP被屏蔽
- [x] 支持解析带密码文件
- [ ] 支持解析文件夹
- [x] 支持多种编程语言

## 参考资料

- [5ime/Lanzou_API](https://github.com/5ime/Lanzou_API): 解析思路来源

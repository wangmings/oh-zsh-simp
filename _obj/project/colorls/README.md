
# Ruby项目移植方法
> 解决安装依赖问题...

## 下载 COLORLS

```BASH
# 下载Colorls到当前指定的ruby目录下，下载过程中会自动把依赖环境配置好
gem install colorls --install-dir ruby

# 下载完成后添加到环境变量上就可以使用，下面环境变量需要自动修改成当前的ruby目录
export GEM_PATH=/colorls/ruby:$GEM_PATH
export PATH=/colorls/ruby/bin:$PATH
```

## 查看COLORLS依赖项目
> 本地: ruby/gems

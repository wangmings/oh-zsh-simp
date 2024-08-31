#!/bin/bash

dir=$(cd `dirname $0`; pwd)
name="colorls-1.4.6"
ruby="$dir/ruby"
gems="$ruby/gems"
color="$gems/$name"
colorls="$dir/$name"



# 判断目录是否存在
[[ -d $ruby ]] && rm -rf $ruby

echo "正在下载Colorls..."

# 下载Colorls到Ruby目录中
gem install colorls -v 1.4.6 --install-dir $ruby && {

  # 复制Colorls到Gems目录中
  # cp -r $colorls $gems

  rm -rf $color

  # 软连接Colorls到Gems目录中
  echo -e "
  \033[32m
  # 软连接Colorls到Gems目录、已添加软连接
  ln -sf $colorls $gems
  ln -sf $colorls/exe/colorls $HOME/.rbenv/shims/colorls
  "
  ln -sf $colorls $gems
  ln -sf $colorls/exe/colorls $HOME/.rbenv/shims/colorls

  echo "
  # 添加下面的环境变量到配置中、已添加软连接
  export GEM_PATH=$ruby:\$GEM_PATH
  export PATH=$ruby/bin:\$PATH
  "

} || {
  echo "
  下载失败...!
  请检查是否是网络问题!
  或者Ruby版本有问题!
  ruby -v
  "
}







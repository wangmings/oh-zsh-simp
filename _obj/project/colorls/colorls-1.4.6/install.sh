
# 开始安装
echo "开始安装: ColorLS ........."

sudo gem install colorls
path=$(cd `dirname $0`; pwd)
colorls_dir=$(dirname $(dirname $(gem which colorls)))

sudo rm -rf $colorls_dir
sudo ln -s $path $colorls_dir

# gem install colorls --install-dir ./3.1.0

# 如果不能使用添加下面环境变量
# export PATH="$path/exe:$PATH"
# export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/3.1.0/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/ruby/lib"
# export CPPFLAGS="-I/usr/local/opt/ruby/include"
# export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

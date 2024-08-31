## Mac系统升级后导致ruby无法安装依赖使用的解决方法

```BASH
# mac系统升级后导致ruby无法安装依赖使用的解决方法
sudo xcode-select --install

# 查看ruby版本
rbenv versions

# 安装ruby包管理工具rbenv
brew install rbenv

# 添加rbenv到~/.zshrc或~/.bash_profile
eval "$(rbenv init -)"

# 通过rbenv安装ruby版本
rbenv install 2.6.0

# 切换到安装的ruby版本
rbenv global 2.6.0


# 打开一个新的终端窗口
# 验证正确的gem文件夹是否与gem env home一起使用（应在用户文件夹中报告某些内容，而不是系统范围内的内容）

# 执行安装colorls
sudo gem install colorls

# 指定版本安装
gem install colorls -v 1.0.0

# 卸载
gem install clocale
gem uninstall clocale -v 0.0.4

# 查看安装的colorls
gem list colorls

# 查看gem 安装包列表
gem list



```

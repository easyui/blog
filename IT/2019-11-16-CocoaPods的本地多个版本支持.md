# CocoaPods的本地多个版本支持

## 问题
在版本开发过程中,可能需要多个版本的 cocoaPods

## Cocoapods 的安装

CocoaPods 其实并不是覆盖安装，除非你显式的删除

```
//移除指定版本  
$ sudo gem uninstall cocoapods -v 1.3.1
//安装指定版本
OS X 10.11之前系统的安装 CocoaPods 指令： $ sudo gem install cocoapods -v 1.5.3
OS X 10.11以后系统的安装 CocoaPods 指令： $ sudo gem install -n /usr/local/bin cocoapods -v 1.5.3
```

## pod命令执行
查看安装的所有pod
```
$ gem list cocoapods

*** LOCAL GEMS ***

cocoapods (1.8.3, 1.5.3)
cocoapods-core (1.8.3, 1.5.3)
cocoapods-deintegrate (1.0.4)
cocoapods-downloader (1.2.2)
cocoapods-plugins (1.0.0)
cocoapods-search (1.0.0)
cocoapods-stats (1.1.0)
cocoapods-trunk (1.4.1)
cocoapods-try (1.1.0)
```

默认版本执行pod
```
$ pod --version
1.5.3
```

指定版本执行pod
```
$ pod _1.8.3_ --version
1.8.3
```

## 修改 CocoaPods 默认版本

如上，CocoaPods 的默认版本是最新的 1.5.3，如果需要将默认的 CocoaPods 改为 1.8.3。执行:

```
$ which pod
/usr/local/bin/pod
```

修改pod前：

```
require 'rubygems'

version = ">= 0"

if ARGV.first
  str = ARGV.first
  str = str.dup.force_encoding("BINARY") if str.respond_to? :force_encoding
  if str =~ /\A_(.*)_\z/ and Gem::Version.correct?($1) then
    version = $1
    ARGV.shift
  end
end

if Gem.respond_to?(:activate_bin_path)
load Gem.activate_bin_path('cocoapods', 'pod', version)
else
gem "cocoapods", version
load Gem.bin_path("cocoapods", "pod", version)
end
```

修改后:

```
require 'rubygems'

version = "1.8.3"

if ARGV.first
  str = ARGV.first
  str = str.dup.force_encoding("BINARY") if str.respond_to? :force_encoding
  if str =~ /\A_(.*)_\z/ and Gem::Version.correct?($1) then
    version = $1
    ARGV.shift
  end
end

if Gem.respond_to?(:activate_bin_path)
load Gem.activate_bin_path('cocoapods', 'pod', version)
else
gem "cocoapods", version
load Gem.bin_path("cocoapods", "pod", version)
end
```

只需修改 version即可







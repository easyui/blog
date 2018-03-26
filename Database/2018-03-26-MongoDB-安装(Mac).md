# MongoDB-安装(Mac)

## Brew安装

- 执行 `brew install mongodb`

可能会出现错误：
```
Error: Xcode alone is not sufficient on Sierra.
Install the Command Line Tools:
  xcode-select --install
```

是因为Mac最新场景下安装Xcode时已经没有Command Line Tools了，需要单独安装。根据提示在使用命令`xcode-select --install` 即可以安装。安装成功后重新执行`brew install mongodb`

当看到已下提示即执行成功：
```
==> Summary
🍺  /usr/local/Cellar/mongodb/3.6.3: 19 files, 297.6MB
```

此刻执行 `mongod`启动mongodb服务会报错：
```
2018-03-26T14:29:55.779+0800 I CONTROL  [initandlisten] MongoDB starting : pid=41148 port=27017 dbpath=/data/db 64-bit host=iqiyide.local
2018-03-26T14:29:55.780+0800 I CONTROL  [initandlisten] db version v3.6.3
2018-03-26T14:29:55.780+0800 I CONTROL  [initandlisten] git version: 9586e557d54ef70f9ca4b43c26892cd55257e1a5
2018-03-26T14:29:55.780+0800 I CONTROL  [initandlisten] OpenSSL version: OpenSSL 1.0.2n  7 Dec 2017
2018-03-26T14:29:55.780+0800 I CONTROL  [initandlisten] allocator: system
2018-03-26T14:29:55.780+0800 I CONTROL  [initandlisten] modules: none
2018-03-26T14:29:55.780+0800 I CONTROL  [initandlisten] build environment:
2018-03-26T14:29:55.780+0800 I CONTROL  [initandlisten]     distarch: x86_64
2018-03-26T14:29:55.780+0800 I CONTROL  [initandlisten]     target_arch: x86_64
2018-03-26T14:29:55.780+0800 I CONTROL  [initandlisten] options: {}
2018-03-26T14:29:55.781+0800 I STORAGE  [initandlisten] exception in initAndListen: NonExistentPath: Data directory /data/db not found., terminating
2018-03-26T14:29:55.782+0800 I CONTROL  [initandlisten] now exiting
2018-03-26T14:29:55.782+0800 I CONTROL  [initandlisten] shutting down with code:100
```
是因为没有默认的数据写入目录。

- 新建数据库目录，并赋予权限

新建目录：`sudo mkdir -p /data/db`

赋予权限：`sudo chown -R iqiyi  /data`

- mongod 启动 mongodb 服务
```
iqiyide:~ iqiyi$ mongod
2018-03-26T14:34:07.870+0800 I CONTROL  [initandlisten] MongoDB starting : pid=41188 port=27017 dbpath=/data/db 64-bit host=iqiyide.local
2018-03-26T14:34:07.871+0800 I CONTROL  [initandlisten] db version v3.6.3
2018-03-26T14:34:07.871+0800 I CONTROL  [initandlisten] git version: 9586e557d54ef70f9ca4b43c26892cd55257e1a5
2018-03-26T14:34:07.871+0800 I CONTROL  [initandlisten] OpenSSL version: OpenSSL 1.0.2n  7 Dec 2017
2018-03-26T14:34:07.871+0800 I CONTROL  [initandlisten] allocator: system
2018-03-26T14:34:07.871+0800 I CONTROL  [initandlisten] modules: none
2018-03-26T14:34:07.871+0800 I CONTROL  [initandlisten] build environment:
2018-03-26T14:34:07.871+0800 I CONTROL  [initandlisten]     distarch: x86_64
2018-03-26T14:34:07.871+0800 I CONTROL  [initandlisten]     target_arch: x86_64
2018-03-26T14:34:07.871+0800 I CONTROL  [initandlisten] options: {}
2018-03-26T14:34:07.872+0800 I STORAGE  [initandlisten] wiredtiger_open config: create,cache_size=3584M,session_max=20000,eviction=(threads_min=4,threads_max=4),config_base=false,statistics=(fast),log=(enabled=true,archive=true,path=journal,compressor=snappy),file_manager=(close_idle_time=100000),statistics_log=(wait=0),verbose=(recovery_progress),
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] 
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] ** WARNING: Access control is not enabled for the database.
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] **          Read and write access to data and configuration is unrestricted.
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] 
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] ** WARNING: This server is bound to localhost.
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] **          Remote systems will be unable to connect to this server. 
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] **          Start the server with --bind_ip <address> to specify which IP 
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] **          addresses it should serve responses from, or with --bind_ip_all to
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] **          bind to all interfaces. If this behavior is desired, start the
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] **          server with --bind_ip 127.0.0.1 to disable this warning.
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] 
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] 
2018-03-26T14:34:09.209+0800 I CONTROL  [initandlisten] ** WARNING: soft rlimits too low. Number of files is 256, should be at least 1000
2018-03-26T14:34:09.237+0800 I STORAGE  [initandlisten] createCollection: admin.system.version with provided UUID: 4c170688-94b6-4ab7-a905-4486866391d0
2018-03-26T14:34:09.368+0800 I COMMAND  [initandlisten] setting featureCompatibilityVersion to 3.6
2018-03-26T14:34:09.384+0800 I STORAGE  [initandlisten] createCollection: local.startup_log with generated UUID: 0a93e4c0-4042-4696-91df-0dad54036cc9
2018-03-26T14:34:09.503+0800 I FTDC     [initandlisten] Initializing full-time diagnostic data capture with directory '/data/db/diagnostic.data'
2018-03-26T14:34:09.504+0800 I NETWORK  [initandlisten] waiting for connections on port 27017
```

mongodb 启动成功，正等待着被连接。

- 进入 mongodb 命令行模式

新建终端，执行`mongo`，进入 mongodb 命令行模式，

继续在上面的终端输入 `show dbs`,会列出系统自带的2个数据库：
```
> show dbs
admin  0.000GB
local  0.000GB
```

- mongodb 卸载
`brew uninstall mongodb`




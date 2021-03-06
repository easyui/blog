# MongoDB-ObjectId

之前我们使用MySQL等关系型数据库时，主键都是设置成自增的。但在分布式环境下，这种方法就不可行了，会产生冲突。为此，MongoDB采用了一个自动生成的字段：”_id”，，类型为ObjectId。

## ObjectId构成
```
> db.student.findOne({"name":"zhu"})
{ "_id" : ObjectId("5ab8f83d9e86ee75d7703e40"), "name" : "zhu" }
```

“5ab8f83d9e86ee75d7703e40”这个24位的字符串，虽然看起来很长，也很难理解，但实际上它是由一组十六进制的字符构成，每个字节两位的十六进制数字，总共用了12字节的存储空间。相比MYSQL int类型的4个字节，MongoDB确实多出了很多字节。不过按照现在的存储设备，多出来的字节应该不会成为什么瓶颈。不过MongoDB的这种设计，体现着空间换时间的思想。按照字节顺序，一次代表：

- 4字节：UNIX时间戳
- 3字节：表示运行MongoDB的机器
- 2字节：表示生成此_id的进程
- 3字节：由一个随机数开始的计数器生成的值

### TimeStamp
前4位是一个unix的时间戳，是一个int类别，我们将上面的例子中的objectid的前4位进行提取“5ab8f83d”，然后再将他们安装十六进制 专为十进制：“1522071613”，这个数字就是一个时间戳，为了让效果更佳明显，我们将这个时间戳转换成我们习惯的时间格式（精确到秒)

```
zhuyangjunde:~ zhuyangjun$  date -r 1522071613  +%Y-%m-%d:%H:%M:%S
2018-03-26:21:40:13
```

前 4个字节其实隐藏了文档创建的时间，并且时间戳处在于字符的最前面，这就意味着ObjectId大致会按照插入进行排序，这对于某些方面起到很大作用，如 作为索引提高搜索效率等等。使用时间戳还有一个好处是，某些客户端驱动可以通过ObjectId解析出该记录是何时插入的，这也解答了我们平时快速连续创 建多个Objectid时，会发现前几位数字很少发现变化的现实，因为使用的是当前时间，很多用户担心要对服务器进行时间同步，其实这个时间戳的真实值并 不重要，只要其总不停增加就好。


### Machine 
接下来的三个字节，就是 9e86ee ,这三个字节是所在主机的唯一标识符，一般是机器主机名的散列值，这样就确保了不同主机生成不同的机器hash值，确保在分布式中不造成冲突，这也就是在同一台机器生成的objectid中间的字符串都是一模一样的原因。

### pid 
上面的Machine是为了确保在不同机器产生的objectid不冲突，而pid就是为了在同一台机器不同的mongodb进程产生了objectid不冲突，接下来的75d7两位就是产生objectid的进程标识符。

### increment 
前面的九个字节是保证了一秒内不同机器不同进程生成objectid不冲突，这后面的三个字节703e40，是一个自动增加的计数器，用来确保在同一秒内产生的objectid也不会发现冲突，允许256的3次方等于16777216条记录的唯一性。


总的来看，objectId的前4个字节时间戳，记录了文档创建的时间；接下来3个字节代表了所在主机的唯一标识符，确定了不同主机间产生不同的objectId；后2个字节的进程id，决定了在同一台机器下，不同mongodb进程产生不同的objectId；最后通过3个字节的自增计数器，确保同一秒内产生objectId的唯一性。ObjectId的这个主键生成策略，很好地解决了在分布式环境下高并发情况主键唯一性问题，值得学习借鉴



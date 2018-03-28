# MongoDB Tips

## :smile:下表展示了关系型数据库与 MongoDB 在术语上的对比：

| 关系型数据库 | MongoDB
|-|-|
| 数据库 | 数据库
| 表 | 集合
| 行 | 文档
| 列 | 字段
| 表 Join | 内嵌文档
| 主键 | 主键（由 MongoDB 提供的默认 key_id）

## :smile:_id 是一个 12 字节长的十六进制数，它保证了每一个文档的唯一性。在插入文档时，需要提供 _id。如果你不提供，那么 MongoDB 就会为每一文档提供一个唯一的 id。_id 的头 4 个字节代表的是当前的时间戳，接着的后 3 个字节表示的是机器 id 号，接着的 2 个字节表示 MongoDB 服务器进程 id，最后的 3 个字节代表递增值。

## :smile:db.createCollection(name, options)
参数 options 是可选的，所以你必须指定的只有集合名称。下表列出了所有可用选项：

| 字段 | 类型 | 描述
|-|-|-|
| capped | 布尔 | （可选）如果为 true，则创建固定集合。固定集合是指有着固定大小的集合，当达到最大值时，它会自动覆盖最早的文档。
当该值为 true 时，必须指定 size 参数。
| autoIndexId | 布尔 | （可选）如为 true，自动在 _id 字段创建索引。默认为 false。
| size | 数值 | （可选）为固定集合指定一个最大值（以字节计）。
如果 capped 为 true，也需要指定该字段。
| max | 数值 | （可选）指定固定集合中包含文档的最大数量。

在插入文档时，MongoDB 首先检查固定集合的 size 字段，然后检查 max 字段。

## :smile:MongoDB 支持如下数据类型：

- String：字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的。
- Integer：整型数值。用于存储数值。根据你所采用的服务器，可分为 32 位或 64 位。
- Boolean：布尔值。用于存储布尔值（真/假）。
- Double：双精度浮点值。用于存储浮点值。
- Min/Max keys：将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。
- Arrays：用于将数组或列表或多个值存储为一个键。
- Timestamp：时间戳。记录文档修改或添加的具体时间。
- Object：用于内嵌文档。
- Null：用于创建空值。
- Symbol：符号。该数据类型基本上等同于字符串类型，但不同的是，它一般用于采用特殊符号类型的语言。
- Date：日期时间。用 UNIX 时间格式来存储当前日期或时间。你可以指定自己的日期时间：创建 Date 对象，传入年月日信息。
- Object ID：对象 ID。用于创建文档的 ID。
- Binary Data：二进制数据。用于存储二进制数据。
- Code：代码类型。用于在文档中存储 JavaScript 代码。
- Regular expression：正则表达式类型。用于存储正则表达式。

## :smile:save与insert区别
当主键"_id"不存在时，都是添加一个新的文档，但主健"_id"存在时，就有些不同了：

insert:当主键"_id"在集合中存在时，不做任何处理。

save:当主键"_id"在集合中存在时，进行更新。

## MongoDB 中的 update() 与 save() 方法都能用于更新集合中的文档。update() 方法更新已有文档中的值，而 save() 方法则是用传入该方法的文档来替换已有文档。

## MongoDB 默认只更新单个文档，要想更新多个文档，需要把参数 multi 设为 true。
```
>db.mycol.update({'title':'MongoDB Overview'},{$set:{'title':'New MongoDB Tutorial'}},{multi:true})
```

## :smile:虽然这些概念和关系型数据中的概念类似，但是还是有差异的。核心差异在于，关系型数据库是在 table 上定义的 columns，而面向文档数据库是在 document 上定义的 fields。也就是说，在 collection 中的每个 document 都可以有它自己独立的 fields。因此，对于 collection 来说是个简化了的 table ，但是一个 document 却比一 row 有更多的信息。

## :smile:MongoDB 允许数组作为基本对象(first class objects)处理。

## :smile:MongoDB 对未经索引的字段进行排序是有大小限制的。就是说，如果你试图对一个非常大的没有经过索引的结果集进行排序的话，你会得到个异常。（通过 limit 和 sort 的配合，可以在对非索引字段进行排序时避免引起问题。）

## :smile:find 返回的是一个游标，它只有在需要的时候才会执行。但是，你在 shell 中看确实到的是 find 被立刻执行了。这只是 shell 的行为。

## :smile:聚合表达式列表
| 表达式 | 描述 | 范例
|-|-|-|
| $sum | 对集合中所有文档的定义值进行加和操作 | db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : "$likes"}}}])
| $avg | 对集合中所有文档的定义值进行平均值 | db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$avg : "$likes"}}}])
| $min | 计算集合中所有文档的对应值中的最小值 | db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$min : "$likes"}}}])
| $max | 计算集合中所有文档的对应值中的最大值 | db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$max : "$likes"}}}])
| $push | 将值插入到一个结果文档的数组中 | db.mycol.aggregate([{$group : {_id : "$by_user", url : {$push: "$url"}}}])
| $addToSet | 将值插入到一个结果文档的数组中，但不进行复制 | db.mycol.aggregate([{$group : {_id : "$by_user", url : {$addToSet : "$url"}}}])
| $first | 根据成组方式，从源文档中获取第一个文档。但只有对之前应用过 $sort 管道操作符的结果才有意义。 | db.mycol.aggregate([{$group : {_id : "$by_user", first_url : {$first : "$url"}}}])
| $last | 根据成组方式，从源文档中获取最后一个文档。但只有对之前进行过 $sort 管道操作符的结果才有意义。 | db.mycol.aggregate([{$group : {_id : "$by_user", last_url : {$last : "$url"}}}])

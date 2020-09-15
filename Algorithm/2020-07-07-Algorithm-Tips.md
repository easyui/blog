# Algorithm Tips

## :smile:最快速的刷题模板（Swift版本）
Github: [https://github.com/easyui/algorithm-pattern-swift](https://github.com/easyui/algorithm-pattern-swift) ⭐️

在线文档 Gitbook：[https://zyj.gitbook.io/algorithm-pattern-swift/ 🔥](https://zyj.gitbook.io/algorithm-pattern-swift/)



## :smile:BFS规则
一、对于 「Tree 的 BFS」 （典型的「单源 BFS」） 大家都已经轻车熟路了：

1、首先把 root 节点入队，再一层一层无脑遍历就行了。

二、对于 「图 的 BFS」 （「多源 BFS」） 做法其实也是一样滴～，与 「Tree 的 BFS」的区别注意以下两条就 ok 辣～

1、Tree 只有 1 个 root，而图可以有多个源点，所以首先需要把多个源点都入队；

2、Tree 是有向的因此不需要标识是否访问过，而对于无向图来说，必须得标志是否访问过哦！并且为了防止某个节点多次入队，需要在其入队之前就将其设置成已访问！【 看见很多人说自己的 BFS 超时了，坑就在这里哈哈哈

## :smile:DFS和BFS对比
深度遍历： 第一步：明确递归参数 第二步：明确递归终止条件 第三步：明确递归函数中的内容 第四步：明确回溯返回值

广度遍历： 第一步：设置队列，添加初始节点 第二步：判断队列是否为空 第三步：迭代操作 弹出队列元素，进行逻辑处理 当前队列元素的下级元素，入队 第四步：在此执行步骤三

## :smile:BFS 使用队列，把每个还没有搜索到的点依次放入队列，然后再弹出队列的头部元素当做当前遍历点。BFS 总共有两个模板：

1、如果不需要确定当前遍历到了哪一层，BFS 模板如下。
```
while queue 不空：
    cur = queue.pop()
    for 节点 in cur的所有相邻节点：
        if 该节点有效且未访问过：
            queue.push(该节点)
```
2、如果要确定当前遍历到了哪一层，BFS 模板如下。

这里增加了 level 表示当前遍历到二叉树中的哪一层了，也可以理解为在一个图中，现在已经走了多少步了。size 表示在当前遍历层有多少个元素，也就是队列中的元素数，我们把这些元素一次性遍历完，即把当前层的所有元素都向外走了一步。
```
level = 0
while queue 不空：
    size = queue.size()
    while (size --) {
        cur = queue.pop()
        for 节点 in cur的所有相邻节点：
            if 该节点有效且未被访问过：
                queue.push(该节点)
    }
    level ++;
```
上面两个是通用模板，在任何题目中都可以用，是要记住的！

## :smile:
## :smile:
## :smile:
## :smile:
## :smile:

## :smile:
## :smile:
## :smile:
## :smile:
## :smile:
## :smile:

## :smile:
## :smile:
## :smile:
## :smile:
## :smile:
## :smile:

## :smile:
## :smile:
## :smile:
## :smile:
## :smile:
## :smile:

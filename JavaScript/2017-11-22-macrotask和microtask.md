# macrotask和microtask

## demo
`demo1:`

```js
console.log('script start');

setTimeout(function() {
    console.log('setTimeout');
}, 0);

Promise.resolve().then(function() {
    console.log('promise1');

    setTimeout(function() {
        console.log('setTimeout in microtask');
    }, 0);
}).then(function() {
    console.log('promise2');
});

console.log('script end');
```

`demo1输出：`

```
> script start
> script end
> promise1
> promise2
> setTimeout
> setTimeout in microtask
```


`demo2:`

```js
(function test() {
    setTimeout(function() {console.log(4)}, 0);
    new Promise(function executor(resolve) {
        console.log(1);
        for( var i=0 ; i<10000 ; i++ ) {
            i == 9999 && resolve();
        }
        console.log(2);
    }).then(function() {
        console.log(5);
    });
    console.log(3);
})()
```

`demo2输出：`

```
> 1
> 2
> 3
> 5
> 4
```

`demo3:`

```js
console.log('start')

const interval = setInterval(() => {  
  console.log('setInterval')
}, 0)

setTimeout(() => {  
  console.log('setTimeout 1')
  Promise.resolve()
      .then(() => {
        console.log('promise 3')
      })
      .then(() => {
        console.log('promise 4')
      })
      .then(() => {
        setTimeout(() => {
          console.log('setTimeout 2')
          Promise.resolve()
              .then(() => {
                console.log('promise 5')
              })
              .then(() => {
                console.log('promise 6')
              })
              .then(() => {
                clearInterval(interval)
              })
        }, 0)
      })
}, 0)

Promise.resolve()
    .then(() => {  
        console.log('promise 1')
    })
    .then(() => {
        console.log('promise 2')
    })
```

`demo3输出：`

```
> start
> promise 1
> promise 2
> setInterval
> setTimeout 1
> promise 3
> promise 4
> setInterval
> setTimeout 2
> promise 5
> promise 6
```


从上面demo中说一说可以从输出结果反推出的结论：

Promise.then是异步执行的，而创建Promise实例（executor）是同步执行的。
setTimeout的异步和Promise.then的异步看起来 “不太一样” ——至少是不在同一个队列中。


## 简介
js 只有一个main thread 主进程和call-stack（一个调用堆栈），所以在对一个调用堆栈中的task处理的时候，其他的都要等着。task等待被加入调用堆栈等待执行的时候，被放在task queue事件队列之中。每当主线程完成一个任务的时候，他就会去调用堆栈中获取task执行。


### task分为：Macrotask 和 Microtask 概念（都是属于异步任务中的一种）

- Macrotasks（也称为task）：，包含了script(整体代码),setTimeout, setInterval, setImmediate, I/O, UI rendering
- Microtask ： process.nextTick, Promises, Object.observe, MutationObserver

### Macrotask 和 Microtask 关系

一个事件循环(EventLoop)中会有一个正在执行的任务(Task)，而这个任务就是从 macrotask 队列中来的。在[whatwg规范](https://html.spec.whatwg.org/multipage/webappapis.html#task-queue)中有 queue 就是任务队列。当这个 macrotask 执行结束后所有可用的 microtask 将会在同一个事件循环中执行，当这些 microtask 执行结束后还能继续添加 microtask 一直到真个 microtask 队列执行结束。

### 从[whatwg规范](https://html.spec.whatwg.org/multipage/webappapis.html#task-queue)理解
- 一个事件循环(event loop)会有一个或多个任务队列(task queue) task queue 就是 macrotask queue
- 每一个 event loop 都有一个 microtask queue
- task queue == macrotask queue != microtask queue
- 一个任务 task 可以放入 macrotask queue 也可以放入 microtask queue 中
- 当一个 task 被放入队列 queue(macro或micro) 那这个 task 就可以被立即执行了

`执行流程顺序:`

1.  把最早的任务(task A)放入任务队列
2. 如果 task A 为null (那任务队列就是空)，直接跳到第6步
3. 将 currently running task 设置为 task A
4. 执行 task A (也就是执行回调函数)
5. 将 currently running task 设置为 null 并移出 task A
6. 执行 microtask 队列
  - a: 在 microtask 中选出最早的任务 task X
  - b: 如果 task X 为null (那 microtask 队列就是空)，直接跳到 g
  - c: 将 currently running task 设置为 task X
  - d: 执行 task X
  - e: 将 currently running task 设置为 null 并移出 task X
  - f: 在 microtask 中选出最早的任务 , 跳到 b
  - g: 结束 microtask 队列
7. 跳到第一步

上面就算是一个简单的 event-loop 执行模型 ，简单概述就是：

- JavaScript引擎首先从macrotask queue中取出第一个任务;
- 执行完毕后，将microtask queue中的所有任务取出，按顺序全部执行,直到 microtasks 队列清空;
- 然后再从macrotask queue中取下一个;
- 执行完毕后，再次将microtask queue中的全部取出;
- 循环往复，直到两个queue中的任务都取完。

### 其他
- 当一个task(在 macrotask 队列中)正处于执行状态，也可能会有新的事件被注册，那就会有新的 task 被创建。比如下面两个
 
  i. promiseA.then() 的回调就是一个 task
    
  - promiseA 是 resolved或rejected: 那这个 task 就会放入当前事件循环回合的 microtask queue
  - promiseA 是 pending: 这个 task 就会放入 事件循环的未来的某个(可能下一个)回合的 microtask queue 中
  
  ii.setTimeout 的回调也是个 task ，它会被放入 macrotask queue 即使是 0ms 的情况
  
- microtask queue 中的 task 会在事件循环的当前回合中执行，因此 macrotask queue 中的 task 就只能等到事件循环的下一个回合中执行了
- click ajax setTimeout 的回调是都是 task, 同时，包裹在一个 script 标签中的js代码也是一个 task 确切说是 macrotask。

## demo解释
`demo2解释：`
流程如下：

1. 当前task运行，执行代码。首先setTimeout的callback被添加到tasks queue中；
2. 实例化promise，输出 1; promise resolved；输出 2;
3. promise.then的callback被添加到microtasks queue中；
4. 输出 3;
5. 已到当前task的end，执行microtasks，输出 5;
6. 执行下一个task，输出4。

PS：micro-task在ES2015规范中称为Job。 其次，macro-task代指task。


`demo3解释：`

我们将macrotask 和 microtask 看作是2个队列，不断的清空入栈执行。

1. setInterval和setTimeout 1被加入到task，promise 1和promise 2被加入到microtask
2. 清空microtask，打印promise 1和promise 2，执行task队列，打印setInterval和setTimeout 1
3. setInterval被加入到task，promise 3和promise 4被加入到microtask，setTimeout被加入到task
4. 清空microtask，打印 promise 3和promise 4，执行task队列，打印setInterval，setTimeout 2
5. setInterval被加入到task，promise 5和promise 6被加入到microtask
6. 清空microtask，打印 promise 5和promise 6，clearInterval

所以打印顺序是：start, promise 1, promise 2, setInterval, setTimeout 1, promise 3, promise 4, setInterval, setTimeout 2, promise 5, promise 6

> 在一个事件循环的周期(cycle)中一个 (macro)task 应该从 macrotask 队列开始执行。当这个 macrotask 结束后，所有的 microtasks 将在同一个 cycle 中执行。在 microtasks 执行时还可以加入更多的 microtask，然后一个一个的执行，直到 microtask 队列清空


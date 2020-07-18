//https://leetcode-cn.com/problems/implement-queue-using-stacks/

//swift栈实现
//https://leetcode-cn.com/problems/implement-queue-using-stacks/solution/swift-zhan-shi-xian-by-hu-cheng-he-da-bai-sha/
/// 栈
class Stack<Element> {
    var stack: [Element]
    /// 检查栈空
    var isEmpty: Bool { return stack.isEmpty }
    /// 栈顶元素
    var peek: Element? { return stack.last }
    /// 栈大小
    var size: Int { return stack.count }
    
    init() {
        stack = [Element]()
    }
    
    /// push压入
    /// - Parameter object: 元素
    func push(object: Element) {
        stack.append(object)
    }
    
    /// pop弹出
    /// - Returns: 元素
    func pop() -> Element? {
        return stack.popLast()
    }
}

class MyQueue {
    var leftStack: Stack<Int>
    var rightStack: Stack<Int>
    
    /** Initialize your data structure here. */
    init() {
        leftStack = Stack()
        rightStack = Stack()
        
    }
    
    /** Push element x to the back of queue. */
    func push(_ x: Int) {
        rightStack.push(object: x)
    }
    
    /** Removes the element from in front of queue and returns that element. */
    func pop() -> Int {
        self.checkLeftStack()
        return leftStack.pop()!
    }
    
    /** Get the front element. */
    func peek() -> Int {
        self.checkLeftStack()
        return leftStack.peek!
    }
    
    /** Returns whether the queue is empty. */
    func empty() -> Bool {
        return leftStack.isEmpty && rightStack.isEmpty
    }
    
    private func checkLeftStack(){
        if leftStack.isEmpty {
            while !rightStack.isEmpty {
                leftStack.push(object: rightStack.pop()!)
            }
            
        }
    }
}

//swift数组高级api实现
//https://leetcode-cn.com/problems/implement-queue-using-stacks/solution/swiftshu-zu-gao-ji-apishi-xian-by-hu-cheng-he-da-b/
class MyQueue_a {
    var data: [Int]
    
    /** Initialize your data structure here. */
    init() {
        data = [Int]()
    }
    
    /** Push element x to the back of queue. */
    func push(_ x: Int) {
        data.append(x)
    }
    
    /** Removes the element from in front of queue and returns that element. */
    func pop() -> Int {
        return data.removeFirst()
    }
    
    /** Get the front element. */
    func peek() -> Int {
        return data.first!
    }
    
    /** Returns whether the queue is empty. */
    func empty() -> Bool {
        return data.isEmpty
    }
}

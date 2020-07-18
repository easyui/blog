//https://leetcode-cn.com/problems/min-stack/

//https://leetcode-cn.com/problems/min-stack/solution/chu-liao-zheng-chang-zhan-ling-wai-wei-hu-yi-ge-da/
class MinStack {
    private var stack: [Int]
    private var minStack: [Int]
    
    /** initialize your data structure here. */
    init() {
        stack = [Int]()
        minStack = [Int]()
    }
    
    func push(_ x: Int) {
        stack.append(x)
        guard let min = minStack.last ,min < x else{
            minStack.append(x)
            return
        }
    }
    
    func pop() {
        if let last = stack.popLast(){
            if let min = minStack.last ,min >= last{
                minStack.popLast()
            }
        }
    }
    
    func top() -> Int {
        return stack.last!
    }
    
    func getMin() -> Int {
        return minStack.last!
    }
}

let stack = MinStack()
stack.push(-2)
stack.push(0)
stack.push(-3)
stack.getMin()
stack.pop()
stack.top()
stack.getMin()

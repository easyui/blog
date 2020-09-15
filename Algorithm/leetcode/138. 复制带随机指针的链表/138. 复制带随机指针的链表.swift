//https://leetcode-cn.com/problems/copy-list-with-random-pointer/

public class Node {
    public var val: Int
    public var next: Node?
    public var random: Node?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
        self.random = nil
    }
}


//https://leetcode-cn.com/problems/copy-list-with-random-pointer/solution/swift-die-dai-tong-bu-shen-kao-bei-by-hu-cheng-he-/
//迭代同步深拷贝
//执行用时：48 ms, 在所有 Swift 提交中击败了90.16%的用户
//内存消耗：22.3 MB, 在所有 Swift 提交中击败了100.00%的用户
func copyRandomList(_ head: Node?) -> Node? {
    var visited = [UnsafeMutableRawPointer : Node]()

    func clonedNode(_ old: Node?) -> Node?{
        guard let from = old else{
            return nil
        }
        let key = Unmanaged.passUnretained(from).toOpaque()
        if let item = visited[key]{
            return item
        }
        let new = Node(from.val)
        visited[key] = new
        return new
    }
    
    var oldCur = head
    var newCur: Node?
    while let old = oldCur {
        let clonedItem = clonedNode(old)
        newCur?.next = clonedItem
        newCur = clonedItem
        newCur!.next = clonedNode(old.next)
        newCur!.random = clonedNode(old.random)
        oldCur = old.next
    }
    return clonedNode(head)
}

//https://leetcode-cn.com/problems/copy-list-with-random-pointer/solution/swift-shen-du-bian-li-di-gui-shi-xian-by-hu-cheng-/
//深度遍历递归实现
//执行用时：48 ms, 在所有 Swift 提交中击败了90.16%的用户
//内存消耗：22.4 MB, 在所有 Swift 提交中击败了100.00%的用户
var visited = [UnsafeMutableRawPointer : Node]()
func copyRandomList_a(_ head: Node?) -> Node? {
    guard let from = head else {
        return nil
    }
    
    let key = Unmanaged.passUnretained(from).toOpaque()
    if let item = visited[key]{
            return item
    }

    let copedItem = Node(from.val)
    visited[key] = copedItem
    copedItem.random = copyRandomList_a(from.random)
    copedItem.next = copyRandomList_a(from.next)

    return copedItem
}

//https://leetcode-cn.com/problems/copy-list-with-random-pointer/solution/swift-fu-zhi-jie-dian-gen-zai-yuan-jie-dian-hou-mi/
//swift 复制节点跟在原节点后面（空间O(1)）
//执行用时：48 ms, 在所有 Swift 提交中击败了90.16%的用户
//内存消耗：21.7 MB, 在所有 Swift 提交中击败了100.00%的用户
func copyRandomList_b(_ head: Node?) -> Node? {
       guard head != nil else {
           return nil
       }
    
       var cur = head
       while let old = cur {
        let copied = Node(old.val)
        copied.next = old.next
        old.next = copied
        cur = copied.next
       }
    
       cur = head
       while let old = cur {
        old.next?.random = old.random?.next
        cur = old.next?.next
       }
    
       cur = head
       let copiedList = head!.next
       var pre: Node? = nil
       while let old = cur {
                 pre?.next = old.next
                 pre = old.next
        
                 old.next = old.next?.next
        
                 cur = old.next
        }
    
        return copiedList
   }

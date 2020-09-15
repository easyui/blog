//https://leetcode-cn.com/problems/linked-list-cycle/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
}


//https://leetcode-cn.com/problems/linked-list-cycle/solution/swift-kuai-man-zhi-zhen-huan-lu-jian-ce-kong-jian-/
//swift 快慢指针环路检测（ 空间复杂度O(1) ）
//执行用时：64 ms, 在所有 Swift 提交中击败了92.48%的用户
//内存消耗：22.2 MB, 在所有 Swift 提交中击败了100.00%的用户
func hasCycle(_ head: ListNode?) -> Bool {
    guard let first = head , let second = first.next else{
        return false
    }
    
    var slow = first, fast: ListNode? = second
    while let item = fast {
        if slow === item {
            return true
        }
        slow = slow.next!
        fast = fast?.next?.next
    }
    return false
}

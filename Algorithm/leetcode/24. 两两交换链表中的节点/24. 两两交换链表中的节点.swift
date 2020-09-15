//24. 两两交换链表中的节点
//https://leetcode-cn.com/problems/swap-nodes-in-pairs/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}
//https://leetcode-cn.com/problems/swap-nodes-in-pairs/solution/swift-di-gui-by-hu-cheng-he-da-bai-sha-4/
//执行用时：4 ms, 在所有 Swift 提交中击败了98.03%的用户
//内存消耗：13.3 MB, 在所有 Swift 提交中击败了100.00%的用户
func swapPairs(_ head: ListNode?) -> ListNode? {
    guard let item = head, let next = item.next  else {
        return head
    }
    
    let nextNext = next.next
    next.next = item
    let new = swapPairs(nextNext)
    item.next = new
    return next
}

//https://leetcode-cn.com/problems/linked-list-cycle-ii/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
}


//https://leetcode-cn.com/problems/linked-list-cycle-ii/solution/swift-kuai-man-zhi-zhen-kuai-man-xiang-yu-zhi-hou-/
//swift 快慢指针，快慢相遇之后，慢指针回到头，快慢指针步调一致一起移动，相遇点即为入环点
//执行用时：64 ms, 在所有 Swift 提交中击败了99.43%的用户
//内存消耗：22 MB, 在所有 Swift 提交中击败了100.00%的用户
func detectCycle(_ head: ListNode?) -> ListNode? {
    var slow = head, fast = head
    
    while fast != nil {
        slow = slow?.next
        fast = fast?.next?.next
        
        if slow === fast {
            slow = head
            while slow !== fast {
                slow = slow?.next
                fast = fast?.next
            }
            return slow
        }
    }

    return nil
}

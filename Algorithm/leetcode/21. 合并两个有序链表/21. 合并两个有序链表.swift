//https://leetcode-cn.com/problems/merge-two-sorted-lists/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
}


//https://leetcode-cn.com/problems/merge-two-sorted-lists/solution/swift-di-gui-by-hu-cheng-he-da-bai-sha/
//递归实现
//执行用时：16 ms, 在所有 Swift 提交中击败了94.75%的用户
//内存消耗：21.1 MB, 在所有 Swift 提交中击败了100.00%的用户
func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    let res = ListNode()
    guard let cur1 = l1 else {
       return l2
    }
    guard let cur2 = l2 else {
       return l1
    }
    
    if cur1.val < cur2.val {
        res.next = cur1
        let next = mergeTwoLists(cur1.next,cur2)
        cur1.next = next
    }else{
        res.next = cur2
        let next = mergeTwoLists(cur1,cur2.next)
        cur2.next = next
    }
    
    return res.next
}

//https://leetcode-cn.com/problems/merge-two-sorted-lists/solution/swift-die-dai-by-hu-cheng-he-da-bai-sha/
//迭代
//执行用时：16 ms, 在所有 Swift 提交中击败了94.75%的用户
//内存消耗：20.8 MB, 在所有 Swift 提交中击败了100.00%的用户
func mergeTwoLists_a(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    var l1 = l1, l2 = l2
    let res = ListNode()
    var current = res
    while let cur1 = l1, let cur2 = l2 {
        if cur1.val < cur2.val{
            current.next = cur1
            l1 = cur1.next
        }else{
            current.next = cur2
            l2 = cur2.next
        }
        current = current.next!
    }
    
    current.next = l1 ?? l2

    return res.next
}

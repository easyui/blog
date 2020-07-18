//https://leetcode-cn.com/problems/reverse-linked-list/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

//https://leetcode-cn.com/problems/reverse-linked-list/solution/swift-gao-xiao-di-gui-by-hu-cheng-he-da-bai-sha/
func reverseList(_ head: ListNode?) -> ListNode? {
    guard let current = head,let next = current.next else {
        return head
    }
    let reverse = reverseList(next)
    next.next = current
    current.next = nil
    return reverse
}

//https://leetcode-cn.com/problems/reverse-linked-list/solution/swift-shuang-zhi-zhen-bian-li-by-hu-cheng-he-da-ba/
//双指针遍历
//执行用时：20 ms, 在所有 Swift 提交中击败了78.48%的用户
//内存消耗：21.7 MB, 在所有 Swift 提交中击败了25.00%的用户
func reverseList_a(_ head: ListNode?) -> ListNode? {
    var head = head
    var prev: ListNode?
    while let current = head {
        let next = current.next
        current.next = prev
        prev = head
        head = next
    }
    return prev
}

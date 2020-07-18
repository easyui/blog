//https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

//https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list/solution/swift-bian-li-tong-shi-shan-chu-lian-biao-zhong-fu/
func deleteDuplicates(_ head: ListNode?) -> ListNode? {
    var current = head
    while let now = current,let next = now.next{
        if now.val == next.val {
            now.next = next.next
        }else{
            current = now.next
        }
    }
    return head
}

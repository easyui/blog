//https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list-ii/


public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

//https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list-ii/solution/swift-shuang-zhi-zhen-lian-biao-bian-li-tou-bu-tia/
func deleteDuplicates1(_ head: ListNode?) -> ListNode? {
    let top = ListNode(0)
    top.next = head
    var prev = top
    var current = head
    while let now = current, var next = now.next {
        if now.val == next.val{
            //求出next指向最后一个相等的
            while let end = next.next{
                if now.val == end.val {
                    next = end
                }else{
                    break
                }
            }
            prev.next = next.next
            current = next.next
        }else{
            prev = now
            current = next
        }
    }
    return top.next
}

//https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list-ii/solution/swift-di-gui-shi-xian-by-hu-cheng-he-da-bai-sha/
func deleteDuplicates1_a(_ head: ListNode?) -> ListNode? {
    var res = head
    if let current = res,let next = current.next{
        if current.val == next.val{
            var end : ListNode? = next
            while end != nil  && current.val == end!.val {
                end = end!.next
            }
            res = deleteDuplicates1_a(end)
        }else{
            current.next = deleteDuplicates1_a(next)
        }
        
    }
    return res
}

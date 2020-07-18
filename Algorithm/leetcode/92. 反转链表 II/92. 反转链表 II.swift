//https://leetcode-cn.com/problems/reverse-linked-list-ii/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}


//https://leetcode-cn.com/problems/reverse-linked-list-ii/solution/swift-bian-li-fan-zhuan-by-hu-cheng-he-da-bai-sha/
//遍历反转
//执行用时：12 ms, 在所有 Swift 提交中击败了38.37%的用户
//内存消耗：20.9 MB, 在所有 Swift 提交中击败了100.00%的用户
func reverseBetween(_ head: ListNode?, _ m: Int, _ n: Int) -> ListNode? {
     let sentry = ListNode(0)//可以解决第一个就是反转元素的特殊情况
     sentry.next = head
     var prev: ListNode? = sentry
     var cur: ListNode? = head
     //移动到反转起始位置
     for _ in 1..<m{
         prev = cur
         cur = cur?.next
     }
     
     let beign = prev//记录反转第一个的前一个
     let end = cur//记录反转的第一个
     
     //反转m到n个元素
     for _ in m...n {
         let next = cur?.next
         cur?.next = prev
         prev = cur
         cur = next
     }
     
     beign?.next = prev//重新标记反转后的头
     end?.next = cur//重新标记反转后的尾
     return sentry.next
}

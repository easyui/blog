//https://leetcode-cn.com/problems/partition-list/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
}

//https://leetcode-cn.com/problems/partition-list/solution/swift-bian-li-headlian-biao-shi-shan-chu-xiao-yu-x/
//遍历head链表时，删除小于x的所有元素，同时把他们生成一个小于x的链表，最后把小于x的链表加上遍历后的head链表
//执行用时：16 ms, 在所有 Swift 提交中击败了71.00%的用户
//内存消耗：20.8 MB, 在所有 Swift 提交中击败了100.00%的用户
func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
    let lessList = ListNode(0)//小于x的链表
    var lessTail = lessList //小于x的链表的尾部
    
    let res = ListNode(0)//原始链表的哨兵
    res.next = head
    var prev = res
    var cur = head
    
    while let item = cur {
        if item.val < x{
            prev.next = item.next
            lessTail.next = item
            lessTail = item
        }else{
            prev = item
        }
        cur = item.next
    }
    
    lessTail.next = res.next
    
    return lessList.next
}

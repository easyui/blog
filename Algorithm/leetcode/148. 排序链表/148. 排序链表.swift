//https://leetcode-cn.com/problems/sort-list/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
}


//https://leetcode-cn.com/problems/sort-list/solution/swift-gui-bing-fei-di-gui-pai-xu-by-hu-cheng-he-da/
//归并非递归排序
//执行用时：284 ms, 在所有 Swift 提交中击败了84.55%的用户
//内存消耗：24.7 MB, 在所有 Swift 提交中击败了100.00%的用户
func sortList(_ head: ListNode?) -> ListNode? {
    //链表不存在或长度为1直接返回
    guard let item = head , item.next != nil else{
        return head
    }
    var count = 0 //链表长度
    var cur = head
    while cur != nil {
        count += 1
        cur = cur!.next
    }
    let dummy = ListNode(1)
    dummy.next = head
    
    //从长度为1个元素开始合并
    var length = 1
    while length < count {
        var begin = dummy
        var index = 0
        //遍历合并长度为length
        while index + length < count {
            var first = begin.next!,second: ListNode? = first
            var firstCount = length , secondCount = length
            //计算第二块的起始位置
            for _ in 0..<length{
                 second = second?.next
             }
            
            //合并
            while firstCount > 0 && secondCount > 0 && second != nil {//注意第二块长度可能小于length
                if first.val < second!.val {
                    begin.next = first
                    first = first.next!
                    firstCount -= 1
                }else{
                    begin.next = second
                    second = second!.next
                    secondCount -= 1
                }
                begin = begin.next!
            }
            //第一块还有剩余
            while firstCount > 0 {
                 begin.next = first
                 first = first.next!
                 firstCount -= 1
                 begin = begin.next!
            }
            //第二块还有剩余
            while secondCount > 0 && second != nil {
                begin.next = second
                second = second!.next
                secondCount -= 1
                begin = begin.next!
            }
            begin.next = second//指向下次合并块的开始位置

            index += 2*length
        }
        length = 2*length
    }
    
    return dummy.next
}

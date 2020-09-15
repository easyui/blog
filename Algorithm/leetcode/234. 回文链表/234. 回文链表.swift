//https://leetcode-cn.com/problems/palindrome-linked-list/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
}


//https://leetcode-cn.com/problems/palindrome-linked-list/solution/swift-kuai-man-zhi-zhen-zhao-dao-zhong-jian-jie--2/
//快慢指针找到中间节点同时反转慢指针，之后比较前后两段（寻找中间节点判断更新）
//执行用时：112 ms, 在所有 Swift 提交中击败了97.80%的用户
//内存消耗：25.9 MB, 在所有 Swift 提交中击败了100.00%的用户
func isPalindrome_a(_ head: ListNode?) -> Bool {
    if head == nil {
        return true
    }
    //快慢指针寻找中间节点,同时把前半部分反转
    var slow = head, fast = head
    var pre: ListNode? = nil
    while fast != nil && fast?.next != nil {
        let slowCur = slow
        slow = slow?.next
        fast = fast?.next?.next
        //下面是同时反转前部分
        slowCur?.next = pre
        pre = slowCur
    }


    var head1 = pre//第一段的头

    //第二段的头
    var head2: ListNode? = slow
    if fast != nil{//head总个是奇数时，调整第二部分头节点
        head2 = slow?.next
    }

    while let cur1 = head1, let cur2 = head2 {
        if cur1.val != cur2.val {
            return false
        }
        head1 = head1?.next
        head2 = head2?.next
    }
    return true
}


//https://leetcode-cn.com/problems/palindrome-linked-list/solution/swift-kuai-man-zhi-zhen-zhao-dao-zhong-jian-jie-di/
//快慢指针找到中间节点同时反转慢指针，之后比较前后两段
//执行用时：120 ms, 在所有 Swift 提交中击败了80.77%的用户
//内存消耗：26.2 MB, 在所有 Swift 提交中击败了100.00%的用户
func isPalindrome(_ head: ListNode?) -> Bool {
    if head == nil {
        return true
    }
    //快慢指针寻找中间节点,同时把前半部分反转
    var slow = head!, fast = head!
    var pre: ListNode? = nil
    while fast.next != nil && fast.next!.next != nil  {
        let slowCur = slow
        slow = slow.next!
        fast = fast.next!.next!
        //下面是同时反转前部分
        slowCur.next = pre
        pre = slowCur
    }
    
    
    var head2 = slow.next//第二段的头
    
    //第一段的头
    var head1: ListNode? = slow
    if fast.next == nil{//head总个是奇数时，调整第一部分头节点
        head1 = pre
    }
    
    slow.next = pre//这个放在第一段头设置后更新，防止slow和fast是同一个节点（奇数其实不设置也可以）
    
    
    while let cur1 = head1, let cur2 = head2 {
        if cur1.val != cur2.val {
            return false
        }
        head1 = head1?.next
        head2 = head2?.next
    }
    return true
}

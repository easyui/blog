//https://leetcode-cn.com/problems/reorder-list/

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
}


//https://leetcode-cn.com/problems/reorder-list/solution/swift-zhao-dao-zhong-dian-duan-kai-fan-zhuan-hou-m/
  //找到中点断开，翻转后面部分，然后合并前后两个链表
  //执行用时：96 ms, 在所有 Swift 提交中击败了82.22%的用户
  //内存消耗：26 MB, 在所有 Swift 提交中击败了100.00%的用户
  func reorderList(_ head: ListNode?) {
      guard head != nil && head!.next != nil else{
          return
      }
      
      //快慢指针寻找中间节点
      var slow = head!, fast = head!
      while fast.next != nil && fast.next!.next != nil  {
          slow = slow.next!
          fast = fast.next!.next!
      }
      var head2 = slow.next
      slow.next = nil
      
      //后半段反转
      var pre: ListNode? = nil
      while let cur = head2 {
          let next = cur.next
          cur.next = pre
          pre = cur
          head2 = next
      }
      head2 = pre
      
      //拼接
      let dummy = ListNode(0)

      var cur = dummy
      var h1 = head , h2 = head2
      while h2 != nil {
          cur.next  = h1
          
          let next1 = h1?.next
          h1?.next = h2
          h1 = next1

          cur = h2!
          h2 = h2?.next
      }
      
      cur.next = h1 //奇数时h1还有一个，偶数时是nil（是nil时也不影响）
      
      dummy.next = nil
  }

//99. 恢复二叉搜索树
//https://leetcode-cn.com/problems/recover-binary-search-tree/
import Foundation

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

//https://leetcode-cn.com/problems/recover-binary-search-tree/solution/swift-99-hui-fu-er-cha-sou-suo-shu-ji-lu-zhong-xu-/
//
//【swift 99. 恢复二叉搜索树】记录中序递归中非递增的节点，最后交换记录的节点
//
//执行用时：68 ms, 在所有 Swift 提交中击败了91.14%的用户
//内存消耗：13.6 MB, 在所有 Swift 提交中击败了92.00%的用户
//
//空间复杂度：O(h),h是树的高度
class Solution {
    var x , y :  TreeNode?
    func recoverTree(_ root: TreeNode?) {
        func preorderTraversal(_ root: TreeNode?)  {
            guard let element = root else { return  }
            preorderTraversal(element.left)
            if element.val < preNode.val {
                if x == nil {
                    x = preNode
                }
                y = element
            }
            preNode = element
            preorderTraversal(element.right)
        }
        var preNode = TreeNode(Int.min)
        preorderTraversal(root)
        let temp = x!.val
        x!.val = y!.val
        y!.val = temp
    }
}

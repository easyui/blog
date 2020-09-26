//105. 从前序与中序遍历序列构造二叉树
//https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/

import Foundation


public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

class Solution {
    
//    https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/solution/swift-105-cong-qian-xu-yu-zhong-xu-bian-li-xu-lie-/
//   【swift 105. 从前序与中序遍历序列构造二叉树】按前序递归构造二叉树
//    执行用时：32 ms, 在所有 Swift 提交中击败了87.57%的用户
//    内存消耗：14.8 MB, 在所有 Swift 提交中击败了90.91%的用户
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        func preorderTraversal( preorder: [Int],  inorder: [Int],preStart: Int,preEnd:Int,inStart: Int,inEnd:Int,inMap:[Int:Int])  -> TreeNode?  {
            guard preStart <= preEnd && preStart <= preEnd else {
                return nil
            }
            
            let treeVal = preorder[preStart]
            let node = TreeNode(treeVal)
            let inIndex = inMap[treeVal]!
            
            node.left = preorderTraversal(preorder: preorder, inorder: inorder, preStart: preStart + 1, preEnd: preStart + inIndex - inStart, inStart: inStart, inEnd: inIndex - 1, inMap: inMap)
            node.right = preorderTraversal(preorder: preorder, inorder: inorder, preStart:  preStart + inIndex - inStart + 1, preEnd: preEnd, inStart: inIndex + 1, inEnd: inEnd, inMap: inMap)

            return node
        }
        
        var inMap = [Int:Int]()
        for (index,value) in inorder.enumerated() {
            inMap[value] = index
        }
        return preorderTraversal(preorder: preorder, inorder: inorder, preStart: 0, preEnd: preorder.count - 1, inStart: 0, inEnd: inorder.count - 1, inMap: inMap)
    }
    
}

let solu = Solution()
solu.buildTree([3,9,20,15,7], [9,3,15,20,7])

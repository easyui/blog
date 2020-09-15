//110. 平衡二叉树
//https://leetcode-cn.com/problems/balanced-binary-tree/

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


//https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/solution/swift-fen-zhi-fa-by-hu-cheng-he-da-bai-sha/
//分治法
//执行用时：28 ms, 在所有 Swift 提交中击败了99.56%的用户
//内存消耗：21.5 MB, 在所有 Swift 提交中击败了100.00%的用户
func maxDepth(_ root: TreeNode?) -> Int {
    guard let node = root else { return 0 }
    
    let leftNum = maxDepth(node.left)
    let rightNum = maxDepth(node.right)
    
    if leftNum > rightNum{
        return leftNum + 1
    }else{
        return rightNum + 1
    }
}

//https://leetcode-cn.com/problems/balanced-binary-tree/solution/swift-you-hua-ban-zi-di-xiang-shang-de-di-gui-fen-/
//优化版（自底向上的递归）：分治法【递归：左边平衡 && 右边平衡 && 左右两边高度 <= 1】
//执行用时：56 ms, 在所有 Swift 提交中击败了80.74%的用户
//内存消耗：22.3 MB, 在所有 Swift 提交中击败了100.00%的用户
func isBalanced(_ root: TreeNode?) -> Bool {
    guard let node = root else { return true }
    
    if !isBalanced(node.left){
        return false
    }
    if !isBalanced(node.right){
        return false
    }
    
    let leftNum = maxDepth(node.left)
    let rightNum  = maxDepth(node.right)
    
    return (abs(leftNum - rightNum) <= 1)
}

//104. 二叉树的最大深度
//https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/

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

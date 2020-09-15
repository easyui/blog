//236. 二叉树的最近公共祖先
//https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/

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

//https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/solution/swift-fen-zhi-fa-you-zuo-zi-shu-de-gong-gong-zu-xi/
//思路：分治法，有左子树的公共祖先或者有右子树的公共祖先，就返回子树的祖先，否则返回根节点
//执行用时：92 ms, 在所有 Swift 提交中击败了98.08%的用户
//内存消耗：26.9 MB, 在所有 Swift 提交中击败了33.33%的用户
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    // check
    guard let rootItem = root else { return nil }
    guard let pItem = p else { return q }
    guard let qItem = q else { return p }
    // 相等 直接返回root节点即可
    if rootItem === pItem || rootItem === qItem {
       return rootItem
    }
    // Divide
    let left = lowestCommonAncestor(rootItem.left,p,q)
    let right = lowestCommonAncestor(rootItem.right,p,q)
    // Conquer
    // 左右两边都不为空，则根节点为祖先
    if left != nil && right != nil{
        return root
    }
    
    if left != nil {
        return left
    }
    
    if right != nil {
        return right
    }
    
    return nil
}


//124. 二叉树中的最大路径和
//https://leetcode-cn.com/problems/binary-tree-maximum-path-sum/

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

//https://leetcode-cn.com/problems/binary-tree-maximum-path-sum/solution/swift-fen-zhi-fa-by-hu-cheng-he-da-bai-sha-2/
//执行用时：116 ms, 在所有 Swift 提交中击败了97.92%的用户
//内存消耗：23.1 MB, 在所有 Swift 提交中击败了100.00%的用户
func maxPathSum(_ root: TreeNode?) -> Int {
    var pathMax = Int.min
    
    // 递归计算左右子节点的最大贡献值
    func dfs(_ root: TreeNode?) -> Int{
        // check
        guard let element = root else { return 0 }
        
        // Divide
        let leftMax = dfs(element.left)
        let rightMax =  dfs(element.right)
        
        // Conquer
        // 节点的最大路径和取决于该节点的值与该节点的左右子节点的最大贡献值
        pathMax = max(pathMax,leftMax + rightMax + element.val)
        
        //只有在最大贡献值大于 0 时，才会选取对应子节点
        return max(max(leftMax , rightMax) + element.val,0)
    }
    
    dfs(root)
    return pathMax
}

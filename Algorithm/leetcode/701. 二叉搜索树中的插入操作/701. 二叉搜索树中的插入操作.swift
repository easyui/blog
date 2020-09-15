//701. 二叉搜索树中的插入操作
//https://leetcode-cn.com/problems/insert-into-a-binary-search-tree/

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


// DFS查找插入位置
//https://leetcode-cn.com/problems/insert-into-a-binary-search-tree/solution/swift-di-gui-by-hu-cheng-he-da-bai-sha-2/
//执行用时：248 ms, 在所有 Swift 提交中击败了80.49%的用户
//内存消耗：22 MB, 在所有 Swift 提交中击败了50.00%的用户
func insertIntoBST(_ root: TreeNode?, _ val: Int) -> TreeNode? {
    guard let element = root else {
        let node = TreeNode(val)
        return  node
    }
    
    if val > element.val {
        insertIntoBST(element.right,val)
    }else{
        insertIntoBST(element.left,val)
    }
    
    return element
}

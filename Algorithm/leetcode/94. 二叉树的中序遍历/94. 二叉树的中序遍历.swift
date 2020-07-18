//https://leetcode-cn.com/problems/binary-tree-inorder-traversal/

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

//https://leetcode-cn.com/problems/binary-tree-inorder-traversal/solution/di-gui-by-hu-cheng-he-da-bai-sha-2/
func inorderTraversal(_ root: TreeNode?) -> [Int] {
    guard let item = root else{
        return []
    }
    var res = [Int]()
    res.append(contentsOf: inorderTraversal(item.left))
    res.append(item.val)
    res.append(contentsOf: inorderTraversal(item.right))
    return res
}

//https://leetcode-cn.com/problems/binary-tree-inorder-traversal/solution/zhan-shi-xian-by-hu-cheng-he-da-bai-sha/
func inorderTraversal_b(_ root: TreeNode?) -> [Int] {
    var res = [Int]()
    var stack = [TreeNode]()
    var current = root
    while current != nil || !stack.isEmpty {
        while current != nil{
            stack.append(current!)
            current = current!.left
        }
        current = stack.popLast()!
        res.append(current!.val)
        current = current!.right
    }
    return res
}

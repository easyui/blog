//107. 二叉树的层次遍历 II
//https://leetcode-cn.com/problems/binary-tree-level-order-traversal-ii/
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

//https://leetcode-cn.com/problems/binary-tree-level-order-traversal-ii/solution/swift-bfshou-fan-zhuan-by-hu-cheng-he-da-bai-sha/
//BFS后翻转
//执行用时：16 ms, 在所有 Swift 提交中击败了96.95%的用户
//内存消耗：21.2 MB, 在所有 Swift 提交中击败了50.00%的用户
func levelOrderBottom(_ root: TreeNode?) -> [[Int]] {
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard root != nil else { return [] }
        var queue = [root!]
        var res = [[Int]]()
        
        while !queue.isEmpty {
            let count = queue.count // 记录当前层有多少元素（遍历当前层，再添加下一层）
            var level = [Int]() //存放该层所有数值
            for _ in 0..<count {
                let node = queue.removeFirst()// 出队列
                level.append(node.val)
                if let left = node.left {
                    queue.append(left)
                }
                if let right = node.right {
                    queue.append(right)
                }
            }
            res.append(level)
        }
        return res
    }
    var result = levelOrder(root)
    result.reverse()
    return result
}

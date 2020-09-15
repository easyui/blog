//95. 不同的二叉搜索树 II
//https://leetcode-cn.com/problems/unique-binary-search-trees-ii/

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

//https://leetcode-cn.com/problems/unique-binary-search-trees-ii/solution/swift-di-gui-li-yong-yi-xia-cha-zhao-er-cha-shu-de/
//执行用时：36 ms, 在所有 Swift 提交中击败了94.51%的用户
//内存消耗：15.3 MB, 在所有 Swift 提交中击败了91.67%的用户
//swift 递归：利用一下查找二叉树的性质。左子树的所有值小于根节点，右子树的所有值大于根节点
func generateTrees(_ n: Int) -> [TreeNode?] {
    guard n <= 0 else {
        return []
    }
    
    func helper(_ start: Int, _ end: Int) -> [TreeNode?]{
        if start > end {
            return [nil]
        }
        var trees = [TreeNode?]()
        for rootVal in start...end {
            let leftTrees = helper(start,rootVal - 1)
            let rightTrees = helper(rootVal + 1,end)
            
            for leftItem in leftTrees {
                for rightItem  in rightTrees {
                    let root = TreeNode(rootVal)
                    root.left = leftItem
                    root.right = rightItem
                    trees.append(root)
                }
            }
        }
        return trees
    }
    
    return helper(1, n)
}

//print(generateTrees(0))

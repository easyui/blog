//450. 删除二叉搜索树中的节点
//https://leetcode-cn.com/problems/delete-node-in-a-bst/

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


//https://leetcode-cn.com/problems/delete-node-in-a-bst/solution/swift-di-gui-shan-chu-er-cha-sou-suo-shu-mou-jie-d/
//执行用时：88 ms, 在所有 Swift 提交中击败了100.00%的用户
//内存消耗：15.5 MB, 在所有 Swift 提交中击败了86.96%的用户
func deleteNode(_ root: TreeNode?, _ key: Int) -> TreeNode? {
    // 删除节点分为三种情况：
    // 1、只有左节点 替换为右
    // 2、只有右节点 替换为左
    // 3、有左右子节点 左子节点连接到右边最左节点即可
    guard let element = root  else {
        return root
    }
    
    if key < element.val {
        element.left = deleteNode(element.left, key)
    }else if key > element.val{
        element.right = deleteNode(element.right, key)
    }else{
        if element.left == nil {
            return element.right
        }else if element.right == nil {
            return element.left
        }else{
            var cur = element.right!
            // 一直向左找到最后一个左节点即可
            while cur.left != nil {
                cur = cur.left!
            }
            cur.left = element.left
            return element.right
        }
    }
    return element
}

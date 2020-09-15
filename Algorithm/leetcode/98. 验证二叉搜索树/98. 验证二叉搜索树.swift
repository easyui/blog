//98.验证二叉搜索树
//https://leetcode-cn.com/problems/validate-binary-search-tree/

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

//https://leetcode-cn.com/problems/validate-binary-search-tree/solution/swift-zhong-xu-bian-li-fei-di-gui-bian-li-guo-chen/
//中序遍历非递归，遍历过程发现值小于等于前一个值就直接return false
//执行用时：60 ms, 在所有 Swift 提交中击败了62.50%的用户
//内存消耗：21.5 MB, 在所有 Swift 提交中击败了90.00%的用户
func isValidBST(_ root: TreeNode?) -> Bool {
    guard root != nil  else { return true  }
    
    var lastVisited : Int?
    var stack = [TreeNode]()
    
    var cur = root
    while cur != nil || stack.count != 0 {
        while cur != nil {
            stack.append(cur!)
            cur = cur!.left
        }
        
        let node = stack.removeLast()
        if let last = lastVisited, node.val <= last {
            return false
        }else{
            lastVisited = node.val
        }
        cur = node.right
    }
    
    return true
}

//https://leetcode-cn.com/problems/validate-binary-search-tree/solution/swift-zhong-xu-bian-li-di-gui-bian-li-guo-cheng-fa/
//中序遍历递归，遍历过程发现值小于等于前一个值就直接return false
//执行用时：52 ms, 在所有 Swift 提交中击败了97.75%的用户
//内存消耗：21.8 MB, 在所有 Swift 提交中击败了25.00%的用户
func isValidBST_a(_ root: TreeNode?) -> Bool {
    var lastVisited = Int.min

    func helper(_ root: TreeNode?)-> Bool{
        guard let element = root else { return true }
        
        if !helper(element.left) {
            return false
        }
        
        if element.val <= lastVisited {
            return false
        }
        
        lastVisited = element.val
        
        return helper(element.right)
    }
    
    return helper(root)
}

//https://leetcode-cn.com/problems/validate-binary-search-tree/solution/swift-di-gui-bi-jiao-tong-shi-geng-xin-zuo-you-zi-/
//递归比较，同时更新左右子树的最大最小界
//执行用时：48 ms, 在所有 Swift 提交中击败了99.75%的用户
//内存消耗：21.6 MB, 在所有 Swift 提交中击败了60.00%的用户
func isValidBST_b(_ root: TreeNode?) -> Bool {
    func helper(_ root: TreeNode?, _ min: Int? , _ max: Int?)-> Bool{
        guard let element = root else { return true }
        
        if let val = min , element.val <= val{
            return false
        }
        
        if let val = max , element.val >= val{
            return false
        }
        return helper(element.left,min,element.val) && helper(element.right,element.val,max)
    }
    
    return helper(root,nil,nil)
}

//103. 二叉树的锯齿形层次遍历
//https://leetcode-cn.com/problems/binary-tree-zigzag-level-order-traversal/

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

//https://leetcode-cn.com/problems/binary-tree-zigzag-level-order-traversal/solution/swift-bfsqi-shu-ceng-fan-zhuan-by-hu-cheng-he-da-b/
//奇数层翻转
//执行用时：12 ms, 在所有 Swift 提交中击败了93.41%的用户
//内存消耗：21 MB, 在所有 Swift 提交中击败了100.00%的用户
func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
    guard root != nil else { return [] }
      var queue = [root!]
      var levelIndex = 0
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
        res.append((levelIndex & 1 == 0) ? level : level.reversed())
        levelIndex += 1
      }
      return res
}


//https://leetcode-cn.com/problems/clone-graph/

//https://leetcode-cn.com/problems/clone-graph/solution/swift-shen-du-you-xian-di-gui-by-hu-cheng-he-da-ba/
   public class Node {
       public var val: Int
       public var neighbors: [Node?]
       public init(_ val: Int) {
           self.val = val
           self.neighbors = []
       }
   }
   
   func cloneGraph(_ node: Node?) -> Node? {
       var visited = [Int : Node?]()
       func dfs(_ node: Node?) -> Node?{
           guard let current = node else{
               return nil
           }
           
           if let visitedItem = visited[current.val]{
               return visitedItem
           }
           
           let clonedNode = Node(current.val)
           visited[clonedNode.val] = clonedNode
           
           for neighbor in current.neighbors {
               clonedNode.neighbors.append(dfs(neighbor))
           }
           
           return clonedNode
       }
       
       return dfs(node)
   }

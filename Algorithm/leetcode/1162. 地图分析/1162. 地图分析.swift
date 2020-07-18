//https://leetcode-cn.com/problems/as-far-from-land-as-possible/

class Solution{
    //https://leetcode-cn.com/problems/as-far-from-land-as-possible/solution/swift-yan-du-you-xian-bian-li-by-hu-cheng-he-da-ba/
       func maxDistance(_ grid: [[Int]]) -> Int {
           var res = grid
           var queue = [(Int,Int)]()
           var maxDistance = 0
           for (x, row) in res.enumerated() {
               for (y, item) in row.enumerated() {
                   if item == 1{
                       res[x][y] = 0
                       queue.append((x,y))
                   }else{
                       res[x][y] = -1
                   }
               }
           }
           
           let rowCount = res.count
           let columnCount = res[0].count
           while !queue.isEmpty {
               let point: (x: Int,y: Int) = queue.removeFirst()
               for item: (x: Int,y: Int)  in [(0,-1),(0,1),(-1,0),(1,0)] {
                   let x = point.x + item.x
                   let y = point.y + item.y
                   if x >= 0 && x < rowCount && y >= 0 && y < columnCount && res[x][y] == -1 {
                       let distance = res[point.x][point.y] + 1
                       res[x][y] = distance
                       maxDistance = max(distance,maxDistance)
                       queue.append((x,y))
                   }
               }
           }
           
           return (maxDistance == 0) ? -1 : maxDistance
       }
       
       //https://leetcode-cn.com/problems/as-far-from-land-as-possible/solution/swift-dong-tai-gui-hua-by-hu-cheng-he-da-bai-sha-2/
       func maxDistance_a(_ grid: [[Int]]) -> Int {
           let rowCount = grid.count
           let columnCount = grid[0].count
           var maxDistance = 0
           var res = grid
           for (x, row) in res.enumerated() {
               for (y, item) in row.enumerated() {
                   res[x][y] = (item == 1) ? 0 : 10000
               }
           }
           
           for x in 0..<rowCount {
               for y in 0..<columnCount {
                   if x - 1 >= 0 {
                       res[x][y] = min(res[x][y],res[x-1][y]+1)
                   }
                   if y - 1 >= 0 {
                       res[x][y] = min(res[x][y],res[x][y-1]+1)
                   }
               }
           }
           
           for x in (0..<rowCount).reversed() {
               for y in (0..<columnCount).reversed() {
                   if x + 1 < rowCount {
                       res[x][y] = min(res[x][y],res[x+1][y]+1)
                   }
                   if y + 1 < columnCount {
                       res[x][y] = min(res[x][y],res[x][y+1]+1)
                   }
               }
           }
           
           for (_, row) in res.enumerated() {
               for (_, item) in row.enumerated() {
                   maxDistance = max(item,maxDistance)
               }
           }
           return (maxDistance == 10000 || maxDistance == 0) ? -1 : maxDistance //只有岛屿或海洋特殊判断
       }
}

let solution = Solution()

print(solution.maxDistance([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]))
print(solution.maxDistance([[1,0,1],[0,0,0],[1,0,1]]))

print(solution.maxDistance_a([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]))
print(solution.maxDistance_a([[1,0,1],[0,0,0],[1,0,1]]))

//https://leetcode-cn.com/problems/01-matrix/

class Solution{
//https://leetcode-cn.com/problems/01-matrix/solution/swift-yan-du-bian-li-by-hu-cheng-he-da-bai-sha/
  func updateMatrix(_ matrix: [[Int]]) -> [[Int]] {
      let rowCount = matrix.count
      let columnCount = matrix[0].count
      var queue = [(Int,Int)]()
      var res = matrix
      for (x, row) in matrix.enumerated() {
          for (y, item) in row.enumerated() {
              if item == 0{
                  queue.append((x,y))
              }else{
                  res[x][y] = -1
              }
              
          }
      }
      while !queue.isEmpty {
          let point: (x: Int,y: Int) = queue.removeFirst()
          for item: (x: Int,y: Int)  in [(0,-1),(0,1),(-1,0),(1,0)] {
              let x = point.x + item.x
              let y = point.y + item.y
              if x >= 0 && x < rowCount && y >= 0 && y < columnCount && res[x][y] == -1 {
                  res[x][y] = res[point.x][point.y] + 1
                  queue.append((x,y))
              }
          }
      }
      return res
  }
  
  //https://leetcode-cn.com/problems/01-matrix/solution/swift-dong-tai-gui-hua-by-hu-cheng-he-da-bai-sha/
  func updateMatrix_a(_ matrix: [[Int]]) -> [[Int]] {
      let rowCount = matrix.count
      let columnCount = matrix[0].count
      var res = matrix
      for (x, row) in matrix.enumerated() {
          for (y, item) in row.enumerated() {
              res[x][y] = (item == 0) ? 0 : 10000
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
      
      return res
  }
}


let solution = Solution()


print(solution.updateMatrix([[0,0,0],[0,1,0],[0,0,0]]))
print(solution.updateMatrix([[0,0,0],[0,1,0],[1,1,1]]))

print(solution.updateMatrix_a([[0,0,0],[0,1,0],[0,0,0]]))
print(solution.updateMatrix_a([[0,0,0],[0,1,0],[1,1,1]]))

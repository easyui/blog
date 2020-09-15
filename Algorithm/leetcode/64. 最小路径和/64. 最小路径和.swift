//64. 最小路径和
//https://leetcode-cn.com/problems/minimum-path-sum/

//https://leetcode-cn.com/problems/minimum-path-sum/solution/swift-dong-tai-gui-hua-zi-di-xiang-shang-kong-ji-2/
//动态规划（自底向上），空间优化O(N)
//执行用时：76 ms, 在所有 Swift 提交中击败了83.78%的用户
//内存消耗：20.9 MB, 在所有 Swift 提交中击败了76.92%的用户
func minPathSum(_ grid: [[Int]]) -> Int {
    /*
     let m = grid.count
     guard m != 0 else{
     return 0
     }
     let n = grid[0].count
     var dp = [[Int]](repeating: [Int](repeating: Int.max, count: n + 1), count: m + 1)
     dp[m][n-1] =  0
     for i in (0..<m).reversed()  {
     for j in (0..<n).reversed()  {
     dp[i][j] = min(dp[i+1][j],dp[i][j+1]) + grid[i][j]
     }
     }
     return dp[0][0]
     */
    //空间优化O(N)
    let m = grid.count
    guard m != 0 else{
        return 0
    }
    let n = grid[0].count
    
    var dp =  grid[m-1]
    for i in (0..<(n-1)).reversed() {
        dp[i] += dp[i+1]
    }
    dp.append(Int.max)//dp长度是n+1
    
    for i in (0..<(m-1)).reversed()  {
        for j in (0..<n).reversed()  {
            dp[j] = min(dp[j],dp[j+1]) + grid[i][j]
        }
    }
    return dp[0]
}

//https://leetcode-cn.com/problems/minimum-path-sum/solution/swift-zi-ding-xiang-xia-de-di-gui-shen-du-you-xian/
//自顶向下的递归，深度优先搜索，缓存已经被计算的值
//执行用时：120 ms, 在所有 Swift 提交中击败了5.41%的用户
//内存消耗：22.5 MB, 在所有 Swift 提交中击败了5.77%的用户
func minPathSum_a(_ grid: [[Int]]) -> Int {
    let m = grid.count
    guard m != 0 else{
        return 0
    }
    let n = grid[0].count
    
    var cache =  Dictionary<String, Int>()
    func dfs(_ i: Int, _ j: Int) -> Int {
        if i == m || j == n {
            //m*n的最后一个特殊处理：它的右边或下边为0
            if (i == m - 1) {//(i == m - 1) || (j == n - 1)
                return 0
            }
            return Int.max
        }
        if let item = cache["\(i)-\(j)"] {
            return item
        }
        let res = min(dfs(i+1,j),dfs(i,j+1))+grid[i][j]
        cache["\(i)-\(j)"] = res
        return res
    }
    return dfs(0,0)
}

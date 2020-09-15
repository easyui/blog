//62. 不同路径
//https://leetcode-cn.com/problems/unique-paths/

//https://leetcode-cn.com/problems/unique-paths/solution/swift-dong-tai-gui-hua-zi-di-xiang-shang-kong-ji-3/
//动态规划（自底向上），空间优化O(N)，注意下开始行列
//执行用时：8 ms, 在所有 Swift 提交中击败了63.64%的用户
//内存消耗：20.7 MB, 在所有 Swift 提交中击败了62.79%的用户
func uniquePaths(_ m: Int, _ n: Int) -> Int {
    /*
    var dp = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)
    dp[m][n-1] =  1 //主要是处理最底部一行和最右边的一列
    for i in (0..<m).reversed()  {
        for j in (0..<n).reversed()  {
            dp[i][j] = dp[i+1][j] + dp[i][j+1]
        }
    }
    return dp[0][0]
    */
    //空间优化O(N)
    var dp = [Int](repeating: 1, count: n + 1)
    for _ in (0..<m-1).reversed()  {//从倒数第二行开始
        for j in (0..<n-1).reversed()  {//从倒数第二列开始
            dp[j] = dp[j] + dp[j+1]
        }
    }
    return dp[0]
    
}
//print(uniquePaths(7,3))

//https://leetcode-cn.com/problems/unique-paths/solution/swift-zi-ding-xiang-xia-de-di-gui-shen-du-you-xi-2/
//自顶向下的递归，深度优先搜索，缓存已经被计算的值,终止条件最低边和最右边返回1
//执行用时：8 ms, 在所有 Swift 提交中击败了63.64%的用户
//内存消耗：20.8 MB, 在所有 Swift 提交中击败了41.86%的用户
func uniquePaths_a(_ m: Int, _ n: Int) -> Int {
    var cache =  Dictionary<String, Int>()
    func dfs(_ i: Int, _ j: Int) -> Int {
        if i == m - 1 || j == n - 1 {
            return 1
        }
        if let item = cache["\(i)-\(j)"] {
            return item
        }
        let res = dfs(i+1,j) + dfs(i,j+1)
        cache["\(i)-\(j)"] = res
        return res
    }
    return dfs(0,0)
}
//print(uniquePaths_a(7,3))

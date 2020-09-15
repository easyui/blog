//120. 三角形最小路径和
//https://leetcode-cn.com/problems/triangle/

import Foundation

//https://leetcode-cn.com/problems/triangle/solution/swift-shen-du-you-xian-di-gui-huan-cun-yi-jing-bei/
//自顶向下的递归，深度优先搜索，缓存已经被计算的值
//执行用时：60 ms, 在所有 Swift 提交中击败了8.37%的用户
//内存消耗：21.4 MB, 在所有 Swift 提交中击败了5.00%的用户
func minimumTotal(_ triangle: [[Int]]) -> Int {
    var cache =  Dictionary<String, Int>()
    func dfs(_ i: Int, _ j: Int) -> Int {
        if i == triangle.count {
            return 0
        }
        if let item = cache["\(i)-\(j)"] {
            return item
        }
        let res = min(dfs(i+1,j),dfs(i+1,j+1))+triangle[i][j]
        cache["\(i)-\(j)"] = res
        return res
    }
    return dfs(0,0)
}

//https://leetcode-cn.com/problems/triangle/solution/swift-dong-tai-gui-hua-zi-di-xiang-shang-kong-jian/
//动态规划（自底向上），空间优化O(N)
//执行用时：44 ms, 在所有 Swift 提交中击败了91.16%的用户
//内存消耗：20.4 MB, 在所有 Swift 提交中击败了100.00%的用户
func minimumTotal_a(_ triangle: [[Int]]) -> Int {
    let count = triangle.count
    /*
    var dp = [[Int]](repeating: [Int](repeating: 0, count: count + 1), count: count + 1)
    for i in (0...(count-1)).reversed()  {
        for j in 0...i {
            dp[i][j] = min(dp[i+1][j],dp[i+1][j+1]) + triangle[i][j]
        }
    }
    return dp[0][0]
    */
    //空间优化O(N)
    var dp = [Int](repeating: 0, count: count + 1)
    for i in (0...(count-1)).reversed()  {
        for j in 0...i {
            dp[j] = min(dp[j],dp[j+1]) + triangle[i][j]
        }
    }
    return dp[0]
}

//https://leetcode-cn.com/problems/triangle/solution/swift-dong-tai-gui-hua-zi-ding-xiang-xia-kong-jian/
//动态规划（自顶向下），空间优化O(N)
//执行用时：48 ms, 在所有 Swift 提交中击败了71.16%的用户
//内存消耗：20.9 MB, 在所有 Swift 提交中击败了85.00%的用户
func minimumTotal_b(_ triangle: [[Int]]) -> Int {
    let count = triangle.count
    /*
    var dp = [[Int]](repeating: [Int](repeating: 0, count: count), count: count)
    dp[0][0] = triangle[0][0]
    for i in 1..<count {
        dp[i][0] = dp[i-1][0] + triangle[i][0]
        for j in 1..<i {
            dp[i][j] = min(dp[i-1][j],dp[i-1][j-1]) + triangle[i][j]
        }
        dp[i][i] = dp[i-1][i-1] + triangle[i][i]
    }
    var minTotal = dp[count-1][0]
    for i in 1..<count {
        minTotal = min(minTotal,dp[count-1][i])
    }
    return minTotal
    */
    //空间优化O(N)
    var dp = [Int](repeating: 0, count: count)
    dp[0] = triangle[0][0]
    for i in 1..<count {
        dp[i] = dp[i-1] + triangle[i][i]
        for j in (1..<i).reversed() {
            dp[j] = min(dp[j],dp[j-1]) + triangle[i][j]
        }
        dp[0] = dp[0] + triangle[i][0]
    }
    var minTotal = dp[0]
    for i in 1..<count {
        minTotal = min(minTotal,dp[i])
    }
    return minTotal
}

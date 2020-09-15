//300. 最长上升子序列
//https://leetcode-cn.com/problems/longest-increasing-subsequence/

//https://leetcode-cn.com/problems/longest-increasing-subsequence/solution/swift-dong-tai-gui-hua-by-hu-cheng-he-da-bai-sha-3/
//执行用时：140 ms, 在所有 Swift 提交中击败了37.38%的用户
//内存消耗：20.6 MB, 在所有 Swift 提交中击败了78.79%的用户
func lengthOfLIS(_ nums: [Int]) -> Int {
    let count = nums.count
    if count <= 1 {
        return count
    }
    var dp = Array(repeating: 1, count: count)
    var res = 1;
    for i in 1..<count {
        for j in 0..<i {
            if nums[i] > nums[j] {
                dp[i] = max(dp[i],dp[j] + 1)
            }
        }
        res = max(res,dp[i])
    }
    return res
}

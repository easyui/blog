//1143. 最长公共子序列
//https://leetcode-cn.com/problems/longest-common-subsequence/

//https://leetcode-cn.com/problems/longest-common-subsequence/solution/swift-dong-tai-gui-hua-biao-by-hu-cheng-he-da-bai-/
//执行用时：84 ms, 在所有 Swift 提交中击败了60.58%的用户
//内存消耗：21.5 MB, 在所有 Swift 提交中击败了69.77%的用户
func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
    let array1 = Array(text1)
    let array2 = Array(text2)
    
    var dp = Array(repeating: Array(repeating: 0, count: array2.count + 1), count: array1.count + 1)
    
    for i in 1...array1.count {
        for j in 1...array2.count {
            if array1[i - 1] == array2[j - 1]{
                dp[i][j] = dp[i-1][j-1] + 1
            } else {
                dp[i][j] = max(dp[i-1][j] ,dp[i][j-1])
            }
        }
    }
    
    return dp[array1.count][array2.count]
}

//print(longestCommonSubsequence("abc","def"))

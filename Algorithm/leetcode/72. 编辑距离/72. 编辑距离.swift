//72. 编辑距离
//https://leetcode-cn.com/problems/edit-distance/

//https://leetcode-cn.com/problems/edit-distance/solution/swift-dong-tai-gui-hua-by-hu-cheng-he-da-bai-sha-4/
//执行用时：52 ms, 在所有 Swift 提交中击败了86.67%的用户
//内存消耗：15.9 MB, 在所有 Swift 提交中击败了100.00%的用户
func minDistance(_ word1: String, _ word2: String) -> Int {
    let array1 = Array(word1)
    let array2 = Array(word2)
    
    if array1.count == 0 || array2.count == 0 {
        return array1.count + array2.count
    }
    
    var dp = Array(repeating: Array(repeating: 0, count: array2.count + 1), count: array1.count + 1)
    for row in 0...array1.count {
        dp[row][0] = row
    }
    for column in 0...array2.count {
        dp[0][column] = column
    }
    
    for i in 1...array1.count {
        for j in 1...array2.count {
            if array1[i - 1] == array2[j - 1]{
                dp[i][j] = dp[i-1][j-1]
            } else {
                dp[i][j] = min(dp[i-1][j] ,dp[i][j-1], dp[i-1][j-1])+1
            }
        }
    }
    
    return dp[array1.count][array2.count]
}

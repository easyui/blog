//132. 分割回文串 II
//https://leetcode-cn.com/problems/palindrome-partitioning-ii/

//https://leetcode-cn.com/problems/palindrome-partitioning-ii/solution/swift-dong-tai-gui-hua-ti-qian-huan-cun-hui-wen-ch/
//动态规划，提前缓存回文串
//执行用时：116 ms, 在所有 Swift 提交中击败了100.00%的用户
//内存消耗：21.6 MB, 在所有 Swift 提交中击败了50.00%的用户
func minCut(_ s: String) -> Int {
    let count = s.count
    
    if count <= 1{
        return 0
    }
    
    var dp = Array(0..<count)
    
    let sArray = Array(s)
    
    var checkPalindrome = Array(repeating: Array(repeating: false, count: count), count: count)
    for right in 0..<count {
        for left in 0...right {
            if sArray[left] == sArray[right] && ( right - left <= 2 || checkPalindrome[left + 1][right - 1] == true) {//0,1,2距离的都可以直接判断
                checkPalindrome[left][right] = true
            }
        }
    }
    
    for right in 0..<count {
        if checkPalindrome[0][right] {
            dp[right] = 0
            continue
        }
        for left in 0..<right {
            if checkPalindrome[left + 1][right] {
                dp[right] = min(dp[right], dp[left] + 1);
            }
        }
    }
    return dp[count - 1]
}

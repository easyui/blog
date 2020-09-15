//322. 零钱兑换
//https://leetcode-cn.com/problems/coin-change/

//https://leetcode-cn.com/problems/coin-change/solution/swift-dong-tai-gui-hua-by-hu-cheng-he-da-bai-sha-5/
//执行用时：824 ms, 在所有 Swift 提交中击败了65.87%的用户
//内存消耗：13.7 MB, 在所有 Swift 提交中击败了97.26%的用户
func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    if(amount == 0){
        return 0
    }
    
    var dp = Array(repeating: amount + 1, count: amount + 1)
    dp[0] = 0
    
    for money in 1...amount {
        for coin in coins {
            if money - coin >= 0 {
                dp[money] = min(dp[money],dp[money - coin] + 1)
            }
        }
    }
    
    return  (dp[amount] == amount + 1) ? -1 : dp[amount]
}
//print(coinChange([2],3))

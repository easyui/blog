//45. 跳跃游戏 II
//https://leetcode-cn.com/problems/jump-game-ii/

//https://leetcode-cn.com/problems/jump-game-ii/solution/swift-zheng-xiang-dong-tai-cha-zhao-by-hu-cheng-he/
//正向动态查找
//执行用时：84 ms, 在所有 Swift 提交中击败了74.23%的用户
//内存消耗：21 MB, 在所有 Swift 提交中击败了46.15%的用户
func jump(_ nums: [Int]) -> Int {
    let count = nums.count
    var maxPosition = 0
    var step = 0
    var end = 0
    for i in 0..<(count - 1) {
        maxPosition = max(maxPosition,nums[i]+i)
        if i == end{
            end = maxPosition
            step += 1
        }
        //优化：提前结束
        if maxPosition >= count - 1{
            if end < count - 1{
                step += 1
            }
            break
        }
    }
    return step
}

//55. 跳跃游戏
//https://leetcode-cn.com/problems/jump-game/

//https://leetcode-cn.com/problems/jump-game/solution/swift-dong-tai-gui-hua-cong-qian-wang-hou-by-hu-ch/
//从前往后
//执行用时：80 ms, 在所有 Swift 提交中击败了88.08%的用户
//内存消耗：20.8 MB, 在所有 Swift 提交中击败了84.00%的用户
func canJump(_ nums: [Int]) -> Bool {
    let count = nums.count
    var distance = 0
    for i in 0..<count {
        guard i <= distance else{
            return false
        }
        distance = max(distance,nums[i]+i)
        if distance >= count - 1 {
            return true
        }
    }
    return true
}

//https://leetcode-cn.com/problems/jump-game/solution/swift-dong-tai-gui-hua-cong-hou-wang-qian-pan-duan/
//动态规划：从后往前判断
//执行用时：76 ms, 在所有 Swift 提交中击败了95.92%的用户
//内存消耗：21 MB, 在所有 Swift 提交中击败了23.81%的用户
func canJump_a(_ nums: [Int]) -> Bool {
    let count = nums.count
    var endIndex = count - 1
    for i in (0..<count-1).reversed() {
        if i + nums[i] >= endIndex{
            endIndex = min(endIndex,i)
        }
    }
    return endIndex == 0
}

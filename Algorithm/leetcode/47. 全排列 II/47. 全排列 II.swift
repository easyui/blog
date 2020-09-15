//47. 全排列 II
//https://leetcode-cn.com/problems/permutations-ii/

//https://leetcode-cn.com/problems/permutations-ii/solution/swift-47-quan-pai-lie-iipai-xu-hou-hui-su-you-hua-/
//执行用时：64 ms, 在所有 Swift 提交中击败了43.59%的用户
//内存消耗：14.5 MB, 在所有 Swift 提交中击败了89.47%的用户
func permuteUnique(_ nums: [Int]) -> [[Int]] {
    var res = [[Int]]()
    let count = nums.count
    var used = [Int :Bool]()
    let sortedNums = nums.sorted()

    
    func backtrack(track: inout [Int]){
        if track.count == count{
            res.append(track)
        }
        for (index,num) in sortedNums.enumerated() {
            if used[index] ?? false {
                continue
            }
            
            // if index > 0 && sortedNums[index] == sortedNums[index - 1] && (used[index - 1] ?? false)  {
            //     continue
            // }
            //优化：提前剪枝
            if index > 0 && sortedNums[index] == sortedNums[index - 1] && !(used[index - 1]!)  {
                continue
            }
            
            used[index] = true
            track.append(num)
            backtrack(track: &track)
            used[index] = false
            track.popLast()
        }
    }
    
    var items = [Int]()
    backtrack( track: &items)
    
    return res
}

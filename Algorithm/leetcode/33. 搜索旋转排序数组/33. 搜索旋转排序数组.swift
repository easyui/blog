//33. 搜索旋转排序数组
//https://leetcode-cn.com/problems/search-in-rotated-sorted-array/

//https://leetcode-cn.com/problems/search-in-rotated-sorted-array/solution/swift-er-fen-cha-zhao-que-ren-midhe-targetde-wei-z/
//执行用时：20 ms, 在所有 Swift 提交中击败了95.50%的用户
//内存消耗：20.5 MB, 在所有 Swift 提交中击败了90.91%的用户
func search(_ nums: [Int], _ target: Int) -> Int {
    if nums.count == 0 {
        return -1
    } else  if nums.count == 1 {
        return nums[0] == target ? 0 : -1
    }
    
    var start = 0
    var end = nums.count - 1
    
    while start + 1 < end {
        let mid = (start + end)/2
        if target == nums[mid] {
            return mid
        }
        if nums[start] <= nums[mid] { //这里可以小于
            if target <= nums[mid] && target >= nums[start]{
                end = mid
            }else{
                start = mid
            }
        } else {
            if target >= nums[mid] && target <= nums[end]{
                start = mid
            }else{
                end = mid
            }
        }
    }
    if nums[start] == target {
        return start
    } else if nums[end] == target {
        return end
    }
    return -1
}

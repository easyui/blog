//153. 寻找旋转排序数组中的最小值
//https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/

//https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/solution/swift-er-fen-cha-zhao-by-hu-cheng-he-da-bai-sha-4/
//执行用时：20 ms, 在所有 Swift 提交中击败了93.02%的用户
//内存消耗：21.2 MB, 在所有 Swift 提交中击败了33.33%的用户
func findMin(_ nums: [Int]) -> Int {
    var start = 0
    var end = nums.count - 1
    
    while start + 1 < end {
        let mid = (start + end)/2
        //        if nums[mid] > nums[start] && nums[mid] > nums[end] {
        //            start = mid + 1
        //        } else if  nums[mid] < nums[start] && nums[mid] < nums[end]{
        //            end = mid - 1
        //        } else if  nums[mid] > nums[start] && nums[mid] < nums[end]{
        //            end = mid - 1
        //        }
        if nums[mid] > nums[end] {
            start = mid
        } else {
            end = mid
        }
    }
    return (nums[start] > nums[end]) ? nums[end]  : nums[start]
}

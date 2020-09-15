//154. 寻找旋转排序数组中的最小值 II
//https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array-ii/

//https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array-ii/solution/swift-er-fen-cha-zhao-gen-ju-153ti-bi-jiao-qian-qu/
//二分查找：根据《153. 寻找旋转排序数组中的最小值（https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/solution/swift-er-fen-cha-zhao-by-hu-cheng-he-da-bai-sha-4/）》 ，比较前去除和start、end相等的元素
//执行用时：36 ms, 在所有 Swift 提交中击败了98.04%的用户
//内存消耗：21 MB, 在所有 Swift 提交中击败了100.00%的用户
func findMin(_ nums: [Int]) -> Int {
    var start = 0
    var end = nums.count - 1
    
    while start + 1 < end {
        
        while start + 1 < end {
            if nums[start] == nums[start + 1] {
                start += 1
            } else {
                break
            }
        }
        while end - 1 > start {
            if nums[end] == nums[end - 1] {
                end -= 1
            } else {
                break
            }
        }
        
        let mid = (start + end)/2
        if nums[mid] > nums[end] {
            start = mid
        } else {
            end = mid
        }
    }
    return (nums[start] > nums[end]) ? nums[end]  : nums[start]
}

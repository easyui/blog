//81. 搜索旋转排序数组 II
//https://leetcode-cn.com/problems/search-in-rotated-sorted-array-ii/

//https://leetcode-cn.com/problems/search-in-rotated-sorted-array-ii/solution/swift-zai-33ti-ji-chu-shang-bi-jiao-qian-xian-qu-c/
//在33题基础上：比较前先去除头尾重复（33题：https://leetcode-cn.com/problems/search-in-rotated-sorted-array/solution/swift-er-fen-cha-zhao-que-ren-midhe-targetde-wei-z/）
//执行用时：40 ms, 在所有 Swift 提交中击败了94.29%的用户
//内存消耗：21 MB, 在所有 Swift 提交中击败了100.00%的用户
func search(_ nums: [Int], _ target: Int) -> Bool {
    if nums.count == 0 {
        return false
    } else  if nums.count == 1 {
        return nums[0] == target
    }
    
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
        if target == nums[mid] {
            return true
        }
        if nums[start] <= nums[mid] { //必须要小于等于，因为前面去重的时候可能导致start+1==end
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
    return (nums[start] == target) || (nums[end] == target)
}

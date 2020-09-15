//74. 搜索二维矩阵
//https://leetcode-cn.com/problems/search-a-2d-matrix/

//https://leetcode-cn.com/problems/search-a-2d-matrix/solution/swift-m-x-nju-zhen-ke-yi-shi-wei-chang-du-wei-m-x-/
//m x n矩阵可以视为长度为m x n的有序数组来进行二分查找
//执行用时：80 ms, 在所有 Swift 提交中击败了98.61%的用户
//内存消耗：21 MB, 在所有 Swift 提交中击败了84.62%的用户
func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
    let m = matrix.count
    if m == 0 {
        return false
    }
    let n = matrix[0].count
    if n == 0 {
        return false
    }
    
    var start = 0
    var end = m * n - 1
    
    while start <= end {
        let mid = (end + start)/2
        let midValue = matrix[mid/n][mid%n]
        if target == midValue {
            return true
        }else if target > midValue{
            start = mid + 1
        }else{
            end = mid - 1
        }
    }
    
    return false
}

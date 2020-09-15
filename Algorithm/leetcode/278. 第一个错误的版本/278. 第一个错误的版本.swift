//278. 第一个错误的版本
//https://leetcode-cn.com/problems/first-bad-version/

//https://leetcode-cn.com/problems/first-bad-version/solution/swift-er-fen-cha-zhao-by-hu-cheng-he-da-bai-sha-3/
//执行用时：44 ms, 在所有 Swift 提交中击败了10.94%的用户
//内存消耗：20.4 MB, 在所有 Swift 提交中击败了100.00%的用户
func firstBadVersion(n int) int {
    // 思路：二分搜索
    start := 0
    end := n
    for start+1 < end {
        mid := start + (end - start)/2
        if isBadVersion(mid) {
            end = mid
        } else if isBadVersion(mid) == false {
            start = mid
        }
    }
    if isBadVersion(start) {
        return start
    }
    return end
}

//344. 反转字符串
//https://leetcode-cn.com/problems/reverse-string/

//系统api
func reverseString(_ s: inout [Character]) {
    s.reverse()
}

//递归
//https://leetcode-cn.com/problems/reverse-string/solution/swift-di-gui-by-hu-cheng-he-da-bai-sha-3/
//执行用时：240 ms, 在所有 Swift 提交中击败了98.99%的用户
//内存消耗：24.9 MB, 在所有 Swift 提交中击败了15.87%的用户
func reverseString_a(_ s: inout [Character]) {
    func helper(_ s: inout [Character],_ left: Int,_ right: Int){
        if left >= right {
            return
        }
        (s[left],s[right]) = (s[right],s[left])
        helper(&s, left + 1, right - 1)
    }
    
    helper(&s, 0, s.count-1)
}

//https://leetcode-cn.com/problems/single-number-ii/


/*
> 就有了如下过程：
>
> 1）某数第一次出现（即twice中不存在），存于once
>
> 2）某数第二次出现（即once中存在，故从once中清除），存于twice
>
> 3）某数第三次出现，本来要存于once，结果twice中存在，所以，清零
*/


//https://leetcode-cn.com/problems/single-number-ii/solution/swift-wei-yun-suan-by-hu-cheng-he-da-bai-sha-2/
//思路：https://leetcode-cn.com/problems/single-number-ii/solution/single-number-ii-mo-ni-san-jin-zhi-fa-by-jin407891/
//执行用时：60 ms, 在所有 Swift 提交中击败了94.29%的用户
//内存消耗：21.1 MB, 在所有 Swift 提交中击败了100.00%的用户
func singleNumber(_ nums: [Int]) -> Int {
    var once = 0 ,twice = 0
    for i in nums {
         once  = (i ^ once) & ~twice
         twice = (i ^ twice) & ~once
    }
    return once
}

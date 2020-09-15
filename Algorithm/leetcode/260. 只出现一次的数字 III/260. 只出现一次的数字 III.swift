//https://leetcode-cn.com/problems/single-number-iii/

//https://leetcode-cn.com/problems/single-number-iii/solution/swift-fen-liang-zu-lai-jiang-wei-dao-qiu-chu-xian-/
//分两组来降维到求出现一次的数字
//执行用时：84 ms, 在所有 Swift 提交中击败了83.87%的用户
//执行用时：84 ms, 在所有 Swift 提交中击败了83.87%的用户
func singleNumber(_ nums: [Int]) -> [Int] {
    //全部异或，最后结果就是这两个数字的异或
    let allORX = nums.reduce(0,^)
    //保留最低位的1（可以其他位的1，这里这样处理简单）其他位清零。因为这1是两个数的不同点，这样可以把nums所有数字按这个数是1或0分成2组（这两个数字也分别在2个组，所以这个问题就可以降维到所有数字中找一个是特别的）
    let diff = allORX & (-allORX)//-allORX是补码
    
    //分两组
    var x = 0
    nums.forEach { num in
        if (diff & num) == 0 {//把所有这个位的0取异或就可以找到其中一个数字
            x ^= num
        }
    }
    /*
     根据：
      a=a^b
      b=a^b
      a=a^b
     求得另一个数字是allORX^x
     */
    return [x,allORX^x]
}


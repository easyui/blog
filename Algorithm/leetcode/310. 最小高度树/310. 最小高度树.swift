//https://leetcode-cn.com/problems/minimum-height-trees/

class Solution {
    
    func findMinHeightTrees(_ n: Int, _ edges: [[Int]]) -> [Int] {
        var degree = Dictionary<Int, Int>()
        var map = Dictionary<Int, [Int]>()
        for edge in edges {
            degree[edge[0], default: 0] += 1
            degree[edge[1], default: 0] += 1
            map[edge[0], default: [Int]()].append(edge[1])
            map[edge[1], default: [Int]()].append(edge[0])
        }
        
        var queue = [Int]()
        for i in 0..<n {
            if degree[i] == 1 {
                queue.append(i)
            }
        }
        
        var  res = [Int]()
        while !queue.isEmpty {
            res = [Int]()
            let count = queue.count
            for _ in 0..<count {
                let out = queue.removeFirst()
                res.append(out)
                for item in (map[out])! {
                    degree[item]! -= 1
                    if degree[item] == 1 {
                        queue.append(item)
                    }
                }
            }
        }
        return (res == [] ) ? [0] : res
    }

}

let solution = Solution()

print(solution.findMinHeightTrees(4, [[1,0],[1,2],[1,3]]))
print(solution.findMinHeightTrees(1, []))

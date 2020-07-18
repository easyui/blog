//https://leetcode-cn.com/problems/number-of-islands/

//https://leetcode-cn.com/problems/number-of-islands/solution/swiftshen-du-you-xian-di-gui-by-hu-cheng-he-da-bai/
func numIslands(_ grid: [[Character]]) -> Int {
    var copydGrid = grid
    let rn = grid.count
    guard rn > 0 else{
        return 0
    }
    let cn = copydGrid[0].count
    
    func dfs(_ r: Int,_ c:Int) {
        guard r >= 0 && r < rn && c >= 0 && c < cn && copydGrid[r][c] == "1" else{
            return
        }
        copydGrid[r][c] = "0"
        dfs(r-1, c)//上
        dfs(r+1, c)//下
        dfs(r, c-1)//左
        dfs(r, c+1)//右
    }
    
    var islandCount = 0
    for r in 0..<rn {
        for c in 0..<cn {
            if copydGrid[r][c] == "1" {
                islandCount += 1
                dfs(r,c)
            }
        }
    }
    return islandCount
}

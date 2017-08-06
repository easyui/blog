不成功的 RHS 引用会导致抛出 ReferenceError 异常。不成功的 LHS 引用会导致自动隐式 地创建一个全局变量(非严格模式下)，该变量使用 LHS 引用的目标作为标识符，或者抛 出 ReferenceError 异常(严格模式下)。

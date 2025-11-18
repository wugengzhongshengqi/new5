/* 测试局部优化 */

/* 常量折叠测试 */
int test_constant_folding() {
    int a, b, c, d, e, f, g, h;
    
    a = 2 + 3;          /* 应优化为 a = 5 */
    b = 10 - 4;         /* 应优化为 b = 6 */
    c = 6 * 7;          /* 应优化为 c = 42 */
    d = 20 / 5;         /* 应优化为 d = 4 */
    e = -10;            /* 应优化为 e = -10 */
    
    f = (3 > 2);        /* 应优化为 f = 1 */
    g = (5 == 5);       /* 应优化为 g = 1 */
    h = (4 < 3);        /* 应优化为 h = 0 */
    
    return a;
}

/* 代数化简测试 */
int test_algebraic() {
    int x, y, z, a, b, c, d;
    
    x = 100;
    
    y = x + 0;          /* 应优化为 y = x */
    z = 0 + x;          /* 应优化为 z = x */
    
    a = x - 0;          /* 应优化为 a = x */
    b = x * 1;          /* 应优化为 b = x */
    c = 1 * x;          /* 应优化为 c = x */
    d = x / 1;          /* 应优化为 d = x */
    
    return y;
}

/* 代数化简 - 零测试 */
int test_zero() {
    int a, b, c, d;
    
    a = 5;
    
    b = a * 0;          /* 应优化为 b = 0 */
    c = 0 * a;          /* 应优化为 c = 0 */
    d = 0 / a;          /* 应优化为 d = 0 */
    
    return d;
}

/* CSE测试 */
int test_cse() {
    int a, b, c, d, e;
    
    a = 10;
    b = 20;
    
    c = a + b;          /* 计算 a + b */
    d = a + b;          /* 应复用 c 的结果，优化为 d = c */
    e = a + b;          /* 应复用 c 的结果，优化为 e = c */
    
    return e;
}

/* CSE - 杀死测试 */
int test_cse_kill() {
    int a, b, c, d, e;
    
    a = 10;
    b = 20;
    
    c = a + b;          /* 计算 a + b */
    a = 5;              /* a 被重新定义，杀死 a + b */
    d = a + b;          /* 需要重新计算 */
    
    return d;
}

/* 组合优化测试 */
int test_combined() {
    int a, b, c, d;
    
    a = 2 + 3;          /* 常量折叠: a = 5 */
    b = a + 0;          /* 代数化简: b = a */
    c = a + 0;          /* 代数化简: c = a, CSE: c = b */
    d = 5 * 1;          /* 常量折叠: d = 5, 然后 CSE: d = a */
    
    return d;
}

/* 嵌套表达式测试 */
int test_nested() {
    int a, b, c, d;
    
    a = 1 + 2;          /* 常量折叠: a = 3 */
    b = a * 3;          /* b = 3 * 3，下一轮常量折叠: b = 9 */
    c = 3 * 3;          /* 常量折叠: c = 9, CSE: c = b */
    
    return c;
}

int main() {
    int r1, r2, r3, r4, r5, r6, r7;
    
    r1 = test_constant_folding();
    r2 = test_algebraic();
    r3 = test_zero();
    r4 = test_cse();
    r5 = test_cse_kill();
    r6 = test_combined();
    r7 = test_nested();
    
    output r7;
    
    return 0;
}

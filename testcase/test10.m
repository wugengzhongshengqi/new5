main() {
    int a; 
    int b; 
    int c; 
    int i; 
    int n;
    int l;
    int u;
    int r;

    a = 10;
    b = 20;
    n = 5;
    r = 0;
    c = a + b; 
    u = 1000; 

    i = 0;
    while (i < n) {
        l = c * 2;
        u = u + 1;
        r = r + i;
        r = r + l;
        i = i + 1;
    }

    output l;
}
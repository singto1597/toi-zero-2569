#include <bits/stdc++.h>
using namespace std;

int main() {
    cin.tie(NULL)->sync_with_stdio(false);
    int work, mid, last;
    cin >> work >> mid >> last;
    if (work < 5 || mid < 20 || last < 25){
        cout << "fail" <<endl;
    }
    else{
        cout << "pass" <<endl;
    }
    return 0;
}

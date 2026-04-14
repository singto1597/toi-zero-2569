#include <bits/stdc++.h>
using namespace std;

int main() {
    cin.tie(NULL)->sync_with_stdio(false);
    int max = -100000;
    for (int i = 0; i < 3; i++){
        int n; cin >> n;
        if (n > max){
            max = n;
        }
    }
    cout << max << endl;
    return 0;
}

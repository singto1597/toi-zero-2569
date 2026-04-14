#include <bits/stdc++.h>
using namespace std;

int main() {
    cin.tie(NULL)->sync_with_stdio(false);
    int n;
    cin >> n;
    int k = 4;
    int coins[4] = {1, 2, 5, 10};
    int coin_use[4] = {};
    int i = k - 1;
    while (n > 0){
        if (n >= coins[i]){
            n = n - coins[i];
            coin_use[i]++;
        }
        else{
            if (i == 0) break;
            else i--;
        }
    }
    for (int j = k - 1; j >= 0; j--){
        cout << coins[j] << " = " << coin_use[j] << endl;
    }
    return 0;
}

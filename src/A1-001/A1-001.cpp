#include <bits/stdc++.h>
using namespace std;

int main() {
    cin.tie(NULL)->sync_with_stdio(false);
    string name, lastname;
    cin >> name >> lastname;
    cout << "Hello " << name << " " << lastname << endl;
    cout << name.substr(0,2) << lastname.substr(0,2);
    return 0;
}

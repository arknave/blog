---
title: January USACO Editorial
---

###[Bronze I: Ski Course Design](http://usaco.org/index.php?page=viewproblem2&cpid=376)

Since the heights can only be between 0 and 100, we can try every range from (0, 17) to (100, 117). There's only 1000 hills and 100 possible ranges for a O(N*M) solution, where M is the maximum height of a hill.

```
#include <iostream>
#include <fstream>
#include <algorithm>
#define INF (int)1e8
#define MAX_N 1001
using namespace std;
int h[MAX_N], N;
int main() {
    ifstream fin ("skidesign.in");
    ofstream fout ("skidesign.out");
    fin >> N;
    for(int i=0;i<N;i++) {
        fin >> h[i];
    }
    int best = INF, lo, cur;
    for(int cap = 17;cap <= 117;cap++) {
        lo= cap - 17;
        cur = 0;
        for(int i=0;i<N;i++) {
            if(h[i] < lo) {
                cur += (lo - h[i]) * (lo - h[i]);
            } else if (h[i] > cap) {
                cur += (h[i] - cap) * (h[i] - cap);
            }
        }
        best = min(best, cur);
    }
    fout << best << endl;
    return 0;
}
```

We know that the cost can fit into an integer, because 1000*100<sup>2</sup> = 10,000,000, well below the capacity of an integer.

###[Bronze III: Balanced Teams](http://usaco.org/index.php?page=viewproblem2&cpid=378)
Because the order of the teams doesn't matter, we can fix the first element in the first position. Same backtracking solution as Wormholes from last month.

```
#include <iostream>
#include <fstream>
#include <cstring>
#include <algorithm>
#define MAX_N 1000001
using namespace std;
int a[12], counts[4], sums[4];

int solve(int x) {
    if(x == 12) {
        int maxx=sums[0], minn=sums[0];
        for(int i=1;i<4;i++) {
            maxx = max(maxx, sums[i]);
            minn = min(minn, sums[i]);
        }
        return maxx - minn;
    } else {
        int best = MAX_N;
        for(int i=0;i<4;i++) {
            if(counts[i] < 3) {
                counts[i]++;
                sums[i] += a[x];
                best = min(best, solve(x+1));
                sums[i] -= a[x];
                counts[i]--;
            }
        }
        return best;
    }
}

int main() {
    ifstream fin ("bteams.in");
    ofstream fout ("bteams.out");
    for(int i=0;i<12;i++) {
        fin >> a[i];
    }
    counts[0] = 1;
    sums[0] += a[0];
    fout << solve(1) << endl;
    return 0;
}
```

###[Silver II: Cross Country Skiing](http://usaco.org/index.php?page=viewproblem2&cpid=380)

There's two ways to go about this problem. 
####Binary Search and Flood Fill
We know that if height `h` works, then all heights greater than `h` are valid. Let's define `f(h)` to be a function which returns a boolean, it returns `1` if a skimobile of height `h` can reach all waypoints and `0` otherwise. Since `f` is a monotonically increasing function (think of this as a way of describing the function as "sorted"), we can run binary search on it! Even though the maximum value of `h` is 1,000,000,000, the logarithm of 1,000,000,000 is only around 30.

Sounds great! Now how do we write `f`? Well, let's flood fill from a waypoint and see if we hit every other waypoint. We only extend to a new cell if the height difference is less than `h`. This runs in O(N<sup>2</sup>log(H)) time, hopefully fast enough. Here's the code I submitted: 

```
#include <iostream>
#include <fstream>
#include <cstring>
#include <cmath>
#include <algorithm>
#define MAX_N 505
#define MAX_D 1000000000
using namespace std;
int N, M, field[MAX_N][MAX_N], dx[] = {1, 0, -1, 0}, dy[] = {0, 1, 0, -1};
bool visited[MAX_N][MAX_N], way[MAX_N][MAX_N];

bool all_visited() {
    for(int i=0;i<N;i++) {
        for(int j=0;j<M;j++) {
            if(way[i][j] && !visited[i][j]) return false;
        }
    }
    return true;
}

void dfs(int i, int j, int dist) {
    if(visited[i][j]) return;
    visited[i][j] = true;
    for(int d = 0; d < 4; d++) {
        int nx = i+dx[d], ny = j+dy[d];
        if (nx >= 0 && nx < N && ny >= 0 && ny < M &&
                abs(field[nx][ny] - field[i][j]) <= dist) {
            dfs(nx, ny, dist);
        }
    }
}

bool works(int curd) {
    for(int i=0;i<N;i++) {
        for(int j=0;j<M;j++) {
            visited[i][j] = false;
        }
    }
    for(int i=0;i<N;i++) {
        for(int j=0;j<M;j++) {
            if(way[i][j]) {
                dfs(i, j, curd);
                return all_visited();
            }
        }
    }
    return false;
}

int main() {
    ifstream fin ("ccski.in");
    ofstream fout ("ccski.out");
    fin >> N >> M;
    for(int i=0;i<N;i++) {
        for(int j=0;j<M;j++) {
            fin >> field[i][j];
        }
    }
    for(int i=0;i<N;i++) {
        for(int j=0;j<M;j++) {
            fin >> way[i][j];
        }
    }
    int lo = -1, hi = MAX_D, mid;

    while (hi > lo + 1) {
        mid = (lo + hi) / 2;
        if (works(mid)) {
            hi = mid;
        } else {
            lo = mid;
        }
    }

    fout << hi << endl;
    return 0;
}
```

####Union-Find and Priority Queue

In order to slightly improve upon the runtime of the above algorithm, we can use the [union-find](https://en.wikipedia.org/wiki/Union_find) data structure. Let's add every element in the matrix into the union-find, and make a priority queue of edges, sorted by the height differential. While the waypoints are not part of the same subset, we pop edges off of the priority queue and merge the subsets. The answer is the height of the last element we pop off. 

There are O(N^2) edges, and it takes O(logN) time to push an edge, so setting up the system takes O(N<sup>2</sup>logN) time. Then, we do up to O(N<sup>2</sup>) pops. Each pop takes O(logN), followed by an inverse Ackermann function time merge and another check of around the same time. Thus, the complexity is reduced to O(N<sup>2</sup>logN).

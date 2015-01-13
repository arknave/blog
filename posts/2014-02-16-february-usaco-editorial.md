---
title: February USACO Editorial
---

###[Bronze I: Mirror](http://usaco.org/index.php?page=viewproblem2&cpid=394)

Brute force. It's impossible to get stuck in an infinite loop, as if the laser bounces off of a mirror, the only way to get back to the same side of that mirror is by retracing the path from the beginning, implying the laser exited and re-entered the mirror maze. Similarly, no two entrances can share a common subpath. Therefore, the only thing to do is try every path. Since paths cannot share edges, and there are O(N<sup>2</sup>) edges, our runtime is O(N). 

###[Bronze II/Silver I: Auto](http://usaco.org/index.php?page=viewproblem2&cpid=395)

I see two ways of approaching this problem:

####Binary Search

Create a vector which pairs strings and ints. The string is the word, and the int is the original index. Sort the vector based on the string. Now we can do a binary search for our prefix to find the first word in the dictionary which has our prefix. We can then step over k elements and see if the element we're on is still has the same prefix. 

Code speaks louder than words.

```cpp
//skipping imports
int W, N, k;
vector<pair<string, int> > s;
string t;

int binary_search() {
    int low = 0, high = W, mid;
    while(low < high) {
        mid = (low + high) / 2;
        if(s[mid].first < t) low = mid + 1;
        else high = mid;
    }
    return low;
}

bool is_prefix(int p) {
    //returns true if t is a prefix of the string at position p
    string prefix = s[p].first;
    return prefix.substr(0, t.size()) == t;
}

int main() {
    ifstream fin ("auto.in");
    ofstream fout ("auto.out");
    fin >> W >> N;
    for(int i=0;i<W;i++) {
        fin >> t;
        s.push_back(make_pair(t, i+1)); 
    }
    sort(s.begin(), s.end());
    for(int i=0;i<N;i++) {
        fin >> k >> t; 
        k--;
        int pos = binary_search();
        pos += k;
        if(pos < W && is_prefix(pos)) {
            fout << s[pos].second << endl;
        } else {
            fout << -1 << endl;
        }
    }
    return 0;
}
```

Let's look at the runtime of this. The first step after reading in the data is sorting. This takes O(WlogW) time, where W is the number of lines. In the worst case, we have 1 character per line, which sets W at 1,000,000. Uh-oh, this is too long!

This can be salvaged by using a O(N) sorting algorithm like radix sort. Which brings us to our next method:

####The "Trie"d and True Method
A trie (pronounced "try" to distinguish it from a tree) is a recursive data structure which we can use to solve this problem. We can store the number of elements below a node within each node to easily detect which to descend to.

###[Bronze III/Silver III: Secret Code](http://usaco.org/index.php?page=viewproblem&cpid=390)

I'll merge these together since the silver solution will also handle the bronze solution.

####Dynamic Programming
Our state is the string we're looking at. We then check the four possibilities. Since there are O(N) ways to split a substring and O(N^2) substrings, our code runs in O(N^3) time. I think the code is clearer than any english explanation.

```cpp
//no imports
#define MAX_N 105
#define MOD 2014
using namespace std;
int N, dp[MAX_N][MAX_N] = {{0}};
string s, first, second;

bool is_prefix(bool reverse) {
    if(reverse) {
        return second == first.substr(0, second.size());
    } else {
        return first == second.substr(0, first.size());
    }
}

bool is_suffix(bool reverse) {
    if(reverse) {
        return second == first.substr(first.size()-second.size(), second.size());
    } else {
        return first == second.substr(second.size()-first.size(), first.size());
    }
}

int main() {
    ifstream fin ("scode.in");
    ofstream fout ("scode.out");
    fin >> s;
    N = s.size();
    for(int size=3;size<=N;size++) {
        for(int start=0;start+size<=N;start++) {
            for(int flen=1;flen<size;flen++) {
                first = s.substr(start, flen);
                second = s.substr(start+flen, size-flen);
                if( first.size() < second.size() && second.size() >= 2 && is_prefix(false) ) {
                    dp[size][start]++;
                    dp[size][start] += dp[size-flen][start+flen];
                    dp[size][start] %= MOD;
                }
                
                if( first.size() < second.size() && second.size() >= 2 && is_suffix(false) ) {
                    dp[size][start]++;
                    dp[size][start] += dp[size-flen][start+flen];
                    dp[size][start] %= MOD;
                }
                
                if( second.size() < first.size() && first.size() >= 2 && is_prefix(true) ) {
                    dp[size][start]++;
                    dp[size][start] += dp[flen][start];
                    dp[size][start] %= MOD;
                }
                
                if( second.size() < first.size() && first.size() >= 2 && is_suffix(true) ) {
                    dp[size][start]++;
                    dp[size][start] += dp[flen][start];
                    dp[size][start] %= MOD;
                }

            }
        }
    }
    fout << dp[N][0] << endl;
    return 0;
}

```

Prior to this contest, I wasn't aware of the differences between C/C++ `substr` method and Java/Javascript's `substring` method. The optional second paramters in these functions behave differently - a source of many headaches and painful debugging during the contest.

####Regular Expressions
This only works for the bronze edition, but some carefully crafted regular expressions can simplify a lot of the code. `(\w)(.)+\1` will match a string followed by its prefix, and similar regexes can be constructed for the other cases.

###[Silver II: Roadblock](http://usaco.org/index.php?page=viewproblem&cpid=389)

Fairly standard shortest path problem. The first step is to find the shortest path from Farmer John to the barn. We can solve this either with the Floyd-Warshall algorithm, which runs in O(N<sup>3</sup>) time, or Dijkstra's algorithm, which runs in O(N<sup>2</sup>log(N)) time. 250 is a small number, but I used Dijkstra's algorithm for the speedup because of what comes next.

Once we do that, we try doubling the cost of each edge on the walk from Farmer John to the barn. We don't need to double any other edges because that doesn't change the length of the shortest path. This lowers the number of edge we have to try and double from 25,000 to 250. After we double each edge, we rerun Dijkstra's algorithm and find the new shortest path. Here's the code:

```cpp
//skipping imports
#define INF 250000050
#define MAX_N 255

int N, M, previous[MAX_N];
vector<pair<int, int> > g[MAX_N];

int dijkstra(bool firstrun) {
    //return distance from 0 to N-1
    bool visited[MAX_N];
    int dist[MAX_N];
    fill(visited, visited+N, false);
    fill(dist, dist+N, INF);
    if(firstrun) {
        fill(previous, previous+N, -1);
    }
    previous[0] = 0;
    dist[0] = 0;
    priority_queue<pair<int, int> > pq;
    pq.push(make_pair(0, 0));

    while(!pq.empty()) {
        int place = pq.top().second;
        pq.pop();

        if(visited[place]) continue;
        visited[place] = true;
        
        for(int i=0;i<g[place].size();i++) {
            int vert = g[place][i].first, d = g[place][i].second;
            if(dist[place] + d < dist[vert]) {
                dist[vert] = dist[place] + d;
                if(firstrun) previous[vert] = place;
                pq.push(make_pair(-(dist[place]+d), vert));
            }
        }
    }
    return dist[N-1];
}

int main() {
    ifstream fin ("rblock.in");
    ofstream fout ("rblock.out");
    fin >> N >> M;
    int a, b, l;
    for(int i=0;i<M;i++) {
        fin >> a >> b >> l;
        a--; b--;
        g[a].push_back(make_pair(b, l));
        g[b].push_back(make_pair(a, l));
    }
    int base = dijkstra(true);
    //try doubling every edge on the shortest path
    int e1 = N-1, e2 = previous[N-1];
    int best = 0;
    while(e1 != e2) {
        //double length
        int ind1 = -1, ind2 = -1, l;
        for(int i=0;i<g[e1].size();i++) {
            if(g[e1][i].first == e2) {
                ind1 = i;
                break;
            }
        }
        for(int i=0;i<g[e2].size();i++) {
            if(g[e2][i].first == e1) {
                ind2 = i;
                l = g[e2][i].second;
                break;
            }
        }
        g[e1][ind1].second = g[e2][ind2].second = 2*l;
        cout << "doubling edge from " << e1 << " to " << e2 << endl;
        //try new graph
        best = max(best, dijkstra(false)-base);
        //halve length
        g[e1][ind1].second = g[e2][ind2].second = l/2;
        //try next edge
        e1 = e2;
        e2 = previous[e1];
    }
    fout << best << endl;
    return 0;
}
```

I missed a few testcases on this one, not sure what happened yet.

---

All in all, one of my favorite USACO contests. I feel that Bronze and Silver erred on the side of too easy, while Gold's final problem required several complicated insights and an implementation of a non-trivial data structure. Hopefully the difficulties of future contests will be more uniform.

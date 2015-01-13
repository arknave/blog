---
title: USACO Bronze December 2013 Editorial
---

_This is an editorial for the Bronze problems from USACO's December 2013 competition. The solutions posted below are not official, and are not guaranteed to be correct in all cases._

December brought another rough 4-hour contest. The highlight of the bronze contest was "Wormhole", a challenging combinatorics problem. 

###[Bronze I: Record Keeping](http://usaco.org/index.php?page=viewproblem2&cpid=358)
An important part of parsing strings is _normalization_, where we restructure the input data into a logical, consistent format. This isn't common in contest problems, but the concept is useful here. To check if two groups are the same, we have to normalize the groups and compare them somehow. To do this, I changed a space separated list of three cows into a comma delimited list of three **sorted** cows. This way, we can compare two sets of cows just as we could compare two strings. Here's the sorting and normalization:

```cpp
ifstream fin ("records.in");
ofstream fout ("records.out");
int N;
fin >> N;
string a, b, c; 
vector<string> v;
for(int i=0;i<N;i++) {
	fin >> a >> b >> c;
	//why sort() when you can write your own?
	if(a > b) swap(a, b);
	if(a > c) swap(a, c);
	if(b > c) swap(b, c);
    v.push_back(a+","+b+","+c);
}
```

The delimiter is important, as without it, the three cows `aaa bb c` would be seen as the same as `aa b bc`, even though none of the cows are the same. 

There are a few ways to count the most common cow. The first is dumping our normalized strings into a `vector` or `list` and sorting the container. Then we can scan through the sorted list in linear time and find the most common element. Here's that code:

```cpp
//v is a vector with the normalized strings
sort(v.begin(), v.end());
int count = 1, best = 1;
for(int i=1;i<N;i++){
	count++;
    if(v[i] != v[i-1]) {
        count = 1;
    }
    best = max(best, count);
}
fout << best << '\n';
```
Overall runtime: O(nlogn) (sort) + O(n) (find max) = **O(nlogn)**

Alternately, we could create a map from strings to ints. The keys are the normalized cow strings, and the values are the number of occurences of each string. Here's a full solution using STL's `map`:

```cpp
#include <iostream>
#include <fstream>
#include <map>
#include <algorithm>
using namespace std;

int main() {
    ifstream fin ("records.in");
    ofstream fout ("records.out");
    int N;
    fin >> N;
    string a, b, c, s; 
    map<string, int> m;
    for(int i=0;i<N;i++) {
        fin >> a >> b >> c;
        //sorts yo
        if(a > b) swap(a, b);
        if(a > c) swap(a, c);
        if(b > c) swap(b, c);
        //v.push_back(a+"."+b+"."+c);
        s = a+","+b+","+c;
        m[s]++;
    }
    int best = 1;
    for(map<string, int>::iterator it = m.begin(); it != m.end(); it++) {
        best = max(best, it->second);
    }
    fout << best << '\n';
    return 0;
}
```

###[Bronze II: Baseball](http://usaco.org/index.php?page=viewproblem2&cpid=359)

If you get lucky and use a fast language like C++, brute forcing this problem is possible. We can try every triple of cows O(N<sup>3</sup>) and make sure that the distance from the second cow to the third cow is at least the distance from first to second, but not twice as far from first to second. Here's the full brute force code:

```cpp
#include <iostream>
#include <fstream>
#include <algorithm>
#define MAX_N 1001
using namespace std;

int main() {
    ifstream fin ("baseball.in");
    ofstream fout ("baseball.out");
    int cows[MAX_N], N;
    fin >> N;
    for(int i=0;i<N;i++) {
        fin >> cows[i];
    }
    sort(cows, cows+N);
    int count = 0, d, f;
    for(int i=0;i<N-2;i++) {
        for(int j=i+1;j<N-1;j++) {
            for(int k=j+1;k<N;k++) {
                d = cows[j] - cows[i];
                f = cows[k] - cows[j];
                if(f >= d && f <= 2*d) count++;
            }
        }
    }
    fout << count << endl;
    return 0;
}
```

This shouldn't work. To avoid teetering on the edge of the time limit like this, we should find a more efficient algorithm. Using [binary search](https://en.wikipedia.org/wiki/Binary_search), we can solve this problem in **O(N<sup>2</sup>logN)** time. To do this, let's iterate over every pair of cows. This takes O(N<sup>2</sup>) time. Let's call the first cow a, the second cow b, and the distance between a and b m. We can binary search our cow array for b+m and b+2m. Even if a cow at that position doesn't exist, binary search can tell us where the cow "would be" if it were there. Most languages have some form of built-in binary search. Here's a full solution using the C++ STL `lower_bound` and `upper_bound`.

```cpp
#include <iostream>
#include <fstream>
#include <algorithm>
#define MAX_N 1001
using namespace std;

int main() {
    ifstream fin ("baseball.in");
    ofstream fout ("baseball.out");
    int cows[MAX_N], N;
    fin >> N;
    for(int i=0;i<N;i++) {
        fin >> cows[i];
    }
    sort(cows, cows+N);
    int count = 0;
    for(int i=0;i<N-2;i++) {
        for(int j=i+1;j<N-1;j++) {
            int M = cows[j]-cows[i];
            //find all cows in [cows[j]+M,cows[j]+2M]
            int lo = lower_bound(cows, cows+N, cows[j]+M)  - cows;
            int hi = upper_bound(cows, cows+N, cows[j]+2*M) - cows;
            count += (hi - lo);
        }
    }
    fout << count << endl;
    return 0;
}
```

###[Bronze III: Wormholes](http://usaco.org/index.php?page=viewproblem2&cpid=360)
A little bit of math reveals that there are only 10,395 ways to choose six pairs of wormholes from 12 wormholes (see footnote). If we have a O(n<sup>2</sup>) algorithm that checks for a loop given the pairings, that's probably just fast enough.

Unfortunately, I can't come up with an efficient way to generate only unique combinations of wormholes, so a solution to this problem is still in progress.

**EDIT:** I've since ~~cheated~~ looked at the official solution. Brian Dean uses [backtracking](https://en.wikipedia.org/wiki/Backtracking) to generate all possible pairings of wormholes. Backtracking is great because it lets us prune large swaths of the recursive tree that repeat, allowing us to not check too many states. Backtracking checks a few more states than necessary, but is efficient enough.

Footnote: 12!/(2<sup>6</sup> \* 6!) = 11\*9\*7*5\*3 = 10,395.

12! for every ordering of 12 wormholes. Divide by 2<sup>6</sup> because we don't care about ordering within the pair. Divide by 6! to remove the ordering of the pairs. 

---
title: USACO November 2013 Editorial
---

_This is an editorial for USACO's November 2013 competition. The solutions posted below are not official, and are not guaranteed to be correct in all cases._

I am a huge fan of USACO's problems. Bessie and Farmer John have grown on me over the past few years. The problems are usually challenging, but not impossible. The competition is always evolving: this was the first contest to explicitly set guidelines for partial credit. While I wasn't a fan of the shared bronze-silver problem, I appreciate the added diversity in problems. 

###[Bronze I: Combination Lock](http://usaco.org/index.php?page=viewproblem2&cpid=340)
Given the low bounds on input (N &le; 100), almost any algorithm will work. Here's a C++ solution that tries every single combination and sees if it's valid.

```cpp
bool within2(int a, int b) {
    return abs(a-b) <= 2 || abs(a-b-N) <= 2;
}

int main() {
    ifstream fin ("combo.in");
    ofstream fout ("combo.out");
    int a, b, c, x, y, z;
    fin >> N;
    fin >> a >> b >> c;
    fin >> x >> y >> z;
    int count = 0;
    for(int i=1;i<=N;i++) {
        for(int j=1;j<=N;j++) {
            for(int k=1;k<=N;k++) {
                if((within2(i,a) && within2(j,b) && within2(k,c)) 
                || (within2(i,x) && within2(j,y) && within2(k,z))) {
                    count++; 
                }
            }
        }
    }
    fout << count << endl;
    return 0;
}
```
Runtime: **O(n^3)**

That said, there are many smarter ways to go about this. Looking at only one combination, there's only five valid numbers for each slot. 5^3 = 125. Multiply this by the 2 codes to get 250 possible valid combinations. However, some of these are duplicates of each other. In order to filter out the duplicates, we can put the combinations into a set. Here's some python code showing this.

```python
fin = open('combo.in', 'r')
fout = open('combo.out', 'w')

N = int(fin.readline())
fjcombo = map(int, fin.readline().split(' '))
mastercombo = map(int, fin.readline().split(' '))

s = set();
for i in range(fjcombo[0]-2, fjcombo[0]+3):
    for j in range(fjcombo[1]-2, fjcombo[1]+3):
        for k in range(fjcombo[2]-2, fjcombo[2]+3):
            s.add(((i+N)%N, (j+N)%N, (k+N)%N))

for i in range(mastercombo[0]-2, mastercombo[0]+3):
    for j in range(mastercombo[1]-2, mastercombo[1]+3):
        for k in range(mastercombo[2]-2, mastercombo[2]+3):
            s.add(((i+N)%N, (j+N)%N, (k+N)%N))

fout.write(str(len(s))+'\n')
```

Runtime: **O(1)** (no matter what the input is, 250 insert operations are done)

We can further improve this by calculating the number of overlapping elements instead of generating all of them, but at this point, the optimization is largely irrelevant.

###[Bronze II: Goldilocks and the Cows](http://usaco.org/index.php?page=viewproblem2&cpid=341)
Gah, I wrote a really good editorial for this but I forgot to save. Here's the abridged version.

1. X, Y, and Z are constant for all cows. Therefore, if we know how many cows are cold, hot, and just right, we can calculate the amount of milk in constant time.
2. The only temperatures we need to consider are the ones at which a cow's mood changes. All other temperatures are equivalent to one of those temperature borders.

With those two rules, we can start with the temperature at -1, then increase it to each boundary, keeping track of the state of the cows overall. We don't care about the individual cows, only the group as a whole. By sorting the temperatures and then checking each one, we can solve this problem as such (C++):
```cpp
struct event {
    int temp;
    bool is_start;
    bool operator<(event other) const {
        return temp < other.temp;
    }
};
int main() {
    ifstream fin ("milktemp.in");
    ofstream fout ("milktemp.out");
    fin >> N >> X >> Y >> Z;
    a = N;
    int t;
    vector<event> v;
    for(int i=0;i<N;i++) {
        event e;
        fin >> t;
        e.temp = t;
        e.is_start = true;
        v.push_back(e);

        fin >> t;
        e.temp = t;
        e.is_start = false;
        v.push_back(e);
    }
    sort(v.begin(), v.end());
    int best = a*N;
    for(int i=0;i<v.size();) {
        int j;
        for(j=i;v[i].temp == v[j].temp;j++) {
            if(v[j].is_start) {
                a--;
                b++;
            } else {
                b--;
                c++;
            }
        }
        i = j;
        best = max(best, a*X+b*Y+c*Z);
    }
    best = max(best, c*N);
    fout << best << endl;
    return 0;
}
```
Runtime: **O(nlogn)**

###[Bronze III / Silver I: No Cow](http://usaco.org/index.php?page=viewproblem2&cpid=343)

Just an implementation problem. The code is pretty long, and Brian Dean has a much nicer solution than I do on the USACO web site.

###[Silver II: Crowded Cows](http://usaco.org/index.php?page=viewproblem2&cpid=344)

First step seems obvious: sort the cows. But should we do it by x position or height? A decent naive approach would be to sort the cows by x position, then for each cow, scanning to each side, finding if the cow is crowded or not. This would be a **O(n^2)** runtime. Given USACO's recently increased runtimes - this suffices!
```cpp
struct cow {
    int x, h;
    cow(int x, int h) : x(x), h(h) { }
    bool operator<(cow const other) const {
        return x < other.x;
    }
};

int main() {
    ifstream fin ("crowded.in");
    ofstream fout ("crowded.out");
    int N, D, x, h;
    fin >> N >> D;
    vector<cow> cowlist;
    for(int i=0;i<N;i++) {
        fin >> x >> h;
        cowlist.push_back(cow(x, h));
    }
    sort(cowlist.begin(), cowlist.end());
    int count = 0;
    for(int i=1;i<N-1;i++) {
        if(cowlist[i].h >= 500000000) {
            continue; 
        }
        bool left = false;
        for(int j=i-1;j>=0;j--) {
            if(cowlist[i].x - cowlist[j].x > D) {
                break;
            }
            if(cowlist[j].h >= cowlist[i].h * 2) {
                left = true;
                break;
            }
        }
        if(!left) {
            continue;
        }
        bool right = false;
        for(int j=i+1;j<N;j++) {
            if(cowlist[j].x - cowlist[i].x > D) {
                break;
            }
            if(cowlist[j].h >= cowlist[i].h * 2) {
                right = true;
                break;
            }
        }
        if(left && right) {
            count++;
        }
    }
    fout << count << endl;
    return 0;
}
```

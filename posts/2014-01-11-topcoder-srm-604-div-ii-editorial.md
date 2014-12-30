---
title: TopCoder SRM 604 Div. II Editorial
---

###[Fox And Word](http://community.topcoder.com/stat?c=problem_statement&pm=12953&rd=15837)

TopCoder uses pretty small limits, so we can brute force this. It takes O(N<sup>2</sup>) to iterate through every pair of strings. We can check if one string is a rearrangement of the other in O(N<sup>2</sup>) again (O(N) to try every possible shift, O(N) to verify the shifted string matches the other one). This results in a O(N^2 * N^2) = **O(N<sup>4</sup>)** solution. I wrote a new method to check if two strings can be rearranged to simplify the code. Here's my solution in C++ (be gentle, still learning):

```
bool works(string a, string b) {
    if(a.size() != b.size()) return false;
    int N = a.size();
    for(int p = 0; p<N; p++) {
        bool works = true;
        for(int j=0, i=p%N;j<N;i = (i+1)%N, j++) {
            if(a[i] != b[j]) {
                works = false;
                break;
            }
        }
        if(works) return true;
    }
    return false;
}

class FoxAndWord {
public:
    int howManyPairs(vector <string> words) {
        int N = words.size(), count = 0;
        for(int i=0;i<N;i++) {
            for(int j=i+1;j<N;j++) {
                if(works(words[i], words[j])) count++;
            }
        }
        return count;
    }
};

```
A faster way to check if the strings are equal is to use the `substring` function.

###[Power of Three Easy](http://community.topcoder.com/stat?c=problem_statement&pm=12952&rd=15837&rm=320185&cr=23138918)
This problem can be both brute forced and intelligently solved, although the technique for solving it intelligently is useful in more complicated problems.

####Brute Force
Since there's only two directions to go, and they don't oppose each other, we can just try every possible point starting from (0, 0). Even though the edge of the board is 1,000,000,000 units away, Fox is tripling the distance he moves at each step. Since 3^20 > 1,000,000,000, he can take a maximum of 20 steps __combined__! This makes it easy to find every location he can land on, as there are less than 400 of them. We can do it with BFS or DFS. Here's a succint brute force solution in Python:

```
def dfs(x, y, a, b, step):
    if a > 1000000000 or b > 1000000000:
        return False
    if a == x and b == y:
        return True
    return dfs(x, y, a+step, b, 3*step) or dfs(x, y, a, b+step, 3*step)

class PowerOfThreeEasy:
    def ableToGet(self, x, y):
        return "Possible" if dfs(x, y, 0, 0, 1) else "Impossible"
```

####More Intelligent Solution
Since we can only move in units of 3<sup>k</sup>, x and y have special properties in [trinary](https://en.wikipedia.org/wiki/Trinary). Since we can use each trinary digit once, the sum of x and y in trinary should be composed of only 1s. This means that, the digits of x and y in trinary can only be 0 or 1, and the sum of the corresponding digits must be one. 

That's is a little tricky to read, let's write out an example:
Say `x = 3` and `y = 10`. In trinary, `x = 010` and `y = 101`
```
  010 (x)
+ 101 (y)
---------
  111
```

Because the result is only 1s and the digits of x and y are never two and also not equal, 3 and 10 is a valid point. Here's some code that uses this method:

```
int getTrit(int mask, int val) {
  int trit = (val % mask) - (val % (mask / 3));
  while(trit >= 3) trit /= 3;
  return trit;
}
 
class PowerOfThreeEasy {
public:
  string ableToGet(int x, int y) {
    int sum = x + y;
    for(;sum > 0;sum /= 3) {
      if(sum%3 != 1) return "Impossible";
    }
    sum = x + y;
    int tx, ty;
    for(int mask = 3; mask <= sum; mask *= 3) {
      tx = getTrit(mask, x);
      ty = getTrit(mask, y);
      if(tx==2||ty==2||tx==ty) return "Impossible";
    }
    return "Possible";
  }
};
```

###[Fox Connection II](http://community.topcoder.com/stat?c=problem_solution&rd=15837&rm=320185&cr=23138918&pm=12951)
_Note: I didn't solve this problem during the contest, but here's my thought process:_

We should be able to solve this problem using dynamic programming. Let's define the two-dimensional matrix dp, where the first element is the size of the connected component, and the second element is an element that somehow defines that component uniquely, let's call it a root. We can calculate the number of connected components of size s with root i with two steps:

- The component is entirely made up of a child of i and i itself.
- The component is split across two children of i.


Then we can calculate `dp[s][i]` as the sum of all `dp[s-1][j]`, where j are the children of i, to account the first bullet point. The second bullet point is a little harder. Let's define a value k to be the size of the component of one of the children. Then we need to sum up all `dp[k][a]*dp[s-k-1][b]` where a and b are all pairwise children of i, for all values of k between 1 and s-1. Unfortunately, I had some bug (overflow error probably) and didn't code a working solution in time.

---

With two successful hacks, I finished 34th out of 1435 competitors and was re-promoted to TopCoder Division I! This time, I'm going to practice more and not fall back into Division II. One thing I need to work on is speed: it took me just over 20 minutes to code up a bug-free solution to the Powers of Three problem. 

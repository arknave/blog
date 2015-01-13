---
title: Crump Solution
---

_Crump is a problem I gave to my school's Advanced Computer Programming Class. You can read the problem [here](https://docs.google.com/document/d/1hA8-e_M70a_5hmsM3TTn1LVE1RkZ0KfkbfDct0G3UVc/edit?usp=sharing)._ 

This problem was lifted almost directly from the USACO training pages, but I wrote a short backstory to make it harder to search for answers. The problem can be split into two parts, parsing the input and solving the problem efficiently.

###Parsing the input

```cpp
#include <iostream>
#include <fstream>
#define MAX_N 33
using namespace std;
bool field[4*MAX_N][4*MAX_N] = {{0}};
int N, M;
char A;

void loadBin(int i, int j, char c) {
    int a = (int)c;
    a -= '0';
    if(a > 0xF) a += ('0' - 'A' + 0xA);
    for(int mask = 8, t=j; mask > 0; mask /= 2, t++){
        field[i][t] = (a & mask);
    }
}

int main() {
    ifstream fin ("crump.in");
    fin >> N >> M;
    for(int i=0;i<4*N;i++) {
        for(int j=0;j<M;j++) {
            fin >> A;
            loadBin(i, 4*j, A);
        }
    }
	return 0;
}

```

Here's the code I started with. Let's go through the `loadBin` function, as that's the interesting part. The first part is wrangling the character `c` into its corresponding hex value `a`. If 0 &le; c &le; 9, then we can just subtract `'0'`. Otherwise, we need to subtract `'A'`, and add `0xA` to make `'A'` line up with `0xA`.

Now that we have only 4 bits of data, how can we load it into the matrix? Let's use a [bitmask](https://en.wikipedia.org/wiki/Bitmask)! Here, my mask starts at `1000`, then goes to `0100`, `0010`, and finally `0001`. As my mask halves each time, the index I place the result into is advanced, properly populating the `field` matrix. 

###Solving the Problem
To solve this problem, we can use a technique called [**dynamic programming**](https://en.wikipedia.org/wiki/Dynamic_programming). This is a powerful technique that solves problems by building up from smaller solutions. At the heart of dynamic programming is the concept of a _recurrence relation_, some way to calculate a state given previous states. 

In our case, let's define our state at (i, j) to be the the size of the largest square with bottom right corner (i, j). How does this help us? We can move from one state to another in faster time. In the naiive solution, we needed to check O(N<sup>2</sup>) elements of the matrix to see if there is a square of size s. Now, we only need to check directly above and below. 

To see if there is a square of size s with bottom corner (i, j), there needs to be squares which are at least size s-k with bottom right corners at (i-k, j) and (i, j-k) for all k less than s and greater than 0.

This reduces the total runtime complexity to O(N<sup>3</sup>) time. It's left as an exercise to the reader to reduce it further to O(N<sup>2</sup>) time.

---
title: Scheduling Problem
---

The scheudling problem is commonly used to introduce greedy algorithms. Let's say you're a crazy LASA student who now is encountering the freedoms of college. Say there are N classes, each with start time s<sub>i</sub> and ending time t<sub>i</sub>. A student cannot be enrolled in classes that overlap. What is the maximum number of classes a student can take? 

First off, brute-force solution. There are 2<sup>n</sup> combinations of classes, and it takes O(n<sup>2</sup>) time to check each pair of classes for overlap. Therefore, the brute-force algorithm runs in O(n<sup>2</sup>2<sup>n</sup>). This is obviously really bad. 

Let's start by attacking the low-hanging fruit - checking for overlap. O(n<sup>2</sup>) is too slow. If we sort the classes by end time, we can do a O(1) check to see if two classes overlap (see if the start time of the current class is before the finish time of the previous class). This allows us to reduce the runtime of the overall algorithm to O(nlogn + n2<sup>n</sup>) = O(n2<sup>n</sup>). 

However, the 2<sup>n</sup> part of the runtime is the real issue. We don't actually need to try every subset, we just need to greedily take the class that finishes soonest, and then only consider classes that start as the first class ends. This algorithm requires an initial sort, followed by a linear scan through the classes for a O(nlogn) algorithm, much more efficient than the previous one. 

How can we guarantee that this works? Consider the list of classes sorted by end time. If we take the first class, we're following the algorithm - so far so good. If we don't take the first class __we gain nothing__. At best, we swap out the first class with a later class. At worst, swapping with this later class limits the number of classes we can take. There are no additional classes that can be taken later down the line without taking the current class. Therefore, the greedy algorithm is always correct, as it satisfies the optimal substructure property.
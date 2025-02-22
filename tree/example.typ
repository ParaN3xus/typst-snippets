#import "tree.typ": build-tree, end-sect

#set heading(numbering: "1.1")
#set par(justify: true)

#show: build-tree.with(
  func: (level: 0, heading: none, body) => {
    if (level == 0) {
      return body
    }
    heading
    let fill = black.transparentize((1 - calc.pow(1.3, -level)) * 100%)
    block(
      stroke: (left: 0.5pt + fill),
      inset: (left: 1em, bottom: 0.5em),
      outset: (left: -0.3em),
      body,
    )
  },
)

= Search Algorithms and Data Structures

== Sequential Search Structures
Search algorithms form the backbone of data retrieval, with time complexity varying based on the algorithm design. For a sequence of length n, the efficiency can range from linear to logarithmic time:

$
  T_"linear" (n) = c dot n "for some constant" c > 0 \
  T_"binary" (n) = c dot log_2 (n) "for some constant" c > 0
$

=== Linear Search
Linear search represents the most basic form of search algorithms, operating on unordered sequences. The algorithm examines each element sequentially until the target is found or the sequence is exhausted, resulting in a time complexity of $O(n)$ for a sequence of length $n$.

=== Binary Search
Binary search operates on ordered sequences by repeatedly dividing the search interval in half. For a sequence of length $n$, the algorithm achieves a time complexity of $O(log n)$ through the following recurrence relation:

$ T(n) = T(n / 2) + O(1) $

#end-sect

The efficiency gain of binary search over linear search becomes evident as the sequence size grows, demonstrated by the relationship:

$ O(log n) << O(n) "for large" n $

== Tree-Based Search Structures

=== Binary Search Trees
Binary Search Trees (BSTs) maintain a hierarchical ordering where for any node, all elements in the left subtree are smaller and all elements in the right subtree are larger. The search operation traverses a path from root to target, with average-case time complexity governed by:

$ T_"avg"(n) = O(log n) $

=== AVL Trees
AVL trees enhance BSTs by maintaining balance through rotation operations. The height-balance property ensures that for any node, the heights of its left and right subtrees differ by at most one:

$ abs(h_"left"(v) - h_"right"(v)) <= 1 $

This balance condition guarantees logarithmic time complexity for all operations.

#end-sect

The relationship between tree height and node count in AVL trees satisfies:

$ h <= 1.44 log_2(n + 2) - 1.328 $

== Hash-Based Search Structures

=== Direct Addressing
Direct addressing provides constant-time operations by using array indices as keys. The space complexity directly relates to the key range:

$ S(n) = O(max("key") - min("key")) $

=== Hash Tables
Hash tables overcome the space limitations of direct addressing through hash functions that map keys to array indices. The expected time for operations under simple uniform hashing is:

$ T_"expected"(n) = O(1 + alpha) $

where $alpha = n/m$ is the load factor, $n$ is the number of elements, and $m$ is the table size.

#end-sect

The probability of collision in a hash table follows the birthday problem approximation:

$ P("collision") approx 1 - e^(-n^2 / (2m)) $

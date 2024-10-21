# Runtime Analysis
## Naive CPU code
Since naive CPU code is a nested for loop, the Big-O time is O(n^2) or O(size^2), so the graph of the performance will have exponential growth. 

## Optimal CPU code
A single for-loop is a O(n), hence, the graph will have linear growth. 

## GPU naive code
For naive code, we have O((n^2)/p) and in our case, we have p = 256. So, for n<16, Big-O is O(n) but after that point it will increase exponentially. 

## GPU recursive double
GPU recursive double code has O(nlog(n)/n) or O(nlog(n)/256), which means up until a certain point, optimal CPU code is the most efficient. But after the input size increases to the millionth, the most efficient way to scan is recursive doubling within the methods I've exercised. 

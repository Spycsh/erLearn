# algos

erlang中没有for, while, 一切都由递归来进行循环，但普通递归往往会对内存有很大的需求，考虑阶乘实现：

```erlang
% 1. 无尾递归
fac(N) when N == 0 -> 1;
fac(N) when N > 0 -> N * fac(N-1).

% 或写成
% fac(0) -> 1;
% fac(N) when N > 0 -> N * fac(N-1).
```

不断调用fac函数，但是实质上只有到最后统一计算`N*(N-1)*(N-2)*...*1`因此要一次记住N个数，对内存的占用很大。


**尾递归**对原有递归函数增加一个新的参数(accumulator)，解决了对原有递归不断调用占用很大空间的问题。占用的空间类似for迭代所用的空间。举个例子，使用尾递归1000!，相当于作1000次计算，也即记1000次，但每次记住的只有两个参数，代码如下：

```erlang
% 2. 尾递归
tail_fac(N) -> tail_fac(N, 1).

tail_fac(0, Acc) -> Acc;
tail_fac(N, Acc) when N > 0 -> tail_fac(N-1, N*Acc).
```

对于复杂递归函数的尾递归实现起来往往不太容易。仔细观之其实是有模板的。

1. 加一个参数(accumulator)
2. 函数外不再带有额外操作（如上文中的`N*fac(N-1)`)，所有额外操作都依仗参数accumulator携带

注意！对于返回一个序列（如list）的函数，比如`sublist`函数，尾递归一开始会产生顺序相反的序列，需要加reverse或tail_reverse函数使之"反反得正"。



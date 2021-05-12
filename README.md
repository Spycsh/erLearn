# Erlang笔记


## 尾递归
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

## lists高阶函数
```erlang
1> lists:all(func(x)->x==1, [1,2,3]).
* 1: syntax error before: '->'
1> lists:all(func(X)->X==1, [1,2,3]).
* 1: syntax error before: '->'
1> lists:all(fun(X)->X==1, [1,2,3]).
* 1: syntax error before: ')'
1> lists:all(fun(X)->X==1 end, [1,2,3]).
false
2> lists:all(fun(X)->X==1 end, [1,2,3]).
false
3> lists:any(fun(X)->X==1 end, [1,2,3]).
true
4> lists:append([[1,2,3],[a,b],[4,5,6]]).
[1,2,3,a,b,4,5,6]
5> lists:append([1,2,3],[4,5,6]).
[1,2,3,4,5,6]
6> lists:append(["a","b","c"]).
"abc"
7> lists:concat([doc, '/', file, '.', 3]).
"doc/file.3"
8> lists:delete(a,[1,2,a]).
[1,2]
9> lists:droplast([1,2,3]).
[1,2]
10> lists:dropwhile(fun(X->X>2), [1,2,3]).
* 1: syntax error before: '->'
10> lists:dropwhile(fun(X)->X>2 end, [1,2,3]).
[1,2,3]
11> lists:dropwhile(fun(X)->X>1 end, [1,2,3]).
[1,2,3]
12> MyList = lists:dropwhile(fun(X) -> X < 8 end, lists:seq(1,10)),
io:format("~w", [MyList]).
[8,9,10]ok
13> lists:dropwhile(fun(X) -> X < 8 end, lists:seq(1,10))
.
"\b\t\n"
14> lists:dropwhile(fun(X) -> X < 8 end, lists:seq(1,10)).
"\b\t\n"
15> lists:dropwhile(fun(X) -> X < 8 end, [1,8,9]).
"\b\t"
16> MyList = lists:dropwhile(fun(X) -> X > 8 end, lists:seq(1,10)),
.
* 2: syntax error before: '.'
16> lists:dropwhile(fun(X) -> X > 8 end, [1,8,9]).
[1,8,9]
17> lists:dropwhile(fun(X) -> X < 8 end, [1,8,9]).
"\b\t"
18> lists:duplicate(6,xx).
[xx,xx,xx,xx,xx,xx]
19> lists:dropwhile(fun(X) -> X % 2==0 end, [1,8,9]).
.
* 2: syntax error before: '.'
19> lists:dropwhile(fun(X) -> X rem 2==0 end, [1,8,9]).
[1,8,9]
20> 1 rem 2.
1
21> lists:dropwhile(fun(X) -> X rem 2==1 end, [1,8,9]).
"\b\t"
22> K=lists:dropwhile(fun(X) -> X rem 2==1 end, [1,8,9]).
"\b\t"
23> io.format(K).
* 1: syntax error before: '.'
23> io:format(K).
        ok
24> io:format("~w",[K]).
[8,9]ok
25> filter(X>2, [1,2,3]).
* 1: variable 'X' is unbound
26> filter(func(X)->X>2, [1,2,3]).
* 1: syntax error before: '->'
26> filter(fun(X)->X>2 end, [1,2,3]).
** exception error: undefined shell command filter/2
27> lists:filter(fun(X)->X>2 end, [1,2,3]).
[3]
28> lists:filtermap(fun(X)->X>2 end, [1,2,3]).
[3]
29> lists:filter(fun(X)->X>2 end, [1,2,3,4]).
[3,4]
30> lists:filter(fun(X)->X>2 end, [1,2,3,4,1]).
[3,4]
31> lists:filtermap(fun(X) -> case X rem 2 of 0 -> {true, X div 2}; _ -> false end end, [1,2,3,4,5]).
[1,2]
32> lists:filter(fun(X) -> case X rem 2 of 0 -> {true, X div 2}; _ -> false end end, [1,2,3,4,5]).
** exception error: no case clause matching {true,1}
     in function  lists:'-filter/2-lc$^0/1-0-'/2 (lists.erl, line 1290)
33> 3 div 2
.
1
34> 3/2
.
1.5
35> lists:map(fun(X)->[X,X] end, [a,b,c]).
[[a,a],[b,b],[c,c]]
36> lists:flattern([[a,v],b]).
** exception error: undefined function lists:flattern/1
37> lists:flatten([[a,v],b]).
[a,v,b]
38> lists:foldl(fun(X,Sum) -> X+Sum end, 0, [1,2,3,4,5]).
15
39> lists:foldl(fun(X,Sum) -> X-Sum end, 0, [1,2,3,4,5]).
3
40> 0-1-2.
-3
41> 0-1-2-3-4-5.
-15
42> lists:foldr(fun(X,Sum) -> X-Sum end, 0, [1,2,3,4,5]).
3
43> lists:foldr(fun(X,Sum) -> Sum-X end, 0, [1,2,3,4,5]).
-15
44> lists:nth(3, [a,v,d,c,s]).
d
45> lists:split(2,[a,b,c,d,e]).
{[a,b],[c,d,e]}
46> lists:sublist([a,b,c,d,e],3).
[a,b,c]
47> lists:sublist([a,b,c,d,e],3,4).
[c,d,e]
```

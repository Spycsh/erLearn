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

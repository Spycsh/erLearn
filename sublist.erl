-module(sublist).
-export([sublist/2, tail_sublist/2]).

% 给定一个列表L和整数N，返回列表前N个元素
% 例如sublist([1,2,3,4,5,6],3) 返回[1,2,3]
sublist(_, 0) -> [];
sublist([], _) -> [];
sublist([H|T], N) when N > 0 -> [H|sublist(T, N-1)].

% 尾递归的写法会返回[3,2,1],因此加reverse
tail_sublist(L, N) -> tail_reverse(tail_sublist(L, N, [])).

tail_sublist(_, 0, SubList) -> SubList;
tail_sublist([], _, SubList) -> SubList;
tail_sublist([H|T], N, SubList) when N > 0 ->
    tail_sublist(T, N-1, [H|SubList]).

tail_reverse(L) -> tail_reverse(L, []).

tail_reverse([], Acc) -> Acc;
tail_reverse([H|T], Acc) ->
    tail_reverse(T, [H|Acc]).
-module(reverse).
-export([reverse/1, tail_reverse/1]).

% 反转列表
reverse([]) -> [];
reverse([H|T]) -> reverse(T) ++ [H].

tail_reverse(L) -> tail_reverse(L, []).

tail_reverse([], Acc) -> Acc;
tail_reverse([H|T], Acc) ->
    tail_reverse(T, [H|Acc]).
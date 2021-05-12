-module(funcs).
-compile(export_all).

% https://erldocs.com/18.0/stdlib/lists.html#map/2 
% 更多用法

%predicate
filter(Pred, L) -> lists:reverse(filter(Pred, L, [])).

filter(_, [], Acc) -> Acc;
filter(Pred, [H|T], Acc) ->
    case Pred(H) of
        true -> filter(Pred, T, [H|Acc]);
        false -> filter(Pred, T, Acc)
    end.

map(_, []) -> [];
map(F, [H|T]) -> [F(H)|map(F,T)].

% 任何把list元素减少到1个的都是fold，比如max/min，sum
fold(_, Start, []) -> Start;
fold(F, Start, [H|T]) -> fold(F, F(H,Start), T).
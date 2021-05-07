-module(zip).
-export([zip/2, lenient_zip/2, tail_zip/2, tail_lenient_zip/2]).

% zip function
zip([], []) -> [];
zip([X|Xs], [Y|Ys]) -> [{X, Y}|zip(Xs, Ys)].

% lenient zip function
lenient_zip([], _) -> [];
lenient_zip(_, []) -> [];
lenient_zip([X|Xs], [Y|Ys]) -> [{X,Y}|lenient_zip(Xs, Ys)].

% tail recursive zip functions
tail_zip(X, Y) -> tail_reverse(tail_zip(X, Y, [])).

tail_zip([], [], Acc) -> Acc;
tail_zip([X|Xs], [Y|Ys], Acc) -> 
    tail_zip(Xs, Ys, [{X, Y}|Acc]).

% tail recursive lenient zip function
tail_lenient_zip(X, Y) -> tail_reverse(tail_lenient_zip(X, Y, [])).

tail_lenient_zip([], _, Acc) -> Acc;
tail_lenient_zip(_, [], Acc) -> Acc;
tail_lenient_zip([X|Xs], [Y|Ys], Acc) -> tail_lenient_zip(Xs, Ys, [{X, Y}|Acc]).


% reverse
tail_reverse(L) -> tail_reverse(L, []).

tail_reverse([], Acc) -> Acc;
tail_reverse([H|T], Acc) -> tail_reverse(T, [H|Acc]).

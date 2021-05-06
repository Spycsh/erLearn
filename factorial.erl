-module(factorial).
-export([fac/1, tail_fac/1]).

% 1. 无尾递归
fac(N) when N == 0 -> 1;
fac(N) when N > 0 -> N * fac(N-1).

% 或写成
% fac(0) -> 1;
% fac(N) when N > 0 -> N * fac(N-1).

% 2. 尾递归
% "we never need to hold more than two terms in memory: 
% the space usage is constant.
%  It will take as much space 
% to calculate the factorial of 4 
% as it will take space to 
% calculate the factorial of 1 million
% Acc represents the accumulator"
tail_fac(N) -> tail_fac(N, 1).

tail_fac(0, Acc) -> Acc;
tail_fac(N, Acc) when N > 0 -> tail_fac(N-1, N*Acc).




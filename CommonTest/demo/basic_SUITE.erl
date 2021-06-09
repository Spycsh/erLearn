-module(basic_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0]).
-export([test1/1, test2/1]).

% 每一个test suite都需要以_SUITE结尾

all() -> [test1, test2].

test1(_Config) ->
    1 = 1.

test2(_Config) ->
    A = 0,
    1/A.


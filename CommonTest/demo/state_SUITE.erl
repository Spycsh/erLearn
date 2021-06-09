-module(state_SUITE).
-include_lib("common_test/include/ct.hrl").
 
-export([all/0, init_per_testcase/2, end_per_testcase/2]).
-export([ets_tests/1]).
 
all() -> [ets_tests].
 
init_per_testcase(ets_tests, Config) ->
    % ordered set表示key instance唯一且根据key有序
    % 一条记录
    TabId = ets:new(account, [ordered_set, public]),
    ets:insert(TabId, {andy, 2131}),
    ets:insert(TabId, {david, 12}),
    ets:insert(TabId, {steve, 12943752}),
    [{table,TabId} | Config].
 
end_per_testcase(ets_tests, Config) ->
    ets:delete(?config(table, Config)).

% 测试代码
ets_tests(Config) ->
    TabId = ?config(table, Config),
    [{david, 12}] = ets:lookup(TabId, david),
    steve = ets:last(TabId),
    true = ets:insert(TabId, {zachary, 99}),
    zachary = ets:last(TabId).
-module(tree).
-export([empty/0, insert/3, lookup/2]).

empty() -> {node, 'nil'}.

insert(K, V, {node, 'nil'}) ->  % 插入第一个节点时,左右各有一个空子节点
    {node, {K, V, {node, 'nil'}, {node, 'nil'}}};
insert(NewK, NewV, {node, {K, V, Smaller, Larger}}) when NewK < K ->
    {node, {K, V, insert(NewK, NewV, Smaller), Larger}};
insert(NewK, NewV, {node, {K, V, Smaller, Larger}}) when NewK > K ->
    {node, {K, V, Smaller, insert(NewK, NewV, Larger)}};
insert(K, V, {node, {K, _, Smaller, Larger}}) ->
    {node, {K, V, Smaller, Larger}}.

lookup(_, {node, 'nil'}) ->
    undefined;
lookup(K, {node, {K, V, _, _}}) ->
    {ok, V};
lookup(K, {node, {NodeKey, _, Smaller, _}}) when K < NodeKey ->
    lookup(K, Smaller);
lookup(K, {node, {_, _, _, Larger}}) ->
    lookup(K, Larger).

% 1> T1 = tree:insert("Jim Woodland", "jim.woodland@gmail.com", tree:empty()).
% {node,{"Jim Woodland","jim.woodland@gmail.com",
%        {node,nil},
%        {node,nil}}}
% 2> T2 = tree:insert("Mark Anderson", "i.am.a@hotmail.com", T1).
% {node,{"Jim Woodland","jim.woodland@gmail.com",
%        {node,nil},
%        {node,{"Mark Anderson","i.am.a@hotmail.com",
%               {node,nil},
%               {node,nil}}}}}
% 3> Addresses = tree:insert("Anita Bath", "abath@someuni.edu", tree:insert("Kevin Robert", "myfairy@yahoo.com", tree:insert("Wilson Longbrow", "longwil@gmail.com", T2))).
% {node,{"Jim Woodland","jim.woodland@gmail.com",
%        {node,{"Anita Bath","abath@someuni.edu",
%               {node,nil},
%               {node,nil}}},
%        {node,{"Mark Anderson","i.am.a@hotmail.com",
%               {node,{"Kevin Robert","myfairy@yahoo.com",
%                      {node,nil},
%                      {node,nil}}},
%               {node,{"Wilson Longbrow","longwil@gmail.com",
%                      {node,nil},
%                      {node,nil}}}}}}}
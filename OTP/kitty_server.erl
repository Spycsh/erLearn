-module(kitty_server).
% -export([start_link/0, order_cat/4, return_cat/2, close_shop/1]).
-compile(export_all).
-record(cat, {name, color=green, description}).

% client api
start_link() -> spawn_link(fun init/0).

% server functions
init() -> loop([]).

loop(Cats) ->
    receive
        {Pid, Ref, {order, Name, Color, Description}} ->
            if Cats =:= [] ->
                Pid ! {Ref, make_cat(Name, Color, Description)},
                loop(Cats);
               Cats =/= [] -> % 清空库存
                Pid ! {Ref, hd(Cats)},  % return the head of list
                loop(tl(Cats))  % return the tail (the list minus the head)
            end;
        {return, Cat = #cat{}} ->
            loop([Cat|Cats]);
        {Pid, Ref, terminate} ->
            Pid ! {Ref, ok},
            terminate(Cats);
        Unknown ->
            io:format("Unknown msg: ~p~n", [Unknown]),
            loop(Cats)
        end.

%%% Private functions
make_cat(Name, Col, Desc) ->
    #cat{name=Name, color=Col, description=Desc}.
 
terminate(Cats) ->
[io:format("~p was set free.~n",[C#cat.name]) || C <- Cats],
ok.

% synchronous call
order_cat(Pid, Name, Color, Description) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, {order, Name, Color, Description}},
    receive
        {Ref, Cat} ->
            erlang:demonitor(Ref, [flush]),
            Cat;
        {'Down', Ref, process, Pid, Reason} ->
            erlang:error(Reason)
    after 5000 ->
        erlang:error(timeout)
    end.

% aync
% 告诉server归还猫猫
return_cat(Pid, Cat = #cat{}) ->
    Pid ! {return, Cat},
    ok.

% sync
close_shop(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, terminate},
    receive
        {Ref, ok} ->
            erlang:demonitor(Ref, [flush]),
            ok;
        {'DOWN', Ref, process, Pid, Reason} ->
            erlang:error(Reason)
    after 5000 ->
        erlang:error(timeout)
    end.


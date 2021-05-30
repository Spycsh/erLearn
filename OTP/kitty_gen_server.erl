-module(kitty_gen_server).
-behaviour(gen_server). % 将定义回调函数init, handle_cast, handle_init等等
% https://erldocs.com/18.0/stdlib/gen_server.html
% gen_server module            Callback module
% -----------------            ---------------
% gen_server:start
% gen_server:start_link -----> Module:init/1

% gen_server:stop       -----> Module:terminate/2

% gen_server:call
% gen_server:multi_call -----> Module:handle_call/3

% gen_server:cast
% gen_server:abcast     -----> Module:handle_cast/2

% -                     -----> Module:handle_info/2

% -                     -----> Module:terminate/2

% -                     -----> Module:code_change/3
-export([start_link/0, order_cat/4, return_cat/2, close_shop/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

% 定义结构体cat
-record(cat, {name, color=green, description}).

%%% 客户端 API
start_link() ->
    % 参数 1. 回调module, 2. 给init/1的参数， 3. debugging options
    gen_server:start_link(?MODULE, [], []).

%% 客户端同步 call
order_cat(Pid, Name, Color, Description) ->
    % call 格式
    % call(ServerRef, Request) -> Reply
    % call(ServerRef, Request, Timeout) -> Reply
    % Request 是一个任意的term，用于作handle_call的参数
    gen_server:call(Pid, {order, Name, Color, Description}).

%% 客户端异步 call(cast)
return_cat(Pid, Cat = #cat{}) ->
    % 类似call
    gen_server:cast(Pid, {return, Cat}).

%% 客户端同步call
close_shop(Pid) ->
    gen_server:call(Pid, terminate).

%%% 服务器函数
%% gen_server会调用?Module:init也就是这里的init
init([]) -> {ok, []}. %% 这里没有用到info

%% 处理同步 call
%% handle_call(Request, From, State) -> Result
handle_call({order, Name, Color, Description}, _From, Cats) ->
    if 
        Cats =:= [] ->
            {reply, make_cat(Name, Color, Description), Cats};
        Cats =/= [] ->
            {reply, hd(Cats), tl(Cats)}
    end;
handle_call(terminate, _From, Cats) ->
    {stop, normal, ok, Cats}.

handle_cast({return, Cat = #cat{}}, Cats) ->
    {noreply, [Cat|Cats]}.

handle_info(Msg, Cats) ->
    io:format("Unexpected msg: ~p~n", [Msg]),
    {noreply, Cats}.

terminate(normal, Cats) ->
    % 所有猫猫的名字
    [io:format("~p was set free. ~n", [C#cat.name]) || C <- Cats],
    ok.

code_change(_OldVsn, State, _Extra) ->
    %% No change planned. The function is there for the behaviour,
    %% but will not be used. Only a version on the next
    {ok, State}. 

%%% Private functions
make_cat(Name, Col, Desc) ->
    #cat{name=Name, color=Col, description=Desc}.

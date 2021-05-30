-module(otp_server).
-compile(export_all).

% 通用组件,一个简易的gen_server实现

% call(Pid, Msg) ->
%     Ref = erlang:monitor(process, Pid),
%     Pid ! {self(), Ref, Msg},
%     receive
%         {Ref, Reply} ->
%             erlang:demonitor(Ref, [flush]),
%             Reply;
%         {'DOWN', Ref, process, Pid, Reason} ->
%             erlang:error(Reason)
%     after 5000 ->
%         erlang:error(timeout)
%     end.

% 同步方法调用
call(Pid, Msg) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {sync, self(), Ref, Msg}, % add sync to differentiate different msg
    receive
        {Ref, Reply} ->
            erlang:demonitor(Ref, [flush]),
            Reply;
        {'DOWN', Ref, process, Pid, Reason} ->
            erlang:error(Reason)
    after 5000 ->
        erlang:error(timeout)
    end.

% 异步方法调用
cast(Pid, Msg) ->
    Pid ! {async, Msg},
    ok.

reply({Pid, Ref}, Reply) ->
    Pid ! {Ref, Reply}.

% 
init(Module, InitialState) ->
    loop(Module, Module:init(InitialState)).

loop(Module, State) ->
    receive
        {aync, Msg} ->
            loop(Module, Module:handle_cast(Msg, State));
        {sync, Pid, Ref, Msg} ->
            loop(Module, Module:handle_call(Msg, {Pid, Ref}, State))
    end.
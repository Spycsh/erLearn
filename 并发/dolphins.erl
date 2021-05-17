- module(dolphins).
- compile(export_all).

% 熟悉receive... end范式
dolphin1() ->
    receive
        do_a_flip ->
            io:format("flip!~n");
        fish ->
            io:format("I am a fish.~n");
        _ ->
            io:format("Heh, we are smarter than you humans.~n")
    end.

% 增添一个From，记录发送者的进程号，以便返回信息给它，而不仅仅是打印输出
dolphin2() ->
    receive
        {From, do_a_flip} ->
            From ! "flip!"; % 向发送者发送信息
        {From, fish} ->
            From ! "I am a fish.";
        _ ->
            io:format("Heh, we are smarter than you humans.~n")
    end.

% 再增添递归，这样就会一直答复。注意是尾递归所以不会存在栈溢出
dolphin3() ->
    receive
        {From, do_a_flip} ->
            From ! "flip!",
            dolphin3();
        {From, fish} ->
            From ! "I am a fish.";
        _ -> 
            io:format("Heh, we are smarter than you humans.~n"),
            dolphin3()
    end.

## 错误处理

### try... catch

```erlang
try
  some_unsafe_function(),
  {ok, FileHandle} = file:open("foo.txt", [read]),
of
  0 -> io:format("0");
  N -> do_something_with(N)
catch
  oops -> got_throw_oops;
  throw:Other -> {got_throw, Other};
  exit:Reason -> {got_exit, Reason};
  error:Reason -> {got_error, Reason};
  _:_ -> gg
after
  file:close(FileHandle)
end
```

### link

```erlang
1> c(linkmon).
{ok,linkmon}
2> spawn(fun linkmon:myproc/0).
<0.52.0>
3> link(spawn(fun linkmon:myproc/0)).
true
** exception error: reason
```

这个exception不能被try...catch捕获

在shell中杀死进程
```erlang
exit(Pid, Reason)
```

使用system process使exit signal被捕获(trapped result)
```erlang
2> c(linkmon).
{ok,linkmon}
3> process_flag(trap_exit,true).
true
4> spawn_link(fun() -> linkmon:chain(3) end).
<0.87.0>
5> receive X -> X end.
{'EXIT',<0.87.0>,"chain dies here"}
```


需要注意，使用kill无法捕获。



### monitor

两个进程彼此无依赖，只是想监视另一个进程

```erlang
1> erlang:monitor(process, spawn(fun() -> timer:sleep(500) end)).
#Ref<0.0.0.77>
2> flush().
Shell got {'DOWN',#Ref<0.0.0.77>,process,<0.63.0>,normal}
ok
```

只是想用一个进程监视另一个进程

```erlang
3> {Pid, Ref} = spawn_monitor(fun() -> receive _ -> exit(boom) end end).
{<0.73.0>,#Ref<0.0.0.100>}
4> erlang:demonitor(Ref).
true
5> Pid ! die.
die
6> flush().
ok
```


### 命名进程以防止exit后pid丢失

* `erlang:register/2` `unregister/1`

使用whereis(critic)找到pid同样会有问题，那就是臭名昭著的race condition，考虑以下两种情况
```
  1. critic ! Message
                        2. critic receives
                        3. critic replies
                        4. critic dies
  5. whereis fails
                        6. critic is restarted
  7. code crashes
```
```
  1. critic ! Message
                           2. critic receives
                           3. critic replies
                           4. critic dies
                           5. critic is restarted
  6. whereis picks up
     wrong pid
  7. message never matches
```


## 并发

```erlang
1> c(dolphins).
dolphins.erl:2: Warning: export_all flag enabled - all functions will be exported
{ok,dolphins}
2> Dolphin1 = spawn(dolphins, dolphin1, []).
<0.85.0>
3> Dolphin1 ! do_a_flip.
flip!       %%% Dolphin1进程接收到do_a_flip，打印
do_a_flip
4> Dolphin1 ! fish.
fish        %%% 进程已经结束，这一句没有任何输出，发送失败
```

```erlang
5> Dolphin2 = spawn(dolphins, dolphin2, []).
<0.89.0>
6> Dolphin2 ! {self(), do_a_flip}.
{<0.78.0>,do_a_flip}    %%% Dolphin2进程接收到信息，并答复一个flip!的信息，用flush()查看
7> flush().
Shell got "flip!"
ok
```

```erlang
2> Dolphin3 = spawn(dolphins, dolphin3, []).
<0.85.0>
3> Dolphin3 ! {self(), unknown_msg}.
Heh, we are smarter than you humans.
{<0.78.0>,unknown_msg}
4> Dolphin3 ! {self(), do_a_flip}.
{<0.78.0>,do_a_flip}
5> flush().
Shell got "flip!"   %%% 加入递归,，Dolphin3进程不会退出
ok
```
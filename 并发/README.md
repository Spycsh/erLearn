
## 并发

并发是Erlang的原生特性，它的可扩展性来源于禁止进程间共享内存，相反通过发送复制所有数据的消息进行通信；它的容错来源于异步消息的进程模型，需要ack来确认消息抵达。

Erlang VM会对每个core启动一个线程作为调度程序(scheduler)，这些调度程序每个都有一个运行队列(run queue)，当有个调度程序的运行队列有太多任务时，VM负责执行所有的负载平衡。由Amdahl's Law，多核看似可以线性地缩小(linear Scaling)运行时间但并不完全可以，运行时间还与系统的并行度有关。

Erlang在图像，密码暴力破解，GPU编程方面等大量数据处理的数值算法方面并不好；相反在聊天服务器，电话交换机，web服务器，消息队列，web爬虫这类可表示成actor模型的逻辑实体方面可以近似linear Scaling，表现出众。

下面是一个简易的进程通信的例子：
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

保存状态的例子：

```erlang
9> c(kitchen).
{ok,kitchen}
10> f().
ok
11> Pid = spawn(kitchen, fridge2, [[baking_soda]]).
<0.73.0>
12> kitchen:store2(Pid, water).
ok
13> kitchen:take2(Pid, water).
{ok,water}
14> kitchen:take2(Pid, juice).
not_found
```
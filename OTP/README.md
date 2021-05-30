```erlang
Eshell V11.1  (abort with ^G)
1> c(kitty_server).  
kitty_server.erl:3: Warning: export_all flag enabled - all functions will be exported
{ok,kitty_server}
2> rr(kitty_server).  %% Reads record definitions from a module's BEAM file
[cat]
3> Pid = kitty_server:start_link().
<0.88.0>
4> Cat1 = kitty_server:order_cat(Pid, carl, brown, "loves to burn bridges").
#cat{name = carl,color = brown,
     description = "loves to burn bridges"}
5> kitty_server:return_cat(Pid, Cat1).
ok
6> kitty_server:order_cat(Pid, jimmy, orange, "cuddly").
#cat{name = carl,color = brown,
     description = "loves to burn bridges"}
7> kitty_server:order_cat(Pid, jimmy, orange, "cuddly").
#cat{name = jimmy,color = orange,description = "cuddly"}
8> kitty_server:return_cat(Pid, Cat1).
ok
9> kitty_server:close_shop(Pid).
carl was set free.
ok
10> kitty_server:close_shop(Pid).
** exception error: no such process or port
     in function  kitty_server:close_shop/1 (kitty_server.erl, line 69)
```

```erlang
Eshell V11.1  (abort with ^G)
1> c(kitty_gen_server).
{ok,kitty_gen_server}
2> rr(kitty_gen_server).
[cat]
3> {ok, Pid} = kitty_gen_server:start_link().
{ok,<0.88.0>}
4> Pid ! <<"Test handle_info">>.
Unexpected msg: <<"Test handle_info">>
<<"Test handle_info">>
5> Cat = kitty_gen_server:order_cat(Pid, "Cat Stevens", white, "not a cat").
#cat{name = "Cat Stevens",color = white,
     description = "not a cat"}
6> kitty_gen_server:return_cat(Pid, Cat).
ok
7> kitty_gen_server:order_cat(Pid, "Kitten Mittens", black, "look at them little paws!").
#cat{name = "Cat Stevens",color = white,
     description = "not a cat"}
8> kitty_gen_server:order_cat(Pid, "Kitten Mittens", black, "look at them little paws!").
#cat{name = "Kitten Mittens",color = black,
     description = "look at them little paws!"}
9> kitty_gen_server:return_cat(Pid, Cat).
ok
10> kitty_gen_server:return_cat(Pid, Cat).
ok
11> kitty_gen_server:close_shop(Pid).
"Cat Stevens" was set free. 
"Cat Stevens" was set free.
ok
```
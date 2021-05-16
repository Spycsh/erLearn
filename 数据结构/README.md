## 数据结构

### Records

类似C的结构体，#调用这个结构体，.获取属性

<!-- https://blog.csdn.net/wild46cat/article/details/79197209 -->

```erlang
-export([main/0]).
-export([person_factory/1, person_factory/3]).

-record(person, {name, age = 0, hobbies = []}).
main() ->
  io:format("erlang record demo~n", []),
  Myvar = person_factory(dfdf, 12, [sing, sleep]),
  io:format("~p,~p,~p~n", [Myvar#person.name, Myvar#person.age, Myvar#person.hobbies]),
  Myvar2 = person_factory(dfdf),
  io:format("~p,~p,~p~n", [Myvar2#person.name, Myvar2#person.age, Myvar2#person.hobbies]),
  io:format("~n", []).

person_factory(Name, Age, Hobbies) ->
  #person{name = Name, age = Age, hobbies = Hobbies}.

person_factory(Name) ->
  #person{name = Name}.

```

## KV Store

* proplist
* orddict

## Arrays

* arrays

## Set

* ordsets
* sets
* gb_sets
* sofs (sets of sets)

## Directed Graphs

* digraph

## Queues

* queue
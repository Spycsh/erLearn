# 分布式

# Erlang分布式计算的问题

* 网络不可靠  
异步发送模式并强迫使用ack

* 延迟

* 带宽有限  
发送正在发生的事情（玩家X找到了Y，而不是全部库存）。非常大的信息可能会阻塞其他信息的通道。

* 网络安全  
不推荐也无法跨不同的数据中心进行集群。SSL实现自己的高级通信层

* 拓补会改变

* 有不同团队管理  
版本控制，升级代码需要协调

* 运输成本  
小数据

* 网络应用程序语言格式不同  
json，XML翻译层

# CAP

[Why not CA?](https://codahale.com/you-cant-sacrifice-partition-tolerance/)

* CAP：  
Consistency: atomicity or linearizability. There exists a uniform bill on different servers  
Availability: Every request has a successful response（只对活的节点而言，对死节点来说因为死节点不会接收新的request，只要复活时同步就行）    
Partition Tolerance:  network fail

* CAP 三者取二，但实际上只有CP和AP是合理的。因为P是无法避免的。其实应该解释为在P的情况下，要C还是A


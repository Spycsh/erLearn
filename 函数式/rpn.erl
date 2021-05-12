-module(rpn).
-compile(export_all).

% reverse polish notation (rpn) 
% 基于树的后序遍历，相比于基于中序遍历的数学表达式，可以无括号地遍历整个表达式
% e.g. 2 *（3 + 4）+ 5 => 2 3 4 + * 5 +
% 想要计算rpn表达式, 首先想到使用foldl（多值合一）

% 表达式以空格分隔，parse后返回结果
rpn(L) when is_list(L) ->
    [Res] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")),
    Res.

% 遇到操作符，匹配前面的两个数字N1,N2进行运算
% 没有遇到操作符，默认遇到数字，交给read函数转换成整数
rpn("+", [N1,N2|S]) -> [N2+N1|S];
rpn("-", [N1,N2|S]) -> [N2-N1|S];
rpn("*", [N1,N2|S]) -> [N2*N1|S];
rpn("/", [N1,N2|S]) -> [N2/N1|S];
rpn("^", [N1,N2|S]) -> [math:pow(N2, N1)|S];
rpn("ln", [N|S]) -> [math:log(N)|S];
rpn("log10",[N|S]) -> [math:log10(N)|S];
rpn("sum", Stack) -> [lists:sum(Stack)];
rpn("prod", Stack) -> [lists:foldl(fun erlang:'*'/2, 1, Stack)];
rpn(X, Stack) -> [read(X)|Stack].

read(N) ->
    case string:to_float(N) of 
        {error, no_float} -> list_to_integer(N);
        {F, _} -> F
    end.

%% 返回ok如果下列正确
rpn_test() ->
    5 = rpn("2 3 +"),
    87 = rpn("90 3 -"),
    -4 = rpn("10 4 3 + 2 * -"),
    -2.0 = rpn("10 4 3 + 2 * - 2 /"),
    ok = try
        rpn("90 34 12 33 55 66 + * - +")
    catch
        error:{badmatch,[_|_]} -> ok
    end,
    4037 = rpn("90 34 12 33 55 66 + * - + -"),
    8.0 =  rpn("2 3 ^"),
    true = math:sqrt(2) == rpn("2 0.5 ^"),
    true = math:log(2.7) == rpn("2.7 ln"),
    true = math:log10(2.7) == rpn("2.7 log10"),
    50 = rpn("10 10 10 20 sum"),
    10.0 = rpn("10 10 10 20 sum 5 /"),
    1000.0 = rpn("10 10 20 0.5 prod"),
    ok.


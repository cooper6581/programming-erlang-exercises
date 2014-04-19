-module(math_functions).
-export([even/1, odd/1, test/0]).

even(X) ->
    X rem 2 =:= 0.

odd(X) ->
    X rem 2 =/= 0.

filter(_, []) -> [];
filter(F, [H|T]) ->
    case F(H) of
        true  -> [H|filter(F,T)];
        false -> filter(F,T)
    end.

%% tail recursive version of filter
filter_tail(F, L) ->
    filter_tail(F, L, []).
filter_tail(_, [], Acc) -> lists:reverse(Acc);
filter_tail(F,[H|T], Acc) ->
    case F(H) of
        true  -> filter_tail(F, T, [H|Acc]);
        false -> filter_tail(F, T, Acc)
    end.

%% List comprehension version
split(L) ->
    { [N || N <- L, even(N)],
      [N || N <- L,  odd(N)] }.

%% Accumulator version
split_acc(L) -> split_acc(L, [], []).
split_acc([], EAcc, OAcc) -> {lists:reverse(EAcc), lists:reverse(OAcc)};
split_acc([H|T], EAcc, OAcc) -> 
    case even(H) of
        true  -> split_acc(T, [H|EAcc], OAcc);
        false -> split_acc(T, EAcc, [H|OAcc])
    end.

%% filter version
split_filter(L) ->
    {filter(fun even/1, L), filter(fun odd/1, L)}.

test() ->
    true         = even(2),
    false        = even(1),
    true         = odd(5),
    false        = odd(6),
    [2,4,6,8,10] = filter(fun even/1, lists:seq(1,10)),
    [1,3,5,7,9]  = filter_tail(fun odd/1, lists:seq(1,10)),
    {[2,4,6,8,10],[1,3,5,7,9]} = split(lists:seq(1,10)),
    {[2,4,6,8,10],[1,3,5,7,9]} = split_acc(lists:seq(1,10)),
    {[2,4,6,8,10],[1,3,5,7,9]} = split_filter(lists:seq(1,10)),
    passed.

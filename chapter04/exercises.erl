-module(exercises).
-export([my_tuple_to_list/1, test/0]).

my_tuple_to_list(T) when is_tuple(T) -> my_tuple_to_list(T, 1).
my_tuple_to_list(T, Size) when Size > tuple_size(T) -> [];
my_tuple_to_list(T, Size) -> [element(Size, T)|my_tuple_to_list(T,Size+1)].

%% Returns seconds elapsed as a float
my_time_func(F) ->
    {Smeg, Ss, Smic} = now(),
    F(),
    {Emeg, Es, Emic} = now(),
    ((Emeg - Smeg) * 1.0e6) +
    (Es - Ss) +
    ((Emic - Smic) / 1.0e6).

my_date_string() ->
    {Year, Month, Day}        = date(),
    {Hours, Minutes, Seconds} = time(),
    io:format("~p-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B~n",
               [Year, Month, Day, Hours, Minutes, Seconds]).
test() ->
    Foo = {this, is, a, {test, {this, too}}},
    BIFList = erlang:tuple_to_list(Foo),
    BIFList = my_tuple_to_list(Foo),
    Sleep = fun() -> timer:sleep(500) end,
    io:format("~p~n",[my_time_func(Sleep)]),
    my_date_string(),
    passed.

-module(exercises).
-export([my_tuple_to_list/1, test/0]).

my_tuple_to_list(T) when is_tuple(T) -> my_tuple_to_list(T, 1).
my_tuple_to_list(T, Size) when Size > tuple_size(T) -> [];
my_tuple_to_list(T, Size) -> [element(Size, T)|my_tuple_to_list(T,Size+1)].

test() ->
    Foo = {this, is, a, {test, {this, too}}},
    BIFList = erlang:tuple_to_list(Foo),
    BIFList = my_tuple_to_list(Foo),
    passed.

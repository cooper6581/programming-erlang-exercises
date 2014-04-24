-module(exercises).
-export([test/0]).

binary_reverse_tail(B) -> binary_reverse_tail(B, <<>>).
binary_reverse_tail(<<A:8, Rest/binary>>, Acc) ->
    binary_reverse_tail(Rest, <<A,Acc/binary>>);
binary_reverse_tail(<<>>, Acc) -> Acc.

binary_reverse(<<>>) -> <<>>;
binary_reverse(<<A:8, Rest/binary>>) ->
    Foo = binary_reverse(Rest),
    <<Foo/binary,A>>.  

test() ->
    <<1,7,6,2,1>> = binary_reverse(<<1,2,6,7,257>>),
    <<1,7,6,2,1>> = binary_reverse_tail(<<1,2,6,7,257>>),
    passed.

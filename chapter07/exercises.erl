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

bit_reverse(<<>>) -> <<>>;
bit_reverse(<<X:8, Rest/binary>>) ->
    Foo = bit_reverse(Rest),
    R = reverse_byte(<<X:8>>),
    <<R,Foo/binary>>.

reverse_byte(<<A:1, B:1, C:1, D:1, E:1, F:1, G:1, H:1>>) ->
    <<X:8>> = <<H:1,G:1,F:1,E:1,D:1,C:1,B:1,A:1>>,
    X.

term_to_packet(Term) ->
    Data = term_to_binary(Term),
    N = byte_size(Data),
    <<N:32,Data/binary>>.

packet_to_term(<<_Length:32,Data/binary>>) ->
    binary_to_term(Data).

test() ->
    <<1,7,6,2,1>> = binary_reverse(<<1,2,6,7,257>>),
    <<1,7,6,2,1>> = binary_reverse_tail(<<1,2,6,7,257>>),
    Packet = term_to_packet({test, "foo"}),
    <<Length:32,_Term/binary>> = Packet,
    16 = Length,
    {test, "foo"} = packet_to_term(Packet), 
    <<128,64,192>> = bit_reverse(<<1,2,3>>),
    passed.

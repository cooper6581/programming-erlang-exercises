-module(exercises).
-export([map_search_pred/2, test/0]).

map_search_pred(Map, Pred) -> 
    map_search_pred(Map, Pred, maps:keys(Map)).

map_search_pred(_, _, []) -> {};
map_search_pred(Map, Pred, [H|T]) ->
    case Pred(H, maps:get(H, Map)) of
        true  -> {H, maps:get(H, Map)};
        false -> map_search_pred(Map, Pred, T)
    end.

test() ->
    Foo = #{foo => 12, monkey => 13, bleh => a},
    {foo, 12} = map_search_pred(Foo, fun(A,B) ->
            (A =:= foo) and (B =:= 12) end),
    {} = map_search_pred(Foo, fun(_,_) -> false end),
    passed.


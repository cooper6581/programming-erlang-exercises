-module(try_test).
-export([test/0]).

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'EXIT', a};
generate_exception(5) -> error(a).

test() ->
    [catcher(I) || I <- lists:seq(1,5)].

catcher(N) ->
    try generate_exception(N)
    catch
        throw:X -> {exception_thrown, erlang:get_stacktrace(), X};
        exit:X  -> {exception_exit, erlang:get_stacktrace(), X};
        error:X -> {exception_error, erlang:get_stacktrace(), X}
    end.

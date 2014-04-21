-module(myfile).
-export([read/1, test/0]).

read(File) ->
    case file:read_file(File) of
        {ok, Bin}    -> Bin;
        {error, Why} -> throw(Why)
    end.

test() ->
    enoent = try read("fooo")
             catch
                throw:A -> A
             end,
    worked = try
                read("myfile.erl"),
                worked
             catch
                throw:B -> B
             end,
    passed.

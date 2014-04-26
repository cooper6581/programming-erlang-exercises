-module(exercises).
-export([test/0]).

functions_in_dict() ->
    [{exports, Functions}|_] = dict:module_info(),
    length(Functions).

get_module_info() ->
    [{Module, apply(Module, module_info, [])} || {Module,_File} <- code:all_loaded()].

%module_with_most_functions() ->

test() ->
    io:format("Functions in dict module: ~p~n",[functions_in_dict()]),
    passed.

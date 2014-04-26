-module(exercises).
-export([test/0]).

functions_in_dict() ->
    [{exports, Functions}|_] = dict:module_info(),
    length(Functions).

%% returns tuple with {module, contents of module_info}
get_module_info() ->
    [{Module, apply(Module, module_info, [])} || 
     {Module,_File} <- code:all_loaded()].

%% takes output of get_module_info, returns 
%% tuple with {module, number of funs}
get_max_functions(Info) ->
    [{Module, length(Exports)} || {Module, [{exports,Exports}|_]} <- Info].

%% max function for the output of get_max_functions
max_functions(Modules) -> max_functions(Modules, {none,0}).
max_functions([], Max) -> Max;
max_functions([{HModule, Length}|T], {_, Max}) when Length > Max ->
    max_functions(T, {HModule, Length});
max_functions([{_, Length}|T], {CModule, Max}) when Length < Max ->
    max_functions(T, {CModule, Max}).

test() ->
    io:format("Functions in dict module: ~p~n",[functions_in_dict()]),
    Info = get_module_info(),
    Fun_count = get_max_functions(Info),
    io:format("Max Functions: ~p~n", [max_functions(Fun_count)]),
    passed.

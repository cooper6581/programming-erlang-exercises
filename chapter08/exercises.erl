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

%% Cleaner, but requires a sort on the list
max_functions_2(Modules) ->
    lists:last(lists:keysort(2, Modules)).

%% Answers the most common function question.
%% Changed to return top 3 (#1 was module_info)
most_common_function(Info) ->
    % strip the arity, so we have a list of function names
    Counts = list_frequency_dict(functions_to_list(Info)),
    Sorted = lists:keysort(2,Counts),
    lists:reverse(lists:nthtail(length(Sorted) - 3, Sorted)).

functions_to_list(Info) ->
    [ Fname || {Fname, _} <- extract_exports(Info) ].

%% create a list of all functions exported by modules
extract_exports(Info) ->
    lists:flatten([ Exports || {_Module, [{exports, Exports}|_]} <- Info]).

%% returns tagged tuple {item, count}
%list_frequency(L) -> list_frequency(L, #{}).
%list_frequency([], Acc) -> maps:to_list(Acc);
%list_frequency([Key|T], Acc) ->
%    case maps:find(Key, Acc) of
%        {ok, Value} ->
%            list_frequency(T, maps:update(Key, Value+1, Acc));
%        error ->
%            list_frequency(T, maps:put(Key, 1, Acc))
%    end.

%% same as above, using dict instead of map for older versions
list_frequency_dict(L) -> list_frequency_dict(L, dict:new()).
list_frequency_dict([], Acc) -> dict:to_list(Acc);
list_frequency_dict([Key|T], Acc) ->
    list_frequency_dict(T, dict:update_counter(Key, 1, Acc)).

%% This is probably cheating...
unambiguous(Info) ->
    sets:to_list(sets:from_list(functions_to_list(Info))).

test() ->
    io:format("Functions in dict module: ~p~n",[functions_in_dict()]),
    Info = get_module_info(),
    Fun_count = get_max_functions(Info),
    io:format("Max Functions: ~p~n", [max_functions(Fun_count)]),
    io:format("Max Functions (2nd version): ~p~n", [max_functions_2(Fun_count)]),
    io:format("Most Common Function(s): ~p~n", [most_common_function(Info)]),
    io:format("Unambiguous Functions: ~p~n", [unambiguous(Info)]),
    passed.

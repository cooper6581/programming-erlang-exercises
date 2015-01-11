-module(exercises).
-export([test/0]).

%% Exercise 1
%% 
start(AnAtom, Fun) ->
    case whereis(AnAtom) of
        undefined -> register(AnAtom, spawn(fun() -> Fun() end));
        _ -> {error, previously_defined}
    end.

wait() ->
    receive
        _ -> void
    end.

%% Exercise 2
%%
max(N) ->
    statistics(runtime),
    statistics(wall_clock),
    Procs = [spawn(fun() -> wait() end) || _ <- lists:seq(1,N)],
    {_, Runtime} = statistics(runtime),
    {_, Wall} = statistics(wall_clock),
    lists:foreach(fun(Pid) -> Pid ! die end, Procs),
    U1 = Runtime * 1000 / N,
    U2 = Wall * 1000 / N,
    io:format("~p,~p,~p~n", [N, U1, U2]).

%% Exercise 3
%%
%-define(debug, true).
-ifdef(debug).
-define(DEBUG(Format, Args), io:format("[DEBUG] - " ++ Format, Args)).
-else.
-define(DEBUG(Format, Args), void).
-endif.

ring(N,M) ->
    statistics(runtime),
    statistics(wall_clock),
    create_procs(N, M, none),
    register(stats, spawn(fun() -> stats(N, M) end)),
    head ! foo.

create_procs(N, M, none) ->
    % le tail
    TPid = spawn(fun() -> loop(none, M) end),
    create_procs(N-1, M, TPid);
create_procs(0, _M, Pid) ->
    % le head
    register(head, Pid);
create_procs(N, M, Pid) ->
    % le rest
    NPid = spawn(fun() -> loop(Pid, M) end),
    create_procs(N-1, M, NPid).

loop(Pid, M) ->
    receive
        die when is_pid(Pid) -> 
            ?DEBUG("~p bye!~n", [self()]),
            Pid ! die;
        % All procs except for the tail
        Any when is_pid(Pid) ->
            ?DEBUG("~p received ~p~n", [self(), Any]),
            Pid ! Any,
            loop(Pid, M);
        % Reached the tail, send the message 'round the ring again
        _Any when M - 1 > 0 ->
            ?DEBUG("*~p received ~p~n", [self(), _Any]),
            ?DEBUG("End of ring!~n", []),
            head ! foo,
            loop(Pid, M-1);
        % Reached the tail, message is done going around the ring
        _Any ->
            ?DEBUG("**~p received ~p~n", [self(), _Any]),
            ?DEBUG("All messages sent!~n", []),
            stats ! report_stats
    end.

stats(N, M) ->
    receive
        report_stats ->
            {_, Runtime} = statistics(runtime),
            {_, Wall} = statistics(wall_clock),
            io:format("~p Procs, ~p Messages (~p Total) - ", [N, M, N*M]),
            io:format("Runtime: ~p, WallTime: ~p~n", [Runtime / 1000, Wall / 1000]),
            % teardown the process ring
            head ! die
    end.

test() ->
    % test for exercise 1
    true = start(test, fun() -> wait() end),
    true = is_pid(whereis(test)),
    {error, previously_defined} = start(test, fun ?MODULE:wait/0),
    test ! die,
    %% exercise 2
    [max(trunc(math:pow(2,X))) || X <- lists:seq(0,17)],
    %% exercise 3
    ring(500,3000),
    ok.

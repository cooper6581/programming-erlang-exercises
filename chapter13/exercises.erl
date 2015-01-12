-module(exercises).
-compile(export_all).

%% ex1
my_spawn(Mod, Func, Args) ->
    Start = now(),
    Pid = spawn(Mod, Func, Args),
    spawn(fun() ->
        Ref = monitor(process, Pid),
        receive
            {'DOWN', Ref, process, Pid, Why} ->
                End = now(),
                io:format("~p went down bro! Running time ~p seconds.~nReason: ~p~n",
                    [Pid, timer:now_diff(End, Start) / 1.0e6, Why])
        end
    end),
    Pid.

foo() ->
    receive
        X -> 
            _ = list_to_atom(X),
            foo()
    end.

on_exit(Pid, Fun) ->
    spawn(fun() ->
        Ref = monitor(process, Pid),
        receive
            {'DOWN', Ref, process, Pid, Why} -> Fun(Why)
        end
    end).

%% ex2
my_spawn_on_exit(Mod, Func, Args) ->
    Start = now(),
    Pid = spawn(Mod, Func, Args),
    on_exit(Pid, fun(Why) ->
        io:format("~p went down bro! Running time ~p seconds.~nReason: ~p~n",
            [Pid, timer:now_diff(now(), Start) / 1.0e6, Why])
    end),
    Pid.

%% ex3
my_spawn(Mod, Func, Args, Time) ->
    Pid = spawn(Mod, Func, Args),
    link(spawn(fun() ->
        receive
        after Time ->
            io:format("Bye!~n")
        end
    end)),
    Pid.

%% ex4
ex4() ->
    Time = 5000,
    register(still_running, spawn(fun() -> still_running(Time) end)),
    spawn(fun() ->
        Ref = monitor(process, still_running),
        receive
            {'DOWN', Ref, process, Pid, _Why} ->
                io:format("~p died, restarting...~n", [Pid]),
                register(still_running, spawn(fun() -> still_running(Time) end))
        end
    end).

still_running(Time) ->
    receive
        die -> void
    after Time ->
              io:format("I'm still running~n"),
              still_running(Time)
    end.

%% ex5
monitor_workers(L) -> [monitor_fun(F) || F <- L].

monitor_fun(F) ->
    Pid = spawn(F),
    spawn(fun() ->
        Ref = monitor(process, Pid),
        receive
            {'DOWN', Ref, process, Pid, _Why} ->
                io:format("~p died, restarting...~n", [Pid]),
                monitor_fun(F)
        end
    end),
    Pid.

%% ex6
start(L) -> 
    Pid = spawn(fun() ->
        [spawn_link(F) || F <- L],
        receive
        after infinity -> true
        end
    end),
    on_exit(Pid, fun(_) ->
        io:format("Link went down, restarting...~n"),
        start(L)
    end).

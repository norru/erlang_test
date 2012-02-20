-module(test).
-export([start/0, stop/0, hello/1]).

start() ->
    Pid = spawn(fun() -> run() end),
    register(hello, Pid),
    {ok, Pid}.

run() ->
    receive 
	{command, stop} ->
	    io:format("Terminating ~p~n", [self()]),
	    unregister(hello),
	    {ok, stop};
	Parameter ->
	    io:format("Hello, ~s~n", [Parameter]),
	    run()
    after 5000 ->
	    io:format("Still waiting...~n"),
	    run()
    end.

hello(Who) ->
    hello ! Who,
    {ok, Who}.

stop() ->
    hello ! {command, stop}.

-module(webmachine_demo_resource_tests).
-include_lib("eunit/include/eunit.hrl").

setup() ->
    %% turn off sasl output
    application:load(sasl),
    application:set_env(sasl, sasl_error_logger, false),

    %% ensure dependencies are started
    ok = ensure_started([
                         sasl
                         ,ibrowse
                         ,crypto
                         ,mochiweb
                         ,webmachine
                         ,webmachine_demo
                        ]).

ensure_started([]) ->
    ok;
ensure_started([App|Apps]) ->
    case application:start(App) of
        ok ->
            ensure_started(Apps);
        {error, {already_started, _}} ->
            ensure_started(Apps);
        Error ->
            Error
    end.

http_test() ->
    setup(),
    {ok, Status, _, _} = ibrowse:send_req("http://127.0.0.1:8000/demo",
                                          [{"Content-Type", "text/plain"}],
                                          get),
    ?assertEqual("200", Status).

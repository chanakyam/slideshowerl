-module(home_page_handler).
-author("shree@ybrantdigital.com").

-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
 	% Url = "http://api.contentapi.ws/videos?channel=us_mlb&limit=1&skip=0&format=long",
 	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=0&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	TopNBA_Url = "http://api.contentapi.ws/news?channel=us_nba&limit=2&skip=0&format=short",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_TopNBA} = ibrowse:send_req(TopNBA_Url,[],get,[],[]),
	ResponseParams_TopNBA = jsx:decode(list_to_binary(Response_TopNBA)),	
	TopNBAParams = proplists:get_value(<<"articles">>, ResponseParams_TopNBA),

	TopNHL_Url = "http://api.contentapi.ws/news?channel=us_nhl&limit=2&skip=0&format=short",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_TopNHL} = ibrowse:send_req(TopNHL_Url,[],get,[],[]),
	ResponseParams_TopNHL = jsx:decode(list_to_binary(Response_TopNHL)),	
	TopNHLParams = proplists:get_value(<<"articles">>, ResponseParams_TopNHL),

	NBA_Url = "http://api.contentapi.ws/news?channel=us_nba&limit=5&skip=2&format=short",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_NBA} = ibrowse:send_req(NBA_Url,[],get,[],[]),
	ResponseParams_NBA = jsx:decode(list_to_binary(Response_NBA)),	
	NBAParams = proplists:get_value(<<"articles">>, ResponseParams_NBA),

	NHL_Url = "http://api.contentapi.ws/news?channel=us_nhl&limit=5&skip=2&format=short",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_NHL} = ibrowse:send_req(NHL_Url,[],get,[],[]),
	ResponseParams_NHL = jsx:decode(list_to_binary(Response_NHL)),	
	NHLParams = proplists:get_value(<<"articles">>, ResponseParams_NHL),

	NFL_Url = "http://api.contentapi.ws/news?channel=us_nfl&limit=5&skip=2&format=short",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_NFL} = ibrowse:send_req(NFL_Url,[],get,[],[]),
	ResponseParams_NFL = jsx:decode(list_to_binary(Response_NFL)),	
	NFLParams = proplists:get_value(<<"articles">>, ResponseParams_NFL),

	{ok, Body} = index_dtl:render([{<<"videoParam">>,Params},{<<"topnba">>,TopNBAParams},{<<"topnhl">>,TopNHLParams},{<<"nba">>,NBAParams},{<<"nhl">>,NHLParams},{<<"nfl">>,NFLParams}]),
    {Body, Req, State}
.



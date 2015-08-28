-module(play_video_handler).
-author("chanakyam@koderoom.com").

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
	{[{_,Value}], Req2} = cowboy_req:bindings(Req),
	Url = "http://api.contentapi.ws/videos?channel=us_mlb&limit=1&skip=6&format=long",
	% io:format("movies url: ~p~n",[Url]), 
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	% Url_news = starstyle_util:play_video_item_url(binary_to_list(Value)),
	Url_news = string:concat("http://api.contentapi.ws/v?id=",binary_to_list(Value) ), 
	{ok, "200", _, ResponseNews} = ibrowse:send_req(Url_news,[],get,[],[]),
	ResNews = string:sub_string(ResponseNews, 1, string:len(ResponseNews) -1 ),
	ParamsNews = jsx:decode(list_to_binary(ResNews)),
	%io:format("params ~p ~n ",[ParamsNews]),

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

	Url_all_news = "http://api.contentapi.ws/videos?channel=world_news&limit=20&format=short&skip=0",
	% io:format("all news : ~p~n",[Url_all_news]),
	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(ResponseAllNews)),
	ResAllNews = proplists:get_value(<<"articles">>, ResponseParams),

	{ok, Body} = playvideo_dtl:render([{<<"videoParam">>,Params},{<<"newsParam">>,ParamsNews},{<<"topnba">>,TopNBAParams},{<<"topnhl">>,TopNHLParams},{<<"nba">>,NBAParams},{<<"allnews">>,ResAllNews}]),
    {Body, Req2, State}.



-module(all_news_handler).
-author("chanakyam@koderoom.com").
-include("includes.hrl").
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
	%{[{_,Value}], Req2} = cowboy_req:bindings(Req),
	{PageBinary, _} = cowboy_req:qs_val(<<"p">>, Req),
	PageNum = list_to_integer(binary_to_list(PageBinary)),
	SkipItems = (PageNum-1) * ?NEWS_PER_PAGE,
	{CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
	Category = binary_to_list(CategoryBinary),

	Url_all_news = case Category of 
		"us_nba" ->
			%Category = "US",
			string:concat("http://api.contentapi.ws/news?channel=us_nba&limit=35&format=short&skip=", integer_to_list(SkipItems));
		"us_nfl" ->
			%Category = "US",
			string:concat("http://api.contentapi.ws/news?channel=us_nfl&limit=35&format=short&skip=", integer_to_list(SkipItems));
			
		"us_nhl" ->
			%Category = "Politics",
			string:concat("http://api.contentapi.ws/news?channel=us_nhl&limit=35&format=short&skip=", integer_to_list(SkipItems));
		
		_ ->
			%Category = "None",
			lager:info("#########################None")

	end,

	% for videos

	% Url = case Category of 
	% 	"us_nba" ->
	% 		%Category = "US",
	% 		"http://api.contentapi.ws/videos?channel=us_mlb&limit=1&skip=3&format=long";
	% 	"us_nfl" ->
	% 		%Category = "US",
	% 		"http://api.contentapi.ws/videos?channel=us_mlb&limit=1&skip=4&format=long";
			
	% 	"us_nhl" ->
	% 		%Category = "Politics",
	% 		"http://api.contentapi.ws/videos?channel=us_mlb&limit=1&skip=5&format=long";
		
	% 	_ ->
	% 		%Category = "None",
	% 		lager:info("#########################None")

	% end,

	{ok, "200", _, Response} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(Response)),	
	ParamsAllNews = proplists:get_value(<<"articles">>, ResponseParams),

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=0&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[VideoParams] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	{ok, Body} = all_news_paginated_dtl:render([{<<"videoParam">>,VideoParams},{<<"news_category">>,Category},{<<"allnews">>,ParamsAllNews}]),
    {Body, Req, State}.





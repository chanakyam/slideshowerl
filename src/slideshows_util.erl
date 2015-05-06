-module(slideshows_util).
-include("includes.hrl").



-export([newsdb_url/0, 
		 thumbs_and_title/0, 
		 thumb_title_count/3,
		 news_item_url/1,
		 news_top_text_news_by_category_with_limit_and_skip/3,
		 news_count/1
		]).


newsdb_url() ->
	string:concat(?COUCHDB_URL, ?COUCHDB_TEXT_GRAPHICS)
.

thumbs_and_title() ->
	%http://couchdb.speakglobally.net/wildridge_latest/_design/slideshow/_view/title_thumbs?limit=5&descending=true
	Url1 = string:concat(?MODULE:newsdb_url(),"_design/slideshow/_view/title_thumbs?limit=5&descending=true"),
	Url1
.

thumb_title_count(Category, Limit, Skip) ->
	%http://couchdb.speakglobally.net/wildridge_latest/_design/slideshow/_view/us_nba?descending=true&limit=2
	Url1 = string:concat(?MODULE:newsdb_url(),"_design/slideshow/_view/"),
	Url2 = string:concat(Url1, Category),
	Url3 = string:concat(Url2, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)
.

news_top_text_news_by_category_with_limit_and_skip(Category, Limit, Skip) ->
	%% http://localhost:5984/reconlive/_design/news_by_category/_view/us_news?descending=true&limit=10
	Url  = string:concat(?MODULE:newsdb_url(), "_design/slideshow/_view/"), 
	Url1 = string:concat(Url,Category ),	
	Url3 = string:concat(Url1, "?descending=true&limit="),
	Url4 = string:concat(Url3, Limit),
	Url5 = string:concat(Url4, "&skip="),
	string:concat(Url5, Skip)	
.

news_count(Category) ->
	%% http://localhost:5984/reconlive/_design/get_count/_view/<category>
	Url1 = string:concat(?MODULE:newsdb_url(), "_design/news_by_sports_category/_view/"),
	Url2 = string:concat(Url1, Category),	
	string:concat(Url2, "?descending=true&limit=1")
.

news_item_url(Id) ->
	string:concat(?MODULE:newsdb_url(),Id)
.

PROJECT = slideshows
 
DEPS = lager cowboy erlydtl jsx ibrowse
dep_lager = https://github.com/basho/lager.git head
dep_cowboy = https://github.com/extend/cowboy master
dep_erlydtl = https://github.com/evanmiller/erlydtl.git head
dep_jsx = https://github.com/talentdeficit/jsx.git master
dep_ibrowse = https://github.com/cmullaparthi/ibrowse.git v4.0.1
 
include erlang.mk
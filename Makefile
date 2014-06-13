PROJECT = jxa-cowboy

DEPS = cowboy jsx simple_env simple_sup cowboy_base
dep_cowboy = pkg://cowboy master
dep_jsx = pkg://jsx master
dep_simple_env = https://github.com/camshaft/simple_env.git master
dep_simple_sup = https://github.com/camshaft/simple_sup.git master
dep_cowboy_base = https://github.com/camshaft/cowboy_base.git master

JXA_SRC = $(wildcard src/*.jxa)
JXA_OUT = $(patsubst src/%.jxa, ebin/%.beam, $(JXA_SRC))

TEST_SRC = $(wildcard test/*.jxa)
TEST_OUT = $(patsubst test/%.jxa, ebin/%.beam, $(TEST_SRC))

all: deps app bin/joxa $(JXA_OUT)

include erlang.mk

bin/joxa:
	@mkdir -p bin
	@curl -L -o $@ https://gist.githubusercontent.com/camshaft/b5f1047d6749459e90a5/raw/joxa
	@chmod +x $@

ebin/%.beam: src/%.jxa
	@ERL_LIBS=deps ./bin/joxa -o ebin -c $<
ebin/%.beam: test/%.jxa
	@ERL_LIBS=deps:.. ./bin/joxa -o ebin -c $<

ebin/chat.app: test/chat.app.src
	@cp $< $@

start: all ebin/chat.app $(TEST_OUT)
	@erl -pa ebin -pa deps/*/ebin -s chat $(args)

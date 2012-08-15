FROM	debian:buster-slim

SHELL	["/bin/bash", "-xeuo", "pipefail", "-c"]

RUN	apt-get update; \
	apt-get dist-upgrade -y; \
	apt-get install -y build-essential git; \
	apt-get clean; \
	apt-get autoclean

RUN	git clone --progress https://github.com/wolfcw/libfaketime /usr/src/libfaketime

WORKDIR	/usr/src/libfaketime

RUN	make -j"$(nproc)"; \
	make install

FROM	debian:buster-slim
COPY	--from=0	/usr/local/lib/faketime/libfaketimeMT.so.1	/usr/lib/faketime.so
ENV	LD_PRELOAD="/usr/lib/faketime.so" \
	FAKETIME="-10000y" \
	DONT_FAKE_MONOTONIC=1

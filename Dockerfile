FROM	debian:bookworm-slim

SHELL	["/bin/bash", "-xeuo", "pipefail", "-c"]

RUN	apt-get update; \
	apt-get dist-upgrade -y; \
	apt-get install -y build-essential git; \
	apt-get clean; \
	apt-get autoclean

WORKDIR	/usr/src/libfaketime
RUN	git clone --progress https://github.com/wolfcw/libfaketime /usr/src/libfaketime; \
	make -j"$(nproc)"; \
	make install

FROM	debian:bookworm-slim
COPY	--from=0	/usr/local/lib/faketime/libfaketimeMT.so.1	/usr/lib/faketime.so
ENV	LD_PRELOAD="/usr/lib/faketime.so" \
	FAKETIME="-10000y" \
	DONT_FAKE_MONOTONIC=1

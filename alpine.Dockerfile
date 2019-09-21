#

FROM	alpine

SHELL	["/bin/ash", "-xeuo", "pipefail", "-c"]

RUN	apk update; \
	apk add --update --upgrade --no-cache build-base git

RUN	git clone --progress https://github.com/wolfcw/libfaketime /usr/src/libfaketime

WORKDIR	/usr/src/libfaketime

RUN	make -j"$(nproc)"; \
	make install

#

FROM	alpine
COPY	--from=0	/usr/local/lib/faketime/libfaketimeMT.so.1	/lib/faketime.so
ENV	LD_PRELOAD="/lib/faketime.so" \
	FAKETIME="-10000y" \
	DONT_FAKE_MONOTONIC=1

#

FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake zlib1g zlib1g-dev libtool automake autotools-dev gettext
RUN git clone https://github.com/WizardMac/ReadStat.git
WORKDIR /ReadStat
RUN ./autogen.sh
RUN ./configure CC=afl-clang CXX=afl-clang++
RUN make
RUN make install
RUN mkdir /readstatCorpus
RUN wget https://rpadgett.butler.edu/ps310/datasets/Teach.sav
RUN wget https://rpadgett.butler.edu/ps310/datasets/lying.sav
RUN wget https://rpadgett.butler.edu/ps310/datasets/Drug.sav
RUN wget https://rpadgett.butler.edu/ps310/datasets/social.sav
RUN wget https://rpadgett.butler.edu/ps310/datasets/OCD.sav
RUN wget https://rpadgett.butler.edu/ps310/datasets/loveData.sav
RUN wget https://rpadgett.butler.edu/ps310/datasets/butlerpsych.sav
RUN mv *.sav /readstatCorpus
ENV LD_LIBRARY_PATH=/usr/local/lib

ENTRYPOINT ["afl-fuzz","-i","/readstatCorpus","-o","/readstatOut"]
CMD ["/usr/local/bin/readstat", "-f", "@@"]

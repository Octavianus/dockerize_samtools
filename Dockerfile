### Dockerized SAMTools 1.0
## This is Dockerized SAMTools without manual command.

# use the dockerfile/ubuntu base image provided by https://index.docker.io/u/dockerfile/ubuntu/
# The environment is ubuntu-14.04
FROM dockerfile/python

MAINTAINER David Weng weng@email.arizona.edu
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

### get the lib that needed for compiling by the samtools.
## Step 1: Install the basic tools to set up the environment.
# Install the wget, gcc, make tools, handling the lib dependency problem.
RUN apt-get install -y wget
#RUN sudo apt-get update
#RUN apt-get install -y gcc-4.6
RUN apt-get install -y gcc
#RUN apt-get install -y linux-libc-dev
RUN apt-get install -y make
#RUN apt-get install -y aptitude

### Hardcore install the lib gcc if is needed.
# WORKDIR /usr/lib/gcc/x86_64-linux-gnu/
# RUN mkdir 4.6
# WORKDIR 4.6/include-fixed
# RUN mkdir include-fixed
# RUN wget --no-check-certificate https://www.dropbox.com/s/2peii1imo14wcv9/limits.h
# RUN wget --no-check-certificate https://www.dropbox.com/s/0at9upocj14235m/syslimits.h

## Step 2: Get the zlib lib that needed for executing the samtools.
# Back to the /home/vagrant/ directory
WORKDIR /home/vagrant
RUN wget http://zlib.net/zlib-1.2.8.tar.gz
RUN tar xzvf zlib-1.2.8.tar.gz
WORKDIR zlib-1.2.8
RUN sudo ./configure
# Still in /zlib-1.2.8 directory
RUN make
RUN sudo make install 

## Step 3:Install curses
#RUN sudo apt-get install -y libtinfo5 # unseccess 
#RUN sudo aptitude install -y libtinfo-dev
#RUN sudo apt-get install -y libtinfo5-dbg
#RUN apt-mark showhold
#RUN apt-mark unhold libncurses5-dev libncursesw5-dev
#RUN sudo apt-get install -y libncurses5-dev libncursesw5-dev

WORKDIR /home/vagrant
RUN wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.4.tar.gz
RUN tar xzvf ncurses-5.4.tar.gz
WORKDIR ncurses-5.4
RUN sudo ./configure
RUN make
RUN sudo make install

## Step 3: Make and install samtools.
WORKDIR /home/vagrant/
RUN wget https://www.dropbox.com/s/8joxwj1ddfnsqxw/samtools-0.1.19.tar.bz2
RUN tar xvjf samtools-0.1.19.tar.bz2
# Change the working directory to the samtools
# compile samtools
WORKDIR samtools-0.1.19
RUN make

## Step 4: Add the executable to PATH.
## Or change the CMD and ENTRYPOINT, we use the latter here.

######## MODIFICATION, comment ENTRYPOIN. ADD ENV
#ENTRYPOINT ["/home/vagrant/samtools-0.1.19/samtools"]
#CMD ["/home/vagrant/samtools-0.1.19/samtools"]

ENV PATH /home/vagrant/samtools-0.1.19:$PATH
ENV PATH /home/vagrant/samtools-0.1.19/bcftools:$PATH
ENV PATH /home/vagrant/samtools-0.1.19/misc:$PATH



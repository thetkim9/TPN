FROM pytorch/pytorch:1.5.1-cuda10.1-cudnn7-devel
ENV LANG C.UTF-8
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get -y install wget
RUN mkdir ckpt
#RUN cd ckpt
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=15HHKGIhksTf0dSmgxrTsoHzZxF6n7eRa' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=15HHKGIhksTf0dSmgxrTsoHzZxF6n7eRa" -O sthv2_tpn.pth && rm -rf /tmp/cookies.txt
#RUN cd ..
#RUN mkdir demo
#COPY demo demo
#RUN cd demo
#RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=14VYS8hGA5i1J70qBqrUqLiDxJq_FgXiW' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=14VYS8hGA5i1J70qBqrUqLiDxJq_FgXiW" -O demo.mp4 && rm -rf /tmp/cookies.txt
#RUN cd ..
RUN conda install pytorch==1.2.0 torchvision==0.4.0 cudatoolkit=9.2 -c pytorch
RUN conda install -c anaconda flask
RUN conda install -c anaconda "Pillow<7"
RUN conda install -c anaconda requests
RUN apt-get -y install curl gnupg locales unzip
RUN conda install -c menpo opencv
RUN conda install scikit-image matplotlib pyyaml
RUN conda install -c conda-forge tensorboardx
RUN conda install -c conda-forge moviepy
RUN export PATH=/usr/local/cuda/bin:$PATH
RUN export CPATH=/usr/local/cuda/include:$CPATH
RUN export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
RUN conda install gxx_linux-64=7.3
RUN apt -y install git
RUN conda install -c anaconda cython
#RUN mv demo.mp4 demo
RUN mv sthv2_tpn.pth ckpt
RUN mkdir mmaction
COPY mmaction mmaction
COPY README.md .
COPY setup.py .
RUN python setup.py develop
COPY . .
EXPOSE 80
CMD python server.py
#CMD python ./test_video.py config_files/sthv2/tsm_tpn.py ckpt/sthv2_tpn.pth

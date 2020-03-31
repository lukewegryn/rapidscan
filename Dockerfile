FROM kalilinux/kali-rolling
RUN apt-get update && apt-get -yu dist-upgrade -y
WORKDIR /rapidscan

#install golismero manually
RUN apt-get install -y \
  python2.7 \
  python2.7-dev \
  python-pip \
  python-docutils \
  git \
  perl \
  nmap \
  sslscan

RUN cd /opt
RUN git clone https://github.com/golismero/golismero.git
RUN cd golismero
RUN pip install -r requirements.txt
RUN pip install -r requirements_unix.txt
RUN ln -s /opt/golismero/golismero.py /usr/bin/golismero

WORKDIR /rapidscan
RUN cd /rapidscan

RUN apt-get install -y \
  python2.7 \
  wget \
  dmitry \
  dnsrecon \
  wapiti \
  nmap \
  sslyze \
  dnsenum \
  wafw00f \
  dirb \
  host \
  lbd \
  xsser \
  dnsmap \
  dnswalk \
  fierce \
  davtest \
  whatweb \
  nikto \
  uniscan \
  whois \
  theharvester

RUN wget -O rapidscan.py https://raw.githubusercontent.com/lukewegryn/rapidscan/master/rapidscan.py && chmod +x rapidscan.py
RUN ln -s /rapidscan/rapidscan.py /usr/local/bin/rapidscan
WORKDIR /reports
ENTRYPOINT ["rapidscan"]

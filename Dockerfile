FROM kalilinux/kali-rolling
RUN apt-get update && apt-get -yu dist-upgrade -y
WORKDIR /rapidscan

#install golismero manually
RUN apt-get install -y \
  python3 \
  python3-pip \
  python2.7 \
  python2.7-dev \
  python-pip \
  python-docutils \
  git \
  perl \
  nmap \
  sslscan

RUN pip install wheel
RUN pip install pip==9.0.3
RUN pip install awscli
RUN pip install futures==2.1.5
RUN pip install ffsend

WORKDIR /opt
RUN git clone https://github.com/golismero/golismero.git
WORKDIR /opt/golismero
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

ENTRYPOINT rapidscan ${TARGET_URL} && \
  mv /rapidscan/RS-Vulnerability-Report /rapidscan/${TARGET_URL}-Vulnerability-Scan-Report.pdf && \
  ffsend /rapidscan/${TARGET_URL}-Vulnerability-Scan-Report.pdf > /rapidscan/result.txt && \
  sendlink=$(cat /rapidscan/result.txt | grep "send.firefox.com/download" | cut -d" " -f5) && \
  aws ses send-email \
  --from "${FROM_ADDRESS}" \
  --destination "ToAddresses=${TO_ADDRESS}" \
  --message "Subject={Data=${SUBJECT},Charset=utf8},Body={Text={Data=Your Vulnerability Scan Report is ready for download: $sendlink,Charset=utf8},Html={Data=,Charset=utf8}}"

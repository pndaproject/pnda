if [ "x$http_proxy" == "x" ] || [ "x$https_proxy" == "x" ]; then
  echo 'System proxies ($http_proxy and $https_proxy) must first be set'
  exit
fi

HTTP_PROXY_HOST=`echo $http_proxy | awk -F/ '{print $3}' | awk -F: '{print $1}'`
HTTP_PROXY_PORT=`echo $http_proxy | awk -F/ '{print $3}' | awk -F: '{print $2}'`
HTTPS_PROXY_HOST=`echo $https_proxy | awk -F/ '{print $3}' | awk -F: '{print $1}'`
HTTPS_PROXY_PORT=`echo $https_proxy | awk -F/ '{print $3}' | awk -F: '{print $2}'`

cat > ~/.setproxy.sh << EOF
export http_proxy=http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT
export https_proxy=http://$HTTPS_PROXY_HOST:$HTTPS_PROXY_PORT
export JAVA_FLAGS="-Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTPS_PROXY_HOST -Dhttps.proxyPort=$HTTPS_PROXY_PORT -Dhttp.nonProxyHosts=localhost,127.0.0.1,$HTTP_PROXY_HOST"
export JAVA_OPTS="\$JAVA_FLAGS"
export MAVEN_OPTS="\$JAVA_FLAGS -Dmaven.javadoc.skip=true"
export JRUBY_OPTS="-J-Dhttp.proxyHost=$HTTP_PROXY_HOST -J-Dhttp.proxyPort=$HTTP_PROXY_PORT -J-Dhttps.proxyHost=$HTTPS_PROXY_HOST -J-Dhttps.proxyPort=$HTTPS_PROXY_PORT"
EOF
if ! fgrep -q 'source ~/.setproxy.sh' ~/.bashrc; then
cat >> ~/.bashrc <<'EOF'
source ~/.setproxy.sh
EOF
source ~/.setproxy.sh
fi
if ! [ -d ~/.m2 ]; then mkdir ~/.m2; fi
cat > ~/.m2/settings.xml <<EOF
<settings>
  <proxies>
    <proxy>
      <id>default</id>
      <active>true</active>
      <protocol>http</protocol>
      <host>$HTTP_PROXY_HOST</host>
      <port>$HTTP_PROXY_PORT</port>
    </proxy>
    <proxy>
      <id>default</id>
      <active>true</active>
      <protocol>https</protocol>
      <host>$HTTPS_PROXY_HOST</host>
      <port>$HTTPS_PROXY_PORT</port>
    </proxy>
  </proxies>
</settings>
EOF

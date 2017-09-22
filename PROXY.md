## Proxy configuration tool.

The entire mirror build process can be performed from behind a non-transparent proxy. 

This mode requires configuring the various build tools that don't observe the system's proxy environment configuration.

#### Configure the proxy.

To configure the various build tools -

```sh
sudo su
export http_proxy=http://<proxy_host>:<proxy_port>
export https_proxy=http://<proxy_host>:<proxy_port>
. set-proxy-env.sh
```

The script tool automatically detects the system proxy settings and generates the configurations needed for the various build tools.

package com.androlua.network;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;
import okhttp3.OkHttpClient;
import okhttp3.dnsoverhttps.DnsOverHttps;
import java.net.InetAddress;
import okhttp3.HttpUrl;

public class DohProviders {
  
  static DnsOverHttps dohCloudflare(OkHttpClient bootstrapClient) {
    return new DnsOverHttps.Builder().client(bootstrapClient)
        .url(HttpUrl.get("https://cloudflare-dns.com/dns-query"))
        .bootstrapDnsHosts(
            getByIp("162.159.36.1"),
            getByIp("162.159.46.1"),
            getByIp("1.1.1.1"),
            getByIp("1.0.0.1"),
            getByIp("162.159.132.53"),
            getByIp("2606:4700:4700::1111"),
            getByIp("2606:4700:4700::1001"),
            getByIp("2606:4700:4700::0064"),
            getByIp("2606:4700:4700::6400"))
        .build();
   }

  static DnsOverHttps dohGoogle(OkHttpClient bootstrapClient) {
    return new DnsOverHttps.Builder().client(bootstrapClient)
        .url(HttpUrl.get("https://dns.google/dns-query"))
        .bootstrapDnsHosts(
          getByIp("8.8.4.4"), 
          getByIp("8.8.8.8"))
        .build();
   }
   
   private static InetAddress getByIp(String host) {
        try {
            return InetAddress.getByName(host);
        } catch (UnknownHostException e) {
            throw new RuntimeException(e);
        }
    }
}
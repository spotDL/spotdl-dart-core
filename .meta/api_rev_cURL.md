# api_rev_cURL

## YTM Search Sugessions API

```bashcurl 'https://music.youtube.com/youtubei/v1/music/get_search_suggestions?prettyPrint=false' \
  -H 'accept: */*' \
  -H 'accept-language: en-GB,en;q=0.9,en-US;q=0.8,en-IN;q=0.7' \
  -H 'authorization: SAPISIDHASH 1740421965_ccb158b839153a3eaa301623bcab148c778d72d4_u SAPISID1PHASH 1740421965_ccb158b839153a3eaa301623bcab148c778d72d4_u SAPISID3PHASH 1740421965_ccb158b839153a3eaa301623bcab148c778d72d4_u' \
  -H 'content-type: application/json' \
  -b 'LOGIN_INFO=AFmmF2swRAIgUwDptv6WrOXvLwKMGRoNrIKiKGQsP5em340O9JSDPgwCIC89TLPC0f3XSvFCeAp7vSt7aiMkG85nD8YPgUWReqgX:QUQ3MjNmd1NwZmJ3Q3JBMVh5dEctbjMtLXhURUpzb294YmNyTEw2Mk1UdDlnZ2I3Sk1HaEJrM1BHRWxPelRXcFhBaWRFamotSHpkU0toYWtGQWo0dFY1b05iSjFBTlA0STIycElYRFRoQjlKQkVvNy0wRWtXSmpsSWp6bWppX09xTThIVFp6ZUFfUXpwZE1XQjhIRFczak1QeklwOWxVOFRn; VISITOR_INFO1_LIVE=flNatNZSjG8; VISITOR_PRIVACY_METADATA=CgJJThIEGgAgTA%3D%3D; VISITOR_INFO1_LIVE=IAfuOzK7iBE; VISITOR_PRIVACY_METADATA=CgJJThIEGgAgXQ%3D%3D; PREF=tz=Asia.Calcutta&f4=4000000&f6=40000000&f5=30000&f7=100&repeat=NONE&autoplay=true; SID=g.a000twi7Yy5OB8IY0WFoOQPcgc7OqxYH2RYiJNMmqdFOgCHlURnc99enF1f8I3YbLN_TXsnl6wACgYKAeMSARMSFQHGX2MiAcZr6JiQSxl6xmW9Do_HdxoVAUF8yKoC6_QN3fsIjCJCkB6-R7VT0076; __Secure-1PSID=g.a000twi7Yy5OB8IY0WFoOQPcgc7OqxYH2RYiJNMmqdFOgCHlURncS250jpovEDO2jlNLIrR82QACgYKATISARMSFQHGX2Mi3MnPT8jdSz2ANu_PTHhPABoVAUF8yKqcYIdWVtuy8keF-z1jgah00076; __Secure-3PSID=g.a000twi7Yy5OB8IY0WFoOQPcgc7OqxYH2RYiJNMmqdFOgCHlURncYih6EJWbNSrYeR0ma4EuygACgYKASgSARMSFQHGX2MiZCC9Y6pRaBXU8HucbTAYEhoVAUF8yKrXkge6NCdHMS14qnivNE9l0076; HSID=Aft_Un-msZlqK9w92; SSID=AxzSj2lrlhqoIeOXx; APISID=nAXmRL5VubSHN4pb/AmCDCdTwAit6-GXwR; SAPISID=TyuX87HlnwN1iKg7/AkfROoJJVzt0XOtOU; __Secure-1PAPISID=TyuX87HlnwN1iKg7/AkfROoJJVzt0XOtOU; __Secure-3PAPISID=TyuX87HlnwN1iKg7/AkfROoJJVzt0XOtOU; __Secure-ROLLOUT_TOKEN=CKj0i-iv5eLvOhD8-rrAvumKAxi0r7StyNuLAw%3D%3D; YSC=nf_ARSbrp1I; CONSISTENCY=AKreu9uuxJSYF2V0cX8zmVBzEQqcxTvAa2jOYBk6hqcNFDk6d3Vj-ksuKxghR80wemGf2utXKF-FozP5WeC-L7tQABizcdLb6w7KZC6sJ1jB8eoHlWCWUinLCcbIc9rDG97u2y_gWCjVupRoDfRAjdEl; __Secure-1PSIDTS=sidts-CjEBEJ3XV3vvc8IAFdXfJ1gPeUpyHWU13xyh4PCWB0WZqYMlrRBSkCMVrMNQwSjwNHBxEAA; __Secure-3PSIDTS=sidts-CjEBEJ3XV3vvc8IAFdXfJ1gPeUpyHWU13xyh4PCWB0WZqYMlrRBSkCMVrMNQwSjwNHBxEAA; SIDCC=AKEyXzVgXXcUcOQn5X6IemW-Xtfb7gLFAIfBrV6DPiTOn3xihkzU6t9o2LduQDJ0KMY2I9nbdg; __Secure-1PSIDCC=AKEyXzVCKWsFe779aJP30kOF34VlRKlJ2bt-HPLmjqqqI72lkqgPtXUqJDesSDR1N5PzbNhXGn8; __Secure-3PSIDCC=AKEyXzWFjK-AtOxpv8CbcmG-xnyH4MWtyqSRubaVnbaKCwQ7GmnQY3br9ISDVYjFkOr9ixaX2Bw' \
  -H 'dnt: 1' \
  -H 'origin: https://music.youtube.com' \
  -H 'priority: u=1, i' \
  -H 'referer: https://music.youtube.com/search?q=tenebre+rosso+sangue' \
  -H 'sec-ch-ua: "Not(A:Brand";v="99", "Chromium";v="133", "Google Chrome";v="133"' \
  -H 'sec-ch-ua-arch: "x86"' \
  -H 'sec-ch-ua-bitness: "64"' \
  -H 'sec-ch-ua-form-factors: "Desktop"' \
  -H 'sec-ch-ua-full-version: "133.0.6943.127"' \
  -H 'sec-ch-ua-full-version-list: "Not(A:Brand";v="99.0.0.0", "Chromium";v="133.0.6943.127", "Google Chrome";v="133.0.6943.127"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-model: ""' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-ch-ua-platform-version: "19.0.0"' \
  -H 'sec-ch-ua-wow64: ?0' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: same-origin' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
  -H 'x-goog-authuser: 0' \
  -H 'x-goog-visitor-id: CgtmbE5hdE5aU2pHOCjM9vK9BjIKCgJJThIEGgAgTA%3D%3D' \
  -H 'x-origin: https://music.youtube.com' \
  -H 'x-youtube-bootstrap-logged-in: true' \
  -H 'x-youtube-client-name: 67' \
  -H 'x-youtube-client-version: 1.20250219.01.00' \
  --data-raw '{"input":"tenebre rosso sangue","context":{"client":{"hl":"en-GB","gl":"IN","remoteHost":"110.224.92.79","deviceMake":"","deviceModel":"","visitorData":"CgtmbE5hdE5aU2pHOCjM9vK9BjIKCgJJThIEGgAgTA%3D%3D","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36,gzip(gfe)","clientName":"WEB_REMIX","clientVersion":"1.20250219.01.00","osName":"Windows","osVersion":"10.0","originalUrl":"https://music.youtube.com/search?q=tenebre+rosso+sangue","screenPixelDensity":2,"platform":"DESKTOP","clientFormFactor":"UNKNOWN_FORM_FACTOR","configInfo":{"appInstallData":"CMz28r0GEOrDrwUQmY2xBRC9tq4FEMnmsAUQyfevBRC9irAFEMS7zhwQh6zOHBDu2c4cEL_ezhwQuNnOHBDM364FENbYzhwQjtexBRDiuLAFELfq_hIQutnOHBDerbEFEKL0_xIQppnOHBD8ss4cEImwzhwQmZixBRC5284cEM7azhwQgc3OHBDT4a8FEJT-sAUQmdL_EhDkyc4cEJ3QsAUQk9nOHBCEvc4cEL2ZsAUQ8ZywBRD4q7EFEJXw_xIQ9quwBRCI468FEL3ezhwQiIewBRDLgLAFEN68zhwQro__EhDr6P4SEJT8rwUQsNzOHCocQ0FNU0R4VU1vTDJ3RE5Ia0J1SGRoUW9kQnc9PQ%3D%3D","coldConfigData":null,"coldHashData":null,"hotHashData":null},"screenDensityFloat":1.5,"userInterfaceTheme":"USER_INTERFACE_THEME_DARK","timeZone":"Asia/Calcutta","browserName":"Chrome","browserVersion":"133.0.0.0","acceptHeader":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7","deviceExperimentId":"ChxOelEzTlRBMU5UUXhOall6TVRVNU1ESXlNUT09EMz28r0GGMz28r0G","rolloutToken":"CKj0i-iv5eLvOhD8-rrAvumKAxi0r7StyNuLAw%3D%3D","screenWidthPoints":1699,"screenHeightPoints":488,"utcOffsetMinutes":330,"musicAppInfo":{"pwaInstallabilityStatus":"PWA_INSTALLABILITY_STATUS_UNKNOWN","webDisplayMode":"WEB_DISPLAY_MODE_BROWSER","storeDigitalGoodsApiSupportStatus":{"playStoreDigitalGoodsApiSupportStatus":"DIGITAL_GOODS_API_SUPPORT_STATUS_UNSUPPORTED"}}},"user":{"lockedSafetyMode":false},"request":{"useSsl":true,"consistencyTokenJars":[{"encryptedTokenJarContents":"AKreu9uuxJSYF2V0cX8zmVBzEQqcxTvAa2jOYBk6hqcNFDk6d3Vj-ksuKxghR80wemGf2utXKF-FozP5WeC-L7tQABizcdLb6w7KZC6sJ1jB8eoHlWCWUinLCcbIc9rDG97u2y_gWCjVupRoDfRAjdEl"}],"internalExperimentFlags":[]},"adSignalsInfo":{"params":[{"key":"dt","value":"1740421965061"},{"key":"flash","value":"0"},{"key":"frm","value":"0"},{"key":"u_tz","value":"330"},{"key":"u_his","value":"5"},{"key":"u_h","value":"1067"},{"key":"u_w","value":"1707"},{"key":"u_ah","value":"1019"},{"key":"u_aw","value":"1707"},{"key":"u_cd","value":"24"},{"key":"bc","value":"31"},{"key":"bih","value":"488"},{"key":"biw","value":"1699"},{"key":"brdim","value":"0,0,0,0,1707,0,1707,1019,1699,488"},{"key":"vis","value":"1"},{"key":"wgl","value":"true"},{"key":"ca_type","value":"image"}]}}}'
  ```

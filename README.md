[![Status](https://travis-ci.org/SKDE-Analyse/dynamiskTabellverk.svg?branch=master)](https://travis-ci.org/SKDE-Analyse/dynamiskTabellverk/builds)[![Coverage Status](https://img.shields.io/codecov/c/github/SKDE-Analyse/dynamiskTabellverk/master.svg)](https://codecov.io/github/SKDE-Analyse/dynamiskTabellverk?branch=master)

This is a R package to produce *dynamisk tabellverk* web pages. 
The web page is hosted on www.shinyapps.io and can be found here: https://skde.shinyapps.io/tabellverk/ 
The data in itself is not included in this package.


## How to install the package

```
devtools::install_github("SKDE-Analyse/dynamiskTabellverk")
```

### If behind Helse-Nord proxy

```
httr::set_config(httr::use_proxy(url="http://www-proxy.helsenord.no", port=8080))
devtools::install_github("SKDE-Analyse/dynamiskTabellverk")
```



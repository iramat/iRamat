  [![R-CMD-check](https://github.com/iramat/iRamat/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/iramat/iRamat/actions/workflows/R-CMD-check.yaml) [![Codecov test coverage](https://codecov.io/gh/iramat/iRamat/graph/badge.svg)](https://app.codecov.io/gh/iramat/iRamat)

# iRamat <img src="doc/img/logo.png" width="100" align="right"/>

This R package provides a simple way to connect to the CHIPS API and retrieve data for further analysis and visualization. Documentation for the CHIPS database and API is available on the [CHIPS website](https://iramat.github.io/chips).

## Install

### Install from GitHub

```R
# install.packages("devtools")
devtools::install_github("iramat/iRamat")
```

Load the `iRamat` package


```R
library(iRamat)
```

## Using the Database API

Connect to the database API using the `db_api_connect()` function. 

### Get a specific dataset

Connect to the database API using the default parameters. The default dataset is `dataset_adisser17`.

```R
df <- db_api_connect()
names(df)
# [1] "dataset_adisser17"
```

The dataset can be accessed by its name. For example, and for the first row of `dataset_adisser17`:

```R
df$dataset_adisser17[1, ]
```

|context_name    | id_chips|sample_name |typology |   na|   mg|   al|    si|    p|    s| cl|    k|   ca|   mn|    fe|   loi| ag|  arsenic|     ba|     be|     bi|    cd|     ce|     co|    cr|    cs|     cu|     dy|     er|    eu| deltafe56| deltafe57|    ga|     gd|   ge|    hf|    ho| indium|    la| li|    lu|    mo|     nb|    nd|     ni| os|os187_os188 | os187_os186|       pb| pd|     pr|     rb| ru|     sb|     sc| se|     sm|    sn|     sr| sr87_sr86|    ta|    tb| te|    th|    ti| tl|    tm|     u|      v|     w|      y|     yb|     zn|     zr|major_method |major_analytical_setup                    |trace_method |trace_analytical_setup                    |reference                                                                                                                                                                                                                                                          |url                                                         |
|:------------|--------:|:-----------|:--------|----:|----:|----:|-----:|----:|----:|--:|----:|----:|----:|-----:|-----:|--:|--------:|------:|------:|------:|-----:|------:|------:|-----:|-----:|------:|------:|------:|-----:|---------:|---------:|-----:|------:|----:|-----:|-----:|------:|-----:|--:|-----:|-----:|------:|-----:|------:|--:|:-----------|-----------:|--------:|--:|------:|------:|--:|------:|------:|--:|------:|-----:|------:|---------:|-----:|-----:|--:|-----:|-----:|--:|-----:|-----:|------:|-----:|------:|------:|------:|------:|:------------|:-----------------------------------------|:------------|:-----------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------|
|Aux Minières |     4967|MINHAO108-A |NA       | 0.04| 0.03| 3.23|  4.45| 0.04| 0.00|  0| 0.07| 0.09| 0.03| 53.17|  7.90| NA|  578.900|  20.31| 13.500|  0.308| 0.325|  56.06| 26.590| 214.9| 0.971|  5.587|  5.025|  2.637| 1.387|        NA|        NA| 7.478|  4.960| 2.61| 1.431| 0.938|  0.475| 21.24| NA| 0.372| 5.362|  2.808| 24.37| 63.140| NA|NA          |          NA| 113.8444| NA|  6.119|  4.692| NA| 127.50|  1.342| NA|  6.095| 0.945|  43.73|        NA| 0.227| 0.843| NA| 17.38| 0.092| NA| 0.397| 9.352|  857.3| 0.563|  22.17|  2.776| 112.60|  58.04|ICP-OES      |CRPG - Thermo Fisher Scientific Icap 6500 |ICP-OES      |CRPG - Thermo Fisher Scientific Icap 6500 |Alexandre Disser, Philippe Dillmann, Marc Leroy, Maxime L'Héritier, Sylvain Bauvais, Philippe Fluzin (2017), Iron Supply for the Building of Metz Cathedral: New Methodological Development for Provenance Studies and Historical Considerations, Archaeometry, 59 |https://onlinelibrary.wiley.com/doi/full/10.1111/arcm.12265 |

Column descriptions are available on [CHIPS website](https://iramat.github.io/chips/docs/documentation/#tables-and-values).

### Get all the datasets

Collect all data from API-available datasets by using the option `all_datasets = TRUE`. By default, all API-available datasets are listed in the CHIPS table hosted on GitHub: [urls_data.tsv](https://github.com/iramat/chips/blob/hugo-files/static/data/urls_data.tsv)

```R
df <- db_api_connect(all_datasets = TRUE)
# all_datasets = TRUE: collecting all datasets from urls_data.tsv
# Requesting: http://157.136.252.188:3000/dataset_tyoungxx
# Requesting: http://157.136.252.188:3000/dataset_adisser17
# Requesting: http://157.136.252.188:3000/dataset_gzabinski23
# Requesting: http://157.136.252.188:3000/dataset_gpages22
# Requesting: http://157.136.252.188:3000/dataset_vserneels93
# Requesting: http://157.136.252.188:3000/dataset_sleroy12
# Requesting: http://157.136.252.188:3000/dataset_pdillmann17
# Requesting: http://157.136.252.188:3000/dataset_amdesaulty8a
# Requesting: http://157.136.252.188:3000/dataset_amdesaulty8b
# Requesting: http://157.136.252.188:3000/dataset_jmilot16
# Requesting: http://157.136.252.188:3000/dataset_mpcoustures06
# Requesting: http://157.136.252.188:3000/dataset_gstdidier17
# Requesting: http://157.136.252.188:3000/dataset_mbrauns13
# Requesting: http://157.136.252.188:3000/dataset_lheritier20
# Requesting: http://157.136.252.188:3000/dataset_mleroy97
# Requesting: http://157.136.252.188:3000/dataset_mleroy24
# Requesting: http://157.136.252.188:3000/dataset_leschenlohr01
# Requesting: http://157.136.252.188:3000/dataset_tivancan21
# Requesting: http://157.136.252.188:3000/dataset_pmameli14
# Requesting: http://157.136.252.188:3000/dataset_kmittelstaedt22
# Requesting: http://157.136.252.188:3000/dataset_mbenvenuti13
# Requesting: http://157.136.252.188:3000/dataset_mberranger26
# Requesting: http://157.136.252.188:3000/dataset_rsaage26
# Collected and merged 23 datasets. Total rows: 3513
```


## Chronology

### Timelines of sites in CHIPS

The `chrono()` function models the chronological attribution of the site by creating a timeline:


```R
df <- db_api_connect()
chrono(d = df$dataset_adisser17)
```

<p align="center">
  <img alt="img-name" src="./doc/chrono_sites_seriated.png" width="700">
</p>

### PeriodO timelines

PeriodO[^1] periods can also be displayed. The default PeriodO authority (i.e. a set of different periods identified by the same author) is `INRAP: Institut National de Recherches Archeologiques Préventive`[^2].

```R
periodo(min_date = -700, max_date = 0, use_periodo = TRUE, time_match = 1)
```

<p align="center">
  <img alt="img-name" src="./doc/periodo_periods_seriated.png" width="700">
</p>

#### PeriodO timelines by location

PeriodO records the spatial extent of periods. In the `periodo()` function, this spatial extent is represented by the variable `location`. Here, the PeriodO authority `ArkeoGIS authors`[^3] is used for periods in France only.

```R
periodo(periodo_authority = "http://n2t.net/ark:/99152/p09hq4n", min_date = -500, max_date = 500, 
        use_periodo = TRUE, time_match = 1, location = "France")
```

<p align="center">
  <img alt="img-name" src="./doc/periodo_periods_seriated_2.png" width="700">
</p>

### Timelines of sites in CHIPS and PeriodO timelines

Site and PeriodO timelines can be merged into a single plot:

```r
df <- db_api_connect()
plots <- chrono(df$dataset_adisser17, use_periodo = TRUE)
ggpubr::ggarrange(plots$sites, plots$periodo$periodo,
                  heights = c(1, 2), ncol = 1, align = "v")
```

<p align="center">
  <img alt="img-name" src="./doc/chrono_sites_and_periodo.png" width="700">
</p>

---

## Talks

- WAIA: **Présentation du package R `iRamat`** - [slides](https://iramat.github.io/iramat-dev/talks/2025-wiai-iRamat/pres) | [video](https://sdrive.cnrs.fr/s/yP5DFgGXtF9ERQH)

[^1]: <https://client.perio.do/>
[^2]: <https://n2t.net/ark:/99152/p02chr4>
[^3]: <http://n2t.net/ark:/99152/p09hq4n>

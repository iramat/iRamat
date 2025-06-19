# iRamat
> R package development

Install from GitHub

```R
devtools::install_github("iramat/iRamat")
```

Load the `iRamat` package


```R
library(iRamat)
```

## Using the Database API

Connect the database API with the default parameters, and show the first rows, using the `db_api_connect()` function

```R
df <- db_api_connect()
head(df$dataset_adisser17)
```

Gives:


|site_name    | id_chips|sample_name |typology |   na|   mg|   al|    si|    p|    s| cl|    k|   ca|   mn|    fe|   loi| ag|  arsenic|     ba|     be|     bi|    cd|     ce|     co|    cr|    cs|     cu|     dy|     er|    eu| deltafe56| deltafe57|    ga|     gd|   ge|    hf|    ho| indium|    la| li|    lu|    mo|     nb|    nd|     ni| os|os187_os188 | os187_os186|       pb| pd|     pr|     rb| ru|     sb|     sc| se|     sm|    sn|     sr| sr87_sr86|    ta|    tb| te|    th|    ti| tl|    tm|     u|      v|     w|      y|     yb|     zn|     zr|major_method |major_analytical_setup                    |trace_method |trace_analytical_setup                    |reference                                                                                                                                                                                                                                                          |url                                                         |
|:------------|--------:|:-----------|:--------|----:|----:|----:|-----:|----:|----:|--:|----:|----:|----:|-----:|-----:|--:|--------:|------:|------:|------:|-----:|------:|------:|-----:|-----:|------:|------:|------:|-----:|---------:|---------:|-----:|------:|----:|-----:|-----:|------:|-----:|--:|-----:|-----:|------:|-----:|------:|--:|:-----------|-----------:|--------:|--:|------:|------:|--:|------:|------:|--:|------:|-----:|------:|---------:|-----:|-----:|--:|-----:|-----:|--:|-----:|-----:|------:|-----:|------:|------:|------:|------:|:------------|:-----------------------------------------|:------------|:-----------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------|
|Aux Minières |     4967|MINHAO108-A |NA       | 0.04| 0.03| 3.23|  4.45| 0.04| 0.00|  0| 0.07| 0.09| 0.03| 53.17|  7.90| NA|  578.900|  20.31| 13.500|  0.308| 0.325|  56.06| 26.590| 214.9| 0.971|  5.587|  5.025|  2.637| 1.387|        NA|        NA| 7.478|  4.960| 2.61| 1.431| 0.938|  0.475| 21.24| NA| 0.372| 5.362|  2.808| 24.37| 63.140| NA|NA          |          NA| 113.8444| NA|  6.119|  4.692| NA| 127.50|  1.342| NA|  6.095| 0.945|  43.73|        NA| 0.227| 0.843| NA| 17.38| 0.092| NA| 0.397| 9.352|  857.3| 0.563|  22.17|  2.776| 112.60|  58.04|ICP-OES      |CRPG - Thermo Fisher Scientific Icap 6500 |ICP-OES      |CRPG - Thermo Fisher Scientific Icap 6500 |Alexandre Disser, Philippe Dillmann, Marc Leroy, Maxime L'Héritier, Sylvain Bauvais, Philippe Fluzin (2017), Iron Supply for the Building of Metz Cathedral: New Methodological Development for Provenance Studies and Historical Considerations, Archaeometry, 59 |https://onlinelibrary.wiley.com/doi/full/10.1111/arcm.12265 |
|Aux Minières |     4968|MINHAO108-B |NA       | 0.03| 0.03| 4.57|  8.40| 0.04| 0.00|  0| 0.02| 0.11| 0.04| 43.30| 10.57| NA| 1010.000|  12.87|  9.351|  0.193| 0.296|  47.05| 27.430| 341.7| 0.221| 63.670|  4.556|  2.518| 1.103|        NA|        NA| 5.733|  4.166| 1.56| 2.771| 0.908|  0.806| 24.99| NA| 0.354| 4.121|  2.977| 18.26| 81.020| NA|NA          |          NA| 117.9742| NA|  5.025|  2.133| NA|  47.82|  1.333| NA|  4.576| 0.911|  86.50|        NA| 0.253| 0.748| NA| 55.21| 0.094| NA| 0.364| 4.369| 3957.0| 0.663|  23.34|  2.575| 113.70| 118.50|ICP-OES      |CRPG - Thermo Fisher Scientific Icap 6500 |ICP-OES      |CRPG - Thermo Fisher Scientific Icap 6500 |Alexandre Disser, Philippe Dillmann, Marc Leroy, Maxime L'Héritier, Sylvain Bauvais, Philippe Fluzin (2017), Iron Supply for the Building of Metz Cathedral: New Methodological Development for Provenance Studies and Historical Considerations, Archaeometry, 59 |https://onlinelibrary.wiley.com/doi/full/10.1111/arcm.12265 |
|Aux Minières |       71|SCHAO 108a  |NA       | 0.52| 0.22| 3.43|  9.54| 0.11| 0.21| NA| 1.03| 0.94| 0.09| 52.61|    NA| NA|    5.200|  93.00|  7.270|  0.010| 0.030| 122.00|  1.300| 110.0| 2.380|  4.100| 18.650| 10.700| 4.500|        NA|        NA| 5.800| 20.800| 0.96| 4.700| 3.740|  0.020| 58.10| NA| 1.490| 2.740|  9.600| 79.40|  1.000| NA|NA          |          NA|   5.7000| NA| 18.250| 20.500| NA|   0.08| 14.900| NA| 20.400| 1.000|  82.60|        NA| 0.670| 3.350| NA| 15.70| 0.097| NA| 1.690| 2.400|  144.0| 3.000| 119.00| 10.100|  23.00| 195.00|ICP-MS       |ALS Chemex - Unknown ME-MS61              |ICP-MS       |ALS Chemex - Unknown ME-MS61              |Alexandre Disser, Philippe Dillmann, Marc Leroy, Maxime L'Héritier, Sylvain Bauvais, Philippe Fluzin (2017), Iron Supply for the Building of Metz Cathedral: New Methodological Development for Provenance Studies and Historical Considerations, Archaeometry, 59 |https://onlinelibrary.wiley.com/doi/full/10.1111/arcm.12265 |
|Aux Minières |       72|SCHAO 108b  |NA       | 0.03| 0.08| 3.07| 10.61| 0.04| 0.01| NA| 0.58| 0.76| 0.12| 53.59|    NA| NA|    2.300| 172.50| 11.650|  0.060| 0.020| 146.00|  0.500| 137.0| 4.230|  3.700| 21.300| 11.950| 5.090|        NA|        NA| 6.000| 23.500| 0.80| 6.600| 4.220|  0.010| 66.50| NA| 1.680| 0.480| 11.800| 93.90|  0.600| NA|NA          |          NA|  30.2000| NA| 21.300| 36.100| NA|   0.05| 19.300| NA| 24.100| 1.000| 147.00|        NA| 0.800| 3.700| NA| 20.00| 0.083| NA| 1.860| 2.800|  522.0| 4.000| 138.50| 11.300|   4.00| 278.00|ICP-MS       |ALS Chemex - Unknown ME-MS61              |ICP-MS       |ALS Chemex - Unknown ME-MS61              |Alexandre Disser, Philippe Dillmann, Marc Leroy, Maxime L'Héritier, Sylvain Bauvais, Philippe Fluzin (2017), Iron Supply for the Building of Metz Cathedral: New Methodological Development for Provenance Studies and Historical Considerations, Archaeometry, 59 |https://onlinelibrary.wiley.com/doi/full/10.1111/arcm.12265 |
|Aux Minières |       73|SCHAO 108c  |NA       | 0.07| 0.10| 3.69| 10.04| 0.03| 0.01| NA| 0.67| 0.97| 0.10| 53.19|    NA| NA|    2.500| 174.00|  7.330|  0.010| 0.020|  95.30|  0.500| 118.0| 2.720|  3.600| 17.400| 10.350| 3.840|        NA|        NA| 6.400| 18.450| 0.76| 4.900| 3.510|  0.010| 46.20| NA| 1.550| 0.790| 12.200| 64.40|  0.500| NA|NA          |          NA|   3.1000| NA| 14.300| 28.900| NA|   0.05| 15.300| NA| 16.900| 1.000|  60.60|        NA| 0.750| 3.030| NA| 12.30| 0.046| NA| 1.630| 2.200|  397.0| 6.000| 105.00| 10.050|  15.00| 216.00|ICP-MS       |ALS Chemex - Unknown ME-MS61              |ICP-MS       |ALS Chemex - Unknown ME-MS61              |Alexandre Disser, Philippe Dillmann, Marc Leroy, Maxime L'Héritier, Sylvain Bauvais, Philippe Fluzin (2017), Iron Supply for the Building of Metz Cathedral: New Methodological Development for Provenance Studies and Historical Considerations, Archaeometry, 59 |https://onlinelibrary.wiley.com/doi/full/10.1111/arcm.12265 |
|Aux Minières |     4973|SLHAO108-A  |NA       | 0.12| 0.24| 3.44| 16.17| 0.13| 0.00|  0| 0.76| 0.92| 0.11| 42.26| -5.23| NA|    7.245| 110.50| 10.520| -0.001| 0.131|  89.76|  1.378| 155.4| 2.225|  5.491| 14.130|  8.028| 3.319|        NA|        NA| 7.276| 13.860| 0.59| 5.377| 2.821|  0.197| 39.26| NA| 1.177| 0.971|  8.751| 51.53| -0.001| NA|NA          |          NA|   3.0746| NA| 12.090| 29.830| NA|  20.83| -0.001| NA| 13.520| 0.627|  69.98|        NA| 0.647| 2.342| NA| 14.67| 0.251| NA| 1.236| 2.607|  599.8| 4.843|  83.14|  8.150|  31.42| 232.10|ICP-OES      |CRPG - Thermo Fisher Scientific Icap 6500 |ICP-OES      |CRPG - Thermo Fisher Scientific Icap 6500 |Alexandre Disser, Philippe Dillmann, Marc Leroy, Maxime L'Héritier, Sylvain Bauvais, Philippe Fluzin (2017), Iron Supply for the Building of Metz Cathedral: New Methodological Development for Provenance Studies and Historical Considerations, Archaeometry, 59 |https://onlinelibrary.wiley.com/doi/full/10.1111/arcm.12265 |


## Point Pattern and spatial analysis

### Point Pattern Analysis

The `ppa()` function performs different point pattern analysis (ppa) on raster. It could be used to assess if a point distribution is regular, clustered or random.

| regular | clustered | random |
|----------|----------|----------|
| ![](https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/regular_distribution.png) | ![](https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/clustered_distribution.png) | ![](https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/random_distribution.png) |

Run the function with its default parameters:

```R
d <- ppa()
```

`d` is an hash object (a Python dictionary-like) that stores different test outputs: Quadrat test, K-Ripley test, G-function test. Let's call some of these results:

#### Quadrat test

Check the Quadrat test of the clustered distribution

```R
d$clustered_distribution.png$quadrat
```

Gives:

```
	Chi-squared test of CSR using quadrat counts

data:  pp
X2 = 732.01, df = 24, p-value < 2.2e-16
alternative hypothesis: two.sided

Quadrats: 5 by 5 grid of tiles
```

#### K-Ripley test

```R
plot(d$clustered_distribution.png$ripley, main = "clustered distribution")
```

Gives:

<p align="center">
  <img alt="img-name" src="./doc/ppa_kripley.png" width="400">
</p>

#### G-function test

```R
plot(d$regular_distribution.png$gfunction, main = "regular distribution")
```

Gives:

<p align="center">
  <img alt="img-name" src="./doc/ppa_gfunction.png" width="400">
</p>



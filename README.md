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

## Point Pattern and spatial analysis

### Point Pattern Analysis

The `ppa()` function performs different point pattern analysis (ppa) on raster. It could be used to assess if a point distribution is regular, clustered or random.

| regular | clustered | random |
|----------|----------|----------|
| [](https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/regular_distribution.png) | [](https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/clustered_distribution.png) | [](https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/random_distribution.png) |

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

#### G-function test

```R
plot(d$regular_distribution.png$gfunction, main = "regular distribution")
```

Gives:




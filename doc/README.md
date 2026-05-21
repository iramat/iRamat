## Point Pattern and spatial analysis

### Point Pattern Analysis

The `ppa()` function performs different point pattern analysis (PPA) on raster grids or spatial data. It could be used to assess if a point distribution is regular, clustered or random.

<div align="center">

<table>
  <tr>
    <th>regular</th>
    <th>clustered</th>
    <th>random</th>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/regular_distribution.png" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/clustered_distribution.png" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/iramat/iRamat/master/inst/extdata/random_distribution.png" width="250"/></td>
  </tr>
</table>

</div>


Run the function with its default parameters:

```R
d <- ppa()
```

`d` is a hash-like object (similar to a Python dictionary) that stores different test outputs: Quadrat test, K-Ripley test, G-function test. Let's call some of these results:

#### Quadrat test

Check the Quadrat test of the clustered distribution

```R
d[["clustered_distribution.png"]]$quadrat
```

```
	Chi-squared test of CSR using quadrat counts

data:  pp
X2 = 732.01, df = 24, p-value < 2.2e-16
alternative hypothesis: two.sided

Quadrats: 5 by 5 grid of tiles
```

#### K-Ripley test

```R
plot(d[["clustered_distribution.png"]]$ripley, main = "clustered distribution")
```

<p align="center">
  <img alt="img-name" src="./doc/ppa_kripley.png" width="500">
</p>

#### G-function test

```R
plot(d[['regular_distribution.png']]$gfunction, main = "regular distribution")
```

<p align="center">
  <img alt="img-name" src="./doc/ppa_gfunction.png" width="500">
</p>

---

## Talks

- WAIA: **Présentation du package R `iRamat`** - [support](https://iramat.github.io/iramat-dev/talks/2025-wiai-iRamat/pres) | [video](https://sdrive.cnrs.fr/s/yP5DFgGXtF9ERQH)

pkgname <- "iRamat"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('iRamat')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("chrono")
### * chrono

flush(stderr()); flush(stdout())

### Name: chrono
### Title: Create a timeline of a selected dataset
### Aliases: chrono

### ** Examples

## Not run: 
##D df <- db_api_connect()
##D plots <- chrono(df$dataset_adisser17, use_periodo = TRUE)
##D ggpubr::ggarrange(plots$sites, plots$periodo, heights = c(1,2), ncol = 1, align = "v")
## End(Not run)




cleanEx()
nameEx("db_api_connect")
### * db_api_connect

flush(stderr()); flush(stdout())

### Name: db_api_connect
### Title: Connect the CHIPS DB API and return an R object (dataframe, etc)
### Aliases: db_api_connect

### ** Examples

# Default behaviour: one dataset stored in a hash
df_hash <- db_api_connect()
head(df_hash$dataset_adisser17)

# All CHIPS datasets listed in urls_data.tsv, merged into a single dataframe
df_all <- db_api_connect(all_datasets = TRUE)
head(df_all)




cleanEx()
nameEx("periodo")
### * periodo

flush(stderr()); flush(stdout())

### Name: periodo
### Title: Create a timeline of periods from a PeriodO authority
### Aliases: periodo

### ** Examples

## Not run: 
##D # Default authority (INRAP)
##D periodo()
##D 
##D # Restrict to a specific interval and require exact overlap
##D periodo(min_date = -700, max_date = 0, use_periodo = TRUE, time_match = 1)
##D 
##D # Authority ArkeOpen, France only
##D periodo(periodo_authority = "http://n2t.net/ark:/99152/p09hq4n", min_date = -500, max_date = 500, use_periodo = TRUE, time_match = 1, location = "France")
## End(Not run)




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')

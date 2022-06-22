## Install R version from rocker 
## Need to check if this uses specific underling versions of all the extra linux libraries below...

FROM rocker/r-ver:4.1.2

## Set up working directory
WORKDIR /usr/src/inlabru

COPY . .

RUN apt-get update

## Install linux libraries - need these to be versioned!
RUN apt-get install -y libgdal-dev libproj-dev libgeos-dev libudunits2-dev libnode-dev libcairo2-dev libnetcdf-dev

## Pending:  Setting Up Ncpus in .Rprofile to match the machine cores
## TODO: renv lock file would be  better here and record all package versions - still in progress!
RUN Rscript -e "pp <- setdiff(c('sp','sf', 'gnorm', 'mnormt', 'rgeos', 'raster', 'MASS', 'mvtnorm', 'matrixStats', 'metR', 'data.table', 'dplyr', 'foreach', 'Matrix', 'rgdal', 'remotes', 'future.apply', 'devtools', 'cowplot'), rownames(installed.packages())); if(length(pp) == 0){print('All packages installed')}else{install.packages(pp, Ncpus=16)}"

EXPOSE 5000

## Run the Italy_forecasts.R script
CMD ["Rscript", "run_forecast.R"]

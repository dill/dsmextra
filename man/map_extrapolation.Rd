% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/map_extrapolation.R
\name{map_extrapolation}
\alias{map_extrapolation}
\title{Interactive maps of extrapolation}
\usage{
map_extrapolation(
  map.type = NULL,
  base.layer = "ocean",
  extrapolation.values = NULL,
  gower.values = NULL,
  covariate.names = NULL,
  prediction.grid = NULL,
  coordinate.system = NULL,
  sightings = NULL,
  tracks = NULL
)
}
\arguments{
\item{map.type}{Character string. Type of map to be returned. Either \code{extrapolation} for an extrapolation map, \code{mic} for a map of the most influential covariates, or \code{nearby} for a map of the percentage of data nearby.}

\item{base.layer}{Base layer used for mapping. The default is \code{ocean}, which uses the ESRI.OceanBasemap. Use \code{world} for ESRI.WorldImagery and \code{gray} for ESRI.WorldGrayCanvas. Available map tiles can be viewed at \href{https://leaflet-extras.github.io/leaflet-providers/preview/}{https://leaflet-extras.github.io/leaflet-providers/preview/}.}

\item{extrapolation.values}{List object as returned by \link{compute_extrapolation}. Only valid when \code{map.type = extrapolation} or \code{map.type = mic}.}

\item{gower.values}{Raster layer object as returned by \link{compute_nearby}. Only valid when \code{map.type = nearby}.}

\item{covariate.names}{Character string. Names of the covariates of interest.}

\item{prediction.grid}{Prediction data.frame. This contains both geographic coordinates (\code{x}, \code{y}) and covariate values associated with the target locations for which predictions are desired. Typically, these locations are taken as the centroids of the grid cells in a spatial prediction grid/raster. See \code{\link[dsm]{predict.dsm}}.}

\item{coordinate.system}{Projected coordinate system relevant to the study location. Can be either a character string or an object of class \code{\link[sp]{CRS}}.}

\item{sightings}{Species observations (optional). Can be supplied as a \code{matrix} of coordinates, a \code{data.frame}, a \code{\link[sp]{SpatialPoints}} object or a \code{\link[sp]{SpatialPointsDataFrame}} object. Circle markers will be proportional to group size if the data contain a column labelled \code{size}.}

\item{tracks}{Survey tracks (optional). Can be supplied as a \code{matrix} of coordinates, a \code{data.frame}, a \code{\link[sp]{SpatialLines}} object or a \code{\link[sp]{SpatialLinesDataFrame}} object. A \code{TransectID} field is required for matrix or data.frame inputs.}
}
\value{
An interactive html map.
}
\description{
Produces interactive html maps of extrapolation values in the prediction area. The function relies on the \code{\link[leaflet]{leaflet}} package (Cheng et al. 2018), and thus requires an internet connection (i.e. will not work offline).
}
\examples{
library(dsmextra)

# Load the Mid-Atlantic sperm whale data (see ?spermwhales)
data(spermwhales)

# Extract the data
segs <- spermwhales$segs
predgrid <- spermwhales$predgrid

# Define relevant coordinate system
my_crs <- sp::CRS("+proj=aea +lat_1=38 +lat_2=30 +lat_0=34 +lon_0=-73 +x_0=0
 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

 # Define covariates of interest
 my_cov <- c("Depth", "DistToCAS", "SST", "EKE", "NPP")

# Assess extrapolation in the multivariate space defined by five covariates
spermw.extrapolation <- compute_extrapolation(segments = segs,
      covariate.names = c("Depth", "DistToCAS", "SST", "EKE", "NPP"),
      prediction.grid = predgrid,
      coordinate.system = my_crs,
      print.summary = TRUE,
      save.summary = TRUE,
      print.precision = 2)

# Assess the percentage of data nearby
spermw.nearby <- compute_nearby(segments = segs,
                               prediction.grid = predgrid,
                               coordinate.system = my_crs,
                               covariate.names = my_cov,
                               nearby = 1)

# Generate maps
map_extrapolation(map.type = "extrapolation",
                  extrapolation.values = spermw.extrapolation,
                covariate.names = my_cov,
                prediction.grid = predgrid,
                coordinate.system = my_crs)

map_extrapolation(map.type = "mic",
                extrapolation.values = spermw.extrapolation,
                covariate.names = my_cov,
                prediction.grid = predgrid,
                coordinate.system = my_crs)

map_extrapolation(map.type = "nearby",
                gower.values = spermw.nearby,
                covariate.names = my_cov,
                prediction.grid = predgrid,
                coordinate.system = my_crs)
}
\references{
Bouchet PJ, Miller DL, Roberts JJ, Mannocci L, Harris CM and Thomas L (2019). From here and now to there and then: Practical recommendations for extrapolating cetacean density surface models to novel conditions. CREEM Technical Report 2019-01, 59 p. \href{https://research-repository.st-andrews.ac.uk/handle/10023/18509}{https://research-repository.st-andrews.ac.uk/handle/10023/18509}

Cheng J, Karambelkar B, Xie Y (2018). leaflet: Create Interactive Web Maps with the JavaScript 'Leaflet' Library. R package version 2.0.2. \href{https://CRAN.R-project.org/package=leaflet}{https://CRAN.R-project.org/package=leaflet}
}
\author{
Phil J. Bouchet
}

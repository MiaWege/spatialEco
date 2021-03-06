#' @title Download Hansen Forest 2000-2013 Change
#' @description Download of Hansen Global Forest Change 2000-2013
#'
#' @param tile  Granule index (See project URL for granule grid index)
#' @param data.type  Type of data to download options: 'treecover2000', 'loss',  
#'                   'gain', 'lossyear', datamask', 'first', 'last'
#' @param download.folder  Destination folder
#'
#' @return Downloaded Hansen forest loss tif files 
#'    
#' @details Available products: 
#' treecover2000, loss, gain, lossyear, datamask, first, or last
#' * treecover2000 - (Tree canopy cover for year 2000) - Tree cover in the year 
#'   2000, defined as canopy closure for all vegetation taller than 5m in height. 
#'   Encoded as a percentage per output grid cell, in the range 0-100.
#' * loss - (Global forest cover loss 2000-2013) - Forest loss during the period 
#'   2000-2013,  defined as a stand-replacement disturbance, or a change from a  
#'   forest to non-forest state. Encoded as either 1 (loss) or 0 (no loss).
#' * gain - (Global forest cover gain 2000-2012) - Forest gain during the period 
#'   2000-2012, defined as the inverse of loss, or a non-forest to forest change 
#'   entirely within the study period. Encoded as either 1 (gain) or 0 (no gain).
#' * lossyear - (Year of gross forest cover loss event) - A disaggregation of total 
#'   forest loss to annual time scales. Encoded as either 0 (no loss) or else a value 
#'   in the range 1-13, representing loss detected primarily in the year 2001-2013.
#' * datamask - (Data mask) - Three values representing areas of no data (0), mapped 
#'   land surface (1), and permanent water bodies (2). 
#' * first - (Circa year 2000 Landsat 7 cloud-free image composite) - Reference 
#'   multispectral imagery from the first available year, typically 2000. If no 
#'   cloud-free observations were available for year 2000, imagery was taken from 
#'   the closest year with cloud-free data, within the range 1999-2012. 
#' * last - (Circa year 2013 Landsat cloud-free image composite) - Reference 
#'   multispectral imagery from the last available year, typically 2013. If no 
#'   cloud-free observations were available for year 2013, imagery was taken 
#'   from the closest year with cloud-free data, within the range 2010-2012.
#'@md
#' @details
#' Project website with 10x10 degree granule index: 
#' \url{ http://earthenginepartners.appspot.com/science-2013-global-forest/download_v1.1.html }
#'
#' @author Jeffrey S. Evans  <jeffrey_evans@@tnc.org>
#'                                                                           
#' @references 
#' Hansen, M. C., P. V. Potapov, R. Moore, M. Hancher, S. A. Turubanova, A. Tyukavina, 
#'   D. Thau, S. V. Stehman, S. J. Goetz, T. R. Loveland, A. Kommareddy, A. Egorov, 
#'   L. Chini, C. O. Justice, and J. R. G. Townshend. (2013) High-Resolution Global Maps 
#'   of 21st-Century Forest Cover Change. Science 342:850-53. 
#'
#' @examples 
#' \dontrun{
#' # Download single tile
#'  download.hansen(tile=c('00N', '130E'), data.type=c('loss', 'lossyear'), 
#'                  download.folder=getwd())
#' 
#' # Batch download of multiple tiles
#' tiles <- list(c('00N', '140E'), c('00N', '130E'))
#'   for( j in 1:length(tiles)){
#'     download.hansen(tile=tiles[[j]], data.type=c('loss'))  
#'   }
#'
#' }
#'
#' @export
download.hansen <- function(tile, data.type = c("loss"), 
                     download.folder = c("current", "temp")) {
    owd <- getwd()
      on.exit(setwd(owd))								
	if(download.folder[1] == "current") {
	  download.folder = getwd()
    } else if(download.folder == "temp") {
	  download.folder = tempdir()
    } 
	if(!dir.exists(download.folder))
      stop("directory does not exists")
    hurl <- "http://commondatastorage.googleapis.com/earthenginepartners-hansen/GFC2014/Hansen_GFC2014"
    if (missing(tile)) 
        stop("Must define granule")
    for (i in 1:length(data.type)) {
        d <- paste(paste(hurl, paste(data.type[i], tile[1], tile[2], sep = "_"), sep = "_"), "tif", sep = ".")
        out <- paste(paste(download.folder, paste(data.type[i], tile[1], tile[2], sep = "_"), sep = "/"), "tif", 
            sep = ".")
        try(utils::download.file(d, out, mode = "w"))
    }
} 

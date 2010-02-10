#' Compute distance matrix from bases.
#' 
#' @param history history of the plots
#' @examples
#' \dontrun{
#'  grand <- interpolate(save_history(flea[, 1:6], max = 50), 0.2)
#'  # The grand tour  -----------------------------
#'  # Look at the tour path in a tour, how well does it cover a sphere
#'  # Using MDS
#'  d <- path_dist(grand)
#'  ord <- as.data.frame(MASS::isoMDS(d)$points)
#'  qplot(V1, V2, data = ord, geom="path") + 
#'  coord_equal() + labs(x = NULL, y = NULL)
#' 
#'  
#'  library(rggobi)
#'  # Using a tour in ggobi
#'  x<-t(rbind(grand[,1,])); colnames(x)<-c("a11","a21","a31","a41","a51","a61")
#'  y<-t(rbind(grand[,2,])); colnames(x)<-c("a12","a22","a32","a42","a52","a62")
#'  z<-cbind(x,y)
#'  ggobi(z) 
#' }
#'
#' # 5 guided tours  -----------------------------
#' holes1d <- guided_tour(holes, 1)
#' tries <- replicate(5, save_history(flea[, 1:6], holes1d, max = 10), 
#'   simplify = FALSE)
#' tries2 <- lapply(tries, interpolate, 0.2)
#' 
#' bases <- unlist(lapply(tries2, as.list), recursive = FALSE)
#' class(bases) <- "history_list"
#' index_values <- paths_index(tries2, holes)
#' d <- path_dist(bases)
#' ord <- as.data.frame(cmdscale(d, 2))
#' 
#' info <- cbind(ord, index_values)
#' qplot(step, value, data = info, geom="line", group = try)
#' qplot(V1, V2, data = info, geom="path", group = try) + 
#'   geom_point(aes(size = value)) + 
#'   coord_equal()
#' last_plot() + facet_wrap(~ try)
path_dist <- function(history) {
  history <- as.array(history)
  n <- dim(history)[3]
  d <- matrix(NA, nrow = n, ncol = n)

  for(i in seq_len(n)) {
    for (j in seq_len(i - 1)) {
      d[i, j] <- proj_dist(history[[i]], history[[j]])
    }
  }
  as.dist(d)
}



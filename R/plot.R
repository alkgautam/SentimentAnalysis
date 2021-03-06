#' Line plot with sentiment scores
#' 
#' Simple line plot to visualize the evolvement of sentiment scores.
#' This is especially helpful when studying a time series of
#' sentiment scores.
#' @param sentiment \code{data.frame} or numeric vector with sentiment scores
#' @param x Optional parameter with labels or time stamps on x-axis.
#' @param cumsum Parameter deciding whether the cumulative sentiment
#' is plotted (default: \code{cumsum=FALSE}).
#' @param xlab Name of x-axis (default: empty string).
#' @param ylab Name of y-axis (default: "Sentiment").
#' @return Returns a plot of class \code{\link[ggplot2]{ggplot}}
#' @examples 
#' sentiment <- data.frame(Dictionary=runif(20))
#' 
#' plotSentiment(sentiment)
#' plotSentiment(sentiment, cumsum=TRUE)
#' 
#' # Change name of x-axis
#' plotSentiment(sentiment, xlab="Tone")
#' 
#' library(ggplot2)
#' # Extend plot with additional layout options
#' plotSentiment(sentiment) + ggtitle("Evolving sentiment")
#' plotSentiment(sentiment) + theme_void() 
#' @keywords evaluation plots
#' @seealso \code{\link{plotSentimentResponse}} and \code{\link{plot.SentimentDictionaryWeighted}} for further plotting options
#' @export
plotSentiment <- function(sentiment, 
                          x=NULL, 
                          cumsum=FALSE,
                          xlab="", ylab="Sentiment") {
  if (is.data.frame(sentiment)) {
    sentiment <- sentiment[[1]]
  }
  
  if (is.null(x)) {
    x <- 1:length(sentiment)
  }
  
  if (cumsum) {
    sentiment <- cumsum(sentiment)
  }
  
  y <- NULL # to avoid binging warning
  p <- ggplot2::ggplot(data.frame(x=x, y=sentiment), 
                       ggplot2::aes(x=x, y=y)) +
    ggplot2::geom_line() + 
    ggplot2::theme_bw() +
    ggplot2::xlab(xlab) + 
    ggplot2::ylab(ylab)
    
  return(p)
}

#' Scatterplot with trend line between sentiment and response
#' 
#' Generates a scatterplot where points pairs of sentiment and
#' the response variable. In addition, the plot addas a trend line
#' in the form of a generalized additive model (GAM). Other
#' smoothing variables are possible based on \code{\link[ggplot2]{geom_smooth}}.
#' This functions is helpful for visualization the relationship
#' between computed sentiment scores and the gold standard. 
#' @param sentiment \code{data.frame} with sentiment scores
#' @param response Vector with response variables of the same length
#' @param smoothing Smoothing functionality. Default is \code{smoothing="gam"}
#' to utilize a generalized additive model (GAM). Other options can be e.g.
#' a linear trend line (\code{smoothing="lm"}); see \code{\link[ggplot2]{geom_smooth}}
#' for a full list of options.
#' @param xlab Description on x-axis (default: "Sentiment").
#' @param ylab Description on y-axis (default: "Sentiment").
#' @return Returns a plot of class \code{\link[ggplot2]{ggplot}}
#' @examples
#' sentiment <- data.frame(Dictionary=runif(10))
#' response <- sentiment[[1]] + rnorm(10)
#' 
#' plotSentimentResponse(sentiment, response)
#' 
#' # Change x-axis
#' plotSentimentResponse(sentiment, response, xlab="Tone")
#' 
#' library(ggplot2)
#' # Extend plot with additional layout options
#' plotSentimentResponse(sentiment, response) + ggtitle("Scatterplot")
#' plotSentimentResponse(sentiment, response) + theme_void() 
#' @keywords evaluation plots
#' @seealso \code{\link{plotSentiment}} and \code{\link{plot.SentimentDictionaryWeighted}} for further plotting options
#' @export
plotSentimentResponse <- function(sentiment, response,
                                  smoothing="gam",
                                  xlab="Sentiment", ylab="Response") {
  x <- NULL # surpress note "no visible binding"
  y <- NULL # surpress note "no visible binding"
  p <- ggplot2::ggplot(data.frame(x=unname(sentiment), y=response), 
                       ggplot2::aes(x=x, y=y)) +
    ggplot2::geom_point() +
#    scale_x_continuous(labels=fancy_scientific) +
    ggplot2::geom_smooth(method=smoothing) + # uses generalized additive model (GAM)
    ggplot2::theme_bw() + 
    ggplot2::xlab(xlab) +
    ggplot2::ylab(ylab)
  
  return(p)
}

#' KDE plot of estimated coefficients
#' 
#' Function performs a Kernel Density Estimation (KDE) of the coefficients and then
#' plot these using \code{\link[ggplot2]{ggplot}}. This type of plot allows to 
#' inspect whether the distribution of coefficients is skew. This can reveal if there
#' are more positive terms than negative or vice versa. 
#' @param x Dictionary of class \code{\link{SentimentDictionaryWeighted}}
#' @param color Color for filling the density plot (default: gray color)
#' @param theme Visualization theme for \code{\link[ggplot2]{ggplot}} (default: is a black-white theme)
#' @param ... Additional parameters passed to function.
#' @return Returns a plot of class \code{\link[ggplot2]{ggplot}}
#' @examples 
#' d <- SentimentDictionaryWeighted(paste0(character(100), 1:100), rnorm(100), numeric(100))
#' plot(d)
#' 
#' # Change color in plot
#' plot(d, color="red")
#' 
#' library(ggplot2)
#' # Extend plot with additional layout options
#' plot(d) + ggtitle("KDE plot")
#' plot(d) + theme_void() 
#' @keywords evaluation plots
#' @seealso \code{\link{plotSentiment}} and \code{\link{plotSentimentResponse}} for further plotting options
#' @export
plot.SentimentDictionaryWeighted <- function(x, color="gray60", theme=ggplot2::theme_bw(), ...) {
  scores <- NULL # surpress note "no visible binding"
  p <- ggplot2::ggplot(data.frame(scores=x$scores), ggplot2::aes(x=scores)) + 
    ggplot2::geom_density(alpha=0.4, fill=color, color=color) +
    ggplot2::xlab("Estimated coefficients") +
    ggplot2::ylab("Density") +
    theme
  
  return(p)
}

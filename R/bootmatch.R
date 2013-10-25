#' Bootstrap treatment units for propensity score analysis
#' 
#' 
#' @param Tr numeric (0 or 1) or logical vector of treatment indicators. 
#' @param Y vector of outcome varaible.
#' @param X matrix or data frame of covariates used to estimate the propensity scores.
#' @param M number of bootstrap samples to generate.
#' @param ratio the ratio of control units to sample relative to the treatment units.
#' @param sample.size the size of each bootstrap sample of control units.
#' @param nstrata number of strata to use.
#' @param ... other parameters passed to \code{\link{Match}} and \code{\link{psa.strata}}
bootmatch <- function(Tr, Y, X, M=100, ratio=3, nstrata=5, 
					  sample.size=(ratio*min(table(Tr))),
					  ...) {
	if('factor' %in% class(Tr)) {
		groups <- levels(Tr)	
	} else {
		groups <- 0:1
	}
	index.control <- which(Tr == groups[1])
	index.treated <- which(Tr == groups[2])
	if(sample.size > length(index.control)) { 
		stop('Sample size cannot be larger than the number of control units. 
			 Try a smaller ratio.')
	}
	tmp <- mclapply(seq_len(M), FUN=function(i) {
		index.sample <- sample(index.control, size=sample.size, replace=FALSE)
		rows <- c(index.treated, index.sample)
		ps <- fitted(glm(treat ~ ., data=cbind(treat=Tr[rows], X[rows,]), family='binomial'))
		strata <- cut(ps, quantile(ps, seq(0, 1, 1/nstrata)), include.lowest=TRUE, 
					  labels=letters[1:nstrata])
		strata.results <- psa.strata(Y=Y[rows], Tr=Tr[rows], strata=strata, ...)
		mr <- Match(Y=Y[rows],
					Tr=Tr[rows],
					X=ps,
					M=1, 
					...)
		ttest <- t.test(Y[mr$index.treated], Y[mr$index.control], paired=TRUE)
		sum <- c(t=unname(ttest$statistic),
				 p=ttest$p.value,
				 ci.min=ttest$conf.int[1],
				 ci.max=ttest$conf.int[2],
				 estimate=unname(ttest$estimate),
				 strata.ATE=strata.results$ATE,
				 strata.se.wtd=strata.results$se.wtd,
				 strata.ci.min=strata.results$CI.95[1],
				 strata.ci.max=strata.results$CI.95[2],
				 strata.approx.t=strata.results$approx.t)
		return(list(summary=sum, t.test=ttest, match=mr, strata=strata.results))
	})
	summary <- as.data.frame(t(sapply(tmp, FUN=function(x) { x$summary })))
	r <- list(summary=summary,
			  details=tmp)
	class(r) <- "bootmatch"
	return(r)
}

#' Summary of pooled results from bootmatch
#' 
#' @param object result of \code{\link{bootmatch}}.
#' @param ... currently unused.
#' @param digits desired number of digits after the decimal point.
#' @return a list with pooled summary statistics.
#' @S3method summary bootmatch
#' @method summary bootmatch
#' @export
summary.bootmatch <- function(object, digits=3, ...) {
	sig.pos <- object$summary$ci.min > 0
	sig.neg <- object$summary$ci.max < 0
	sig.pos.per <- prop.table(table(factor(sig.pos, levels=c('TRUE','FALSE')))) * 100
	sig.neg.per <- prop.table(table(factor(sig.neg, levels=c('TRUE','FALSE')))) * 100
	sig.tot.per <- prop.table(table(factor(sig.pos | sig.neg,
												  levels=c('TRUE','FALSE')))) * 100
	
	m <- mean(object$summary$estimate, na.rm=TRUE)
	ci.min <- m - 2 * sd(object$summary$estimate, na.rm=TRUE)
	ci.max <- m + 2 * sd(object$summary$estimate, na.rm=TRUE)
	
	cat('Matching Results:\n')
	cat(paste0('Pooled mean difference = ', prettyNum(m, digits=digits), 
			   '\nPooled CI = [', prettyNum(ci.min, digits=digits), ', ', 
			   prettyNum(ci.max, digits=digits), ']\n'))
	
	cat(paste0(
		prettyNum(unname(sig.tot.per['TRUE']), 
				  digits=digits),
		   '% of bootstrap samples have confidence intervals that do not span zero.\n',
		   '   ', prettyNum(unname(sig.pos.per['TRUE']), digits=digits), '% positive.\n',
		   '   ', prettyNum(unname(sig.neg.per['TRUE']), digits=digits), '% negative.'))
	
	cat('\n\nStratification Results:\n')
	strata.sig.pos <- object$summary$strata.ci.min > 0
	strata.sig.neg <- object$summary$strata.ci.max < 0
	strata.sig.pos.per <- prop.table(table(factor(strata.sig.pos, 
												  levels=c('TRUE','FALSE')))) * 100
	strata.sig.neg.per <- prop.table(table(factor(strata.sig.neg, 
												  levels=c('TRUE','FALSE')))) * 100
	strata.sig.tot.per <- prop.table(table(factor(strata.sig.pos | strata.sig.neg,
												  levels=c('TRUE','FALSE')))) * 100
	strata.m <- mean(object$summary$strata.ATE, na.rm=TRUE)
	strata.ci.min <- strata.m - 2 * sd(object$summary$strata.ATE, na.rm=TRUE)
	strata.ci.max <- strata.m + 2 * sd(object$summary$strata.ATE, na.rm=TRUE)
	
	cat(paste0('Pooled mean difference = ', prettyNum(strata.m, digits=digits), 
			   '\nPooled CI = [', prettyNum(strata.ci.min, digits=digits), ', ', 
			   prettyNum(strata.ci.max, digits=digits), ']\n'))
	
	cat(paste0(
		prettyNum(unname(strata.sig.tot.per['TRUE']), digits=digits),
		'% of bootstrap samples have confidence intervals that do not span zero.\n',
		'   ', prettyNum(unname(strata.sig.pos.per['TRUE']), digits=digits), '% positive.\n',
		'   ', prettyNum(unname(strata.sig.neg.per['TRUE']), digits=digits), '% negative.'))
	
	
	invisible(list(
		match.pooled.mean=m,
		match.pooled.ci=c(ci.min, ci.max),
		match.percent.sig=table(sig.pos | sig.neg),
		strata.pooled.mean=strata.m,
		strata.pooled.ci=c(strata.ci.min, strata.ci.max),
		strata.percent.sig=table(strata.sig.pos | strata.sig.neg)
	))
}

#' Print results of bootmatch
#' 
#' @param x result of \code{\link{bootmatch}}.
#' @param ... currently unused.
#' @S3method print bootmatch
#' @method print bootmatch
#' @export
print.bootmatch <- function(x, ...) {
	summary(x, ...)
}

#' Plot the results of bootmatch
#' 
#' @param x result of \code{\link{bootmatch}}.
#' @param plot.matching plot the results of matched results.
#' @param plot.stratification plot the results of stratification.
#' @param sort how the sort the rows by mean difference. Options are to sort
#'        using the mean difference from matching, stratificaiton, both 
#'        individually, or no sorting.
#' @param ... currently unused.
#' @S3method plot bootmatch
#' @method plot bootmatch
#' @export
plot.bootmatch <- function(x, 
						   plot.matching=TRUE,
						   plot.stratification=TRUE,
						   sort=c('both','match','strata','none'),
						   ...) {
	if(sort[1] %in% c('both','match')) {
		results.match <- x$summary[order(x$summary$estimate),
								   c('estimate','ci.min','ci.max')]		
	} else if(sort[1] == 'strata') {
		results.match <- x$summary[order(x$summary$strata.ATE),
								   c('estimate','ci.min','ci.max')]
	} else {
		results.match <- x$summary[,c('estimate','ci.min','ci.max')]
	}
	results.match$y <- 1:nrow(results.match)
	results.match$Method <- 'Matching'
	
	
	if(sort[1] %in% c('both','strata')) {
		results.strata <- x$summary[order(x$summary$strata.ATE),
								   c('strata.ATE','strata.ci.min','strata.ci.max')]		
	} else if(sort[1] == 'strata') {
		results.strata <- x$summary[order(x$summary$estimate),
								   c('strata.ATE','strata.ci.min','strata.ci.max')]
	} else {
		results.strata <- x$summary[,c('strata.ATE','strata.ci.min','strata.ci.max')]
	}
	names(results.strata) <- c('estimate','ci.min','ci.max')
	results.strata$y <- 1:nrow(results.strata)
	results.strata$Method <- 'Stratification'
	
	results <- rbind(results.match, results.strata)
	
	#results$y <- 1:nrow(results)
	results$sig <- results$ci.min > 0 | results$ci.max < 0
	ci.min <- mean(results$estimate) - 2 * sd(results$estimate)
	ci.max <- mean(results$estimate) + 2 * sd(results$estimate)
	
	p <- ggplot(results, aes(y=y, xmin=ci.min, xmax=ci.max, x=estimate, color=sig)) +
		geom_vline(xintercept=0, size=1.5) + 
		geom_errorbarh(height=0, alpha=.5) + 
		geom_point(color='blue') + 
		geom_vline(xintercept=mean(results$estimate), color='blue', size=1.5) +
		geom_vline(xintercept=ci.min, color='green') +
		geom_vline(xintercept=ci.max, color='green') +
		scale_y_continuous() + 
		scale_color_manual(values=c("TRUE"="green", "FALSE"="grey")) +
		theme(legend.position='none', axis.ticks.y=element_blank(), 
			  axis.text.y=element_blank()) +
		xlab('Mean Difference') + ylab('') +
		facet_wrap(~ Method, nrow=1)
	return(p)
}

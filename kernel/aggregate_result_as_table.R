#library(ggplot2)
library(plyr)
library(reshape2)
library(xtable)

#args <- commandArgs(trailingOnly = TRUE)
args <- c('result/sum.all.txt', 'error')
input <- args[1]
disp.type <- args[2]

df <- read.table(input, header=F)
names(df) <- c('n', 'k', 's', 'method', 'data', 'ans', 'time')

df$method <- factor(df$method)
df$data <- factor(df$data)
df$s <- factor(df$s)
df$k <- factor(df$k)
df$n <- factor(df$n)

df.approx <- subset(df, !(method=='approx' & k %in% unique(df$n)))
df.exact <- subset(df, method=='approx' & k %in% unique(df$n))
df.exact$time <- NULL
df.exact$method <- NULL
df.exact$k <- NULL
names(df.exact)[4] <- 'exact'
df.join <- join(df.exact, df.approx)

df.s <- ddply(df.join, .(n, k, method, data), summarize,
              m.error=mean(abs(ans - exact), na.rm=T),
              s.error=sd(abs(ans - exact), na.rm=T),
              m.time=mean(time, na.rm=T),
              s.time=sd(time, na.rm=T))

df.s$n <- factor(df.s$n)
df.s$k <- factor(df.s$k)
levels(df.s$n)[1] <- sprintf("$n=%s$",levels(df.s$n)[1])
len.n <- length(levels(df.s$n))
levels(df.s$method) <- c('Proposed', 'Nystr\\"{o}m')

df.s$error <- sapply(1:nrow(df.s),
                     function(i)sprintf('$%.4f\\pm%.4f$', df.s$m.error[i], df.s$s.error[i]))
df.s$time <- sapply(1:nrow(df.s),
                    function(i) sprintf('$%.3f$', df.s$m.time[i]))


df.latex <- dcast(df.s, method + k ~ n, value.var=disp.type)

df.latex$method <- ""
df.latex$method[1] <- sprintf("\\multirow{%d}{*}{\\rotatebox{90}{%s}} ",
                              len.n, levels(df.s$method)[1])
df.latex$method[1+len.n] <- sprintf("\\hline\n\\multirow{%d}{*}{\\rotatebox{90}{%s}}",
                                    len.n, levels(df.s$method)[2])
names(df.latex)[1] <- ""
fmt <- paste(rep('r', len.n), collapse='')

print(xtable(df.latex, align=sprintf("rrr%s", fmt)),
      include.rownames=FALSE,
      sanitize.text.function = function(x){x})

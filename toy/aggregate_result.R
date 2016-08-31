library(ggplot2)
library(plyr)
library(reshape2)
library(xtable)
library(extrafont)

args <- commandArgs(trailingOnly = TRUE)
#args <- c('result/sum.all.txt', 'test.eps', 'error')
input <- args[1]
output <- args[2]
plot.type <- args[3]

df <- read.table(input, header=F)
names(df) <- c('n', 'k', 's', 'method', 'ans', 'time')
df$method <- NULL

df.approx <- subset(df, !(k %in% unique(df$n)))
df.exact <- subset(df, k %in% unique(df$n))
df.exact$time <- NULL
df.exact$k <- NULL
names(df.exact)[3] <- 'exact'
df.join <- join(df.exact, df.approx)

df.s <- ddply(df.join, .(n, k), summarize,
              m.error= mean(abs(ans - exact), na.rm=T),
              s.error= sd(abs(ans - exact), na.rm=T),
              m.time=mean(time, na.rm=T),
              s.time=sd(time, na.rm=T))

df.s$m.error <- df.s$m.error / df.s$n^2
df.s$s.error <- df.s$s.error / df.s$n^2
df.s$n <- factor(df.s$n)
df.s$k <- factor(df.s$k)
levels(df.s$n)[1] <- sprintf("n=%s",levels(df.s$n)[1])

if (plot.type == 'error') {
    #ylab('|z-z*|/n^2') + xlab('k') +
  gg <- ggplot(df.s, aes(x=k, y=m.error)) +
    geom_point() +
    geom_errorbar(aes(ymin = m.error - s.error, ymax = m.error + s.error), width = 0.1) +
    ylab(expression(italic(group("|", z - z^{symbol('*')}, "|") / n^{2}))) +
    xlab(expression(italic(k))) +
    facet_grid(n~.) +
    #guides(color=guide_legend(title='Acceptance Threshold')) +
    theme_minimal() +
    theme(legend.position='none',
          panel.margin=unit(3, "pt"))
  ggsave(output, gg, width=4, height=3, scale=0.9)
  embed_fonts(output, outfile=sprintf("%s", output))

} else if (plot.type == 'time') {
  gg <- ggplot(df.s, aes(x=k, y=m.time)) +
    geom_bar(stat="identity", fill="white", colour="black") +
    #geom_point() +
    ylab('Runtime (second)') + xlab('k') +
#    scale_y_log10() +
    facet_grid(n~.) +
    theme_minimal() +
    theme(legend.position='none')
  ggsave(output, gg, width=6, height=4.5)
}

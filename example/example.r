library("gstsm")

d <- read.table(
  "made_bangu_6x30.txt",
  header = FALSE,
  sep = " ",
  dec = ".",
  as.is = TRUE,
  stringsAsFactors = FALSE
)

p <- read.table(
  "positions_2D_30.txt",
  header = TRUE,
  sep = " ",
  dec = ".",
  as.is = TRUE,
  stringsAsFactors = FALSE
)

plot(
  p$x,
  p$y,
  main = "positions",
  xlab = "",
  ylab = "",
  col = "blue",
  pch = 19,
  cex = 1,
  lty = "solid",
  lwd = 2
)

text(
  p$x,
  p$y,
  labels = p$points,
  cex = 0.7,
  pos = 3
)

gamma <- 0.8
beta <- 2
sigma <- 1

result <- gstsm::gstsm(d, p, gamma, beta, sigma)

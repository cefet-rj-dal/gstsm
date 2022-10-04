library(gstsm)

test_that("there are frequent sequences from size one to three", {

  D <- as.data.frame(matrix(c("B", "B", "A", "C", "A",
                              "C", "B", "C", "A", "B",
                              "C", "C", "A", "C", "A",
                              "B", "B", "D", "A", "B",
                              "B", "D", "D", "B", "D"
                              ), nrow = 5, ncol = 5, byrow = TRUE))

  ponto <- c("p1", "p2", "p3", "p4", "p5")
  x <- c(1, 2, 3, 4, 5)
  y <- c(0, 0, 0, 0, 0)
  z <- y
  P <- data.frame(ponto=ponto, x=x, y=y, z=z, stringsAsFactors = FALSE)

  gamma <- 0.8
  beta <- 2
  sigma <- 1

  gstsm_object <- gstsm(D, P, gamma, beta, sigma)

  result <- mine(gstsm_object)

  expect_equal(length(result), 3)
})

test_that("size three sequences are correct", {

  D <- as.data.frame(matrix(c("B", "B", "A", "C", "A",
                "C", "B", "C", "A", "B",
                "C", "C", "A", "C", "A",
                "B", "B", "D", "A", "B",
                "B", "D", "D", "B", "D"
               ), nrow = 5, ncol = 5, byrow = TRUE))

  ponto <- c("p1", "p2", "p3", "p4", "p5")
  x <- c(1, 2, 3, 4, 5)
  y <- c(0, 0, 0, 0, 0)
  z <- y
  P <- data.frame(ponto=ponto, x=x, y=y, z=z, stringsAsFactors = FALSE)

  gamma <- 0.8
  beta <- 2
  sigma <- 1

  gstsm_object <- gstsm(D, P, gamma, beta, sigma)

  result <- mine(gstsm_object)

  expect_equal(length(result[[3]]), 1)
  expect_equal(result[[3]][[1]]$s, "ACA")
})


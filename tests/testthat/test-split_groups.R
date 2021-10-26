library(gstsm)

test_that("empty group when no positions occurs", {
  calculated_groups <<- new.env(hash = TRUE)

  adjacency_matrix <- matrix(
    c(
      FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE,
      TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE,
      FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,
      TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE,
      FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
      FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE,
      FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE,
      FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE,
      FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE
    ),
    nrow = 9,
    ncol = 9
  )

  positions <- c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)

  expect_equal(length(gstsm::split_groups(positions, adjacency_matrix)), 0)
})

test_that("a group should be created", {
  calculated_groups <<- new.env(hash = TRUE)

  adjacency_matrix <- matrix(
    c(
      FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE,
      TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE,
      FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,
      TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE,
      FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
      FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE,
      FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE,
      FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE,
      FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE
    ),
    nrow = 9,
    ncol = 9
  )

  positions <- c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE)

  expect_equal(length(gstsm::split_groups(positions, adjacency_matrix)), 1)
})

test_that("two groups should be created", {
  calculated_groups <<- new.env(hash = TRUE)

  adjacency_matrix <- matrix(
    c(
      FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE,
      TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE,
      FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,
      TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE,
      FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
      FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE,
      FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE,
      FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE,
      FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE
    ),
    nrow = 9,
    ncol = 9
  )

  positions <- c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE)

  expect_equal(length(gstsm::split_groups(positions, adjacency_matrix)), 2)
})
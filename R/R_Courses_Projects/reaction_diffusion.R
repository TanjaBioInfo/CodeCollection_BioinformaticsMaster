## -----------------------------------------------------------------------------
#| code-fold: true
LaplacianNBC <- function(n){
  off_diag <- rep(1, n - 1)
  main_diag <- -c(1, rep(2, n - 2), 1)
  L <- Matrix::bandSparse(n, n, 0:1,
                          list(main_diag, 
                               off_diag),
                          symmetric = TRUE)
  return(L)
}

LaplacianPBC <- function(n){
  off_diag <- rep(1, n - 1)
  main_diag <- -rep(2, n)
  L <- Matrix::bandSparse(n, n, 0:1,
                          list(main_diag, 
                               off_diag),
                          symmetric = TRUE)
  L[1, n] <- L[n, 1] <- 1
  return(L)
}

Logistic <- function(N, params){
  r <- params['r']
  K <- params['K']
  return(r * N * (1 - N / K))
}

dN <- function(t, N, params, L){
  D <- params['D']
  dx <- params['dx']
  D.scaled <- D / (dx * dx)
  n <- length(N)
  return(list(as.vector(D.scaled * L %*% N + Logistic(N ,params))))
}


## -----------------------------------------------------------------------------
n_time_points <- 501
times <- times <- seq(0, 100, length.out=n_time_points)

n_space_points <- 201
params <- c(r = 1.1, 
            K = 10, 
            D = 1, dx = 1)

L.pbc = LaplacianPBC(n_space_points)
L.nbc = LaplacianNBC(n_space_points)

## A spike on the left of the domain
# N <- c(1e-1 * params["K"], rep(0, 200))

## A spike at the center
# half_space <- 0.5 * (n_space_points - 1)
# N <- c(rep(0, half_space), 
#        1e-1 * params["K"], 
#        rep(0, half_space))

## Randomly-placed spikes
N <- rep(0, n_space_points)
n_start <- 1
k_start <- sample(1:n_space_points, n_start)
N[k_start] <- runif(n_start, 0, 2) * params['K']

# N.sols <- deSolve::ode(N, times, dN, params, L=L.pbc)
N.sols <- deSolve::ode(N, times, dN, params, L=L.nbc)


## ----eval=FALSE---------------------------------------------------------------
## library(manipulate)
## manipulate({
##   plot(N.sols[k, -1],
##        type = "s",
##        lwd=2,
##        ylim=c(0, 2 * params["K"]),
##        ylab="N",
##        xlab="Position")
##   abline(h=params["K"],
##          lty="dashed",
##          col="darkblue")
## },
## k = slider(1, n_time_points, 1, step = 10))


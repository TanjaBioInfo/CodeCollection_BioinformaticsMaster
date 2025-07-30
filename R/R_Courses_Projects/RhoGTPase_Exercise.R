## Librairies to install!
library(deSolve)
library(data.table)
library(ggplot2)
library(ggrepel)

## Helpers
is.real <- function(z, factor=100){
  return(abs(Im(z)) < factor * .Machine$double.eps)
}

jacobian <- function(state, params){
  mT <- state['mT']
  mD <- state['mD']
  mu <- params['mu']
  J11 <- -mu + 2 * mT * mD
  J22 <- -(2 + mT ^ 2)
  J12 <-  (1 + mT ^ 2)
  J21 <- -(1 + 2 * mT * mD)
  return(matrix(c(J11, J21, J12, J22), 2, 2))
}

is.stable <- function(state, params){
  jac <- jacobian(state, params)
  return(all(Re(eigen(jac, symmetric=FALSE, only.values = TRUE)$values) < 0))
}

steady_states <- function(params){
  mu <- params['mu']
  n <- params['n']
  coefs <- c(-n, 1 + 2 * mu, -n, 1 + mu)
  coefs <- as.vector(coefs)
  mT <- polyroot(coefs)
  mT <- Re(mT[is.real(mT)])
  mD <- mu * mT / (1 + mT ^ 2)
  dt <- data.table(mT=mT, mD=mD)
  dt[,stable:=apply(dt, 1, is.stable, params=params)]
  dt[,stability:=factor(stable, levels=c(FALSE, TRUE), labels=c("unstable", "stable"))]
  return(dt)
}

## Reduced dynamical system
# Rates dmT and dmD
dmT <- function(mT, mD, params){
  return(-params["mu"] * mT + (1 + mT ^ 2) * mD)
}


dmD <- function(mT, mD, params){
  return(params["n"] - mT - (2 + mT ^ 2) * mD)
}

# Null-clines
isodmT <- function(mT, params){
  return(params["mu"] * mT / (1 + mT ^ 2))
}

isodmD <- function(mT, params){
  return((params["n"] - mT) / (2 + mT ^ 2))
}

# RH for ODE solver
dy <- function(t, y, params){
  dy <- c(mT=NA, mD=NA)
  dy['mT']  <- dmT(y['mT'], y['mD'], params)
  dy['mD']  <- dmD(y['mT'], y['mD'], params)
  return(list(dy))
}

# Example parameters to try, in this order

# scenario 1: Very low hydrolysis, very low amounts
# params <- c(mu=2, n=2)

# scenario 2: Moderate hydrolysis (x4) and amounts (x4)
# params <- c(mu=8, n=8)

# scenario 3: High hydrolysis (x8) and amounts (x8)
# params <- c(mu=16, n=16)

# scenario 4: High hydrolysis, higher amounts = 2 x hydrolysis
# params <- c(mu=16, n=32)

# scenario 5: Very high hydrolysis (x16) and amounts (x16)
# params <- c(mu=32, n=32)

# scenario 6: High hydrolysis, higher amounts = 4 x hydrolysis
# params <- c(mu=16, n=64)

# scenario 7: Very high hydrolysis, higher amounts = 2 x hydrolysis
# params <- c(mu=32, n=64)


params.dt <- 
  data.table(
    mu = c(2,8,16,16,32,16,32),
    n  = c(2,8,16,32,32,64,64),
    scenario=c(
      "Very low hydrolysis\nVery low amounts",
      "Moderate hydrolysis (x4)\nand amounts (x4)",
      "High hydrolysis (x8)\nand amounts (x8)",
      "High hydrolysis\n Higher amounts = 2 x hydrolysis",
      "Very high hydrolysis (x16)\nand amounts (x16)",
      "High hydrolysis\nHigher amounts = 4 x hydrolysis",
      "Very high hydrolysis\nHigher amounts = 2 x hydrolysis"))

scenario <- 1
params <- params.dt[scenario, c(mu, n)]
names(params) <- c("mu", "n")

## Build multiple starting points around a square and organized in a data.table

# Sides of the square
mT.MAX.seq <- 2
mD.MAX.seq <- 2


## First strategy: a square
# Number of starting points per side
n.traj.per.side <- 10

# Build n.traj.per.side equally-spaced between mT.MAX.seq and mD.MAX.seq
mT.seq <- seq(0, mT.MAX.seq, length.out=n.traj.per.side)
mD.seq <- seq(0, mD.MAX.seq, length.out=n.traj.per.side)

# Build starting points as a square of sides mT.MAX.seq per mD.MAX.seq with n.traj.per.side on each side
starting.points <- 
  data.table(mT = c(mT.seq, rep(mT.MAX.seq , n.traj.per.side), rev(mT.seq), rep(0, n.traj.per.side)),
             mD = c(rep(0, n.traj.per.side), mD.seq,  rep(mD.MAX.seq, n.traj.per.side), rev(mD.seq)))

## Second strategy: random sampling in a box

# starting.points <- 
#   data.table(mT = runif(n.traj.per.side * 4, 0, mT.MAX.seq),
#              mD = runif(n.traj.per.side * 4, 0, mD.MAX.seq))

# Add a unique ID for each trajectory for grouping in ggplot
starting.points <- unique(starting.points)[,id:=1:.N]

# Simulate all the trajectories, and organize the results in a data.table
t_max <- 15
n_time_points <- 10001
times <- seq(0, t_max, length.out=n_time_points)
yt.dt <- starting.points[,data.table(ode(c(mT=mT, mD=mD), times, dy, params)), by=id]

## Plotting

# Phase Space
plot_phase_space <- 
  ggplot(data=yt.dt)+
  geom_path(aes(x=mT, y=mD, group=id), alpha=0.5)+
  geom_point(aes(x=mT, y=mD), size=0.75,
             data=yt.dt[time<=min(time)])+
  geom_function(fun=isodmT, 
                args = list(params=params),
                n=1001,
                col="blue", linewidth=1.)+
  geom_function(fun=isodmD, 
                args = list(params=params),
                n=1001,
                col="red", linewidth=1.)+
  geom_point(aes(x=mT, y=mD, fill=stability, color=stability), shape=21, size=4, data=steady_states(params))+
  scale_fill_manual(values=c(unstable="white", stable="black"))+
  scale_color_manual(values=c(unstable="black", stable="white"))+
  theme_bw()

# Time Traces
plot_time_traces <- 
  ggplot(data=yt.dt)+
  geom_line(aes(x=time, y=mT), col="blue")+
  geom_line(aes(x=time, y=mD), col="red")+
  facet_wrap(~id)

print(plot_time_traces)
print(plot_phase_space)

##- Hopf bifurcation diagram

# Helper
hopf_boundary <- function(mt){
  dt <- data.table(mt = mt)
  dt[,mu := (2 + 3 * mt ^ 2 + mt ^ 4) / (mt ^ 2 - 1)]
  dt[, n := mt * (3 + 5 * mt ^ 2 + mt ^ 4) / (mt ^ 2 - 1)]
  return(dt)
}

# Generate boundary parameter mt and data set
mt <- seq(1.01, to = 10, length.out=1001)
hopf.dt <- hopf_boundary(mt)

# Plot and overlay scenario
hopf_gp <-
  ggplot(data=hopf.dt,
         mapping=aes(x=mu, y=n))+
  geom_polygon(fill='blue',
               alpha=0.25)+
  # geom_vline(xintercept = 0)+
  # geom_hline(yintercept = 0)+
  geom_point(data=params.dt,
             shape=21, size=2,
             fill="black")+
  geom_label_repel(aes(x=mu, y=n, label=scenario),
                   force=5,
                   max.iter=1e4,
                   min.segment.length = 0,
                   box.padding = 1.25,
                   data=params.dt)+
  scale_x_continuous(limits=c(0, 50),
                     name = expression("Normalized GTP hydrolysis rate"~mu),
                     expand = expansion(add = c(0, 2)),
                     oob = scales::oob_keep)+
  scale_y_continuous(limits=c(0, 100),
                     name="Total amounts n",
                     expand = expansion(add = c(0, 2)),
                     oob = scales::oob_keep)+
  theme_bw()

# print(hopf_gp)




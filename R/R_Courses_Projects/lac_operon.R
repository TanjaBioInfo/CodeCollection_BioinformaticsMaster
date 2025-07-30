
## -----------------------------------------------------------------------------
#| eval: false
## knitr::purl("lac_operon.qmd")


## -----------------------------------------------------------------------------
#| warning: false

library(manipulate)
library(deSolve)
library(data.table)
library(ggplot2)
library(Sim.DiffProc)


## -----------------------------------------------------------------------------
LacI <- function(TMG, RT=1, TMG0=1, Hill=2){
  return( RT / (1 + (TMG / TMG0) ** Hill))
}


## -----------------------------------------------------------------------------
TMG_MAX <- 20
TMG0 <- TMG_MAX/2
RT <- 1
n.points <- 1001
curve(LacI(x, RT=RT, TMG0=TMG0, Hill=0), 
      from=0, to=TMG_MAX, 
      ylim=c(0, RT), n=n.points,
      xlab="TMG [a.u.]", 
      ylab="LacI [a.u.]")
hill_coefficients <- c(1, 1.5, 2, 4, 8, 128)
for (hill_coefficient in hill_coefficients){
  curve(LacI(x, RT=RT, TMG0=TMG0, Hill=hill_coefficient), 
        from=0, to=TMG_MAX, 
        n=n.points,
        col = "blue", lwd=2,
        add=TRUE)
}
abline(h=c(0, RT), v=TMG0, lty="dashed", lwd=1.25)


## ----eval=FALSE---------------------------------------------------------------
## manipulate({
##   curve(
##     LacI(x, RT = 1, TMG0, 2^log2Hill),
##     from = 0, to = TMG_MAX,
##     ylim = c(0, 1),
##     col = "blue", lwd=2,
##     n = 1001)
##   abline(
##     h = c(0, RT), v = TMG0,
##     lty = "dashed", lwd = 1.25)
## },
##   TMG0 = slider(0, TMG_MAX, TMG_MAX / 2, label = "TMG0"),
##   log2Hill = slider(0, 12, 0, step = 0.1, label = "log2 Hill exponent"))


## -----------------------------------------------------------------------------
beta <- function(eTMG, glucose=0){
  return( 1.23 * 1e-3 * (eTMG ^ 0.6) * 65)
}
  
alpha <- function(eTMG, glucose=0){
  return( 84.4 / (1 + (glucose/8.1) ^ 1.2) + 15.6)
}
  
dLacY <- function(TMG, LacY, params){
  return(params['alpha'] * (1 + TMG ^ params['Hill'])/ ( params['rho'] + TMG ^ params['Hill']) - LacY)
}

dTMG <- function(TMG, LacY, params){
  return(params['beta'] * LacY - TMG)
}

isodLacY <- function(TMG, params){
  return( params['alpha'] * (1 + TMG ^ params['Hill']) / (params['rho'] + TMG ^ params['Hill']))
}
  
isodTMG <- function(TMG, params){
  return( 1/params['beta'] * TMG)
}


## -----------------------------------------------------------------------------
is.real <- function(z){
  return(abs(Im(z)) < 2 * .Machine$double.eps)
}

jacobian <- function(state, params){
  J11 <- J22 <- -1
  J12 <- 2 * params['alpha'] * (params['rho'] - 1) * state['TMG'] / ((params['rho'] + state['TMG'] ^ 2) ^ 2)
  J21 <- params['beta']
  return(matrix(c(J11, J21, J12, J22), 2, 2))
}

is.stable <- function(state, params){
  jac <- jacobian(state, params)
  return(all(eigen(jac, symmetric=FALSE, only.values = TRUE)$values < 0))
}

steady_states <- function(params){
  coefs <- as.vector(c(-params['alpha']*params['beta'], params['rho'], -params['alpha']*params['beta'], 1))
  TMG <- polyroot(coefs)
  TMG <- Re(TMG[is.real(TMG)])
  LacY <- TMG / params['beta']
  dt <- data.table(TMG=TMG, LacY=LacY)
  dt[,stable:=apply(dt, 1, is.stable, params=params)]
  return(dt)
}


## ----eval=FALSE---------------------------------------------------------------
## manipulate({
##   TMG <- seq(0., TMG_MAX, length.out=5000)
##   # params <- c(alpha=alpha(eTMG), beta=beta(eTMG), rho=rho, Hill=2)
##   params <- c(alpha=alpha(eTMG), beta=beta(2^log2eTMG), rho=rho, Hill=2)
##   plot(0,
##      xlim=range(TMG), xlab="Internal TMG [a. u.]",
##      ylim=c(0, LacY_MAX), ylab="LacY [a. u.]",
##      type='n')
##   lines(TMG, isodTMG(TMG, params), type='l', col="blue", lwd=2)
##   lines(TMG, isodLacY(TMG, params), type='l', lwd=2)
##   rect(-2*LacY_MAX, -2*TMG_MAX, 0, 2*LacY_MAX, col="grey", border="grey")
##   rect(-2*LacY_MAX, -2*TMG_MAX, 2*TMG_MAX, 0, col="grey", border="grey")
## },
##   rho = slider(0, 167, 2),
##   log2eTMG = slider(0, 7, 0.1, step = 0.1, label = "log2 Ext. TMG [a.u.]"),
##   TMG_MAX = slider(0, 150, 150, label = "Internal TMG Maximum"),
##   LacY_MAX = slider(0, 100, 100, label = "LacY Maximum"))


## -----------------------------------------------------------------------------
TMG_MAX <- 60
LacY_MAX <- 100
eTMG <- 1e-5
rho <- list(WT=167.1, plasmid.4=50, plasmid.25=5)
TMG <- seq(1e-5, TMG_MAX, length.out=5000)
plot(0, 
     xlim=range(TMG), xlab="Internal TMG [a. u.]",
     ylim=c(0, LacY_MAX), ylab="LacY [a. u.]",
     type='n')
rect(-2*LacY_MAX, -2*TMG_MAX, 0, 2*LacY_MAX, col="grey", border="grey")
rect(-2*LacY_MAX, -2*TMG_MAX, 2*TMG_MAX, 0, col="grey", border="grey")

for (eTMG in seq(1e-5, 25, length.out=10)){
  params <- c(alpha=alpha(eTMG), beta=beta(eTMG), rho=rho[["WT"]], Hill=2)
  lines(TMG, isodTMG(TMG, params), type='l', col="blue")
  lines(TMG, isodLacY(TMG, params), type='l')  
}



## -----------------------------------------------------------------------------
dy <- function(t, y, params){
  dy <- c(TMG=NA, LacY=NA)
  dy['TMG']  <-  dTMG(y['TMG'], y['LacY'], params)
  dy['LacY'] <- dLacY(y['TMG'], y['LacY'], params)
  return(list(dy))
}


## -----------------------------------------------------------------------------
TMG_MAX <- 150

n.seq <- 50

TMG.MAX.seq <- 100
LacY.MAX.seq <- 100
TMG.seq <- seq(0, TMG.MAX.seq, length.out=n.seq)
LacY.seq <- seq(0, LacY.MAX.seq, length.out=n.seq)

starting.points <- 
  data.table(TMG =  c(TMG.seq, rep(TMG.MAX.seq , n.seq), rev(TMG.seq), rep(0, n.seq)),
             LacY = c(rep(0, n.seq), LacY.seq,  rep(LacY.MAX.seq, n.seq), rev(LacY.seq)))

starting.points <- unique(starting.points)[,id:=1:.N]

times <- seq(0, 10, length.out=201)
eTMG <- 33
params['rho'] <- 750
params['alpha'] <- alpha(eTMG)
params['beta'] <- beta(eTMG)
yt.dt <- starting.points[,data.table(ode(c(TMG=TMG, LacY=LacY), times, dy, params)), by=id]


## -----------------------------------------------------------------------------
#| warning: false
TMG.seq <- seq(0, TMG_MAX, length.out=1001)

ggplot(data=yt.dt)+
  geom_path(aes(x=TMG, y=LacY, group=id), alpha=0.5)+
  geom_point(aes(x=TMG, y=LacY), size=0.25,
             data=yt.dt[time<=min(time)])+
  geom_line(aes(x=TMG, y=null.TMG), col="blue",
            data=data.table(TMG=TMG.seq, null.TMG=isodTMG(TMG.seq, params)))+
  geom_line(aes(x=TMG, y=null.LacY), col="red",
            data=data.table(TMG=TMG.seq, null.LacY=isodLacY(TMG.seq, params)))+
  geom_point(aes(x=TMG, y=LacY, fill=stable), shape=21, size=4, data=steady_states(params))+
  scale_fill_manual(values=c("white", "black"))+
  ylim(c(0, max(starting.points[,LacY])))+
  xlim(c(0, max(starting.points[,TMG])))+
  coord_fixed()+
  theme_bw()


## -----------------------------------------------------------------------------
#| warning: false

eTMG.seq <- seq(1e-5, 50, length.out=2001)
hysteresis.dt <- data.table(eTMG=eTMG.seq)[,{
 tryCatch(steady_states(c(alpha=alpha(eTMG), beta=beta(eTMG), Hill=2, rho=150)),
          error = function(err) return(list(NA_real_, NA_real_, NA)))
}, by=eTMG]

ggplot(data=hysteresis.dt[order(TMG)])+
  geom_path(aes(x=eTMG, y=TMG, color=as.numeric(stable)))+
  scale_color_gradient(low="red", high="blue", n.breaks=2)


## -----------------------------------------------------------------------------
#| warning: false

LacY_stable_state <- steady_states(params)[stable==TRUE, LacY]
TMG_stable_state <- steady_states(params)[stable==TRUE, TMG]

LacY_unstable_state <- steady_states(params)[stable==FALSE, LacY]
TMG_unstable_state <- steady_states(params)[stable==FALSE, TMG]

starting_point <- c(TMG_unstable_state, LacY_unstable_state)

t_max <- 200
dt <- 0.01
nsamples <- 5

sig_LacY <- 0
sig_TMG <- 0

sde.trajectories <- 
  snssde2d(N=round(t_max/dt), 
           M=nsamples, 
           x0=starting_point, 
           t0=0, Dt=dt, 
           drift = expression(params['beta'] * y - x, 
                              params['alpha'] * (1 + x^2)/(params['rho'] + x^2) - y), 
           diffusion = expression(sig_TMG , sig_LacY))


yrange <- c(0, 1.2*max(LacY_stable_state, TMG_stable_state))

plot(sde.trajectories,
     legend=FALSE,
     lwd=2,
     pos=1,
     ylim=yrange)

abline(h=LacY_stable_state, col="red")
abline(h=LacY_unstable_state, col="red", lty="dashed")

abline(h=TMG_stable_state)
abline(h=TMG_unstable_state, lty="dashed")

legend("topleft",
       c(expression(LacY), expression(TMG)),
       lty = 1,
       col=c("black", "red"),
       cex=0.75)

points(c(0,0), starting_point, 
       col=c("black", "red"), 
       pch=21, bg="white")


## -----------------------------------------------------------------------------
#| warning: false

eTMG.seq <- seq(1e-2, 2, length.out=300)
rho.seq <- c(1:14, 18, 20)
hysteresis.dt <- data.table(expand.grid(rho=rho.seq, eTMG=eTMG.seq))[,{
 tryCatch(steady_states(c(alpha=alpha(eTMG), beta=beta(eTMG), Hill=2, rho=rho)),
          error = function(err) return(list(TMG=NA_real_, LacY=NA_real_, stable=NA)))
}, by=list(eTMG, rho)]

ggplot(data=hysteresis.dt[order(TMG)])+
  geom_path(aes(x=eTMG, y=TMG, color=as.numeric(stable)))+
  scale_color_gradient(low="red", high="blue", n.breaks=2, guide="none")+
  facet_wrap(vars(rho))





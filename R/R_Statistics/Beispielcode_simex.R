## Simex:

## code aus dem Skript, funktioniert jedoch nicht:
library(simex)
m1 <- lm(Vy ~ Vx1 + Vx2, Datensatz, x = TRUE)
r.simex <- simex(m1, SIMEXvariable = Vx1, measurement.error = 0.5, 
                 lambda = seq(0.1 ,2.5, 0.1), B=100, fitting.method='quadratic')
               # lambda = c(0.5, 1, 1.5, 2), B=100, fitting.method = "quadratic")
summary(r.simex$coef$asymptotic)
plot(r.simex)



## to test nonlinear extrapolation set.seed(3) (aus dem Internet):
x <- rnorm(200, 0, 100)
u <- rnorm(200, 0, 25)
w <- x+u
y <- x + rnorm(200, 0, 9)
true.model <- lm(y ~ x)   # true model
naive.model <- lm(y ~w, x=TRUE)
simex.model <- simex(model = naive.model, 
                     SIMEXvariable = "w", 
                     measurement.error = 25)
plot(x,y)
abline(true.model, col="darkblue")
abline(simex.model, col="red")
abline(naive.model, col="green")
legend(min(x), max(y), legend=c("True Model", "SIMEX Model", "Naive Model"), 
       col=c("darkblue", "red", "green"), lty=1)
plot(simex.model, mfrow=c(2,2))



## MC-SIMEX-Korrektur von Messfehlern in nomialen Variablen:
mcsimextable = function(obs_data, Pi=NULL, rel=NULL, n_MC_sets=100, n_MC_steps=3, proportion=T) {
  lev=levels(factor(obs_data))
  k=length(lev)
  if (is.null(Pi)&is.null(rel)) {print("Please provide either misclassification matrix or reliability estimate.")}
  if (is.null(Pi)&!is.null(rel)) {
    Pi = make_Pi_coef(rel, lev)
  }
  
  
  }
}
## Beispielcode für Matrix-Algebra:


## clear R
rm(list=ls())

## eine Matrix erstellen:
M <- matrix(c(1,0,0,1), nrow=2, ncol=2, byrow=TRUE)
M
#       [,1] [,2]
# [1,]    1    0
# [2,]    0    1

## erkundigen ob es eine Matrix ist?
is.matrix(M)
# TRUE

## Objekte in eine Matrix umwandeln:
as.matrix(data.frame(x=c(1, 0), y=c(0, 1)))
#      x y
# [1,] 1 0
# [2,] 0 1

## diagonale Matrices (so wie im Beispiel oben) kann man auch so erstellen:
M <- diag(nrow=2, ncol=2)
M

## noch allgemeiner kann man eine n-Identitäts-Matrix (nur 1 als Ziffer) erstellen:
n <- 10
diag(nrow=n, ncol=n)

## den diagonalen Vektor der Matrix noch spezifizieren (nicht nur eine Ziffer):
M <- diag(c(2,1), nrow=2, ncol=2)
M
#       [,1] [,2]
# [1,]    2    0
# [2,]    0    1


## Matrix-Algebra:
M <- matrix(c(0,2,1,0), nrow=2, ncol=2, byrow=TRUE)
M     
#       [,1] [,2]
# [1,]    0    2
# [2,]    1    0

## Matrix-Algebra: Addition
M+M
#       [,1] [,2]
# [1,]    0    4
# [2,]    2    0

## Matrix-Algebra: Skalar-Multiplikation
2*M
#       [,1] [,2]
# [1,]    0    4
# [2,]    2    0

## Matrix-Algebra: normale Multiplikation
M*M
#       [,1] [,2]
# [1,]    0    4
# [2,]    1    0

## Matrix-Algebra: Matrix-Multiplikation
M%*%M
#       [,1] [,2]
# [1,]    2    0
# [2,]    0    2
# bei der Matrix-Multiplikation muss die Spaltennummer der ersten Matrix 
#                                mit der Zeilennummer der zweiten Matrix übereinstimmen, sonst ist es nicht definiert. 

## Matrix-Transposition:
t(M)
#       [,1] [,2]
# [1,]    0    1
# [2,]    2    0
# bei symmetrischen Matrixes ist das Transposon (t()) gleich der Original-Matrix
# das Produkt von A %*% t(A) ist immer symmetrisch

## Matrix-Inversion:
solve(M)
#       [,1] [,2]
# [1,]  0.0    1
# [2,]  0.5    0
## qr.solve() ist schneller:
qr.solve(M)
# quardatische Matrixes kann man inversen (solve()), sowie auch immer ein Skalar (zB. Vektor-Produkt)

## das Matrix-Produkt von M mit seiner Inversion (solve(), wenn sie existiert), ist wieder eine Einheitsmatrix ("I"):
solve(M) %*% M == diag(nrow=nrow(M), ncol=ncol(M))
## als Kontrolle ob die Inversion korrekt war. 
#       [,1] [,2]
# [1,] TRUE TRUE
# [2,] TRUE TRUE
# das Produkt von A %*% solve(A) (Inversion von A) ist immer "I" (Einheitsmatrix)
# das Produkt von A %*% "I" (Einheitsmatrix) ist immer A

## andere Arten um Inversionen zu machen:
library('car')
inv
library('MASS')
ginv(M)

## Eigen-Vektoren:
eigen(M)

## Meta-Daten bekommen:
diM(M)
nrow(M)
ncol(M)


# ### einige Regeln:
# quardatische Matrixes kann man inversen (solve()), sowie auch immer ein Skalar (zB. Vektor-Produkt)
# bei symmetrischen Matrixes ist das Transposon (t()) gleich der Original-Matrix
# bei der Matrix-Multiplikation muss die Spaltennummer der ersten Matrix 
#                                mit der Zeilennummer der zweiten Matrix übereinstimmen, sonst ist es nicht definiert. 
# das Produkt von A %*% t(A) ist immer symmetrisch
# das Produkt von A %*% solve(A) (Inversion von A) ist immer "I" (Einheitsmatrix)
# das Produkt von A %*% "I" (Einheitsmatrix) ist immer A
### least-squares estimates of Beta (estimated):
Beta_estimated <- solve(t(Xtilde) %*% Xtilde) %*% t(Xtilde) %*% t.Y 

####### 100 Simulationen durchführen, 
# mit jeder Runde die estimated Koeffizienten(-Vektoren) Beta0Dächli, Beta1Dächli, Beta3Dächli festhalten.
# die Schätzungen sind in jeder Runde ein wenig unterschiedlich, wiel t.E jedesmal zu y.Y dazu gezählt wird.
# zuerst eine Error-Matrix von der Dimension 5 Reihen und 100 Spalten kreieren. 
# Jede Spalte enthält den Error von einem Experiment:
t.E <- matrix(rnorm(500), ncol=100, nrow=5)
# mittels t.E die Beobachtungen generieren:
t.Y <- matrix(rep(t.y, 100), nrow=5, byrow=F)
y.Y <- t.y + t.E
# eine Matrix (100 Reihen und 3 Spalten) mit Resultaten erstellen, 
# in welcher die Spalten für Beta0Dächli, Beta1Dächli, Beta3Dächli stehen,  
# und die Reihen für die Resultate der 100 Durchgänge. 
r.coef <- matrix(NA, ncol=3, nrow=100)
for(i in 1:100) {
  r.coef[i, ] <- lm(y.Y[ ,i] ~ x1 + x2)$coefficients
}

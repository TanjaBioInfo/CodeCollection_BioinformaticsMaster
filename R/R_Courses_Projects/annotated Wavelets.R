# Function to create a sinusoidal function with specified amplitudes and frequencies
make_sinusoidal <- function(amplitudes, frequencies) {
  # Inner function that calculates the sum of cosines for each time value
  sinusoidal_fun <- function(times) {
    sapply(times, function(time) {
      sum(amplitudes * cos(2 * pi * frequencies * time))  # Sum of cosines for each time
    })
  }
  return(sinusoidal_fun)  # Return the sinusoidal function
}

# Set up parameters for time and noise
T <- 20  # Total time duration
dt <- 0.01  # Time step
times <- seq(0, T, by = dt)  # Time points from 0 to T with step size dt
N <- length(times)  # Number of time points
sd_noise <- 1.2  # Standard deviation of the noise

# Set up frequencies and amplitudes for the sinusoidal signal
periods <- c(2.0, 0.5)  # Periods of the sinusoidal components
frequencies <- 1 / periods  # Corresponding frequencies
amplitudes <- c(4, 5.5)  # Amplitudes of the sinusoidal components

# Generate the sinusoidal function and signal
sinusoidal_fun <- make_sinusoidal(amplitudes, frequencies)
sinusoidal_signal <- sinusoidal_fun(times)  # Apply the function to the time points

# Add noise to the sinusoidal signal
noisy_sinusoidal_signal <- sinusoidal_signal + rnorm(N, sd = sd_noise)

# Plot the noisy sinusoidal signal
plot(times, noisy_sinusoidal_signal, ylab = "Signal", xlab = "Time", type = 's')
lines(times, sinusoidal_signal, col = "red")  # Plot the clean sinusoidal signal in red
for (k in seq_along(frequencies)) {
  lines(times, amplitudes[k] * cos(2 * pi * frequencies[k] * times), col = "blue")  # Plot individual components
}

# Calculate and plot the spectrum of the noisy signal
signal_spectrum <- spectrum(noisy_sinusoidal_signal, log = 'no', plot = FALSE)
sample_frequencies <- signal_spectrum$freq / dt  # Adjust frequencies based on time step
signal_spectrum_density <- 2 * signal_spectrum$spec  # Spectral density
plot(sample_frequencies, signal_spectrum_density, xlab = "Frequency", ylab = "Spectral Density", xlim = c(0, 2 * max(frequencies)), type = 's')
abline(v = frequencies, col = "blue", lty = "dashed")  # Mark the actual frequencies

#### The next part creates a polynomial trend and chirp signal:

# Function to create a polynomial trend
make_polynomial_trend <- function(roots, leading_coef = 1) {
  polynom_fun <- function(times) {
    return(leading_coef * sapply(times, function(time) prod(time - roots)))  # Polynomial using the roots
  }
  return(polynom_fun)
}

# Generate a polynomial trend with random roots
n_roots <- 3  # Number of roots
roots <- runif(n_roots, min = 0, max = T)  # Random roots between 0 and T
polynomial_trend_fun <- make_polynomial_trend(roots)
trend <- polynomial_trend_fun(times)
trend <- max(amplitudes) * scale(trend, center = FALSE)  # Scale the trend to match amplitude

# Plot the polynomial trend
plot(times, trend, ylab = "Signal", xlab = "Time", type = 's')
points(roots, rep_len(0, n_roots))  # Mark the roots
abline(h = 0)  # Horizontal line at 0
abline(v = roots, lty = 'dashed')  # Mark the positions of the roots


#### adding a linear chirp signal:

# Function to create a linear chirp signal (frequency sweep over time)
make_linear_chirp <- function(amplitude, f0, f1, T) {
  linear_chirp_fun <- function(times) {
    ft <- f0 + (f1 - f0) / T * times  # Linear interpolation of frequencies
    return(amplitude * cos(2 * pi * ft * times))  # Chirp formula
  }
  return(linear_chirp_fun)
}

# Create and plot a linear chirp signal
f0 <- min(frequencies)  # Starting frequency
f1 <- max(frequencies)  # Ending frequency
linear_chirp_fun <- make_linear_chirp(mean(amplitudes), f0, f1, T)
chirp_signal <- linear_chirp_fun(times)
noisy_chirp_signal <- chirp_signal + rnorm(N, sd = sd_noise)  # Add noise to the chirp signal

plot(times, noisy_chirp_signal, ylab = "Signal", xlab = "Time", type = 's')
lines(times, chirp_signal, col = "red")  # Plot the clean chirp signal in red



##### generating and analyzing a Morlet wavelet signal:

# Function to create a Morlet wavelet
make_morlet <- function(amplitude, t0, sigma, f) {
  morlet_fun <- function(times) {
    return(amplitude * dnorm(times, t0, sigma) * cos(2 * pi * f * times))  # Gaussian * cosine
  }
  return(morlet_fun)
}

# Generate and plot a Morlet wavelet signal
T_morlet <- runif(1, 0.25 * T, 0.35 * T)  # Random time center for the wavelet
frequency_morlet <- max(frequencies)  # Use the highest frequency
period_morlet <- 1 / frequency_morlet
sigma_morlet <- 1 / frequency_morlet  # Standard deviation of the Gaussian
amplitude_morlet <- max(amplitudes)  # Amplitude for the Morlet wavelet
morlet_fun <- make_morlet(amplitude_morlet, T_morlet, sigma_morlet, frequency_morlet)
morlet_signal <- morlet_fun(times)
noisy_morlet_signal <- morlet_signal + rnorm(N, sd = sd_noise)  # Add noise to the Morlet wavelet

plot(times, noisy_morlet_signal, ylab = "Signal", xlab = "Time", type = 's')
lines(times, morlet_signal, col = "red")  # Plot the clean Morlet wavelet



##### performe a wavelet transform analysis:

# Perform wavelet analysis on the noisy sinusoidal signal
library(WaveletComp)
noisy_sinusoidal_signal.dt <- data.frame(x = times, y = noisy_sinusoidal_signal)
scalogram <- analyze.wavelet(noisy_sinusoidal_signal.dt, "y", make.pval = FALSE, dt = dt, verbose = FALSE)

# Plot the wavelet scalogram
wt.image(scalogram, color.key = "interval", spec.time.axis = list(at = seq(1, length(times), length.out = 11), labels = seq(0, T, length.out = 11)))
plot(noisy_sinusoidal_signal.dt, type = 's')

# Plot average wavelet power spectrum
wt.avg(scalogram, verbose = FALSE)
abline(h = log2(frequencies), lty = "dashed")  # Mark the original frequencies


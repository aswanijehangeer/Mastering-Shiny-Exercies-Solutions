# install.packages("ambient")

library(ambient)
worley_noise <- ambient::noise_worley(c(200, 200))

png("noise_plot.png")
plot(as.raster(normalise(worley_noise)))
dev.off()

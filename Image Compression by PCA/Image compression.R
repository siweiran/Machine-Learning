# Store all the three matrices into seperate variables.
tiger_jpeg <- readJPEG('tiger.jpeg')
RGB_c1 <- tiger_jpeg[,,1]
RGB_c2 <- tiger_jpeg[,,2]
RGB_c3 <- tiger_jpeg[,,3]

# Plot the tiger image by the three RGB colors
plot(1, type="n")                             
rasterImage(RGB_c1, 0.6, 0.6, 1, 1.4)
rasterImage(RGB_c2, 0.6, 0.6, 1.4, 1.4, add = TRUE)
rasterImage(RGB_c3, 0.6, 0.6, 1.4, 1.4, add = TRUE)

# PCA on all three
tiger_color_matrix <- cbind(RGB_c1, RGB_c2, RGB_c3)
tiger_pca <- prcomp(tiger_color_matrix, center = FALSE)
# In order to drop the columns with smaller eigen-value, we should choose a number of k which could explain a large 
# percentage of variace. Lets say we want to the culmulative variance is explained by 90%
cul_var <- cumsum(tiger_pca$sdev^2) / sum(tiger_pca$sdev^2)
num_compo <- min(which(cul_var > 0.90))
compressed_tiger <- tiger_pca$x[,1:num_compo]
# It shows that we just need to keep 6 components to maintain 90% variance. At the same time, we compress the size of # data

# Plot the fraction of variance explained as k increases
plot(cul_var, xlab="Number of Components k", ylab="Culmulative Variance Explained", main="Variance Explained by Principal Components")

# create and save the image of list of k of compressed photo
c1.pca<-prcomp(RGB_c1, center=FALSE, scale.=FALSE)
c2.pca<-prcomp(RGB_c2, center=FALSE, scale.=FALSE)
c3.pca<-prcomp(RGB_c3, center=FALSE, scale.=FALSE)
tiger_pca<-list(c1.pca, c2.pca, c3.pca)

vec<- c(3,5,10,25,50,100,150,200,250,300,350,nrow(tiger_jpeg))
for(i in vec){
  tiger.pca<-sapply(tiger_pca, function(j) {
    new.RGB<-j$x[,1:i] %*% t(j$rotation[,1:i])}, simplify="array")
  assign(paste("photo_", round(i,0), sep=""), tiger.pca)
  writeJPEG(tiger.pca, paste("photo_", round(i,0), "_princ_comp.jpg", sep=""))
}

# Lets plot the photo here
par(mfrow=c(3,3)) 
par(mar=c(1,1,1,1))
plot(image_read(get(paste("photo_", round(vec[1],0), sep=""))))
plot(image_read(get(paste("photo_", round(vec[2],0), sep=""))))
plot(image_read(get(paste("photo_", round(vec[3],0), sep=""))))
plot(image_read(get(paste("photo_", round(vec[4],0), sep=""))))
plot(image_read(get(paste("photo_", round(vec[5],0), sep=""))))
plot(image_read(get(paste("photo_", round(vec[6],0), sep=""))))
plot(image_read(get(paste("photo_", round(vec[7],0), sep=""))))
plot(image_read(get(paste("photo_", round(vec[8],0), sep=""))))
plot(image_read(get(paste("photo_", round(vec[9],0), sep=""))))

# calculate the size and compression ratio
sizes<-matrix(0, nrow=12, ncol=4)
colnames(sizes)<-c("Number of PC", "Photo size", "Compression ratio", "MSE-Mean Squared Error")
sizes[,1]<-round(vec,0)
for(i in 1:12) {
  path<-paste("photo_", round(vec[i],0), "_princ_comp.jpg", sep="")
  sizes[i,2]<-file.info(path)$size 
  photo_mse<-readJPEG(path)
  sizes[i,4]<-mse(tiger_jpeg, photo_mse)
}
sizes[,3]<-round(as.numeric(sizes[,2])/as.numeric(sizes[9,2]),3)
sizes

# Plot the compression ratio
plot(sizes[,1],sizes[,3],xlab="Number of Components k", ylab="Compression ratio")

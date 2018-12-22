# Tutorials Used
# http://jdav.is/2015/07/28/r-with-visual-studio-code/
# https://www.datamentor.io/r-programming/bar-plot/

squareRoot <- function(x) {
    sqrt(x)
}

a <- c(9, 16, 25)
print(squareRoot(a))
barplot(a, 
main = "Square Roots",
xlab = "X Axis",
ylab = "Y Axis",
names.arg = a,
col = "pink",
horiz = TRUE)
# Analisis de Componentes Principales
str(iris)

# Particionar los datos
set.seed(42)
ind <- sample(2, nrow(iris),
              replace = TRUE,
              prob = c(0.8, 0.2))
train <- iris[ind==1,]
test <- iris[ind==2,]

#install.packages("psych")
library(psych)

pairs.panels(train[,-5],
             gap = 0,
             bg = c("blue", "yellow", "red")[train$Species],
             pch = 21)

# Componentes principales
pc <- prcomp(train[, -5],
             center = TRUE,
             scale. = TRUE)

attributes(pc)  
pc$scale
print(pc)
summary(pc)

pairs.panels(pc$x,
             gap=0,
             bg=c("red", "blue", "green")[train$Species],
             pch = 21)

###################################
# Predicción
pred <- predict(pc, train)
class(pred)
training <- data.frame(pred, train[5])
testing <- predict(pc, test)
testing <- data.frame(testing, test[5])

library(nnet)
training$Species <- relevel(training$Species, ref = "setosa")
modelo <- multinom(Species ~ PC1 + PC2,
                   data = training)

summary(modelo)


prediccion <- predict(modelo, training)
tablita <- table(prediccion, training$Species)
1-sum(diag(tablita))/sum(tablita) # Tenemos un 7.8% de error de clasificación

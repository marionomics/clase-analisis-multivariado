library(tidyverse)

df <- read.csv("data/student-por.csv")
str(df)

df <- df %>%
  mutate(Grades = (G1+G2+G3)/3) %>%
  select(-G1, -G2, -G3)

df2 <- data.frame(model.matrix(~ . -1, data = df))



df_cor <- cor(df2,df2, 
              method = "pearson")

df_cor <- data.frame(cor = df_cor[1:40,41])
df_cor <- df_cor %>% 
  mutate(cor_abs = abs(cor))
plot(df_cor$cor_abs, type = "l")


df_cor$var <- rownames(df_cor)

ggplot(df_cor, aes(x = var, y = cor_abs))+
  geom_bar(stat = "identity")+
  coord_flip()



#################################################

df_cor <- df_cor %>% filter(cor_abs > 0.2)
df_filtrado <- df2 %>%
  select(Grades, one_of(df_cor$var))

library(psych) 
pairs.panels(df_filtrado,
             gap = 0,
             bg = c("blue", "yellow", "red")[df_filtrado$Grades],
             pch = 21)


##################################
lm(Grades ~., data = df_filtrado) %>%
  summary()


###################################

pca <- prcomp(df_filtrado[,-1],
       scale. = TRUE,
       center = TRUE)

summary(pca)
plot(pca)

pca_df <- data.frame(pca$x)
pca_df <- pca_df[,-c(7:8)]
pca_df$Grades <- df_filtrado$Grades



PCbiplot <- function(PC, x="PC1", y="PC2") {
  data <- data.frame( PC$x)
  plot <- ggplot(data, aes_string(x=x, y=y))
  datapc <- data.frame(varnames=row.names(PC$rotation), PC$rotation)
  mult <- min(
    (max(data[,y]) - min(data[,y])/(max(datapc[,y])-min(datapc[,y]))),
    (max(data[,x]) - min(data[,x])/(max(datapc[,x])-min(datapc[,x])))
  )
  datapc <- transform(datapc,
                      v1 = .7 * mult * (get(x)),
                      v2 = .7 * mult * (get(y))
  )
  plot <- plot + coord_equal() + geom_text(data=datapc, aes(x=v1, y=v2, label=varnames), size = 3, vjust=1, color="darkred")
  plot <- plot + geom_segment(data=datapc, aes(x=0, y=0, xend=v1, yend=v2), arrow=arrow(length=unit(0.2,"cm")), alpha=0.5, color="black")
  plot
}

PCbiplot(pca)

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

library(psych) 
pairs.panels(df2[,c(41,4:9)],
             gap = 0,
             bg = c("blue", "yellow", "red")[df$Grades],
             pch = 21)


#################################################


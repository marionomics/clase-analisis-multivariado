library(psych)

df_bfi <- bfi
head(df_bfi)
help(bfi)

prop.table(table(bfi$A1))

df_bfi <- df_bfi[complete.cases(df_bfi),]

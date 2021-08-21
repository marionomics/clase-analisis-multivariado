# Collider Bias

library(tidyverse)
tb <- tibble(
  female = ifelse(runif(10000)>0.5,1,0),
  ability = rnorm(10000),
  discrimination = female,
  occupation = 1 + 2*ability + 0*female - 2 * discrimination + rnorm(10000),
  wage = 1 - 1*discrimination + 1 * occupation + 2 * ability + rnorm(10000)
)
tb


modelo1 <- lm(wage ~ female, tb)
modelo2 <- lm(wage ~ female + occupation, tb)
modelo3 <- lm(wage ~ female + occupation + ability, tb)


library(stargazer)
stargazer(modelo1, modelo2, modelo3, type = "text",
          column.labels = c("Sesgado incondicional",
                            "Sesgado"))

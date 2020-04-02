# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # LIBRARIES # # # # # # # # # # # # # # # # # # # # # # #

library(shiny)
library(ggplot2)
library(matrixStats) # for rowSds
library(e1071) # the e1071 library contains implementations for a number of statistical learning methods.
library(boot) # for bootstrap
library(leaps) # for subset selection
library(randomForest)
library(shinyjs)
library(DT)

# # # # # # # # # # # # # # # # # # LIBRARIES # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
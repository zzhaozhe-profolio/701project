# set up: ---------------------------------------------------------------------
library(stringr)
library(lubridate)
library(data.table)
library(ggplot2)

# data: -----------------------------------------------------------------------
file = "~/Desktop/Math_Courses/Umich/701/701project/project.log"
log_dt = read.table(file=file, header = T)
log_dt = as.data.table(log_dt)

# violin plot: ----------------------------------------------------------------
log_dt=log_dt[1000:nrow(log_dt), ]
log_dt[, seir.R0_After:=seir.R0*seir.b]
log_dt[, seir.R0_Before:=seir.R0]
plot_log_dt = melt(log_dt, id.vars = c("Sample"), 
              measure.vars = c("seir.R0_Before", "seir.R0_After"),
              variable.name = "Time", value.name = "R0"
              )

ggplot(plot_log_dt, aes(x=Time, y=R0)) + 
  geom_violin(trim=FALSE) + geom_boxplot(width=0.1)

# Phylogenetics Tree: ---------------------------------------------------------
# installation
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("ggtree")
BiocManager::install("treeio")
library(ggtree)
library(treeio)

# read tree file
file = "~/Desktop/Math_Courses/Umich/701/701project/sum_trees"
beast <- read.beast(file)

# label tips
d = data.table(label = beast@phylo$tip.label)
d[, External:=grepl("_exog", label)]
tree=full_join(beast, d, by='label')
ggtree(tree) + geom_tippoint(aes(colour=External))




ggtree(beast) + geom_tiplab()


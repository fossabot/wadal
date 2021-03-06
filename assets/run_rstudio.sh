#!/usr/bin/env bash

# Configure s3fs
sudo su -l rstudio -c "echo -e $1:$2 > ~/.passwd-s3fs"
sudo su -l rstudio -c "chmod 600 ~/.passwd-s3fs"
sudo su -l rstudio -c "mkdir ~/works"
sudo su -l rstudio -c "/usr/local/bin/s3fs $3 /home/rstudio/works"

sudo su -l rstudio -c "cat << EOF > /home/rstudio/initSpark.R
.libPaths(c(.libPaths(), '/usr/lib/spark/R/lib')) 
Sys.setenv(SPARK_HOME = '/usr/lib/spark')
library(sparklyr)
sc <- spark_connect(master = 'yarn-client')
# Sys.setenv(SPARKR_SUBMIT_ARGS='\"sparkr-shell\"')
# library(SparkR, lib.loc = c(file.path(Sys.getenv(\"SPARK_HOME\"), \"R\", \"lib\")))
# sparkR.session(master = \"local[*]\", sparkEnvir = list(spark.driver.memory=\"11g\"))
EOF
"
# need to be here
sudo Rscript -e 'install.packages("sparklyr", repos = "http://cran.us.r-project.org")'

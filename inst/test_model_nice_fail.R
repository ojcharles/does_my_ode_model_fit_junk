#!/usr/bin/env Rscript

# arg is tempdir

# R script to run a potentially failing model fit, which results in a standard 0 or 1 response we can handle as error or not
args = commandArgs(trailingOnly=TRUE)


library(odejunkfitr)
library(nlmixr2)

tdir = args[1]

vl_data_loc = paste0(tdir, "/vl_data.csv")
vl_data = read.csv(vl_data_loc)

model_string = readLines(paste0(tdir, "/mod.txt"))
ode_function = eval(parse(text = model_string))

# print(head(vl_data))
# print(ode_function())


fit = tryCatch(
  expr = {
    setTimeLimit(elapsed = 20)
    nlmixr2::nlmixr(ode_function,
                    vl_data,
                    control = nlmixr2::saemControl(nBurn = 400, # we need to assume each model poorly fits initially.
                                                   print=0,seed = round(runif(1,1,100),0)),
                    est="saem")
                    
  #                   #longer burn does not improvefits!
  #                   control = nlmixr2::saemControl(print=0,
  #                                                  seed = round(runif(1,1,100),0)),
  #                                                  est="saem")
  
    }
  , error = function(e) {
    data.frame(v1 = "error")
  }
)

write_err = F
# error handling
if(fit[1,1] == "error"){
  write_err = T
}

if(ncol(fit) < 6){
  write_err = T
}

if(!typeof(fit) == "list"){
  write_err = T
}




if(write_err){
  writeLines("fail", paste0(tdir, "/fail"))
}else{
  saveRDS(fit, paste0(tdir,"/mod.rds"))
}

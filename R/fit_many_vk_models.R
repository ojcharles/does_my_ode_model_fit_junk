#' For a viral kinetic dataset in nlmixr format
#' This assesses how parsimoniously several viral kinetic models fit the data
#' Returned are AIC values. As parameter identifiability is also crucial the max,
#' mean, sd of the RSE% for populations parameter estiamates are returned also.
#' @param vl_data nlmixr formatted viral load data with or without drug admininstrations
#' @param num_fit_attempts for each model, the number or attempts at fitting with random init pop parameter vectors 
#' @return Table outlining AIC and RSE comparisons of the viral load models
#' @export


#'# dev
# library(odejunkfitr)
# odejunkfitr::load_examples()
# vl_data = data2_cmv_untreated
# num_fit_attempts = 20
# i = 31
# outfile = "t.csv

fit_many_vk_models = function(vl_data = data2_cmv_untreated, 
                              num_fit_attempts = 5,
                              outfile = "t.csv"){
  tdir = tempdir()
  write.csv(vl_data, paste0(tdir,"/vl_data.csv"),row.names = F)

  
  # load the modelling options to run
  model_handler = read.csv(system.file("all_vk_models.csv", package = "odejunkfitr"))
  model_handler$shortname = ""
  
  model_handler$AIC = 0       # parsimonious
  model_handler$`RSE_mean` = 0  # param identifiability
  model_handler$`RSE_max` = 0  # param identifiability
  model_handler$`RSE_sd` = 0  # param identifiability
  
  
  # for each model & fixed param combination.
  for(i in 1:nrow(model_handler)){
    print(paste("i = ", i))
    model_name = model_handler[i,1]
    model_handler$shortname[i] = paste0(model_handler[i,2:6],collapse = "")
    model_function = eval(parse(text = paste0("odejunkfitr::", model_name)))
    model_string = model_function(model_handler[i,2],
                                  model_handler[i,3],
                                  model_handler[i,4],
                                  model_handler[i,5],
                                  model_handler[i,6])
    # write model string to temp file
    writeLines(text = model_string,con = paste0(tdir, "/mod.txt"))
    
    ode_function = eval(parse(text = model_string))
    # attempt 5 fits with random init param values, and starting seed.
    fit_list = list()
    fit_attempts = paste0("fit", 1:num_fit_attempts)
    for(f in fit_attempts){
      print(paste("i = ", i, "fit = ", f))
      # run model fit. if it takes too long we assume the initial estimates were poor and the job is killed
      
      
      ### handle timeouts and errors
      # remove success files from previous if present
      suppressWarnings(file.remove(paste0(tdir, "/mod.rds")))
      suppressWarnings(file.remove(paste0(tdir, "/fail")))
      
      # the error handling with timeouts is so unpleasant we need to run it as a system call. cant even rely on 1 or 0 return!
      # we look instead for presence of a fail file
      command = paste0("Rscript inst/test_model_nice_fail.R ", tdir )
      system(command,ignore.stderr = T,ignore.stdout = T)
      
      if(file.exists(paste0(tdir, "/fail"))){next}
      if(! file.exists(paste0(tdir, "/mod.rds"))){next} # something else occurred
      
      
      fit = readRDS(paste0(tdir, "/mod.rds"))

      fit_list[[f]] = fit
    }
    
    # which fit had the lowest AIC?
    best_fit_AIC = 9999999999999999
    best_fit = "0"
    for(f in fit_attempts){
      # if errored / timed out
      if( is.null(fit_list[[f]]) ){next}
      # if AIC calculation is going to be intense
      if( IQR(fit$parFixedDf$`RSE`,na.rm = T) > 50000 ){next}
      tAIC = suppressMessages( # not all solutions can return AIC, simply skip those than cannot
        tryCatch({
          fit_list[[f]]$AIC
        }, error = function(e) {
          return(9999999999999999)
        })
      )
      #print(tAIC)
      if(tAIC < best_fit_AIC){
        best_fit_AIC = tAIC
        best_fit = f
      }
    }
    
    # if all are terrible just assume fit is fine
    if(best_fit == "0"){
      # model never converged
      model_handler$AIC[i] = 9999
      model_handler$`RSE_max`[i] = 9999
      model_handler$`RSE_mean`[i] = 9999
      model_handler$`RSE_sd`[i] = 9999
    }else{
      fit = fit_list[[best_fit]] 
      saveRDS(fit, paste0("temp/bestfit_",i,".rds")) # save fit RDS and return list of best fit rds later?
      tAIC = suppressMessages(round(fit$AIC,2))
      print(paste0("AIC:", tAIC, " - Model:", model_name, " - Fixed vector:", paste0(model_handler[i,2:6],collapse = "")))
      model_handler$AIC[i] = tAIC
      model_handler$`RSE_max`[i] = round(max(fit$parFixedDf$`RSE`,na.rm = T),2)
      model_handler$`RSE_mean`[i] = round(mean(fit$parFixedDf$`RSE`,na.rm = T),2)
      model_handler$`RSE_sd`[i] = round(sd(fit$parFixedDf$`RSE`,na.rm = T),2)
    }
    write.csv(model_handler, outfile)
  }


  
  return(model_handler)
}





#' For a viral kinetic dataset in nlmixr format
#' This assesses how parsimoniously several viral kinetic models fit the data
#' Returned are AIC values. As parameter identifiability is also crucial the max,
#' mean, sd of the RSE% for populations parameter estiamates are returned also.
#' @param vl_data nlmixr formatted viral load data with or without drug admininstrations
#' @param num_fit_attempts for each model, the number or attempts at fitting with random init pop parameter vectors 
#' @return Table outlining AIC and RSE comparisons of the viral load models
#' @export
#'
fit_many_vk_models = function(vl_data = data2_cmv_untreated, 
                              num_fit_attempts = 5){

  
  # load the modelling options to run
  model_handler = read.csv(system.file("all_vk_models.csv", package = "odejunkfitr"))
  model_handler$shortname = ""
  
  model_handler$AIC = 0       # parsimonious
  model_handler$`%RSE_mean` = 0  # param identifiability
  model_handler$`%RSE_max` = 0  # param identifiability
  model_handler$`%RSE_sd` = 0  # param identifiability
  
  
  # for each model & fixed param combination.
  for(i in 1:nrow(model_handler)){
    model_name = model_handler[i,1]
    model_handler$shortname[i] = paste0(model_handler[i,2:6],collapse = "")
    model_function = get(model_name)
    model_string = model_function(model_handler[i,2],
                                  model_handler[i,3],
                                  model_handler[i,4],
                                  model_handler[i,5],
                                  model_handler[i,6])
    ode_function = ode_string_to_function(model_string)
  
    # attempt 5 fits with random init param values, and starting seed.
    fit_list = list()
    fit_attempts = paste0("fit", 1:num_fit_attempts)
    for(f in fit_attempts){
      # run model fit.
      fit = suppressWarnings(suppressMessages(
        nlmixr(ode_function,
               vl_data,
               control = saemControl(print=0,seed = round(runif(1,1,100),0)), est="saem")
      ))
      fit_list[[f]] = fit
    }
  
    # which fit had the lowest AIC?
    best_fit_AIC = 9999999999999999
    best_fit = 0
    for(f in fit_attempts){
      tAIC = suppressMessages(fit_list[[f]]$AIC)
      #print(tAIC)
      if(tAIC < best_fit_AIC){
        best_fit_AIC = tAIC
        best_fit = f
      }
    }
    
    fit = fit_list[[best_fit]]
  
    tAIC = suppressMessages(round(fit$AIC,2))
    print(paste0("AIC:", tAIC, " - Model:", model_name, " - Fixed vector:", paste0(model_handler[i,2:6],collapse = "")))
    model_handler$AIC[i] = tAIC
    model_handler$`%RSE_max`[i] = round(max(fit$parFixedDf$`%RSE`,na.rm = T),2)
    model_handler$`%RSE_mean`[i] = round(mean(fit$parFixedDf$`%RSE`,na.rm = T),2)
    model_handler$`%RSE_sd`[i] = round(sd(fit$parFixedDf$`%RSE`,na.rm = T),2)
  }

  
  return(model_handler)
}

# # Takes a dataframe and a model.
# #
# # Each model in this list has its initial parameter values set to match those of a cmv untreated trajectory.
# # As input data can be in whichever frame of reference, we normalise the input table to match the training cmv data
# # We can then fit models to something that is more like the training data.
# # allowing 5 random attempts at fitting, using 5 raandom intial parameter vectors draws from runif.
# # We take the best fit, and store its params.
# # We then increase the x axis to slowly in turn over 5 steps to match input data, passing params.
# # This is repeated for y, unstil the outcome parameters match the input data.
# #
# # 1 - scale   2 - fit 3 - shift x toward input, pass params recursive. 4 - repeat for y - 5 done.
# 
# 
# # example from: https://doi.org/10.1111/bcp.15518
# example_in = read.csv(system.file("sars.csv", package = "odejunkfitr"))
# 
# handle_anything = function(){
# 
# }




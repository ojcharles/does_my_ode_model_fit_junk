# functions

#' load function to memory
#' definitely no security risks here..  //todo
#'
#' Simply handles whether the model can compile via nlmixr
#'
#' @param ode_function_string string defining nlmixr compatible ode
#' @return String of "error" or "pass"
#' @export
ode_string_to_function = function(ode_function_string){
  eval(parse( text = paste("m = ", text = ode_function_string)))
}







#' does_model_compile
#'
#' Simply handles whether the model can compile via nlmixr
#'
#' @param ode_function nlmixr compatible ode function
#' @return String of "error" or "pass"
#' @export

does_model_compile = function(ode_function){
  x <- tryCatch(
    {
      b = nlmixr::nlmixr(ode_function)
    },
    error = function(e){
      return("error")
    }
  )
  if(length(x) > 2){
    return("pass")
  }else{
    return("error")
  }
}

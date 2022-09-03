#' load all examples to memory
#'
#' @return data and models to global env
#' @export
#' 
load_examples = function(){
  ##### data
  data1_theo_sd <<- nlmixr2data::theo_sd
  
  data2_cmv_untreated <<-  read.csv("inst/2020_duke_viral.csv")
  
  
  ##### models
  model1_theo_sd <<- "function() {
  ini({
    tka <- 0.45
    tcl <- log(c(0, 2.7, 100))
    tv <- 3.45
    eta.ka ~ 0.6
    eta.cl ~ 0.3
    eta.v ~ 0.1
    add.sd <- 0.7
  })
  model({
    ka <- exp(tka + eta.ka)
    cl <- exp(tcl + eta.cl)
    v <- exp(tv + eta.v)
    linCmt() ~ add(add.sd)
  })
}"
  
  
  
  
  
  model2_viral_kinetic_2cmp <<-
    "function() {
    ini({
      trv = -1.8
      tom = -9
      tdE = -3
      tvirion = 1.5
      eta.om ~ 3
      eta.dE ~ 1.4
      eta.rv ~ 0.3
      eta.virion ~ 1
      
      
      add.sd = 10
    })
    model({
      rv = exp(trv + eta.rv)
      om = exp(tom + eta.om)
      dE = exp(tdE + eta.dE)
      v0 = exp(tvirion + eta.virion)
      
      immune(0) = 0
      virion(0) = v0
      
      d/dt(virion) = rv * virion - immune * virion
      d/dt(immune) = om * virion - dE * immune
      
      
      vt = log(virion)
      vt ~ add(add.sd)
    })
  }"
  
  return(":)")
}














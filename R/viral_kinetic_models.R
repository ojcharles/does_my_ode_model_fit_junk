# Functions that generate ODE viral kinetic model functions strings
# these strings can be consumed by nlmixr
# The initial parameter esimates and randomly selected each time a functions is run.
# They are loosely tunes to fix the example CMV untreated trajectories


##### load model frameworks

##### Model with Target Cell Limitation and Implicit, Static Immune Control (TC, No EIS)
#' m1_MwTCLESIC
#' @return VK nlmixr function string
#' @export
m1_MwTCLESIC = function(fix_dS = F, fix_V_v = F, fix_dI = F, fix_dE = F, fix_gamma = F){
  m = "function() {
    ini({
      add.err = 1
      tbeta = runif(1,0,6)
      eta.beta ~ 1
      tgamma = runif(1,-10,0)
      eta.gamma ~ 1
      tdelta_S = runif(1,-5,1)
      eta.delta_S ~ 1
      tdelta_I = runif(1,-5,0)
      eta.delta_I ~ 1
      tS_v = runif(1,0,4)
      eta.S_v ~ 1
      tI_v = runif(1,0,4)
      eta.I_v ~ 1
      tV_v = runif(1,-4,4)
      eta.V_v ~ 1
    })
    model({
      beta = exp(tbeta + eta.beta)
      gamma = exp(tgamma + eta.gamma)
      delta_S = exp(tdelta_S + eta.delta_S)
      delta_I = exp(tdelta_I + eta.delta_I)
      S_v(0) = exp(tS_v + eta.S_v)
      I_v(0) = exp(tI_v + eta.I_v)
      V_v(0) = exp(tV_v + eta.V_v)
      d/dt(S_v) = gamma - delta_S * S_v - ( beta * V_v * S_v )
      d/dt(I_v) = beta * V_v * S_v - delta_I * I_v
      d/dt(V_v) = 3.141593 * I_v - gamma * V_v
      VL = log(V_v)
      VL ~ add(add.err)       # define error model
    })
  }"
  if(fix_dS){
    m = gsub("tdelta_S = runif(1,-5,1)","",m,fixed = T)
    m = gsub("eta.delta_S ~ 1","",m)
    m = gsub("delta_S = exp(tdelta_S + eta.delta_S)","delta_S = 0",m,fixed = T)
  }
  if(fix_dI){
    m = gsub("tdelta_I = runif(1,-5,0)","",m,fixed = T)
    m = gsub("eta.delta_I ~ 1","",m)
    m = gsub("delta_I = exp(tdelta_I + eta.delta_I)","delta_I = 0",m,fixed = T)
  }
  if(fix_V_v){
    m = gsub("tV_v = runif(1,-4,4)","",m,fixed = T)
    m = gsub("eta.V_v ~ 1","",m)
    m = gsub("V_v(0) = exp(tV_v + eta.V_v)","V_v(0) = 0",m,fixed = T)
  }
  if(fix_gamma){
    m = gsub("tgamma = runif(1,-10,0)","",m,fixed = T)
    m = gsub("eta.gamma ~ 1","",m)
    m = gsub("gamma = exp(tgamma + eta.gamma)","gamma = 0",m,fixed = T)
  }
  return(m)
}



##### Model with Target Cell Limitation and an Explicit, Dynamic Immune System (TC, EIS)
#' m2_MwTCLEDIS
#' @return VK nlmixr function string
#' @export
m2_MwTCLEDIS = function(fix_dS = F, fix_E_v = F, fix_dI = F, fix_dE = F, fix_gamma = F){
  m = "function() {
    ini({
    tbeta = runif(1,-4,0)
    eta.beta ~ 1
    tgamma = runif(1,-3,1)
    eta.gamma ~ 1
    tom = runif(1,-7,-3)
    eta.om ~ 1
    tk = runif(1,-7,-3)
    eta.k ~ 1
    tdelta_S = runif(1,-2,2)
    eta.delta_S ~ 1
    tdelta_I = runif(1,-2,2)
    eta.delta_I ~ 1
    tdelta_E = runif(1,-4,0)
    eta.delta_E ~ 1
    tS_v = runif(1,0,4)
    eta.S_v ~ 1
    tI_v = runif(1,0,4)
    eta.I_v ~ 1
    tE_v = runif(1,0,4)
    eta.E_v ~ 1
    tV_v = runif(1,0,4)
    eta.V_v ~ 1
    add.err = 1
    })
    model({
      beta = exp(tbeta + eta.beta)
      gamma = exp(tgamma + eta.gamma)
      om = exp(tom + eta.om)
      k = exp(tk + eta.k)
      delta_S = exp(tdelta_S + eta.delta_S)
      delta_I = exp(tdelta_I + eta.delta_I)
      delta_E = exp(tdelta_E + eta.delta_E)
      S_v(0) = exp(tS_v + eta.S_v)
      I_v(0) = exp(tI_v + eta.I_v)
      E_v(0) = exp(tE_v + eta.E_v)
      V_v(0) = exp(tV_v + eta.V_v)
      d/dt(S_v) = gamma - delta_S * S_v - ( beta * V_v * S_v )
      d/dt(I_v) = beta * V_v * S_v - delta_I * I_v - ( k * I_v * E_v )  # Infected cell
      d/dt(V_v) = 3.141593 * I_v - gamma * V_v                               # virus
      d/dt(E_v) = om * V_v - delta_E * E_v                             # immune cell
      VL = log(V_v)
      VL ~ add(add.err)       # define error model
    })
  }"
  if(fix_dS){
    m = gsub("tdelta_S = runif(1,-2,2)","",m,fixed = T)
    m = gsub("eta.delta_S ~ 1","",m)
    m = gsub("delta_S = exp(tdelta_S + eta.delta_S)","delta_S = 0",m,fixed = T)
  }
  if(fix_dI){
    m = gsub("tdelta_I = runif(1,-2,2)","",m,fixed = T)
    m = gsub("eta.delta_I ~ 1","",m)
    m = gsub("delta_I = exp(tdelta_I + eta.delta_I)","delta_I = 0",m,fixed = T)
  }
  if(fix_dE){
    m = gsub("tdelta_E = runif(1,-4,0)","",m,fixed = T)
    m = gsub("eta.delta_E ~ 1","",m)
    m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
  }
  if(fix_E_v){
    m = gsub("tE_v = runif(1,0,4)","",m,fixed = T)
    m = gsub("eta.E_v ~ 1","",m)
    m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
  }
  if(fix_gamma){
    m = gsub("tgamma = runif(1,-3,1)","",m,fixed = T)
    m = gsub("eta.gamma ~ 1","",m)
    m = gsub("gamma = exp(tgamma + eta.gamma)","gamma = 0",m,fixed = T)
  }
  return(m)
}



##### Explicit, Dynamic Immune Control Model without Target Cell Limitation (EIS, No TC)
#' m3_EDICwTCL
#' @return VK nlmixr function string
#' @export
m3_EDICwTCL = function(fix_dE = F, fix_E_v = F, fix_dI = F, ...){
  m = "function() {
    ini({
      add.err = 1
      tbeta = runif(1,-5,0)
      eta.beta ~ 5
      tom = runif(1,-5,0)
      eta.om ~ 5
      tk = runif(1,-5,1)
      eta.k ~ 2
      tgamma = runif(1,-5,0)
      eta.gamma ~ 5
      tdelta_E = runif(1,-10,-4)
      eta.delta_E ~ 1
      tdelta_I = runif(1,-4,0)
      eta.delta_I ~ 1
      tI_v = runif(1,0,4)
      eta.I_v ~ 5
      tE_v = runif(1,-2,4)
      eta.E_v ~ 5
      tV_v = runif(1,-2,4)
      eta.V_v ~ 5
    })
    model({
      beta = exp(tbeta + eta.beta)
      gamma = exp(tgamma + eta.gamma)
      om = exp(tom + eta.om)
      k = exp(tk + eta.k)
      delta_I = exp(tdelta_I + eta.delta_I)
      delta_E = exp(tdelta_E + eta.delta_E)
      I_v(0) = exp(tI_v + eta.I_v)
      E_v(0) = exp(tE_v + eta.E_v)
      V_v(0) = exp(tV_v + eta.V_v)
      d/dt(I_v) = beta * V_v - delta_I * I_v - ( k * I_v * E_v )  # Infected cell
      d/dt(V_v) = 3.141593 * I_v - gamma * V_v                               # virus
      d/dt(E_v) = om * V_v - delta_E * E_v                             # immune cell
      VL = log(V_v)
      VL ~ add(add.err)       # define error model
    })
  }"
  if(fix_dE){
    m = gsub("tdelta_E = runif(1,-10,-4)","",m,fixed = T)
    m = gsub("eta.delta_E ~ 1","",m)
    m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
  }
  if(fix_dI){
    m = gsub("tdelta_I = runif(1,-4,0)","",m,fixed = T)
    m = gsub("eta.delta_I ~ 1","",m)
    m = gsub("delta_I = exp(tdelta_I + eta.delta_I)","delta_I = 0",m,fixed = T)
  }
  if(fix_E_v){
    m = gsub("tE_v = runif(1,-2,4)","",m,fixed = T)
    m = gsub("eta.E_v ~ 5","",m)
    m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
  }
  return(m)
}

#' m4_EDICwTCL
#' @return VK nlmixr function string
#' @export
m4_EDICwTCL = function(fix_dE = F, fix_E_v = F, ...){
  m = "function() {
    ini({
      add.err = 1
      tbeta = runif(1,-10,-2)
      eta.beta ~ 2
      tom = runif(1,-20,-5)
      eta.om ~ 2
      tgamma = runif(1,-8,-2)
      eta.gamma ~ 2
      tdelta_E = runif(1,-1,1)
      eta.delta_E ~ 1
      tdelta_I = runif(1,-1,1)
      eta.delta_I ~ 1
      tk = runif(1,-20,-5)
      eta.k ~ 2
      tI_v = runif(1,0,4)
      eta.I_v ~ 5
      tE_v = runif(1,0,4)
      eta.E_v ~ 2
      tV_v = runif(1,0,4)
      eta.V_v ~ 2
    })
    model({
      beta = exp(tbeta + eta.beta)
      gamma = exp(tgamma + eta.gamma)
      om = exp(tom + eta.om)
      delta_I = exp(tdelta_I + eta.delta_I)
      delta_E = exp(tdelta_E + eta.delta_E)
      k = exp(tk + eta.k)
      I_v(0) = exp(tI_v + eta.I_v)
      E_v(0) = exp(tE_v + eta.E_v)
      V_v(0) = exp(tV_v + eta.V_v)
      d/dt(I_v) = beta * V_v - delta_I * I_v - ( k * I_v * E_v )
      d/dt(V_v) = I_v - gamma * V_v                              
      d/dt(E_v) = om * V_v - delta_E * E_v                       
      VL = log(V_v)
      VL ~ add(add.err) 
    })
  }"
  if(fix_dE){
    m = gsub("tdelta_E = runif(1,-1,1)","",m,fixed = T)
    m = gsub("eta.delta_E ~ 1","",m)
    m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
  }
  if(fix_E_v){
    m = gsub("tE_v = runif(1,0,4)","",m,fixed = T)
    m = gsub("eta.E_v ~ 2","",m)
    m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
  }
  return(m)
}

#' m5_EDICwTCL
#' @return VK nlmixr function string
#' @export
m5_EDICwTCL = function(fix_dE = F, fix_E_v = F, ...){
  m = "function() {
    ini({
      add.err = 1
      tbeta = runif(1,-6,0)
      eta.beta ~ 5
      tom = runif(1,-4,1)
      eta.om ~ 1
      tgamma = runif(1,-8,-2)
      eta.gamma ~ 5
      tdelta_E = runif(1,-4,0)
      eta.delta_E ~ 1
      tdelta_I = runif(1,-4,0)
      eta.delta_I ~ 1
      tI_v = runif(1,0,4)
      eta.I_v ~ 5
      tE_v = runif(1,0,4)
      eta.E_v ~ 5
      tV_v = runif(1,0,4)
      eta.V_v ~ 5
    })
    model({
      beta = exp(tbeta + eta.beta)
      gamma = exp(tgamma + eta.gamma)
      om = exp(tom + eta.om)
      delta_I = exp(tdelta_I + eta.delta_I)
      delta_E = exp(tdelta_E + eta.delta_E)
      I_v(0) = exp(tI_v + eta.I_v)
      E_v(0) = exp(tE_v + eta.E_v)
      V_v(0) = exp(tV_v + eta.V_v)
      d/dt(I_v) = beta * V_v - delta_I * I_v - ( I_v * E_v )  # Infected cell
      d/dt(V_v) = I_v - gamma * V_v                               # virus
      d/dt(E_v) = om * V_v - delta_E * E_v                             # immune cell
      VL = log(V_v)
      VL ~ add(add.err)       # define error model
    })
  }"
  if(fix_dE){
    m = gsub("tdelta_E = runif(1,-4,0)","",m,fixed = T)
    m = gsub("eta.delta_E ~ 1","",m)
    m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
  }
  if(fix_E_v){
    m = gsub("tE_v = runif(1,0,4)","",m,fixed = T)
    m = gsub("eta.E_v ~ 5","",m)
    m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
  }
  return(m)
}

#' m6_EDICwTCL
#' @return VK nlmixr function string
#' @export
m6_EDICwTCL = function(fix_dI = F, fix_dE = F, fix_E_v = F, fix_V_v = F, ...){
  m = "function() {
    ini({
      add.err = 1
      tbeta = runif(1,-5,1)
      eta.beta ~ 1
      tk = runif(1,-14,-2)
      eta.k ~ 1
      tgamma = runif(1,-6,0)
      eta.gamma ~ 1
      tdelta_E = runif(1,-2,2)
      eta.delta_E ~ 1
      tdelta_I = runif(1,-3,2)
      eta.delta_I ~ 1
      tI_v = runif(1,0,4)
      eta.I_v ~ 1
      tE_v = runif(1,0,4)
      eta.E_v ~ 1
      tV_v = runif(1,0,4)
      eta.V_v ~ 1
    })
    model({
      beta = exp(tbeta + eta.beta)
      gamma = exp(tgamma + eta.gamma)
      k = exp(tk + eta.k)
      delta_I = exp(tdelta_I + eta.delta_I)
      delta_E = exp(tdelta_E + eta.delta_E)
      I_v(0) = exp(tI_v + eta.I_v)
      E_v(0) = exp(tE_v + eta.E_v)
      V_v(0) = exp(tV_v + eta.V_v)
      d/dt(I_v) = beta * V_v - delta_I * I_v - ( k * I_v * E_v )  # Infected cell
      d/dt(V_v) = I_v - gamma * V_v                               # virus
      d/dt(E_v) = V_v - delta_E * E_v                             # immune cell
      VL = log(V_v)
      VL ~ add(add.err)       # define error model
    })
  }"
  if(fix_dI){
    m = gsub("tdelta_I = runif(1,-3,2)","",m,fixed = T)
    m = gsub("eta.delta_I ~ 1","",m)
    m = gsub("delta_I = exp(tdelta_I + eta.delta_I)","delta_I = 0",m,fixed = T)
  }
  if(fix_dE){
    m = gsub("tdelta_E = runif(1,-2,2)","",m,fixed = T)
    m = gsub("eta.delta_E ~ 1","",m)
    m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
  }
  if(fix_E_v){
    m = gsub("tE_v = runif(1,0,4)","",m,fixed = T)
    m = gsub("eta.E_v ~ 1","",m)
    m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
  }
  if(fix_V_v){
    m = gsub("tV_v = runif(1,0,4)","",m,fixed = T)
    m = gsub("eta.V_v ~ 1","",m)
    m = gsub("V_v(0) = exp(tV_v + eta.V_v)","V_v(0) = 1",m,fixed = T)
  }
  return(m)
}



##### Semi-Mechanistic, Explicit Immune Control Model (VE)

#' m7_SMEIMCs
#' @return VK nlmixr function string
#' @export
m7_SMEIMCs = function(fix_E0 = T, fix_dE = T, ...){
  m = "function() {
  ini({
    trv = runif(1,-6,0)
    tk_hat = runif(1,-14,-1)
    tom = runif(1,-14, -1)
    tdE = runif(1, -14, -1)
    tvirus = runif(1,-2,2)
    tE0 = runif(1,-6,1)
    eta.k_hat ~ 2
    eta.om ~ 2
    eta.dE ~ 2
    eta.rv ~ 2
    eta.virus ~ 2
    eta.E0 ~ 2

    add.sd = 10

  })
  model({
    rv = exp(trv + eta.rv)
    k_hat = exp(tk_hat + eta.k_hat)
    om = exp(tom + eta.om)
    dE = exp(tdE + eta.dE)
    v0 = exp(tvirus + eta.virus)
    E0 = exp(tE0 + eta.E0)

    immune(0) = E0
    virus(0) = v0

    d/dt(virus) = rv * virus - k_hat * immune * virus
    d/dt(immune) = om * virus - dE * immune


    VL = log(virus)
    VL ~ add(add.sd)
  })
}"
  
  if(fix_E0){
    m = gsub("tE0 = runif(1,-6,1)","",m,fixed = T)
    m = gsub("eta.E0 ~ 2","",m)
    m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m,fixed = T)
  }
  if(fix_dE){
    m = gsub("tdE = runif(1, -14, -1)","",m,fixed = T)
    m = gsub("eta.dE ~ 2","",m)
    m = gsub("dE = exp(tdE + eta.dE)","dE = 0",m,fixed = T)
  }
  return(m)
}

#' m8_SMEIMCs
#' @return VK nlmixr function string
#' @export
m8_SMEIMCs = function(fix_E0 = T, ...){
  m = paste0("function() {
  ini({
    trv = runif(1,-6,1)
    tk_hat = runif(1,-12,-4)
    tdE = runif(1,-6,0)
    tvirus = runif(1,-6,2)
    tE0 = runif(1,-6,0)
    eta.k_hat ~ 2
    eta.dE ~ 2
    eta.rv ~ 2
    eta.virus ~ 2
    eta.E0 ~ 2

    add.sd = 10

  })
  model({
    rv = exp(trv + eta.rv)
    dE = exp(tdE + eta.dE)
    k_hat = exp(tk_hat + eta.k_hat)
    v0 = exp(tvirus + eta.virus)
    E0 = exp(tE0 + eta.E0)

    immune(0) = E0
    virus(0) = v0

    d/dt(virus) = rv * virus - k_hat * immune * virus
    d/dt(immune) = virus - dE * immune

    VL = log(virus)
    VL ~ add(add.sd)
  })
}")
  
  if(fix_E0){
    m = gsub("tE0 = runif(1,-6,0)","",m,fixed = T)
    m = gsub("eta.E0 ~ 2","",m,fixed = T)
    m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  }
  return(m)
}

#' m9_SMEIMCs
#' @return VK nlmixr function string
#' @export
m9_SMEIMCs = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    trv = runif(1,-6,1)
    tom = runif(1,-12, -4)
    tdE = runif(1,-10, -2)
    tvirus = runif(1,-2, 2)
    tE0 = runif(1,-6,1)
    eta.om ~ 2
    eta.dE ~ 2
    eta.rv ~ 2
    eta.virus ~ 1
    eta.E0 ~ 2

    add.sd = 10
  })
  model({
    rv = exp(trv + eta.rv)
    om = exp(tom + eta.om)
    dE = exp(tdE + eta.dE)
    v0 = exp(tvirus + eta.virus)
    E0 = exp(tE0 + eta.E0)

    immune(0) = E0
    virus(0) = v0

    d/dt(virus) = rv * virus - immune * virus
    d/dt(immune) = om * virus - dE * immune

    VL = log(virus)
    VL ~ add(add.sd)
  })
}"
  
  if(fix_E0){
    m = gsub("tE0 = runif(1,-6,1)","",m,fixed = T)
    m = gsub("eta.E0 ~ 2","",m,fixed = T)
    m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  }
  return(m)
}



##### SARS-CoV-2 Target Cell Limited Models

#' m10_SARSTCLM
#' @return VK nlmixr function string
#' @export
m10_SARSTCLM = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    tbeta = runif(1,-10,-2)
    tro = runif(1,-6, -0)
    tc = runif(1,-20, -2)
    td = runif(1,-4,3)
    tvirus = runif(1,-2, 2)
    tinfected = runif(1,0, 6)
    ttarget = runif(1,0, 6)

    eta.ro ~ 2
    eta.d ~ 2
    eta.beta ~ 2
    eta.virus ~ 1
    eta.infected ~ 1
    eta.target ~ 1
    eta.c ~ 2

    add.sd = 10
  })
  model({
    beta = exp(tbeta + eta.beta)
    ro = exp(tro + eta.ro)
    c = exp(tc + eta.c)
    d = exp(td + eta.d)
    virus0 = exp(tvirus + eta.virus)
    infected0 = exp(tinfected + eta.infected)
    target0 = exp(ttarget + eta.target)
    
    target(0) = target0
    infected(0) = infected0
    virus(0) = virus0

    d/dt(target) = - beta * virus * target
    d/dt(virus) = ro * infected - c * virus
    d/dt(infected) = beta * virus * target - d * infected

    VL = log(virus)
    VL ~ add(add.sd)
  })
}"
  
  # if(fix_E0){
  #   m = gsub("tE0 = runif(1,-6,1)","",m,fixed = T)
  #   m = gsub("eta.E0 ~ 2","",m,fixed = T)
  #   m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  # }
  return(m)
}

#' m11_SARSTCLM - simplified
#' @return VK nlmixr function string
#' @export
m11_SARSTCLM = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    tbeta = runif(1,-6,1)
    tgamma = runif(1,-12, -4)
    td = runif(1,-6,1)
    tvirus = runif(1,-2, 2)
    tuninfected_frac = runif(1,-2, 2)

    eta.beta ~ 2
    eta.gamma ~ 2
    eta.d ~ 2
    eta.virus ~ 1
    eta.uninfected_frac ~ 1

    add.sd = 10
  })
  model({
    beta = exp(tbeta + eta.beta)
    gamma = exp(tgamma + eta.gamma)
    d = exp(td + eta.d)
    virus0 = exp(tvirus + eta.virus)
    uninfected_frac0 = exp(tuninfected_frac + eta.uninfected_frac)
    
    uninfected_frac(0) = uninfected_frac0
    virus(0) = virus0

    d/dt(uninfected_frac) = - beta * uninfected_frac * virus
    d/dt(virus) = gamma * uninfected_frac * virus - d * virus

    VL = log(virus)
    VL ~ add(add.sd)
  })
}"
  
  # if(fix_E0){
  #   m = gsub("tE0 = runif(1,-6,1)","",m,fixed = T)
  #   m = gsub("eta.E0 ~ 2","",m,fixed = T)
  #   m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  # }
  return(m)
}



##### SARS-CoV-2 Target Cell Limited Models with eclipse phase

#' m12_SARSTCLMwEP
#' @return VK nlmixr function string
#' @export
m12_SARSTCLMwEP = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    tbeta = runif(1,-10,-2)
    tro = runif(1,-6, -0)
    tc = runif(1,-20, -2)
    td = runif(1,-4,3)
    tk = runif(1,-4,3)
    tvirus = runif(1,-2, 2)
    tinfected_eclipse = runif(1,0, 6)
    tinfected_lytic = runif(1,0, 6)
    ttarget = runif(1,0, 6)

    eta.ro ~ 2
    eta.d ~ 2
    eta.beta ~ 2
    eta.k ~ 1
    eta.virus ~ 1
    eta.infected_eclipse ~ 1
    eta.infected_lytic ~ 1
    eta.target ~ 1
    eta.c ~ 2

    add.sd = 10
  })
  model({
    beta = exp(tbeta + eta.beta)
    ro = exp(tro + eta.ro)
    c = exp(tc + eta.c)
    d = exp(td + eta.d)
    k = exp(tk + eta.k)
    virus0 = exp(tvirus + eta.virus)
    infected_eclipse0 = exp(tinfected_eclipse + eta.infected_eclipse)
    infected_lytic0 = exp(tinfected_lytic + eta.infected_lytic)
    target0 = exp(ttarget + eta.target)
    
    target(0) = target0
    infected_eclipse(0) = infected_eclipse0
    infected_lytic(0) = infected_lytic0
    virus(0) = virus0

    d/dt(target) = - beta * virus * target
    d/dt(infected_eclipse) = beta * virus * target - k * infected_eclipse
    d/dt(infected_lytic) = k * infected_eclipse - d * infected_lytic
    d/dt(virus) = ro * infected_lytic - c * virus - beta * virus * target
    
    VL = log(virus)
    VL ~ add(add.sd)
  })
}"
  
  # if(fix_E0){
  #   m = gsub("tE0 = runif(1,-6,1)","",m,fixed = T)
  #   m = gsub("eta.E0 ~ 2","",m,fixed = T)
  #   m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  # }
  return(m)
}



##### SARS-CoV-2 Target Cell Limited Models with Immune Effector

#' m13_SARSTCLMwImmune   immune  recovers target cells
#' @return VK nlmixr function string
#' @export
m13_SARSTCLMwImmune = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    tbeta = runif(1,-10,-2)
    tro = runif(1,-6, -0)
    tc = runif(1,-20, -2)
    td = runif(1,-4,3)
    tk = runif(1,-4,3)
    tvphi = runif(1,-4,3)
    tvtheta = runif(1,-4,3)
    tdImm = runif(1,-4,1)
    tvirus = runif(1,-2, 2)
    tinfected_eclipse = runif(1,0, 6)
    tinfected_lytic = runif(1,0, 6)
    ttarget = runif(1,0, 6)
    tImmuneEffector = runif(1,0,6)

    eta.ro ~ 2
    eta.d ~ 2
    eta.beta ~ 2
    eta.k ~ 1
    eta.vphi ~ 1
    eta.vtheta ~ 1
    eta.dImm ~ 1
    eta.virus ~ 1
    eta.infected_eclipse ~ 1
    eta.infected_lytic ~ 1
    eta.target ~ 1
    eta.c ~ 2
    eta.ImmuneEffector ~ 1

    add.sd = 10
  })
  model({
    beta = exp(tbeta + eta.beta)
    ro = exp(tro + eta.ro)
    c = exp(tc + eta.c)
    d = exp(td + eta.d)
    k = exp(tk + eta.k)
    vphi = exp(tvphi + eta.vphi)
    vtheta = exp(tvtheta + eta.vtheta)
    dImm = exp(tdImm + eta.dImm)
    virus0 = exp(tvirus + eta.virus)
    infected_eclipse0 = exp(tinfected_eclipse + eta.infected_eclipse)
    infected_lytic0 = exp(tinfected_lytic + eta.infected_lytic)
    target0 = exp(ttarget + eta.target)
    ImmuneEffector0 = exp(tImmuneEffector + eta.ImmuneEffector)
    
    target(0) = target0
    infected_eclipse(0) = infected_eclipse0
    infected_lytic(0) = infected_lytic0
    virus(0) = virus0
    ImmuneEffector(0) = ImmuneEffector0

    d/dt(target) = - beta * virus * target - vphi * (ImmuneEffector / (ImmuneEffector + vtheta) ) * target
    d/dt(infected_eclipse) = beta * virus * target - k * infected_eclipse
    d/dt(infected_lytic) = k * infected_eclipse - d * infected_lytic
    d/dt(virus) = ro * infected_lytic - c * virus - beta * virus * target
    d/dt(ImmuneEffector) = infected_lytic - dImm * ImmuneEffector
    
    VL = log(virus)
    VL ~ add(add.sd)
  })
}"
  
  # if(fix_E0){
  #   m = gsub("tE0 = runif(1,-6,1)","",m,fixed = T)
  #   m = gsub("eta.E0 ~ 2","",m,fixed = T)
  #   m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  # }
  return(m)
}

#' m14_SARSTCLMwImmune immune blocks cell infections
#' @return VK nlmixr function string
#' @export
m14_SARSTCLMwImmune = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    tbeta = runif(1,-10,-2)
    tro = runif(1,-6, -0)
    tc = runif(1,-20, -2)
    td = runif(1,-4,3)
    tk = runif(1,-4,3)
    tvphi = runif(1,-4,3)
    tvtheta = runif(1,-4,3)
    tdImm = runif(1,-4,1)
    tvirus = runif(1,-2, 2)
    tinfected_eclipse = runif(1,0, 6)
    tinfected_lytic = runif(1,0, 6)
    ttarget = runif(1,0, 6)
    tImmuneEffector = runif(1,0,6)

    eta.ro ~ 2
    eta.d ~ 2
    eta.beta ~ 2
    eta.k ~ 1
    eta.vphi ~ 1
    eta.vtheta ~ 1
    eta.dImm ~ 1
    eta.virus ~ 1
    eta.infected_eclipse ~ 1
    eta.infected_lytic ~ 1
    eta.target ~ 1
    eta.c ~ 2
    eta.ImmuneEffector ~ 1

    add.sd = 10
  })
  model({
    beta = exp(tbeta + eta.beta)
    ro = exp(tro + eta.ro)
    c = exp(tc + eta.c)
    d = exp(td + eta.d)
    k = exp(tk + eta.k)
    vphi = exp(tvphi + eta.vphi)
    vtheta = exp(tvtheta + eta.vtheta)
    dImm = exp(tdImm + eta.dImm)
    
    virus(0) = exp(tvirus + eta.virus)
    infected_eclipse(0) = exp(tinfected_eclipse + eta.infected_eclipse)
    infected_lytic(0) = exp(tinfected_lytic + eta.infected_lytic)
    target(0) = exp(ttarget + eta.target)
    ImmuneEffector(0) = exp(tImmuneEffector + eta.ImmuneEffector)

    d/dt(target) = - beta * (1 - ( vphi * (ImmuneEffector / (ImmuneEffector + vtheta) ) ) ) * target * virus
    d/dt(infected_eclipse) = beta * (1 - ( vphi * (ImmuneEffector / (ImmuneEffector + vtheta) ) ) ) - k * infected_eclipse
    d/dt(infected_lytic) = k * infected_eclipse - d * infected_lytic
    d/dt(virus) = ro * infected_lytic - c * virus - beta * virus * target
    d/dt(ImmuneEffector) = infected_lytic - dImm * ImmuneEffector
    
    VL = log(virus)
    VL ~ add(add.sd)
  })
}"
  
  # if(fix_E0){
  #   m = gsub("tE0 = runif(1,-6,1)","",m,fixed = T)
  #   m = gsub("eta.E0 ~ 2","",m,fixed = T)
  #   m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  # }
  return(m)
}

#' m15_SARSTCLMwImmune immune increases viral clearance
#' @return VK nlmixr function string
#' @export
m15_SARSTCLMwImmune = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    tbeta = runif(1,-10,-2)
    tro = runif(1,-6, -0)
    tc = runif(1,-20, -2)
    td = runif(1,-4,3)
    tk = runif(1,-4,3)
    tvphi = runif(1,-4,3)
    tvtheta = runif(1,-4,3)
    tdImm = runif(1,-4,1)
    tvirus = runif(1,-2, 2)
    tinfected_eclipse = runif(1,0, 6)
    tinfected_lytic = runif(1,0, 6)
    ttarget = runif(1,0, 6)
    tImmuneEffector = runif(1,0,6)

    eta.ro ~ 2
    eta.d ~ 2
    eta.beta ~ 2
    eta.k ~ 1
    eta.vphi ~ 1
    eta.vtheta ~ 1
    eta.dImm ~ 1
    eta.virus ~ 1
    eta.infected_eclipse ~ 1
    eta.infected_lytic ~ 1
    eta.target ~ 1
    eta.c ~ 2
    eta.ImmuneEffector ~ 1

    add.sd = 10
  })
  model({
    beta = exp(tbeta + eta.beta)
    ro = exp(tro + eta.ro)
    c = exp(tc + eta.c)
    d = exp(td + eta.d)
    k = exp(tk + eta.k)
    vphi = exp(tvphi + eta.vphi)
    vtheta = exp(tvtheta + eta.vtheta)
    dImm = exp(tdImm + eta.dImm)
    
    virus(0) = exp(tvirus + eta.virus)
    infected_eclipse(0) = exp(tinfected_eclipse + eta.infected_eclipse)
    infected_lytic(0) = exp(tinfected_lytic + eta.infected_lytic)
    target(0) = exp(ttarget + eta.target)
    ImmuneEffector(0) = exp(tImmuneEffector + eta.ImmuneEffector)

    d/dt(target) = - beta * target * virus
    d/dt(infected_eclipse) = beta * target * virus - k * infected_eclipse
    d/dt(infected_lytic) = k * infected_eclipse - d * infected_lytic
    d/dt(virus) = ro * infected_lytic - c * virus - beta * virus * target    - vphi * (ImmuneEffector / (ImmuneEffector + vtheta) ) * virus
    d/dt(ImmuneEffector) = infected_lytic - dImm * ImmuneEffector
    
    VL = log(virus)
    VL ~ add(add.sd)
  })
}"
  
  # if(fix_E0){
  #   m = gsub("tE0 = runif(1,-6,1)","",m,fixed = T)
  #   m = gsub("eta.E0 ~ 2","",m,fixed = T)
  #   m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  # }
  return(m)
}

#' m16_SARSTCLMwImmune immune promotes cytotoxicity
#' @return VK nlmixr function string
#' @export
m16_SARSTCLMwImmune = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    tbeta = runif(1,-10,-2)
    tro = runif(1,-6, -0)
    tc = runif(1,-20, -2)
    td = runif(1,-4,3)
    tk = runif(1,-4,3)
    tvphi = runif(1,-4,3)
    tvtheta = runif(1,-4,3)
    tdImm = runif(1,-4,1)
    tvirus = runif(1,-2, 2)
    tinfected_eclipse = runif(1,0, 6)
    tinfected_lytic = runif(1,0, 6)
    ttarget = runif(1,0, 6)
    tImmuneEffector = runif(1,0,6)

    eta.ro ~ 2
    eta.d ~ 2
    eta.beta ~ 2
    eta.k ~ 1
    eta.vphi ~ 1
    eta.vtheta ~ 1
    eta.dImm ~ 1
    eta.virus ~ 1
    eta.infected_eclipse ~ 1
    eta.infected_lytic ~ 1
    eta.target ~ 1
    eta.c ~ 2
    eta.ImmuneEffector ~ 1

    add.sd = 10
  })
  model({
    beta = exp(tbeta + eta.beta)
    ro = exp(tro + eta.ro)
    c = exp(tc + eta.c)
    d = exp(td + eta.d)
    k = exp(tk + eta.k)
    vphi = exp(tvphi + eta.vphi)
    vtheta = exp(tvtheta + eta.vtheta)
    dImm = exp(tdImm + eta.dImm)
    
    virus(0) = exp(tvirus + eta.virus)
    infected_eclipse(0) = exp(tinfected_eclipse + eta.infected_eclipse)
    infected_lytic(0) = exp(tinfected_lytic + eta.infected_lytic)
    target(0) = exp(ttarget + eta.target)
    ImmuneEffector(0) = exp(tImmuneEffector + eta.ImmuneEffector)

    d/dt(target) = - beta * target * virus
    d/dt(infected_eclipse) = beta * target * virus - k * infected_eclipse
    d/dt(infected_lytic) = k * infected_eclipse - d * infected_lytic  - vphi * (ImmuneEffector / (ImmuneEffector + vtheta) ) * infected_lytic
    d/dt(virus) = ro * infected_lytic - c * virus - beta * virus * target   
    d/dt(ImmuneEffector) = infected_lytic - dImm * ImmuneEffector
    
    VL = log(virus)
    VL ~ add(add.sd)
  })
}"
  
  # if(fix_E0){
  #   m = gsub("tE0 = runif(1,-6,1)","",m,fixed = T)
  #   m = gsub("eta.E0 ~ 2","",m,fixed = T)
  #   m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  # }
  return(m)
}



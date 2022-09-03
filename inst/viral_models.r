# these are functions required to fit data against 38 vira kinetic models
# each function generates a text string, that can be consumed by nlmixr.

library(nlmixr2)
odejunkfitr::load_examples()

vl_df = data2_cmv_untreated

##### load model frameworks

#####
# Model with Target Cell Limitation and Implicit, Static Immune Control (TC, No EIS)
# odd mu referencing error
# MwTCLESIC1 = function(fix_dS = F, fix_E_v = F, fix_dI = F, fix_dE = F, fix_gamma = F){
#   m = "function() {
#     ini({
#       add.err = 1
#       tbeta = -1
#       eta.beta ~ 5
#       tgamma = 0.53
#       eta.gamma ~ 5
#       tdelta_S = 1
#       eta.delta_S ~ 1
#       tdelta_I = 1
#       eta.delta_I ~ 1
#       tS_v = 2
#       eta.S_v = 5
#       tI_v = 2
#       eta.I_v ~ 5
#       tV_v = 2
#       eta.V_v ~ 5
#     })
#     model({
#       beta = exp(tbeta + eta.beta)
#       gamma = exp(tgamma + eta.gamma)
#       delta_S = exp(tdelta_S + eta.delta_S)
#       delta_I = exp(tdelta_I + eta.delta_I)
#       S_v(0) = exp(tS_v + eta.S_v)
#       I_v(0) = exp(tI_v + eta.I_v)
#       V_v(0) = exp(tV_v + eta.V_v)
#       d/dt(S_v) = gamma - delta_S * S_v - ( beta * V_v * S_v )
#       d/dt(I_v) = beta * V_v * S_v - delta_I * I_v
#       d/dt(V_v) = 3.141593 * I_v - gamma * V_v
#       VL = log(V_v)
#       VL ~ add(add.err)       # define error model
#     })
#   }"
#   if(fix_dS){
#     m = gsub("tdelta_S = 1","",m)
#     m = gsub("eta.delta_S ~ 1","",m)
#     m = gsub("delta_S = exp(tdelta_S + eta.delta_S)","delta_S = 0",m,fixed = T)
#   }
#   if(fix_dI){
#     m = gsub("tdelta_I = 1","",m)
#     m = gsub("eta.delta_I ~ 1","",m)
#     m = gsub("delta_I = exp(tdelta_I + eta.delta_I)","delta_I = 0",m,fixed = T)
#   }
#   if(fix_E_v){
#     m = gsub("tE_v = 2","",m)
#     m = gsub("eta.E_v ~ 5","",m)
#     m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
#   }
#   if(fix_gamma){
#     m = gsub("tgamma = 2","",m)
#     m = gsub("eta.gamma ~ 5","",m)
#     m = gsub("gamma = exp(tgamma + eta.gamma)","gamma = 0",m,fixed = T)
#   }
#   return(m)
# }
# suppressWarnings(nlmixr(object = eval(parse( text = paste(text = MwTCLESIC1(T,T,T,T)))), vl_df, list(print=0), est = "focei"))



#####
#Model with Target Cell Limitation and an Explicit, Dynamic Immune System (TC, EIS)
# odd mu referencing error
# MwTCLEDIS2 = function(fix_dS = F, fix_E_v = F, fix_dI = F, fix_dE = F, fix_gamma = F){
#   m = "function() {
#     ini({
#       tbeta = 1
#       eta.beta ~ 5
#       tom = -12
#       eta.om ~ 5
#       tgamma = 1
#       eta.gamma ~ 5
#       tk = 1
#       eta.k ~ 1
#       tdelta_S = 1
#       eta.delta_S ~ 1
#       tdelta_E = 1
#       eta.delta_E ~ 1
#       tdelta_I = 1
#       eta.delta_I ~ 1
#       tS_v = 2
#       eta.S_v = 5
#       tI_v = 2
#       eta.I_v ~ 5
#       tE_v = 2
#       eta.E_v ~ 5
#       tV_v = 2
#       eta.V_v ~ 5
#       add.err = 1
#     })
#     model({
#       beta = exp(tbeta + eta.beta)
#       gamma = exp(tgamma + eta.gamma)
#       om = exp(tom + eta.om)
#       k = exp(tk + eta.k)
#       delta_S = exp(tdelta_S + eta.delta_S)
#       delta_I = exp(tdelta_I + eta.delta_I)
#       delta_E = exp(tdelta_E + eta.delta_E)
#       S_v(0) = exp(tS_v + eta.S_v)
#       I_v(0) = exp(tI_v + eta.I_v)
#       E_v(0) = exp(tE_v + eta.E_v)
#       V_v(0) = exp(tV_v + eta.V_v)
#       d/dt(S_v) = gamma - delta_S * S_v - ( beta * V_v * S_v )
#       d/dt(I_v) = beta * V_v * S_v - delta_I * I_v - ( k * I_v * E_v )  # Infected cell
#       d/dt(V_v) = 3.141593 * I_v - gamma * V_v                               # virus
#       d/dt(E_v) = om * V_v - delta_E * E_v                             # immune cell
#       VL = log(V_v)
#       VL ~ add(add.err)       # define error model
#     })
#   }"
#   if(fix_dS){
#     m = gsub("tdelta_S = 1","",m)
#     m = gsub("eta.delta_S ~ 1","",m)
#     m = gsub("delta_S = exp(tdelta_S + eta.delta_S)","delta_S = 0",m,fixed = T)
#   }
#   if(fix_dI){
#     m = gsub("tdelta_I = 1","",m)
#     m = gsub("eta.delta_I ~ 1","",m)
#     m = gsub("delta_I = exp(tdelta_I + eta.delta_I)","delta_I = 0",m,fixed = T)
#   }
#   if(fix_dE){
#     m = gsub("tdelta_E = 1","",m)
#     m = gsub("eta.delta_E ~ 1","",m)
#     m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
#   }
#   if(fix_E_v){
#     m = gsub("tE_v = 2","",m)
#     m = gsub("eta.E_v ~ 5","",m)
#     m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
#   }
#   if(fix_gamma){
#     m = gsub("tgamma = 1","",m)
#     m = gsub("eta.gamma ~ 5","",m)
#     m = gsub("gamma = exp(tgamma + eta.gamma)","gamma = 0",m,fixed = T)
#   }
#   return(m)
# }
# suppressWarnings(nlmixr(object = eval(parse( text = paste(text = MwTCLEDIS2(T,T,T,T,T)))), vl_df, list(print=0), est = "saem"))

#####
# Explicit, Dynamic Immune Control Model without Target Cell Limitation (EIS, No TC)
# these are all essentially just 3 - but where various params are fixed to 0. //todo
EDICwTCL3 = function(fix_dE = F, fix_E_v = F, fix_dI = F, ...){
  m = "function() {
    ini({
      add.err = 1
      tbeta = -1
      eta.beta ~ 5
      tom = -12
      eta.om ~ 5
      tk = 1
      eta.k ~ 2
      tgamma = 0.53
      eta.gamma ~ 5
      tdelta_E = 1
      eta.delta_E ~ 1
      tdelta_I = 1
      eta.delta_I ~ 1
      tI_v = 2
      eta.I_v ~ 5
      tE_v = 2
      eta.E_v ~ 5
      tV_v = 2
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
    m = gsub("tdelta_E = 1","",m)
    m = gsub("eta.delta_E ~ 1","",m)
    m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
  }
  if(fix_dI){
    m = gsub("tdelta_I = 1","",m)
    m = gsub("eta.delta_I ~ 1","",m)
    m = gsub("delta_I = exp(tdelta_I + eta.delta_I)","delta_I = 0",m,fixed = T)
  }
  if(fix_E_v){
    m = gsub("tE_v = 2","",m)
    m = gsub("eta.E_v ~ 5","",m)
    m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
  }
  return(m)
}
#suppressWarnings(nlmixr(object = eval(parse( text = paste(text = EDICwTCL3(T,T,T)))), vl_df, list(print=0), est = "saem"))

EDICwTCL4 = function(fix_dE = F, fix_E_v = F, ...){
  m = "function() {
    ini({
      add.err = 1
      tbeta = -6
      eta.beta ~ 2
      tom = -20
      eta.om ~ 2
      tgamma = -1
      eta.gamma ~ 2
      tdelta_E = 1
      eta.delta_E ~ 1
      tdelta_I = 1
      eta.delta_I ~ 1
      tk = -20
      eta.k ~ 2
      tI_v = 1
      eta.I_v ~ 5
      tE_v = 2
      eta.E_v ~ 2
      tV_v = 1
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
      d/dt(I_v) = beta * V_v - delta_I * I_v - ( k * I_v * E_v )  # Infected cell
      d/dt(V_v) = I_v - gamma * V_v                               # virus
      d/dt(E_v) = om * V_v - delta_E * E_v                             # immune cell
      VL = log(V_v)
      VL ~ add(add.err)       # define error model
    })
  }"
  if(fix_dE){
    m = gsub("tdelta_E = 1","",m)
    m = gsub("eta.delta_E ~ 1","",m)
    m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
  }
  if(fix_E_v){
    m = gsub("tE_v = 2","",m)
    m = gsub("eta.E_v ~ 2","",m)
    m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
  }
  return(m)
} # additional fix to duke 2020
#suppressWarnings(nlmixr(object = eval(parse( text = paste(text = EDICwTCL4(F,F)))), vl_df, list(print=0), est = "saem"))

EDICwTCL5 = function(fix_dE = F, fix_E_v = F, ...){
  m = "function() {
    ini({
      add.err = 1
      tbeta = -1
      eta.beta ~ 5
      tom = 0
      eta.om ~ 1
      tgamma = -5
      eta.gamma ~ 5
      tdelta_E = 1
      eta.delta_E ~ 1
      tdelta_I = 1
      eta.delta_I ~ 1
      tI_v = 2
      eta.I_v ~ 5
      tE_v = 2
      eta.E_v ~ 5
      tV_v = 2
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
    m = gsub("tdelta_E = 1","",m)
    m = gsub("eta.delta_E ~ 1","",m)
    m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
  }
  if(fix_E_v){
    m = gsub("tE_v = 2","",m)
    m = gsub("eta.E_v ~ 5","",m)
    m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
  }
  return(m)
}
#suppressWarnings(nlmixr(object = eval(parse( text = paste(text = EDICwTCL5(T,T)))), vl_df, list(print=0), est = "saem"))
 
EDICwTCL6 = function(fix_dI = F, fix_dE = F, fix_E_v = F, fix_V_v = F, ...){
  m = "function() {
    ini({
      add.err = 1
      tbeta = -1
      eta.beta ~ 1
      tk = -8
      eta.k ~ 1
      tgamma = -0.5
      eta.gamma ~ 1
      tdelta_E = 1
      eta.delta_E ~ 1
      tdelta_I = 1
      eta.delta_I ~ 1
      tI_v = 3
      eta.I_v ~ 1
      tE_v = 2
      eta.E_v ~ 1
      tV_v = 0
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
    m = gsub("tdelta_I = 1","",m)
    m = gsub("eta.delta_I ~ 1","",m)
    m = gsub("delta_I = exp(tdelta_I + eta.delta_I)","delta_I = 0",m,fixed = T)
  }
  if(fix_dE){
    m = gsub("tdelta_E = 1","",m)
    m = gsub("eta.delta_E ~ 1","",m)
    m = gsub("delta_E = exp(tdelta_E + eta.delta_E)","delta_E = 0",m,fixed = T)
  }
  if(fix_E_v){
    m = gsub("tE_v = 2","",m)
    m = gsub("eta.E_v ~ 1","",m)
    m = gsub("E_v(0) = exp(tE_v + eta.E_v)","E_v(0) = 0",m,fixed = T)
  }
  if(fix_V_v){
    m = gsub("tV_v = 0","",m)
    m = gsub("eta.V_v ~ 1","",m)
    m = gsub("V_v(0) = exp(tV_v + eta.V_v)","V_v(0) = 1",m,fixed = T)
  }
  return(m)
 }
#(nlmixr(object = eval(parse( text = paste(text = EDICwTCL6(T,T,T,T)))), vl_df, list(print=0), est = "saem"))





#####
# 9 - Semi-Mechanistic, Explicit Immune Control Model (VE)

SMEIMCs7 = function(fix_E0 = T, fix_dE = T, ...){
  m = "function() {
  ini({
    trv = -2
    tk_hat = -8
    tom = -8
    tdE = -3
    tvirus = 2
    tE0 = 0
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
    m = gsub("tE0 = 0","",m)
    m = gsub("eta.E0 ~ 2","",m)
    m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m,fixed = T)
  }
  if(fix_dE){
    m = gsub("tdE = -3","",m)
    m = gsub("eta.dE ~ 2","",m)
    m = gsub("dE = exp(tdE + eta.dE)","dE = 0",m,fixed = T)
  }
  return(m)
}
#suppressWarnings(nlmixr(object = eval(parse( text = paste(text = SMEIMCs7(T,T)))), vl_df, list(print=0), est = "saem"))

SMEIMCs8 = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    trv = -2
    tk_hat = -8
    tdE = -3
    tvirus = 2
    tE0 = 0
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
}"

  if(fix_E0){
    m = gsub("tE0 = 0","",m,fixed = T)
    m = gsub("eta.E0 ~ 2","",m,fixed = T)
    m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  }
  return(m)
}
#suppressWarnings(nlmixr(object = eval(parse( text = paste(text = SMEIMCs8(T)))), vl_df, list(print=0), est = "saem"))

SMEIMCs9 = function(fix_E0 = T, ...){
  m = "function() {
  ini({
    trv = -2
    tom = -8
    tdE = -3
    tvirus = 2
    tE0 = 0
    eta.om ~ 2
    eta.dE ~ 2
    eta.rv ~ 2
    eta.virus ~ 2
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
    m = gsub("tE0 = 0","",m,fixed = T)
    m = gsub("eta.E0 ~ 2","",m,fixed = T)
    m = gsub("E0 = exp(tE0 + eta.E0)","E0 = 0",m, fixed = T)
  }
  return(m)
}
#suppressWarnings(nlmixr(object = eval(parse( text = paste(text = SMEIMCs9(T)))), vl_df, list(print=0), est = "saem"))

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/assess_model.r
\name{does_model_compile}
\alias{does_model_compile}
\title{does_model_compile}
\usage{
does_model_compile(ode_function)
}
\arguments{
\item{ode_function}{nlmixr compatible ode function}
}
\value{
String of "error" or "pass"
}
\description{
Simply handles whether the model can compile via nlmixr
}

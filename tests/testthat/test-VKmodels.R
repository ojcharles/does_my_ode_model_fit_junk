# assess models
odejunkfitr::load_examples()


test_that("model_VK_1", {
  fit = suppressWarnings(nlmixr2::nlmixr(object = eval(parse( text = paste(text = m1_MwTCLESIC(T,T,T,T,T)))),
                                data2_cmv_untreated,
                                list(print=0), est = "saem"))
  
  expect_identical(length(fit$parFixedDf$Estimate) , as.integer(4))
})



test_that("model_VK_2", {
  fit = suppressWarnings(nlmixr2::nlmixr(object = eval(parse( text = paste(text = m2_MwTCLEDIS(T,T,T,T,T)))),
                                data2_cmv_untreated,
                                list(print=0), est = "saem"))
  
  expect_identical(length(fit$parFixedDf$Estimate) , as.integer(7))
})


test_that("model_VK_3", {
  fit = suppressWarnings(nlmixr2::nlmixr(object = eval(parse( text = paste(text = m3_EDICwTCL(T,T,T)))),
                                data2_cmv_untreated,
                                list(print=0), est = "saem"))
  
  expect_identical(length(fit$parFixedDf$Estimate) , as.integer(7))
})

test_that("model_VK_4", {
  fit = suppressWarnings(nlmixr2::nlmixr(object = eval(parse( text = paste(text = m4_EDICwTCL(T,T)))),
                                data2_cmv_untreated,
                                list(print=0), est = "saem"))
  
  expect_identical(length(fit$parFixedDf$Estimate) , as.integer(8))
})


test_that("model_VK_5", {
  fit = suppressWarnings(nlmixr2::nlmixr(object = eval(parse( text = paste(text = m5_EDICwTCL(T,T)))),
                                data2_cmv_untreated,
                                list(print=0), est = "saem"))
  
  expect_identical(length(fit$parFixedDf$Estimate) , as.integer(7))
})


test_that("model_VK_6", {
  fit = suppressWarnings(nlmixr2::nlmixr(object = eval(parse( text = paste(text = m6_EDICwTCL(T,T,T,T)))),
                                data2_cmv_untreated,
                                list(print=0), est = "saem"))
  
  expect_identical(length(fit$parFixedDf$Estimate) , as.integer(5))
})

test_that("model_VK_7", {
  fit = suppressWarnings(nlmixr2::nlmixr(object = eval(parse( text = paste(text = m7_SMEIMCs(T,T)))),
                                data2_cmv_untreated,
                                list(print=0), est = "saem"))
  
  expect_identical(length(fit$parFixedDf$Estimate) , as.integer(5))
})

test_that("model_VK_8", {
  fit = suppressWarnings(nlmixr2::nlmixr(object = eval(parse( text = paste(text = m8_SMEIMCs(T)))),
                                data2_cmv_untreated,
                                list(print=0), est = "saem"))
  
  expect_identical(length(fit$parFixedDf$Estimate) , as.integer(5))
})

test_that("model_VK_9", {
  fit = suppressWarnings(nlmixr2::nlmixr(object = eval(parse( text = paste(text = m9_SMEIMCs(T)))),
                                data2_cmv_untreated,
                                list(print=0), est = "saem"))
  
  expect_identical(length(fit$parFixedDf$Estimate) , as.integer(5))
})


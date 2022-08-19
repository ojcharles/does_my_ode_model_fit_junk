# assess models
odejunkfitr::load_examples()


test_that("string2function", {
  ode_function = ode_string_to_function(model1_theo_sd)
  expect_identical(typeof(ode_function) , "closure")
})






test_that("good model does compile, returns pass", {
  ode_function = ode_string_to_function(model1_theo_sd)
  b = does_model_compile(ode_function)
  expect_identical(b , "pass")
})

test_that("bad model does not compile, returns error", {
  ode_function_string = 'function(){print("junk")}'
  ode_function = ode_string_to_function(ode_function_string)
  b = does_model_compile(ode_function)
  expect_identical(b , "error")
})







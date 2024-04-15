locals {
  # path-parts = {
  #   health   = "health",
  #   student  = "student",
  #   students = "students"
  # }
  # methods = {
  #   get    = "GET",
  #   any    = "ANY"
  # }

  resources = {
    health = "GET",
    student = "ANY",
    students = "GET"
  }

  # resource = {
  #   health = "GET",
  #   student = [{
  #     any = "ANY"
  #     option = "OPTIONS"
  #   }],
  #   students = "GET"
  # }
}
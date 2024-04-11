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
    health = ["GET"],
    student = ["ANY"],
    students = ["GET"]
  }
}


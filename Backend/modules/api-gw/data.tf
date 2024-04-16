locals {
  cloudWatch_Alarm = compact(var.cloudWatch_Alarms)
  resources = {
    health = "GET",
    student = "ANY",
    students = "GET"
  }
}
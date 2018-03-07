library("testthat")
library("aws.transcribe")

if (Sys.getenv("AWS_ACCESS_KEY_ID") != "") {
    test_check("aws.transcribe", filter = "authenticated")
}

test_check("aws.transcribe", filter = "public")

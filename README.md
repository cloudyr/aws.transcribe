# Package Template for the cloudyr project

**aws.transcribe** is a package for the [AWS Transcribe](https://aws.amazon.com/transcribe/) API. This is a work-in-progress.

To use the package, you will need an AWS account and to enter your credentials into R. Your keypair can be generated on the [IAM Management Console](https://aws.amazon.com/) under the heading *Access Keys*. Note that you only have access to your secret key once. After it is generated, you need to save it in a secure location. New keypairs can be generated at any time if yours has been lost, stolen, or forgotten. The [**aws.iam** package](https://github.com/cloudyr/aws.iam) profiles tools for working with IAM, including creating roles, users, groups, and credentials programmatically; it is not needed to *use* IAM credentials.

By default, all **cloudyr** packages for AWS services allow the use of credentials specified in a number of ways, beginning with:

 1. User-supplied values passed directly to functions.
 2. Environment variables, which can alternatively be set on the command line prior to starting R or via an `Renviron.site` or `.Renviron` file, which are used to set environment variables in R during startup (see `? Startup`). Or they can be set within R:
 
    ```R
    Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
               "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
               "AWS_DEFAULT_REGION" = "us-east-1",
               "AWS_SESSION_TOKEN" = "mytoken")
    ```
 3. If R is running an EC2 instance, the role profile credentials provided by [**aws.ec2metadata**](https://cran.r-project.org/package=aws.ec2metadata).
 4. Profiles saved in a `/.aws/credentials` "dot file" in the current working directory. The `"default" profile is assumed if none is specified.
 5. [A centralized `~/.aws/credentials` file](https://blogs.aws.amazon.com/security/post/Tx3D6U6WSFGOK2H/A-New-and-Standardized-Way-to-Manage-Credentials-in-the-AWS-SDKs), containing credentials for multiple accounts. The `"default" profile is assumed if none is specified.

Profiles stored locally or in a centralized location (e.g., `~/.aws/credentials`) can also be invoked via:

```R
# use your 'default' account credentials
aws.signature::use_credentials()

# use an alternative credentials profile
aws.signature::use_credentials(profile = "bob")
```

Temporary session tokens are stored in environment variable `AWS_SESSION_TOKEN` (and will be stored there by the `use_credentials()` function). The [aws.iam package](https://github.com/cloudyr/aws.iam/) provides an R interface to IAM roles and the generation of temporary session tokens via the security token service (STS).


## Code Examples

To start a transcription, use `start_transcription()` with a "job name" and the URL for the file to be transcribed:

```R
library("aws.transcribe")
t1 <- start_transcription("aws-transcribe-example", "https://s3.amazonaws.com/randhunt-transcribe-demo-us-east-1/out.mp3")
```

Then, wait for the transcription to complete and retrieve it by name using `get_transcription()`:


```r
library("aws.transcribe")
t1 <- get_transcription("aws-transcribe-example")
cat(strwrap(t1$Transcriptions[1L], 60), sep = "\n")
```

```
## Hi, everybody, i'm randall and i wanted to show off some of
## the new features an amazon transcribe, and i'm cool like
## noel with the cake quote, what do you do a minute here ?
## Work for boeing satellite. Whoa, that's awesome. Are you
## excited for reading twenty nineteen ? Yes, i can't wait to
## meet everyone of aids. Are you excited for the musical
## guest, who is identity ? I have no idea, but i'm not sure.
```

That's it!

## Installation

[![CRAN](https://www.r-pkg.org/badges/version/aws.transcribe)](https://cran.r-project.org/package=aws.transcribe)
![Downloads](https://cranlogs.r-pkg.org/badges/aws.transcribe)
[![Travis Build Status](https://travis-ci.org/cloudyr/aws.transcribe.png?branch=master)](https://travis-ci.org/cloudyr/aws.transcribe)
[![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/PROJECTNUMBER?svg=true)](https://ci.appveyor.com/project/cloudyr/aws.transcribe)
[![codecov.io](https://codecov.io/github/cloudyr/aws.transcribe/coverage.svg?branch=master)](https://codecov.io/github/cloudyr/aws.transcribe?branch=master)

This package is not yet on CRAN. To install the latest development version you can install from the cloudyr drat repository:

```R
# latest stable version
install.packages("aws.transcribe", repos = c(cloudyr = "http://cloudyr.github.io/drat", getOption("repos")))
```

Or, to pull a potentially unstable version directly from GitHub:

```R
if (!require("remotes")) {
    install.packages("remotes")
}
remotes::install_github("cloudyr/aws.transcribe")
```


---
[![cloudyr project logo](https://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)

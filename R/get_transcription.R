#' @title Get AWS Transcribe Job
#' @description Retrieve a specific AWS Transcribe job
#' @param job A character string specifying the name of a job, possibly returned by \code{\link{list_transcriptions}}.
#' @param \dots Additional arguments passed to \code{\link{transcribeHTTP}}.
#' @return A list.
#' @seealso \code{\link{start_transcription}}, \code{\link{list_transcriptions}}
#' \dontrun{
#' # start a transcription
#' ## upload a file to S3
#' library("aws.s3")
#' put_object(file = "recording.mp3", bucket = "my-bucket", object = "recording.mp3")
#' 
#' ## start trancription
#' start_transcription("first-example", "https://my-bucket.us-east-1.amazonaws.com/recording.mp3")
#' 
#' ## wait
#' Sys.sleep(5)
#'
#' ## retrieve transcription
#' get_transcription("first-example")
#' }
#' @export
get_transcription <-
function(
    job,
    ...
) {
    bod <- list(TranscriptionJobName = job)
    transcribeHTTP(query = list(Action = "GetTranscriptionJob"), body = bod, ...)
}

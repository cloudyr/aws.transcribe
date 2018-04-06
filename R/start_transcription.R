#' @title Start AWS Transcribe Job
#' @description Start an AWS Transcribe job
#' @param name A character string specifying a unique name for the transcription job.
#' @param url A character string specifying a URL for the media file to be transcribed.
#' @param format A character string specifying the file format. One of: \dQuote{mp3}, \dQuote{mp4}, \dQuote{wav}, \dQuote{flac}.
#' @param language A character string specifying a language code. Currently defaults to \dQuote{en-US}.
#' @param hertz Optionally, a numeric value specifying sample rate in Hertz.
#' @param \dots Additional arguments passed to \code{\link{transcribeHTTP}}.
#' @return A list containing details of the job. The transcript can be retrieved with \code{\link{get_transcription}}.
#' @examples
#' \dontrun{
#' # start a transcription
#' ## upload a file to S3
#' library("aws.s3")
#' put_object(file = "recording.mp3", bucket = "my-bucket", object = "recording.mp3")
#' 
#' ## start trancription
#' start_transcription("first-example", "https://my-bucket.us-east-1.amazonaws.com/recording.mp3")
#' }
#' @seealso \code{\link{get_transcription}}
#' @importFrom tools file_ext
#' @export
start_transcription <-
function(
    name,
    url,
    format = tools::file_ext(url),
    language = "en-US",
    hertz = NULL,
    ...
) {
    bod <- list(Media = list(MediaFileUri = url))
    bod$MediaFormat <- format
    bod$LanguageCode <- language
    if (!is.null(hertz)) {
        bod$MediaSampleRateHertz <- hertz
    }
    bod$TranscriptionJobName <- name
    transcribeHTTP(action = "StartTranscriptionJob", body = bod, ...)
}

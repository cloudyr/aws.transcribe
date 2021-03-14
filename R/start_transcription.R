#' @title Start AWS Transcribe Job
#' @description Start an AWS Transcribe job
#'
#' @param name A character string specifying a unique name for the transcription job.
#' @param url A character string specifying a URL for the media file to be transcribed.
#' @param format A character string specifying the file format. One of: \dQuote{mp3}, \dQuote{mp4}, \dQuote{wav}, \dQuote{flac}.
#' @param language A character string specifying a language code. Currently defaults to \dQuote{en-US}.
#' @param hertz Optionally, a numeric value specifying sample rate in Hertz.
#' @param output_bucket Optionally, a character string specifying the output bucket to place the results of the Amazon Transcribe job in.
#' @param channel_identification Optionally, a boolean which instructs Amazon Transcribe to process each audio channel separately and then merge the transcription output of each channel into a single transcription. Amazon Transcribe also produces a transcription of each item detected on an audio channel, including the start time and end time of the item and alternative transcriptions of the item including the confidence that Amazon Transcribe has in the transcription. You can't set both \code{show_speaker_labels} and \code{channel_identification} in the same request.
#' @param show_speaker_labels Optionally, a boolean specifying whether the transcription job uses speaker recognition to identify different speakers in the input audio. Speaker recognition labels individual speakers in the audio file. If you set the \code{show_speaker_labels} field to true, you must also set the maximum number of speaker labels \code{max_speaker_labels} field.  
#' @param max_speaker_labels Optionally, an integer specifying the maximum number of speakers to identify in the input audio. If there are more speakers in the audio than this number, multiple speakers are identified as a single speaker. If you specify the \code{max_speaker_labels} field, you must set the \code{show_speaker_labels} field to \code{TRUE}. Valid Range: Minimum value of 2. Maximum value of 10.
#' @param vocabulary_name Optionally, a character string specifying the name of a vocabulary to use when processing the transcription job.
#' @param more_settings Optionally, a list of additional settings to be passed to Amazon Transcribe.
#' @param \dots Additional arguments passed to \code{\link{transcribeHTTP}}. 
#'
#' @return A list containing details of the job. The transcript can be retrieved with \code{\link{get_transcription}}.
#' @examples
#' \dontrun{
#' # start a transcription
#' ## upload a file to S3
#' library("aws.s3")
#' put_object(file = "recording.mp3", bucket = "my-bucket", object = "recording.mp3")
#' 
#' ## start transcription
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
    output_bucket = NULL,
    channel_identification = NULL,
    show_speaker_labels = NULL,
    max_speaker_labels = NULL,
    vocabulary_name = NULL,
    more_settings = list(),
    ...
) {
    bod <- list(Media = list(MediaFileUri = url))
    bod$MediaFormat <- format
    bod$LanguageCode <- language
    bod$MediaSampleRateHertz <- hertz
    bod$TranscriptionJobName <- name
    bod$OutputBucketName <- output_bucket
    
    stopifnot(is.list(more_settings))
    settings <- more_settings
    
    settings$ChannelIdentification <- channel_identification
    settings$ShowSpeakerLabels <- show_speaker_labels
    settings$MaxSpeakerLabels <- max_speaker_labels
    settings$VocabularyName <- vocabulary_name
    
    if (length(settings)) {
        bod$Settings <- settings
    }
    
    transcribeHTTP(action = "StartTranscriptionJob", body = bod, ...)
}
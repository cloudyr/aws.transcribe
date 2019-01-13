#' @title Start AWS Transcribe Job
#' @description Start an AWS Transcribe job
#' @param name A character string specifying a unique name for the transcription job.
#' @param url A character string specifying a URL for the media file to be transcribed.
#' @param format A character string specifying the file format. One of: \dQuote{mp3}, \dQuote{mp4}, \dQuote{wav}, \dQuote{flac}.
#' @param language A character string specifying a language code. Currently defaults to \dQuote{en-US}.
#' @param hertz Optionally, a numeric value specifying sample rate in Hertz.
#' @param output_bucket Optionally, The location where the transcription is stored. 
#' If you set the OutputBucketName, Amazon Transcribe puts the transcription in the specified S3 bucket. 
#' When you call the GetTranscriptionJob operation, the operation returns this location in the TranscriptFileUri field. 
#' The S3 bucket must have permissions that allow Amazon Transcribe to put files in the bucket.
#' If you don't set the OutputBucketName, Amazon Transcribe generates a pre-signed URL, 
#' a shareable URL that provides secure access to your transcription, and returns it in the TranscriptFileUri field. 
#' Use this URL to download the transcription.
#' @param channel_identification Optionally, a boolean that instructs Amazon Transcribe to process each audio channel 
#' separately and then merge the transcription output of each channel into a single transcription.
#' Amazon Transcribe also produces a transcription of each item detected on an audio channel, 
#' including the start time and end time of the item and alternative transcriptions of the item 
#' including the confidence that Amazon Transcribe has in the transcription.
#' You can't set both ShowSpeakerLabels and ChannelIdentification in the same requestto indicate whether channel.
#' More info at 
#' \code{\link{https://aws.amazon.com/about-aws/whats-new/2018/08/amazon_transcribe_can_now_identify_and_label_transcripts_based_on_audio_channels/}}.
#' @param show_speaker_labels Optionally, boolean that determines whether the transcription job uses
#' speaker recognition to identify different speakers in the input audio. 
#' Speaker recognition labels individual speakers in the audio file. 
#' If you set the ShowSpeakerLabels field to true, you must also set 
#' the maximum number of speaker labels MaxSpeakerLabels field.
#' @param max_speaker_labels Optionally, a numeric value specifying he maximum number of speakers to identify in the input audio.
#' If there are more speakers in the audio than this number, multiple speakers will be identified as a single speaker.
#' If you specify the MaxSpeakerLabels field, you must set the ShowSpeakerLabels field to true.
#' @param vocabulary_name Optionally, a string specifying the name of a vocabulary to use when processing the transcription job.
#' Length Constraints: Minimum length of 1. Maximum length of 200. Pattern: `^[0-9a-zA-Z._-]+`
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
    output_bucket = NULL,
    channel_identification = NULL,
    show_speaker_labels = NULL,
    max_speaker_labels = NULL,
    vocabulary_name = NULL,
    ...
) {
    bod <- list(Media = list(MediaFileUri = url))
    bod$MediaFormat <- format
    bod$LanguageCode <- language
    bod$TranscriptionJobName <- name
    if (!is.null(hertz)) {
        bod$MediaSampleRateHertz <- hertz
    }
    if (!is.null(output_bucket)) {
      bod$OutputBucketName <- output_bucket
    }
    # add on settings
    if (any(
      !is.null(channel_identification),
      !is.null(show_speaker_labels),
      !is.null(max_speaker_labels),
      !is.null(vocabulary_name)
      )) {
      settings <- list()
      settings$ChannelIdentification <- channel_identification
      settings$ShowSpeakerLabels <- show_speaker_labels
      settings$MaxSpeakerLabels <- max_speaker_labels
      settings$VocabularyName <- vocabulary_name
      # remove null entries from settings
      settings <- settings[lengths(settings) != 0]
      bod$Settings <- settings
    }
    transcribeHTTP(action = "StartTranscriptionJob", body = bod, ...)
}
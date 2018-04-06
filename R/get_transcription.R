#' @title Get AWS Transcribe Job
#' @description Retrieve a specific AWS Transcribe job
#' @param job A character string specifying the name of a job, possibly returned by \code{\link{list_transcriptions}}.
#' @param download A logical indicating whether to download the transcription(s).
#' @param \dots Additional arguments passed to \code{\link{transcribeHTTP}}.
#' @return A list.
#' @seealso \code{\link{start_transcription}}, \code{\link{list_transcriptions}}
#' @examples
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
#' transcript <- get_transcription("first-example")
#' transcript$Transcriptions
#' }
#' @import httr
#' @export
get_transcription <-
function(
    job,
    download = TRUE,
    ...
) {
    bod <- list(TranscriptionJobName = job)
    out <- transcribeHTTP(action = "GetTranscriptionJob", body = bod, ...)$TranscriptionJob
    if (isTRUE(download)) {
        transcription_list <- content(httr::GET(out$Transcript$TranscriptFileUri), "text", encoding = "UTF-8")
        results <- jsonlite::fromJSON(transcription_list)$results
        out$Transcriptions <- unlist(results$transcripts)
        out$TranscriptionItems <- results$item
    } else {
        out$Transcriptions <- NULL
        out$TranscriptionItems <- NULL
    }
    return(structure(out, class = "aws_transcription"))
}

print.aws_transcription <- function(x, ...) {
    cat(paste0("Job: ", x$TranscriptionJobName, " (Status: ", x$TranscriptionJobStatus,")\n"))
    cat(paste0("Media URI:      ", x$Media$MediaFileUri, "\n"))
    cat(paste0("MediaFormat:    ", x$MediaFormat, " (", x$MediaSampleRateHertz, " Hertz)\n"))
    cat(paste0("LanguageCode:   ", x$LanguageCode, "\n"))
    cat(paste0("CreationTime:   ", as.POSIXct(x$CreationTime, origin = "1970-01-01"), "\n"))
    cat(paste0("CompletionTime: ", as.POSIXct(x$CompletionTime, origin = "1970-01-01"), "\n"))
    cat("Settings:\n")
    print(x$Settings)
    if ("TranscriptionItems" %in% names(x)) {
        cat(sprintf(ngettext(nrow(x$TranscriptionItems),
                    "TranscriptionItems: 1 transcription",
                    "TranscriptionItems: %d transcription items"), nrow(x$TranscriptionItems)), "\n")
    }
    if ("Transcriptions" %in% names(x)) {
        cat("Transcriptions:\n")
        print(x$Transcriptions)
    }
    invisible(x)
}

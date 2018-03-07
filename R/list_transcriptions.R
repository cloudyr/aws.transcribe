#' @title List AWS Transcribe Jobs
#' @description List AWS Transcribe jobs, by status
#' @param status A character string specifying the status of jobs to retrieve. Use \code{\link{get_transcription}} to retrieve a specific transcription.
#' @param n Optionally, a numeric value indicating the maximum number of results to return (for pagination).
#' @param token Optionally, a \dQuote{NextToken} indicating the next result to retrieve (for pagination).
#' @param \dots Additional arguments passed to \code{\link{transcribeHTTP}}.
#' @return A list.
#' \dontrun{
#' list_transcriptions("COMPLETED")
#' }
#' @export
list_transcriptions <-
function(
    status = c("COMPLETED", "IN_PROGRESS", "FAILED"),
    n = NULL,
    token = NULL,
    ...
) {
    bod <- list()
    bod$Status <- match.arg(status)
    if (!is.null(n)) {
        bod$MaxResults <- n
    }
    if (!is.null(token)) {
        bod$NextToken <- token
    }
    transcribeHTTP(query = list(Action = "ListTranscriptionJobs"), body = bod, ...)
}

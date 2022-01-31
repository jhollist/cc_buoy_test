library(curl)
library(stringr)
library(here)

up <- paste0(Sys.getenv("NEWFTPU"),":", Sys.getenv("NEWFTPP"))

h <- new_handle()
handle_setopt(handle = h, httpauth = 1, userpwd = up)
res <- curl_fetch_memory(url = "sftp://newftp.epa.gov/buoys/", handle = h)
file_string <- unlist(str_split(rawToChar(res$content), "\n"))
files <- str_extract(file_string, "data.*csv")
files <- files[!is.na(files)]
new_files <- files[!files %in% list.files(here("data/buoys"))]

for(i in new_files){
  file_url <- paste0("sftp://newftp.epa.gov/buoys/",i)
  file_path <- paste0(here("data/buoys"), "/", i)
  tryCatch({curl_download(file_url, i, handle = h)},
    error = function(e) e, warning = function(w) w
  )
}

                                 
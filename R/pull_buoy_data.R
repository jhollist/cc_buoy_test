library(RCurl)
library(stringr)
library(here)
up <- paste0(Sys.getenv("NEWFTPU"),":", Sys.getenv("NEWFTPP"))

files_string <- RCurl::getURL("sftp://newftp.epa.gov/buoys/", 
                              userpwd = up, 
                              dirlistonly = TRUE)
#files_string
files <- unlist(str_split(files_string, "\n"))[grepl("data_report", 
                                                         unlist(str_split(
                                                           files_string, "\n")))]
#files
new_files <- files[!files %in% list.files(here("data/buoys"))]

for(i in new_files){
  file_url <- paste0("sftp://newftp.epa.gov/buoys/",i)
  file_path <- paste0(here("data/buoys"), "/", i)
  file_path
  tryCatch({
    writeBin(object = getBinaryURL(url = file_url,
                                   timeout = 480,
                                   userpwd = up, 
                                   dirlistonly = FALSE), con = file_path)},
    error = function(e) e, warning = function(w) w
  )
}

                                 
####################################################
# automatically create customized certificates
#####################################################

# load needed packages
library(readr)
library(dplyr)
library(stringr)

# load data, read everything in as a string/character
df <- read.csv("nomes.csv", sep = ";")

# load either pdf or word certificate template
template <- readr::read_file("cert.Rmd")

#run through all students, generate personalized certificate for each
for (i in 1:nrow(df)){
  
  #replace the placeholder words in the template with the student information
  current_cert <- template %>%
    str_replace("NOME", df[i,'participante'])
  
  #generate an output file name based on student name
  out_filename = paste(df[i,'participante'],'Certificado',sep="_")
  out_filename = paste0(out_filename, '.Rmd')
  
  #save customized Rmd to a temporary file
  write_file(current_cert, out_filename) }

#listando os certificados em rmd
certificados<-list.files(pattern = "_Certificado.Rmd", full.names = T)

#convertendo para html
purrr::map(certificados, rmarkdown::render)

#apagando arquivos rmd
file.remove(certificados)
  
#selecionando os arquivos html
certificadosht<-list.files(pattern = "_Certificado.html", full.names = T)

#convertendo em pdf
certificadosht %>% purrr::map(xaringanBuilder::build_pdf)

#apagando
file.remove(certificadosht)

  


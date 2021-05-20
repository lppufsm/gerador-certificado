####################################################
# gerador de certificados
#####################################################

library(readr)
library(dplyr)
library(stringr)

# ler a planilha com os nomes dos participantes. A coluna com os nomes tem nome "participante"
df <- read.csv("nomes.csv", sep = ";")

# ler o template do certificado
template <- readr::read_file("cert.Rmd")

# rodar para os participantes, gerando um certificado para cada
for (i in 1:nrow(df)){
  
  # substituir o "NOME" no template pelo nome do participante
  cert_i <- template %>%
    str_replace("NOME", df[i,'participante'])
  
  # gerar nome do cerificado para cada participante
  nome_cert = paste(df[i,'participante'],'Certificado',sep="_")
  nome_cert = paste0(nome_cert, '.Rmd')
  
  # salvar um .Rmd personalizado para cada participante
  write_file(cert_i, nome_cert) }

# listando os certificados em .Rmd
certificados<-list.files(pattern = "_Certificado.Rmd", full.names = T)

# convertendo para .html
purrr::map(certificados, rmarkdown::render)

# apagando arquivos .Rmd
file.remove(certificados)
  
# selecionando os arquivos .html
certificadosht<-list.files(pattern = "_Certificado.html", full.names = T)

# convertendo para pdf
certificadosht %>% purrr::map(xaringanBuilder::build_pdf)

# apagando os arquivos .html
file.remove(certificadosht)

  


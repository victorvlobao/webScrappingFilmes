# Instalando e carregando os pacotes necessários

library(rvest)

# Definindo a URL do site
url <- "https://www.imdb.com/list/ls003330768/?sort=user_rating,desc&st_dt=&mode=detail&page=1"

# Realizando o scraping
page <- read_html(url)

# Extraindo os títulos dos filmes
titulos <- page %>%
  html_nodes(".lister-item-header a") %>%
  html_text()

# Extraindo as estrelas dos filmes
estrelas <- page %>%
  html_nodes(".ipl-rating-star__rating") %>%
  html_text() %>%
  as.numeric()

# Extraindo os metascores dos filmes
metascores <- page %>%
  html_nodes(".metascore") %>%
  html_text() %>%
  as.numeric()

# Ajustando os comprimentos dos vetores para garantir consistência
num_filmes <- min(length(titulos), length(estrelas), length(metascores))
titulos <- titulos[1:num_filmes]
estrelas <- estrelas[1:num_filmes]
metascores <- metascores[1:num_filmes]

# Criando um data frame com os dados extraídos
filmes_df <- data.frame(
  titulo = titulos,
  estrelas = estrelas,
  metascore = metascores
)

# Removendo linhas com valores ausentes
filmes_df <- filmes_df[complete.cases(filmes_df), ]

# Salvando os dados em um arquivo CSV
write.csv(filmes_df, "filmes_imdb.csv", row.names = FALSE)

# Encontrando o filme com maior quantidade de estrelas
maior_estrelas <- filmes_df[which.max(filmes_df$estrelas), "titulo"]

# Encontrando o filme com o maior metascore
maior_metascore <- filmes_df[which.max(filmes_df$metascore), "titulo"]

# Exibindo as respostas
cat("Filme com maior quantidade de estrelas:", maior_estrelas, "\n")
cat("Filme com o maior metascore:", maior_metascore, "\n")

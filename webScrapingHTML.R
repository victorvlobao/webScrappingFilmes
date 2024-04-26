library(rvest)

# Definindo a URL e lendo a página
url <- "https://www.imdb.com/list/ls003330768/?sort=user_rating,desc&st_dt=&mode=detail&page=1"
page <- read_html(url)

# Extraindo os dados da página
titulos <- page %>% html_nodes(".lister-item-header a") %>% html_text()
estrelas <- page %>% html_nodes(".ipl-rating-star__rating") %>% html_text() %>% as.numeric()
metascores <- page %>% html_nodes(".metascore") %>% html_text() %>% as.numeric()

# Determinando o número de filmes
num_filmes <- min(length(titulos), length(estrelas), length(metascores))
titulos <- titulos[1:num_filmes]
estrelas <- estrelas[1:num_filmes]
metascores <- metascores[1:num_filmes]

# Criando o dataframe com os dados dos filmes
filmes_df <- data.frame(titulo = titulos, estrelas = estrelas, metascore = metascores)
filmes_df <- filmes_df[complete.cases(filmes_df), ]

# Escrevendo os dados em um arquivo CSV
write.csv(filmes_df, "filmes_imdb.csv", row.names = FALSE)

# Encontrando os filmes com maior quantidade de estrelas e maior metascore
maior_estrelas <- filmes_df[which.max(filmes_df$estrelas), "titulo"]
maior_metascore <- filmes_df[which.max(filmes_df$metascore), "titulo"]

# Criando o HTML correspondente
html_content <- paste(
  "<html>",
  "<head>",
  "<title>Filmes IMDb</title>",
  "</head>",
  "<body>",
  "<h1>Filme com maior quantidade de estrelas:</h1>",
  "<p>", maior_estrelas, "</p>",
  "<h1>Filme com o maior metascore:</h1>",
  "<p>", maior_metascore, "</p>",
  "</body>",
  "</html>",
  sep = "\n"
)

# Escrevendo o conteúdo HTML em um arquivo
writeLines(html_content, "./Estudos/R/filmes_imdb.html")
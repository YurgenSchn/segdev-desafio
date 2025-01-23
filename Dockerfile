FROM ruby:3.4.1

# Instala as dependências
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client

WORKDIR /app

# Copia os arquivos de dependência
COPY Gemfile Gemfile.lock ./

# Instala as gems
RUN gem install rails bundler && \
    bundle install

# Copia o resto do código
COPY . .

# Adiciona o diretório bin ao PATH
ENV PATH="/app/bin:${PATH}"

# Ajusta as permissões do entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

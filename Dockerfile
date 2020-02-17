FROM ruby:alpine
WORKDIR /code
RUN gem install -N bundler-audit && \
    rm -rf /root/.gem $GEM_HOME/cache
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--update"]

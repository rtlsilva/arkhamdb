# {Choice} Composer version: 1, 2, latest
ARG COMPOSER_VERSION="2"
# [Choice] PHP version: 8, 8.0, 7, 7.4, 7.3
ARG PHP_VERSION="8"

FROM composer:${COMPOSER_VERSION} AS composer_stage

FROM mcr.microsoft.com/vscode/devcontainers/php:0-${PHP_VERSION}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="lts/*"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends git zlib1g-dev libzip-dev zip unzip apt-utils dialog procps iproute2 lsb-release \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_mysql zip
#RUN pecl install xdebug \
#&& docker-php-ext-enable xdebug

# Install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# Copy Composer from official image
COPY --from=composer_stage /usr/bin/composer /usr/local/bin/composer
COPY composer.json ./
COPY composer.lock ./

# Prefetch Composer dependencies to cache them into an image layer
RUN COMPOSER_MEMORY_LIMIT=-1 composer global require squizlabs/php_codesniffer
RUN COMPOSER_MEMORY_LIMIT=-1 composer install \
    --no-interaction \
    --prefer-dist \
    --no-scripts \
    --no-autoloader

# Prefetch card data
ARG CARD_DATA_REPO_URL="https://github.com/Kamalisk/arkhamdb-json-data"
ARG CARD_DATA_PATH="/arkhamdb-json-data/"
# Store card data path in environment variable so app:import:std can find it later
ENV CARD_DATA_PATH=${CARD_DATA_PATH}
RUN git clone --depth=1 ${CARD_DATA_REPO_URL} ${CARD_DATA_PATH}
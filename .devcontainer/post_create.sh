#!/bin/bash
COMPOSER_MEMORY_LIMIT=-1 composer run-script post-install-cmd --no-interaction
php bin/console doctrine:database:create --no-interaction --if-not-exists
php bin/console doctrine:schema:create --no-interaction
php bin/console app:import:std ${CARD_DATA_PATH} --no-interaction

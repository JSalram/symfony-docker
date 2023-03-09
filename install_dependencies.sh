### BASH ###
cd symfony
sudo rm -rf composer.lock package-lock.json symfony.lock vendor node_modules
composer install --ignore-platform-reqs
npm install --legacy-peer-deps
npm run build
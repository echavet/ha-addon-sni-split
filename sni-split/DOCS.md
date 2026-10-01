# Relais par nom

Le module écoute le port 443. Il lit le nom demandé dans le premier message chiffré, puis transmet la connexion sans la déchiffrer.

## Configuration

- `routes` : une ligne par nom. `hostname` est le nom demandé, `backend` est l'adresse et le port de destination, par exemple `192.168.8.224:3129`.
- `default_backend` : destination de tous les autres noms, par exemple `192.168.8.224:4443`.

Le module Nginx Proxy Manager doit avoir libéré le port 443 de la machine et écouter le port indiqué dans `default_backend`. Le port 443 de ce module se change dans son onglet Réseau.

Squid doit écouter le port indiqué pour `proxy.pool-io.com`, avec un certificat à ce nom.

## Ordre

1. Dans Nginx Proxy Manager, passer le port hôte 443 à 4443, puis redémarrer ce module.
2. Vérifier que `default_backend` pointe vers ce port 4443.
3. Démarrer ce module.
4. Si les sites ne répondent plus, remettre Nginx Proxy Manager sur le port 443 et arrêter ce module.

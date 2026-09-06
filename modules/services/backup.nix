{ lib, ... }:
{
  services.restic.backups.home = {
    initialize = true;

    # Both created once by hand on each machine, never committed to this
    # repo - same reasoning as the LUKS passphrases:
    #   sudo mkdir -p /etc/restic
    #   echo "rest:http://backupuser:PASSWORD@truenas.local:8000/home-backups" \
    #     | sudo tee /etc/restic/repository
    #   echo "YOUR-RESTIC-ENCRYPTION-PASSPHRASE" | sudo tee /etc/restic/password
    #   sudo chmod 600 /etc/restic/repository /etc/restic/password
    repositoryFile = "/etc/restic/repository";
    passwordFile = "/etc/restic/password";

    paths = [ "/home" ];

    exclude = [
      "/home/*/.cache"
      "/home/*/.local/share/Trash"
      "/home/*/.mozilla/firefox/*/storage"
      "/home/*/.var/app/*/cache"
    ];

    extraBackupArgs = [ "--exclude-caches" ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };
}
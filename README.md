# sman (very very early (and ugly) version)
Nilfs2 snapshot manager

Run it (sman.sh make; sman.sh compareall) from cron 3 times a day. Example: 8.00am, 12.00pm, 17.00pm.

Usage: 

sman.sh make
- make a snapshot (max 6), and mount it

sman.sh compareall 
- compare all (6) snapshots with each other. Print block changes in percent. Usefully to detect big changes, like ransomware attack. Later versions will send this comparison results in e-mail and nagios server.


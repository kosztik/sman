# sman (very very early (and ugly) version)
Nilfs2 snapshot manager

Usage: 

sman.sh make
- make a snapshot (max 6), and mount it

sman.sh compareall 
- compare all (6) snapshots with each other. Print block changes in percent. Usefully to detect big changes, like by ransomware.

dism /online /set-edition:serverstandard /productkey:<code> /accepteula
shutdown -r -t 0

slmgr /ipk <code>
slmgr /ato

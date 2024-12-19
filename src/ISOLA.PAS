program isola;
{
Auteur: Patrick Pr‚martin.
Date: 26/02/1992. (1.0)
Langage: Turbo Pascal 6.0
But: Jeu. 2 joueurs (ou ordinateur). Chaque joueur … son tour d‚place son pion,
     et d‚truit une case du damier. Le gagnant est celui qui aura bloqu‚ son
     adversaire.
}
uses
    crt,
    u_m_util,
    u_isola,
    olf_software;

begin
  checkbreak := false;
  init_licence ('GAMEISOL');
  init_olf_message (mess_shareware);
  init_olf_software ('Isola '+num_vers, #155' Patrick Pr‚martin '+dat_vers);
  asm { Mode texte 40*25, 16 couleurs, demi-teintes. }
     mov ah, 0
     mov al, 0
     int 10h
  end;
  repeat
    init_joueurs;
    jeu;
  until (not confirm ('Play again ?'));
  asm { Mode texte 80*25, 16 couleurs, demi-teintes. }
     mov ah, 0
     mov al, 3
     int 10h
  end;
  textcolor (lightgray);
  textbackground (black);
  clrscr;
  writeln ('See you later...');
end.

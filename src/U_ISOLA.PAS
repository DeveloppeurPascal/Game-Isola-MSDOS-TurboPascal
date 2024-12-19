unit u_isola;
{
Auteur: Patrick Pr‚martin.
Date: 26/02/1992.
Langage: Turbo Pascal 6.0
}
interface

const
     dat_vers : string [10] = '02/26/1992';
     num_vers : string [3] = '1.0';

procedure init_joueurs;
procedure jeu;

implementation
uses
    crt,
    u_curseur,
    u_sai_donnee,
    u_code_clavier,
    u_m_util;

const
     max_lig = 6; { 6 lignes de cases ayant 4 caractŠres }
     max_col = 10; { 10 colonnes de cases }

type
    t_name = array [1..2] of string;
    t_posxy = record
                x, y : byte;
    end;
    t_coord = array [1..2] of t_posxy;
    t_tab = array [0..max_col+1, 0..max_lig+1] of boolean;
    t_coul = array [1..2] of byte;

var
   player : t_name;
   coord : t_coord;
   ecran : t_tab;
   ocad,
   cad : t_posxy;
   coul : t_coul;

procedure init_joueurs;
var
   x, y : word;
begin
  textcolor (white);
  textbackground (black);
  clrscr;
  textcolor (yellow);
  gotoxy (18, 1);
  writeln ('ISOLA');
  writeln;
  textcolor (white);
  textbackground (black);
  write ('Name of the first player: ');
  textcolor (yellow);
  textbackground (coul [1]);
  x := wherex;
  y := wherey;
  repeat
    gotoxy (x, y);
    if (player [1] = '')
    then
      player [1] := 'COMPUTER';
    {endif}
    saisie_texte ('XXXXXXXXXX', player [1]);
  until (player [1] <> '');
  writeln;
  textcolor (white);
  textbackground (black);
  write ('Name of the second player: ');
  textcolor (yellow);
  textbackground (coul [2]);
  x := wherex;
  y := wherey;
  repeat
    gotoxy (x, y);
    if (player [2] = '')
    then
      player [2] := 'COMPUTER';
    {endif}
    saisie_texte ('XXXXXXXXXX', player [2]);
  until (player [2] <> '');
  writeln;
  if (not confirm ('Are the names OK ?'))
  then
    init_joueurs;
  {endif}
end; { Init_Joueurs }

procedure set_case (x, y : byte);
var
   i, j : byte;
begin
  textcolor (brown);
  textbackground (black);
  x := succ (pred (x) * 4);
  y := succ (pred (y) * 4);
  for i := x to x+2 do
    for j := y to y+2 do
      begin
        gotoxy (i, j);
        write (#219);
      end;
    {endfor}
  {endfor}
end; { Set_Case }

procedure del_case (x, y : byte);
var
   i, j : byte;
begin
  textcolor (lightgray);
  textbackground (black);
  x := succ (pred (x) * 4);
  y := succ (pred (y) * 4);
  for i := x to x+2 do
    for j := y to y+2 do
      begin
        gotoxy (i, j);
        write (' ');
      end;
    {endfor}
  {endfor}
end; { Del_Case }

procedure set_pion (num : byte);
begin
  textcolor (coul [num]);
  gotoxy ((pred (coord [num].x) *4)+2, (pred (coord [num].y) *4)+2);
  write (#219);
end; { Set_Pion }

procedure dessin_ecran;
var
   i, j : byte;
begin
  for i := 0 to max_col+1 do
    begin
      ecran [i, 0] := false;
      ecran [i, max_lig+1] := false;
    end;
  {endfor}
  for j := 0 to max_lig+1 do
    begin
      ecran [0, j] := false;
      ecran [max_col+1, j] := false;
    end;
  {endfor}
  ocad.x := 1;
  ocad.y := 1;
  cad.x := 1;
  cad.y := 1;
  coord [1].x := 1;
  coord [1].y := max_lig div 2;
  coord [2].x := max_col;
  coord [2].y := succ (max_lig) div 2;
  textcolor (yellow);
  textbackground (black);
  clrscr;
  for i := 1 to max_col do
    for j := 1 to max_lig do
      begin
        ecran [i, j] := true;
        set_case (i, j);
      end;
    {endfor}
  {endfor}
  set_pion (1);
  set_pion (2);
end; { Dessin_Ecran }

function joueur_bloque (num : byte) : boolean;
var
   x, y : byte;
begin
  x := coord [num].x;
  y := coord [num].y;
  joueur_bloque := not ((ecran [x-1, y-1]) or (ecran [x-1, y]) or (ecran [x-1, y+1])
                   or (ecran [x+1, y-1]) or (ecran [x+1, y]) or (ecran [x+1, y+1])
                   or (ecran [x, y-1]) or (ecran [x, y+1]));
end; { Joueur_Bloque }

procedure set_cadre (cad : t_posxy);
begin
  if ((ecran [cad.x, cad.y])
     or ((cad.x = coord [1].x) and (cad.y = coord [1].y))
     or ((cad.x = coord [2].x) and (cad.y = coord [2].y)))
  then
    textbackground (brown)
  else
    textbackground (black);
  {endif}
  textcolor (yellow);
  cad.x := succ (pred (cad.x) * 4);
  cad.y := succ (pred (cad.y) * 4);
  gotoxy (cad.x, cad.y);
  write (#201#205#187);
  gotoxy (cad.x, cad.y+1);
  write (#186);
  gotoxy (cad.x+2, cad.y+1);
  write (#186);
  gotoxy (cad.x, cad.y+2);
  write (#200#205#188);
end; { Set_Cadre }

procedure del_cadre (cad : t_posxy);
begin
  if (ecran [cad.x, cad.y])
  then
    set_case (cad.x, cad.y)
  else
    if ((cad.x = coord [1].x) and (cad.y = coord [1].y))
    then
      begin
        set_case (cad.x, cad.y);
        set_pion (1);
      end
    else
      if ((cad.x = coord [2].x) and (cad.y = coord [2].y))
      then
        begin
          set_case (cad.x, cad.y);
          set_pion (2);
        end
      else
        del_case (cad.x, cad.y);
      {endif}
    {endif}
  {endif}
end; { Del_Cadre }

procedure choix_computer;
begin
  repeat
    cad.x := succ (random (max_col));
    cad.y := succ (random (max_lig));
  until (ecran [cad.x, cad.y]);
  delay (100);
end; { Choix_Computer }

procedure deplacement_cadre;
var
   carac : char;
begin
  if ((cad.x <> ocad.x) or (cad.y <> ocad.y))
  then
    begin
      del_cadre (ocad);
      ocad.x := cad.x;
      ocad.y := cad.y;
      set_cadre (cad);
    end
  else
    set_cadre (cad);
  {endif}
  repeat
    carac := readkey;
    if (carac = carac_nul)
    then
      case readkey of
        touche_haut :
          begin
            dec (cad.y);
            if (cad.y < 1)
            then
              cad.y := max_lig;
            {endif}
          end;
        touche_bas :
          begin
            inc (cad.y);
            if (cad.y > max_lig)
            then
              cad.y := 1;
            {endif}
          end;
        touche_gauche :
          begin
            dec (cad.x);
            if (cad.x < 1)
            then
              cad.x := max_col;
            {endif}
          end;
        touche_droite :
          begin
            inc (cad.x);
            if (cad.x > max_col)
            then
              cad.x := 1;
            {endif}
          end;
      end;
    {endif}
    if ((cad.x <> ocad.x) or (cad.y <> ocad.y))
    then
      begin
        del_cadre (ocad);
        ocad.x := cad.x;
        ocad.y := cad.y;
        set_cadre (cad);
      end;
    {endif}
  until ((carac = touche_return) and (ecran [cad.x, cad.y]));
end; { Deplacement_Cadre }

procedure choix_deplacement (num : byte);
var
   xc, yc,
   xp, yp : byte;
begin
  xp := coord [num].x;
  yp := coord [num].y;
  repeat
    if (player [num] = 'COMPUTER')
    then
      choix_computer
    else
      deplacement_cadre;
    xc := cad.x;
    yc := cad.y;
  until (((xc = xp-1) and ((yc = yp-1) or (yc = yp) or (yc = yp+1)))
      or ((xc = xp) and ((yc = yp-1) or (yc = yp+1)))
      or ((xc = xp+1) and ((yc = yp-1) or (yc = yp) or (yc = yp+1))));
  set_case (xp, yp);
  ecran [xp, yp] := true;
  coord [num].x := xc;
  coord [num].y := yc;
  ecran [xc, yc] := false;
  set_pion (num);
end; { Choix_Deplacement }

procedure choix_destruction (num : byte);
var
   i, j : byte;
begin
  if (player [num] = 'COMPUTER')
  then
    choix_computer
  else
    deplacement_cadre;
  {endif}
  del_case (cad.x, cad.y);
  ecran [cad.x, cad.y] := false;
end; { Choix_Destruction }

procedure jeu;
var
   num : byte;
   sortie : boolean;
begin
  curseur_off;
  dessin_ecran;
  num := 1;
  sortie := false;
  while (not (joueur_bloque (num) or sortie)) do
    begin
      textcolor (coul [num]);
      textbackground (black);
      gotoxy (1, 25);
      clreol;
      write (player [num], ' : move your pion...');
      choix_deplacement (num);
      gotoxy (1, 25);
      clreol;
      write (player [num], ' : delete a case...');
      choix_destruction (num);
      num := 3-num;
      if (keypressed)
      then
        sortie := sortie or (readkey = touche_escape);
      {endif}
    end;
  {endwhile}
  num := 3-num;
  if (not sortie)
  then
    calert (player [num]+' win this play.', al_nothing, coul [num]);
  {endif}
  curseur_on;
end; { Jeu }

begin
  randomize;
  player [1] := '';
  player [2] := '';
  coul [1] := red;
  coul [2] := blue;
end. { Fin de 'U_Isola' }

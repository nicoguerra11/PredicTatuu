/* Lexer para PredicTatu: fiel al enunciado */
package predictatu;
import java_cup.runtime.Symbol;

%%

/* ==== OPCIONES ==== */
%class Lexer
%unicode
%public
%cup
%line
%column
%ignorecase       /* hace que CAMPEONATO / Campeonato / campeonato, etc. coincidan */

/* ==== MACROS (definiciones) ==== */
LINEEND = (\r?\n)
WS      = [ \t\f]+
NUM     = [0-9]+
WORD    = [A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+([ '_-][A-Za-zÁÉÍÓÚÜÑáéíóúüñ0-9]+)*

/* ojo con el '-' dentro de [] -> escapar como \- */
EMAIL   = [A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,10}

/* Fechas aceptadas por el enunciado */
/* 2026/06/15 o 15/06/2026 */
DATE1   = {NUM}/{NUM}/{NUM}
DATE2   = {NUM}\|{NUM}\|{NUM}                   /* 15|06|26 */
DATE3   = {NUM}-{NUM}-{NUM}                     /* 2026-06-15 */
/* 20-Ago-2026 */
DATE4   = {NUM}-[A-Za-z]{3,}-{NUM}
DATE    = {DATE1}|{DATE2}|{DATE3}|{DATE4}

/* Cadenas entre comillas (permite escapados) */
QUOTED  = \"([^\\\"\r\n]|\\.)*\"

/* ==== REGLAS ==== */
%%

/* Ignorar espacios en blanco */
{WS}                    { /* skip */ }

/* Fin de línea -> NEWLINE */
{LINEEND}+              { return new Symbol(sym.NEWLINE); }

/* Signos / separadores */
":"                     { return new Symbol(sym.COLON); }
","                     { return new Symbol(sym.COMMA); }
"-"                     { return new Symbol(sym.DASH); }
";"                     { return new Symbol(sym.SEMI); }
"["                     { return new Symbol(sym.LBRACK); }
"]"                     { return new Symbol(sym.RBRACK); }
"(X)"                   { return new Symbol(sym.X); }

/* Palabras clave (con %ignorecase alcanzan) */
CAMPEONATO              { return new Symbol(sym.CAMPEONATO); }
SERIE                   { return new Symbol(sym.SERIE); }
EQUIPOS                 { return new Symbol(sym.EQUIPOS); }
PARTIDO                 { return new Symbol(sym.PARTIDO); }
NRO                     { return new Symbol(sym.NRO); }
PARTICIPANTE            { return new Symbol(sym.PARTICIPANTE); }
/* el enunciado a veces dice “PRONÓSTICOS PARTIDOS”. Nos quedamos con un token PRONOSTICOS
   y si necesitás PARTIDOS como palabra suelta, abajo está. */
PRONOSTICOS             { return new Symbol(sym.PRONOSTICOS); }
PARTIDOS                { return new Symbol(sym.PARTIDOS); }

/* Tokens con valor */
{NUM}                   { return new Symbol(sym.NUMBER, Integer.valueOf(yytext())); }
{EMAIL}                 { return new Symbol(sym.EMAIL, yytext()); }
{DATE}                  { return new Symbol(sym.DATE, yytext()); }
{QUOTED}                { return new Symbol(sym.QSTRING, yytext().substring(1, yytext().length()-1)); }
{WORD}                  { return new Symbol(sym.IDENT, yytext()); }

/* Cualquier otro carácter -> error léxico explícito */
.                       { throw new Error("Carácter ilegal '"+yytext()+"' en ("+yyline+":"+yycolumn+")"); }

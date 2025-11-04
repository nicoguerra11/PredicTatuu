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
%ignorecase

/* ==== MACROS (definiciones) ==== */
LINEEND = \r?\n
WS      = [ \t\f]+
NUM     = [0-9]+
WORD    = [A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+([ '_-][A-Za-zÁÉÍÓÚÜÑáéíóúüñ0-9]+)*

EMAIL   = [A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,10}

/* Fechas aceptadas */
MONTH   = [A-Za-z]+
DATE1   = {NUM}\/{NUM}\/{NUM}
DATE2   = {NUM}\|{NUM}\|{NUM}
DATE3   = {NUM}-{NUM}-{NUM}
DATE4   = {NUM}-{MONTH}-{NUM}
DATE    = {DATE1}|{DATE2}|{DATE3}|{DATE4}

/* Cadenas entre comillas */
QUOTED  = \"([^\\\"\r\n]|\\.)*\"

/* ==== REGLAS ==== */
%%

/* Ignorar espacios en blanco */
{WS}                    { /* skip */ }

/* Fin de línea -> NEWLINE */
{LINEEND}               { return new Symbol(sym.NEWLINE); }

/* Signos / separadores */
":"                     { return new Symbol(sym.COLON); }
","                     { return new Symbol(sym.COMMA); }
"-"                     { return new Symbol(sym.DASH); }
";"                     { return new Symbol(sym.SEMI); }
"["                     { return new Symbol(sym.LBRACK); }
"]"                     { return new Symbol(sym.RBRACK); }
"(X)"                   { return new Symbol(sym.X); }

/* Palabras clave */
CAMPEONATO              { return new Symbol(sym.CAMPEONATO); }
SERIE                   { return new Symbol(sym.SERIE); }
EQUIPOS                 { return new Symbol(sym.EQUIPOS); }
PARTIDO                 { return new Symbol(sym.PARTIDO); }
NRO                     { return new Symbol(sym.NRO); }
PARTICIPANTE            { return new Symbol(sym.PARTICIPANTE); }
PRONOSTICOS|PRONÓSTICOS { return new Symbol(sym.PRONOSTICOS); }
PARTIDOS                { return new Symbol(sym.PARTIDOS); }

/* Tokens con valor - IMPORTANTE: Orden correcto */
{DATE}                  { return new Symbol(sym.DATE, yytext()); }
{NUM}                   { return new Symbol(sym.NUMBER, Integer.valueOf(yytext())); }
{EMAIL}                 { return new Symbol(sym.EMAIL, yytext()); }
{QUOTED}                { return new Symbol(sym.QSTRING, yytext().substring(1, yytext().length()-1)); }
{WORD}                  { return new Symbol(sym.IDENT, yytext()); }

/* Cualquier otro carácter -> error léxico explícito */
.                       { throw new Error("Carácter ilegal '"+yytext()+"' en línea "+(yyline+1)+", columna "+(yycolumn+1)); }
package predictatu;

import java.io.FileReader;

public class Main {
    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            System.err.println("Uso: java predictatu.Main <archivo.txt>");
            System.exit(1);
        }

        System.out.println("Iniciando análisis del archivo: " + args[0]);
        System.out.println("==========================================");

        parser p = new parser(new Lexer(new FileReader(args[0])));
        p.parse();

        System.out.println("==========================================");
        System.out.println("Parse finalizado OK.");
    }
}